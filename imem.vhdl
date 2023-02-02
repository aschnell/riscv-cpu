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

                  -- <__reset>:
    x"00010197",  -- 10000: auipc	gp,0x10
    x"00018193",  -- 10004: mv	gp,gp
    x"00020117",  -- 10008: auipc	sp,0x20
    x"10410113",  -- 1000c: addi	sp,sp,260 # 3010c <__stack_pointer>
    x"00010297",  -- 10010: auipc	t0,0x10
    x"ffd28293",  -- 10014: addi	t0,t0,-3 # 2000d <__bss_end>
    x"00010317",  -- 10018: auipc	t1,0x10
    x"ff530313",  -- 1001c: addi	t1,t1,-11 # 2000d <__bss_end>
    x"0062f863",  -- 10020: bgeu	t0,t1,10030 <memclr_done>
                  -- <memclr>:
    x"0002a023",  -- 10024: sw	zero,0(t0)
    x"00428293",  -- 10028: addi	t0,t0,4
    x"fe62ece3",  -- 1002c: bltu	t0,t1,10024 <memclr>
                  -- <memclr_done>:
    x"068000ef",  -- 10030: jal	ra,10098 <__text_end>
    x"0000006f",  -- 10034: j	10034 <memclr_done+0x4>
                  -- <sleep>:
    x"007a1737",  -- 10038: lui	a4,0x7a1
    x"00000793",  -- 1003c: li	a5,0
    x"20070713",  -- 10040: addi	a4,a4,512 # 7a1200 <__stack_pointer+0x7710f4>
    x"00178793",  -- 10044: addi	a5,a5,1
    x"fee79ee3",  -- 10048: bne	a5,a4,10044 <sleep+0xc>
    x"00008067",  -- 1004c: ret
                  -- <print.constprop.0>:
    x"ff010113",  -- 10050: addi	sp,sp,-16
    x"00812423",  -- 10054: sw	s0,8(sp)
    x"00020437",  -- 10058: lui	s0,0x20
    x"00912223",  -- 1005c: sw	s1,4(sp)
    x"00112623",  -- 10060: sw	ra,12(sp)
    x"04800793",  -- 10064: li	a5,72
    x"00040413",  -- 10068: mv	s0,s0
    x"000804b7",  -- 1006c: lui	s1,0x80
    x"00f480a3",  -- 10070: sb	a5,1(s1) # 80001 <__stack_pointer+0x4fef5>
    x"00140413",  -- 10074: addi	s0,s0,1 # 20001 <__global_pointer+0x1>
    x"fc1ff0ef",  -- 10078: jal	ra,10038 <sleep>
    x"00044783",  -- 1007c: lbu	a5,0(s0)
    x"fe0798e3",  -- 10080: bnez	a5,10070 <print.constprop.0+0x20>
    x"00c12083",  -- 10084: lw	ra,12(sp)
    x"00812403",  -- 10088: lw	s0,8(sp)
    x"00412483",  -- 1008c: lw	s1,4(sp)
    x"01010113",  -- 10090: addi	sp,sp,16
    x"00008067",  -- 10094: ret
                  -- <main>:
    x"ff010113",  -- 10098: addi	sp,sp,-16
    x"00112623",  -- 1009c: sw	ra,12(sp)
    x"fb1ff0ef",  -- 100a0: jal	ra,10050 <print.constprop.0>
    x"ffdff06f",  -- 100a4: j	100a0 <main+0x8>

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

  /*
  process(clk) is
  begin
    if rising_edge(clk) then

      if re then
        data_out <= ram_data(to_integer(addr));
      end if;

    end if;
  end process;
  */

  -- rtl_synthesis off
  probe_instr <= data_out;
  -- rtl_synthesis on

end architecture rtl;
