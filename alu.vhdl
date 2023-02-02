library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use work.common.all;

entity alu is
  port(
    clk:        in  std_ulogic;
    a, b:       in  std_ulogic_vector(XLEN - 1 downto 0);
    alu_ctl:    in  std_ulogic_vector(3 downto 0);
    result:     out std_ulogic_vector(XLEN - 1 downto 0)
  );
end;


-- TODO optimize

architecture rtl of alu is
begin

  process(all) is
  begin

    case alu_ctl is

      when ALU_ADD => result <= a + b;
      when ALU_SUB => result <= a - b;

      when ALU_AND => result <= a and b;
      when ALU_OR  => result <= a or b;
      when ALU_XOR => result <= a xor b;

      when ALU_SLL => result <= std_ulogic_vector(shift_left(unsigned(a), to_integer(b)));
      when ALU_SRL => result <= std_ulogic_vector(shift_right(unsigned(a), to_integer(b)));
      when ALU_SRA => result <= std_ulogic_vector(shift_right(signed(a), to_integer(b)));

      when ALU_A   => result <= a;
      when ALU_B   => result <= b;

      when ALU_SLT => result <= x"00000001" when signed(a) < signed(b) else x"00000000";
      when ALU_SLTU => result <= x"00000001" when unsigned(a) < unsigned(b) else x"00000000";

      when others => result <= (others => 'X');

    end case;

  end process;

  -- rtl_synthesis off
  process(clk) is
  begin
    if rising_edge(clk) then

      report "alu_ctl:" & to_string(alu_ctl) & " a:" & to_string(a) & " b:" & to_string(b) &
        " result:" & to_string(result);

    end if;
  end process;
  -- rtl_synthesis on

end architecture rtl;
