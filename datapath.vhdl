library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use work.common.all;

entity datapath is
  port(
    clk:        in  std_ulogic;
    reset:      in  std_ulogic;

    pcsrc:              in  std_ulogic;
    jump:                  in  std_ulogic;
    zero:              out std_ulogic;
    pc:                buffer std_ulogic_vector(31 downto 0);
    instr:      in  std_ulogic_vector(31 downto 0);
    aluout:            buffer std_ulogic_vector(31 downto 0);
    writedata:         buffer std_ulogic_vector(31 downto 0);
    readdata:          in  std_ulogic_vector(31 downto 0);

    ctl:        in controls_t
  );
end;

architecture struct of datapath is

  signal pcjump, pcnext,
         pcnextbr, pcplus4,
         pcbranch:           std_ulogic_vector(31 downto 0);
  signal signimm, signimmsh: std_ulogic_vector(31 downto 0);
  signal srca, srcb, result: std_ulogic_vector(31 downto 0);
  signal srca2:                 std_ulogic_vector(31 downto 0);
  signal imm:                std_ulogic_vector(31 downto 0);

  -- for all instructions
  alias op:     std_ulogic_vector(6 downto 0) is instr(6 downto 0);

  -- for R-type, I-type, S-type and B-type instructions
  alias rs1:    std_ulogic_vector(4 downto 0) is instr(19 downto 15);

  -- for R-type, S-type and B-type instructions
  alias rs2:    std_ulogic_vector(4 downto 0) is instr(24 downto 20);

  -- for R-type, I-type, U-type and J-type instructions
  alias rd:     std_ulogic_vector(4 downto 0) is instr(11 downto 7);

  -- for I-type instructions (LB, LB, ADDI, SLTI, ...)
  alias imm1:   std_ulogic_vector(11 downto 0) is instr(31 downto 20);

  alias imm2:   std_ulogic_vector(19 downto 0) is instr(31 downto 12);

  alias funct3: std_ulogic_vector(2 downto 0) is instr(14 downto 12);
  alias funct7: std_ulogic_vector(6 downto 0) is instr(31 downto 25);

begin

  -- next PC logic
  pcjump <= pcplus4(31 downto 28) & instr(25 downto 0) & "00";
  pcreg: entity work.flopr generic map(32) port map(clk, reset, pcnext, pc);
  pcadd1: entity work.adder port map(pc, x"00000004", pcplus4);
  immsh: entity work.sl1 port map(signimm, signimmsh);
  pcadd2: entity work.adder port map(pcplus4, signimmsh, pcbranch);
  pcbrmux: entity work.mux2 generic map(32) port map(pcplus4, pcbranch,
                                                     pcsrc, pcnextbr);
  pcmux: entity work.mux2 generic map(32) port map(pcnextbr, pcjump, jump, pcnext);

  -- register logic
  rbank_0: entity work.rbank port map(clk, ctl.rd_write, rs1, rs2, rd,
                                      result, srca, writedata);

  resmux: entity work.mux3 generic map(32) port map(aluout, readdata, pcplus4, ctl.rd_src, result);

  se: entity work.signext port map(imm1, signimm);

  -- imm logic
  imm_0: entity work.imm port map(clk, instr, ctl.imm_ctl, imm);

  -- ALU logic
  srca_mux: entity work.mux2 generic map(32) port map(srca, pc, ctl.alu_srca, srca2);
  srcb_mux: entity work.mux2 generic map(32) port map(writedata, imm, ctl.alu_srcb, srcb);
  alu_0: entity work.alu port map(clk, srca2, srcb, ctl.alu_ctl, aluout, zero);

end;
