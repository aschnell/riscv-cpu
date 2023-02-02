library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

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

  process(all) is
  begin
    case imm_ctl is

      -- I-immediate
      when IMM_I =>
        result <= (31 downto 11 => instr(31)) & instr(30 downto 20);

      -- S-immediate
      when IMM_S =>
        result <= (31 downto 11 => instr(31)) & instr(30 downto 25) & instr(11 downto 7);

      -- B-immediate
      when IMM_B =>
        result <= (31 downto 12 => instr(31)) & instr(7) & instr(30 downto 25) &
                  instr(11 downto 8) & '0';

      -- U-immediate
      when IMM_U =>
        result <= instr(31 downto 12) & (11 downto 0 => '0');

      -- J-immediate
      when IMM_J =>
        result <= (31 downto 20 => instr(31)) & instr(19 downto 12) &
                  instr(20) & instr(30 downto 21) & '0';

      -- shamt (shift amount)
      when IMM_SHAMT =>
        result <= (31 downto 5 => '0') & instr(24 downto 20);

      when others =>
        result <= (31 downto 0 => 'X');

    end case;
  end process;

  -- rtl_synthesis off
  process(clk) is
  begin
    if rising_edge(clk) then

      report "imm_ctl:" & to_string(imm_ctl) & " result:" & to_string(result);

    end if;
  end process;
  -- rtl_synthesis on

end architecture rtl;
