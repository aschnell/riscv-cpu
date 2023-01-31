library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity alu is
  port(
    clk:        in  std_ulogic;
    a, b:       in  std_ulogic_vector(31 downto 0);
    alu_ctl:    in  std_ulogic_vector(3 downto 0);
    result:     buffer std_ulogic_vector(31 downto 0);
    zero:       out std_ulogic
  );
end;


-- TODO optimize alu_ctl to directly map the opcode (like for mem_ctl)


architecture rtl of alu is
begin

  process(all) begin
    case alu_ctl is

      when "0001" => result <= a + b;
      when "0010" => result <= a - b;

      when "0011" => result <= a and b;
      when "0100" => result <= a or b;
      when "0101" => result <= a xor b;

      /*
      when "0110" => result <= a sll b;
      when "0111" => result <= a srl b;
      when "1000" => result <= a sra b;
      */

      when "1001" => result <= a;
      when "1010" => result <= b;

      when "1011" => result <= x"00000001" when a < b else x"00000000";

      when others => result <= (others => 'X');

    end case;
  end process;

  /*
  zero <= '1' when result = x"00000000" else '0';
  */

  process(clk)
  begin
    if rising_edge(clk) then

      if alu_ctl = "0000" then
        report "alu_ctl: none";
      else
        report "alu_ctl:" & to_string(alu_ctl) & " a:" & to_string(a) & " b:" & to_string(b) &
          " result:" & to_string(result);
      end if;

    end if;
  end process;

end;
