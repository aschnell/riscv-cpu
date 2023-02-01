library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common.all;

entity branch is
  port(
    clk:        in  std_ulogic;
    a, b:       in  std_ulogic_vector(XLEN - 1 downto 0);
    cmp_ctl:    in  std_ulogic_vector(2 downto 0);
    result:     out std_ulogic
  );
end;

architecture rtl of branch is
begin

  process(all) is
  begin
    case cmp_ctl is

      when BRANCH_EQ => result <= '1' when a = b else '0';
      when BRANCH_NE => result <= '1' when a /= b else '0';

      when BRANCH_NEVER => result <= '0';

      when BRANCH_LT => result <= '1' when signed(a) < signed(b) else '0';
      when BRANCH_GE => result <= '1' when signed(a) >= signed(b) else '0';

      when BRANCH_LTU => result <= '1' when unsigned(a) < unsigned(b) else '0';
      when BRANCH_GEU => result <= '1' when unsigned(a) >= unsigned(b) else '0';

      when others => result <= 'X';

    end case;
  end process;

  /*
  process(clk) is
  begin
    if rising_edge(clk) then
      report "cmp_ctl:" & to_string(cmp_ctl);
      report "a:" & to_string(a) & " b:" & to_string(b);
      report "result:" & to_string(result);
    end if;
  end process;
  */

end architecture rtl;
