library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use ieee.numeric_std.all;
use work.common.all;

entity alu_tb is
end;

architecture testbench of alu_tb is

  signal clk:       std_ulogic := '0';
  signal ctl:       std_ulogic_vector(3 downto 0) := "0000";
  signal a, b:      std_ulogic_vector(XLEN - 1 downto 0) := x"00000000";
  signal r:         std_ulogic_vector(XLEN - 1 downto 0);

begin

  dut: entity work.alu port map(
    clk, a, b, ctl, r
  );

  process is
  begin

    ctl <= ALU_ADD;
    a <= std_logic_vector(to_signed(34, 32));
    b <= std_logic_vector(to_signed(89, 32));
    wait for 100 ns;
    assert r = 34 + 89 severity failure;

    ctl <= ALU_AND;
    a <= x"ff00ff00";
    b <= x"ffff0000";
    wait for 100 ns;
    assert r = x"ff000000" severity failure;

    ctl <= ALU_OR;
    wait for 100 ns;
    assert r = x"ffffff00" severity failure;

    ctl <= ALU_XOR;
    wait for 100 ns;
    assert r = x"00ffff00" severity failure;

    wait;

  end process;

end architecture testbench;
