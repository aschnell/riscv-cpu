library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;
use work.probe.all;

entity test_add is
end;

architecture testbench of test_add is

  signal clk:                   std_ulogic;
  signal reset:                 std_ulogic;

begin

  probe_fake_imem <= '1';
  probe_imem0 <= x"13012002"; -- addi x2, x0, 0x22
  probe_imem1 <= x"93014004"; -- addi x3, x0, 0x44
  probe_imem2 <= x"b3003100"; -- add  x1, x2, x3

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

    if probe_rx1 /= x"00000066" then
      report "test failed" severity failure;
    end if;

    report "test succeeded";
    finish;
  end process;

end;
