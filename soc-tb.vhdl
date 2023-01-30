library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use std.env.finish;

entity soc_tb is
end;

architecture testbench of soc_tb is

  signal clk:                   std_ulogic;
  signal reset, memwrite:       std_ulogic;
  signal writedata, dataaddr:   std_ulogic_vector(31 downto 0);

begin

  -- instantiate device to be tested
  dut: entity work.soc port map(clk, reset, writedata, dataaddr, memwrite);

  -- Generate clock with 10 ns period
  process begin
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
  end process;

  -- Generate reset for first two clock cycles
  process begin
    reset <= '1';
    wait for 22 ns;
    reset <= '0';
    wait;
  end process;

  process(clk) is
  begin
    if rising_edge(clk) then
      report "";
    end if;
  end process;

  /*
  -- check that 7 gets written to address 84 at end of program
  process (clk) begin
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

end;
