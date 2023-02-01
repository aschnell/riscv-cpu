library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use work.common.all;
-- rtl_synthesis off
use work.probe.all;
-- rtl_synthesis on

-- instruction memory

entity imem is
  port(
    addr:       in  std_ulogic_vector(5 downto 0);  -- address
    data_out:   out std_ulogic_vector(XLEN - 1 downto 0)  -- data out
  );
end;

architecture rtl of imem is

  type ram_type is array (0 to 255) of std_ulogic_vector(31 downto 0);

  signal ram_data: ram_type := (

                  -- <l0>:
    x"000203b7",  --    0: lui  t2,0x20
                  -- <l1>:
    x"00130313",  --    4: addi t1,t1,1
    x"00638023",  --    8: sb   t1,0(t2) # 20000 <l2+0x1ffec>
    x"0000a2b7",  --    c: lui  t0,0xa
    x"c4028293",  --   10: addi t0,t0,-960 # 9c40 <l2+0x9c2c>
                  -- <l2>:
    x"fff28293",  --   14: addi t0,t0,-1
    x"fe029ee3",  --   18: bnez t0,14 <l2>
    x"fe9ff06f",  --   1c: j    4 <l1>

    others => x"00000000"
  );

begin

  -- rtl_synthesis off
  process(all) is
  begin
    if probe_fake_imem = '1' then
      ram_data(0) <= probe_imem0;
      ram_data(1) <= probe_imem1;
      ram_data(2) <= probe_imem2;
      ram_data(3) <= probe_imem3;
      ram_data(4) <= probe_imem4;
      ram_data(5) <= probe_imem5;
      ram_data(6) <= probe_imem6;
      ram_data(7) <= probe_imem7;
    end if;
  end process;
  -- rtl_synthesis on

  data_out <= ram_data(to_integer(addr));

  -- rtl_synthesis off
  probe_instr <= data_out;
  -- rtl_synthesis on

end architecture rtl;
