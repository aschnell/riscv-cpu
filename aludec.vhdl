library ieee;
use ieee.std_logic_1164.all;

-- ALU control decoder

entity aludec is
  port(
    funct3:     in  std_ulogic_vector(2 downto 0);
    funct7:     in  std_ulogic_vector(6 downto 0);
    aluop:      in  std_ulogic_vector(1 downto 0);
    alucontrol: out std_ulogic_vector(2 downto 0)
  );
end;

architecture behave of aludec is
begin

  /*
  process(all) begin
    case aluop is
      when "00" => alucontrol <= "010"; -- add (for lw/sw/addi)
      when "01" => alucontrol <= "110"; -- sub (for beq)
      when others => case funct is      -- R-type instructions
                         when "000000" => alucontrol <= "010"; -- add
                         when "100010" => alucontrol <= "110"; -- sub
                         when "100100" => alucontrol <= "000"; -- and
                         when "100101" => alucontrol <= "001"; -- or
                         when "101010" => alucontrol <= "111"; -- slt
                         when others   => alucontrol <= "---"; -- ???
                     end case;
    end case;
  end process;
*/

  process(all)

  begin

    case aluop is
      when "00" => alucontrol <= "010"; -- add (for lw/sw/addi)

    when others =>
      case funct3 is

        when "000" =>

          case funct7 is

            when "0000000" =>
              alucontrol <= "010"; -- add

            when "0100000" =>
              alucontrol <= "110"; -- sub

            when others =>
              alucontrol <= "000";

          end case;

        when others =>
          alucontrol <= "000";

      end case;

    end case;

  end process;

  -- alucontrol <= "110";

end;
