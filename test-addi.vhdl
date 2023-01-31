library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;
use work.probe.all;

entity test_addi is
end;

architecture testbench of test_addi is

  signal clk:                   std_ulogic;
  signal reset:                 std_ulogic;

begin

  probe_fake_imem <= '1';
  probe_imem0 <= x"93008067"; -- addi x1, x0, 0x678

  dut: entity work.soc port map(clk, reset);

  process begin
    reset <= '1';
    wait for 7.5 ns;
    reset <= '0';
    wait;
  end process;

  process begin
    for i in 0 to 1 loop
      clk <= '1';
      wait for 5 ns;
      clk <= '0';
      wait for 5 ns;
    end loop;

    if probe_rx1 /= x"00000678" then
      report "rx1:" & to_hstring(probe_rx1);
      report "test failed" severity failure;
    end if;

    report "test succeeded";
    finish;
  end process;

end;
