library ieee;
use ieee.std_logic_1164.all;

-- single cycle MIPS processor

entity riscv32 is
  port(
    clk:               in  std_ulogic;
    reset:             in  std_ulogic;
    pc:                out std_ulogic_vector(31 downto 0);
    instr:             in  std_ulogic_vector(31 downto 0);
    memwrite:          out std_ulogic;
    aluout:            out std_ulogic_vector(31 downto 0);
    writedata:         out std_ulogic_vector(31 downto 0);
    readdata:          in  std_ulogic_vector(31 downto 0)
  );
end;

architecture struct of riscv32 is

  signal memtoreg, alusrc, regdst, regwrite, jump, pcsrc: std_ulogic;
  signal zero: std_ulogic;
  signal alucontrol: std_ulogic_vector(2 downto 0);

  -- for all instructions
  alias op:     std_ulogic_vector(6 downto 0) is instr(6 downto 0);

  -- for R, I, S and B-type instructions
  alias funct3:  std_ulogic_vector(2 downto 0) is instr(14 downto 12);

  -- for R-type instructions
  alias funct7:  std_ulogic_vector(6 downto 0) is instr(31 downto 25);

begin

  process(pc, instr)
  begin
    report "PC: " & to_hstring(pc) & "  instr: " & to_string(instr) & " " & to_hstring(instr);
  end process;

  controller_0: entity work.controller port map(
    op, funct3, funct7, zero, memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite,
    jump, alucontrol
  );

  datapath_0: entity work.datapath port map(
    clk, reset, memtoreg, pcsrc, alusrc, regdst, regwrite, jump, alucontrol,
    zero, pc, instr, aluout, writedata, readdata
  );

end;
