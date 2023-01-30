library ieee;
use ieee.std_logic_1164.all;

-- main control decoder

entity maindec is
  port(
    op:                 in  std_ulogic_vector(6 downto 0);
    funct3:             in  std_ulogic_vector(2 downto 0);
    funct7:             in  std_ulogic_vector(6 downto 0);
    memtoreg, memwrite: out std_ulogic;
    branch, alusrc:     out std_ulogic;
    regdst, regwrite:   out std_ulogic;
    jump:               out std_ulogic;
    aluop:              out std_ulogic_vector(1 downto 0)
  );
end;

architecture behave of maindec is

  signal controls: std_ulogic_vector(8 downto 0);

begin

  /*
  process(all) begin
    case op is
      when "000000" => controls <= "110000010"; -- RTYPE
      when "100011" => controls <= "101001000"; -- LW
      when "101011" => controls <= "001010000"; -- SW
      when "000100" => controls <= "000100001"; -- BEQ
      when "001000" => controls <= "101000000"; -- ADDI
      when "000010" => controls <= "000000100"; -- J
      when others   => controls <= "---------"; -- illegal op
    end case;
  end process;
  */

  -- regdst should not be needed for risc-v

  process(all)
  begin
    case op is
      when "0010011" => controls <= "111000000"; -- addi

      when "0110011" => controls <= "110000000"; -- R-type (add/sub/...)

      when "0000011" => controls <= "110001000"; -- lw
      when "0100011" => controls <= "110010000"; -- sw

      when others    => controls <= "000000000"; -- illegal op
      -- when others   => controls <= "---------"; -- illegal op
    end case;
  end process;

  process(op, controls)
  begin
    report "op " & to_string(op) & "  controls " & to_string(controls);
  end process;

  (regwrite, regdst, alusrc, branch, memwrite,
   memtoreg, jump, aluop(1 downto 0)) <= controls;

end;
