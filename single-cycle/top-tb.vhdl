library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end;

architecture testbench of top_tb is

  signal clk:   std_ulogic;
  signal led:   std_ulogic;

begin

  -- instantiate device to be tested
  dut: entity work.top port map(clk, led, open);

  -- Generate 16 MHz clock
  process is
  begin
    for i in 0 to 400000 loop
      clk <= '1';
      wait for 31.25 ns;
      clk <= '0';
      wait for 31.25 ns;
    end loop;

    wait;
  end process;

end architecture testbench;
