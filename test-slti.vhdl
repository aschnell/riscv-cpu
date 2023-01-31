library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;
use work.probe.all;

entity test_slti is
end;

architecture testbench of test_slti is

  signal clk:                   std_ulogic;
  signal reset:                 std_ulogic;

begin

  probe_fake_imem <= '1';
  probe_imem0 <= x"13017000"; -- addi x2, x0, 7
  probe_imem2 <= x"93208100"; -- slti x1, x2, 8

  dut: entity work.soc port map(clk, reset);

  process begin
    reset <= '1';
    wait for 7.5 ns;
    reset <= '0';
    wait;
  end process;

  process begin
    for i in 0 to 3 loop
      clk <= '1';
      wait for 5 ns;
      clk <= '0';
      wait for 5 ns;
    end loop;

    if probe_rx1 /= x"00000001" then
      report "rx1:" & to_hstring(probe_rx1);
      report "test failed" severity failure;
    end if;

    report "test succeeded";
    finish;
  end process;

end;
