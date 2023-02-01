library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use std.env.finish;
use work.common.all;
use work.probe.all;

entity soc_tb is
end;

architecture testbench of soc_tb is

  signal clk:                   std_ulogic;
  signal reset:                 std_ulogic;
  signal memwrite:              std_ulogic;
  signal writedata, dataaddr:   std_ulogic_vector(XLEN - 1 downto 0);

  /*
  alias pc is <<signal dut.soc.pc : std_ulogic_vector(31 downto 0)>>;
  */

begin

  dut: entity work.soc port map(clk, reset, writedata, dataaddr, memwrite);

  process is
  begin
    reset <= '1';
    wait for 75 ns;
    reset <= '0';
    wait;
  end process;

  process is
  begin
    for i in 0 to 100000 loop
      clk <= '1';
      wait for 50 ns;
      clk <= '0';
      wait for 50 ns;
    end loop;

    wait;
  end process;

  /*
  process(clk) is
  begin
    if rising_edge(clk) then
      report "";
    end if;
  end process;
  */

  /*
  -- check that 7 gets written to address 84 at end of program
  process(clk) is
  begin
    if (clk'event and clk = '0' and memwrite = '1') then
      if (to_integer(dataaddr) = 84 and to_integer(writedata) = 7) then
        report "NO ERRORS: Simulation succeeded";
        finish;
      elsif (dataaddr /= 80) then
        report "Simulation failed" severity failure;
      end if;
    end if;
  end process;
  */

  /*
  process(probe_rx1) is
  begin
     report "probe_rx1:" & to_string(probe_rx1);
  end process;
  */

  /*
  process(clk) is
  begin
    if rising_edge(clk) then
      report "haha pc:" & to_hstring(pc);
    end if;
  end process;
  */

end architecture testbench;
