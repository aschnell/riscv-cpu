library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

-- single cycle control decoder

entity controller is
  port(
    clk:        in  std_ulogic;
    op:         in  std_ulogic_vector(6 downto 0);
    funct3:     in  std_ulogic_vector(2 downto 0);
    funct7:     in  std_ulogic_vector(6 downto 0);

    zero:       in  std_ulogic;
    pcsrc:      out std_ulogic;
    jump:       out std_ulogic;

    ctl:        out controls_t
  );
end;

architecture struct of controller is

  signal branch: std_ulogic;

begin

  md: entity work.maindec port map(clk, op, funct3, funct7, ctl);

  pcsrc <= branch and zero;

end;
