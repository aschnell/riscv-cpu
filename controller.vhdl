library ieee;
use ieee.std_logic_1164.all;

-- single cycle control decoder

entity controller is
  port(
    op:                 in  std_ulogic_vector(6 downto 0);
    funct3:             in  std_ulogic_vector(2 downto 0);
    funct7:             in  std_ulogic_vector(6 downto 0);
    zero:               in  std_ulogic;
    memtoreg, memwrite: out std_ulogic;
    pcsrc, alusrc:      out std_ulogic;
    regdst, regwrite:   out std_ulogic;
    jump:               out std_ulogic;
    alucontrol:         out std_ulogic_vector(2 downto 0)
  );
end;

architecture struct of controller is

  signal aluop:  std_ulogic_vector(1 downto 0);
  signal branch: std_ulogic;

begin

  md: entity work.maindec port map(op, funct3, funct7, memtoreg, memwrite, branch,
                                   alusrc, regdst, regwrite, jump, aluop);

  ad: entity work.aludec port map(funct3, funct7, aluop, alucontrol);

  pcsrc <= branch and zero;

end;
