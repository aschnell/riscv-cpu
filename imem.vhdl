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
    clk:        in  std_ulogic;
    re:         in  std_ulogic;
    addr:       in  std_ulogic_vector(XLEN - 1 downto 0);
    data_out:   out std_ulogic_vector(XLEN - 1 downto 0)
  );
end;

architecture rtl of imem is

  type ram_type is array (0 to 63) of std_ulogic_vector(31 downto 0);

  signal ram_data: ram_type := (

    -- hello3.c

                  -- <__reset>:
    x"00010197",  -- 10000: auipc	gp,0x10
    x"02918193",  -- 10004: addi	gp,gp,41 # 20029 <__global_pointer>
    x"00010117",  -- 10008: auipc	sp,0x10
    x"0f810113",  -- 1000c: addi	sp,sp,248 # 20100 <__stack_pointer>
    x"00010297",  -- 10010: auipc	t0,0x10
    x"03728293",  -- 10014: addi	t0,t0,55 # 20047 <__bss_end>
    x"00010317",  -- 10018: auipc	t1,0x10
    x"02f30313",  -- 1001c: addi	t1,t1,47 # 20047 <__bss_end>
    x"0062f863",  -- 10020: bgeu	t0,t1,10030 <memclr_done>
                  -- <memclr>:
    x"0002a023",  -- 10024: sw	zero,0(t0)
    x"00428293",  -- 10028: addi	t0,t0,4
    x"fe62ece3",  -- 1002c: bltu	t0,t1,10024 <memclr>
                  -- <memclr_done>:
    x"094000ef",  -- 10030: jal	ra,100c4 <__text_end>
    x"0000006f",  -- 10034: j	10034 <memclr_done+0x4>
                  -- <sleep>:
    x"007a17b7",  -- 10038: lui	a5,0x7a1
    x"20078793",  -- 1003c: addi	a5,a5,512 # 7a1200 <__stack_pointer+0x781100>
    x"fff78793",  -- 10040: addi	a5,a5,-1
    x"fe079ee3",  -- 10044: bnez	a5,10040 <sleep+0x8>
    x"00008067",  -- 10048: ret
                  -- <lut>:
    x"fd350513",  -- 1004c: addi	a0,a0,-45
    x"0ff57513",  -- 10050: zext.b	a0,a0
    x"02800793",  -- 10054: li	a5,40
    x"00a7ec63",  -- 10058: bltu	a5,a0,10070 <lut+0x24>
    x"000207b7",  -- 1005c: lui	a5,0x20
    x"00078793",  -- 10060: mv	a5,a5
    x"00a787b3",  -- 10064: add	a5,a5,a0
    x"0007c503",  -- 10068: lbu	a0,0(a5) # 20000 <CSWTCH.3>
    x"00008067",  -- 1006c: ret
    x"00000513",  -- 10070: li	a0,0
    x"00008067",  -- 10074: ret
                  -- <print.constprop.0>:
    x"ff010113",  -- 10078: addi	sp,sp,-16
    x"00812423",  -- 1007c: sw	s0,8(sp)
    x"00020437",  -- 10080: lui	s0,0x20
    x"00912223",  -- 10084: sw	s1,4(sp)
    x"00112623",  -- 10088: sw	ra,12(sp)
    x"04800513",  -- 1008c: li	a0,72
    x"02c40413",  -- 10090: addi	s0,s0,44 # 2002c <__global_pointer+0x3>
    x"000804b7",  -- 10094: lui	s1,0x80
    x"fb5ff0ef",  -- 10098: jal	ra,1004c <lut>
    x"00a480a3",  -- 1009c: sb	a0,1(s1) # 80001 <__stack_pointer+0x5ff01>
    x"00140413",  -- 100a0: addi	s0,s0,1
    x"f95ff0ef",  -- 100a4: jal	ra,10038 <sleep>
    x"00044503",  -- 100a8: lbu	a0,0(s0)
    x"fe0516e3",  -- 100ac: bnez	a0,10098 <print.constprop.0+0x20>
    x"00c12083",  -- 100b0: lw	ra,12(sp)
    x"00812403",  -- 100b4: lw	s0,8(sp)
    x"00412483",  -- 100b8: lw	s1,4(sp)
    x"01010113",  -- 100bc: addi	sp,sp,16
    x"00008067",  -- 100c0: ret
                  -- <main>:
    x"ff010113",  -- 100c4: addi	sp,sp,-16
    x"00112623",  -- 100c8: sw	ra,12(sp)
    x"fadff0ef",  -- 100cc: jal	ra,10078 <print.constprop.0>
    x"ffdff06f",  -- 100d0: j	100cc <main+0x8>

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

  -- TODO that should be in soc.vhdl
  process(all) is
  begin
    if addr(31 downto 8) = x"000100" then
      data_out <= ram_data(to_integer(addr(7 downto 2)));
    else
      data_out <= x"XXXXXXXX";
    end if;
  end process;

  -- rtl_synthesis off
  probe_instr <= data_out;
  -- rtl_synthesis on

end architecture rtl;
