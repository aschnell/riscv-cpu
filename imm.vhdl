library ieee;
use ieee.std_logic_1164.all;

entity imm is
  port(
    clk:        in  std_ulogic;
    instr:      in  std_ulogic_vector(31 downto 0);
    imm_ctl:    in  std_ulogic_vector(2 downto 0);
    result:     out std_ulogic_vector(31 downto 0)
  );
end;

architecture rtl of imm is
begin

  -- TODO sign ext

  process(imm_ctl, instr) begin
    case imm_ctl is

      when "001" => result <= "00000000000000000000" & instr(31 downto 20);

      when "010" => result <= "00000000000000000000" & instr(31 downto 25) & instr(11 downto 7);

      when "011" => result <= instr(31 downto 12) & "000000000000";

      when "101" => result <= "00000000000" & instr(31) & instr(19 downto 12) &
                              instr(20) & instr(30 downto 21) & "0";

      when others => result<= (others => 'X');

    end case;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then

      if imm_ctl = "000" then
        report "imm_ctl: none";
      else
        report "imm_ctl:" & to_string(imm_ctl) & " result:" & to_string(result);
      end if;

    end if;
  end process;

end architecture rtl;
