library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity alu is
  port(
    clk:        in  std_ulogic;
    a, b:       in  std_ulogic_vector(31 downto 0);
    alucontrol: in  std_ulogic_vector(2 downto 0);
    result:     buffer std_ulogic_vector(31 downto 0);
    zero:       out std_ulogic
  );
end;

architecture behave of alu is

  signal condinvb, sum: std_ulogic_vector(31 downto 0);

begin

  condinvb <= (not b) + 1 when alucontrol(2) else b;
  sum <= a + condinvb; -- + alucontrol(2);

  process(all) begin
    case alucontrol(1 downto 0) is
      when "00"   => result <= a and b;
      when "01"   => result <= a or b;
      when "10"   => result <= sum;
      when "11"   => result <= (0 => sum(31), others => '0');
      when others => result <= (others => 'X');
    end case;
  end process;

  zero <= '1' when result = x"00000000" else '0';

  process(clk)
  begin
    if rising_edge(clk) then
      report "a:" & to_string(to_integer(a)) & " b:" & to_string(to_integer(b)) &
        " aluc:" & to_string(alucontrol) & " result:" &
        to_string(to_integer(signed(result(15 downto 0))));
        -- overflow problem
        -- to_string(to_integer(result));
      report "condinvb:" & to_string(condinvb);
    end if;
  end process;

end;
