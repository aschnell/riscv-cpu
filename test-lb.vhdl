library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;
use work.probe.all;

entity test_lb is
end;

architecture testbench of test_lb is

  signal clk:                   std_ulogic;
  signal reset:                 std_ulogic;

begin

  probe_fake_imem <= '1';
  probe_imem0 <= x"b7503412"; -- lui   x2, 0x12345
  probe_imem1 <= x"93808067"; -- addi  x2, x2, 0x678
  probe_imem2 <= x"23221000"; -- sw    x2, 4(x0)
  probe_imem3 <= x"83006000"; -- lb    x1, 6(x0)

  dut: entity work.soc port map(clk, reset);

  process begin
    reset <= '1';
    wait for 7.5 ns;
    reset <= '0';
    wait;
  end process;

  process begin
    for i in 0 to 4 loop
      clk <= '1';
      wait for 5 ns;
      clk <= '0';
      wait for 5 ns;
    end loop;

    if probe_rx1 /= x"00000034" then  -- TODO correct?
      report to_hstring(probe_rx1);
      report "test failed" severity failure;
    end if;

    report "test succeeded";
    finish;
  end process;

end;
