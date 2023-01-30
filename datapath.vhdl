library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

-- MIPS datapath

entity datapath is
  port(
    clk:               in  std_ulogic;
    reset:             in  std_ulogic;
    memtoreg, pcsrc:   in  std_ulogic;
    alusrc, regdst:    in  std_ulogic;
    regwrite, jump:    in  std_ulogic;
    alucontrol:        in  std_ulogic_vector(2 downto 0);
    zero:              out std_ulogic;
    pc:                buffer std_ulogic_vector(31 downto 0);
    instr:             in  std_ulogic_vector(31 downto 0);
    aluout:            buffer std_ulogic_vector(31 downto 0);
    writedata:         buffer std_ulogic_vector(31 downto 0);
    readdata:          in  std_ulogic_vector(31 downto 0)
  );
end;

architecture struct of datapath is

  signal writereg:           std_ulogic_vector(4 downto 0);
  signal pcjump, pcnext,
         pcnextbr, pcplus4,
         pcbranch:           std_ulogic_vector(31 downto 0);
  signal signimm, signimmsh: std_ulogic_vector(31 downto 0);
  signal srca, srcb, result: std_ulogic_vector(31 downto 0);

  -- for all instructions
  alias op:     std_ulogic_vector(6 downto 0) is instr(6 downto 0);

  -- for R-type, I-type, S-type and B-type instructions
  alias rs1 : std_ulogic_vector(4 downto 0) is instr(19 downto 15);

  -- for R-type, S-type and B-type instructions
  alias rs2 : std_ulogic_vector(4 downto 0) is instr(24 downto 20);

  -- for R-type, I-type, U-type and J-type instructions
  alias rd : std_ulogic_vector(4 downto 0) is instr(11 downto 7);

  -- for I-type instructions (LB, LB, ADDI, SLTI, ...)
  alias imm1 : std_ulogic_vector(11 downto 0) is instr(31 downto 20);

  alias imm2 : std_ulogic_vector(19 downto 0) is instr(31 downto 12);

  alias funct3 : std_ulogic_vector(2 downto 0) is instr(14 downto 12);
  alias funct7 : std_ulogic_vector(6 downto 0) is instr(31 downto 25);

begin


  process(instr)
  begin

    case op is
      
      when "0110111" =>
        report "lui";
        report "rd: " & to_string(to_integer(rd));
        report "imm2: " & to_string(to_integer(imm2));

      when "0010011" =>
        report "addi";
        report "rs1: " & to_string(to_integer(rs1));
        report "rd: " & to_string(to_integer(rd));
        report "imm1: " & to_string(to_integer(imm1));

      when "0110011" =>

        case funct7 is

          when "0000000" =>
            report "add";
            report "rs1: " & to_string(to_integer(rs1));
            report "rs2: " & to_string(to_integer(rs2));
            report "rd: " & to_string(to_integer(rd));

          when "0100000" =>
            report "sub";
            report "rs1: " & to_string(to_integer(rs1));
            report "rs2: " & to_string(to_integer(rs2));
            report "rd: " & to_string(to_integer(rd));

          when others =>
            report "unknown funct";

        end case;

      when "0000011" =>
        report "lw";
        report "rs1: " & to_string(to_integer(rs1));
        report "rd: " & to_string(to_integer(rd));
        report "imm1: " & to_string(to_integer(imm1));

      when "0100011" =>
        report "sw";
        report "rs1: " & to_string(to_integer(rs1));
        report "rs2: " & to_string(to_integer(rs2));
        report "imm1: " & to_string(to_integer(imm1));

      when others =>
        report "unknown op";

    end case;

  end process;

  -- next PC logic
  pcjump <= pcplus4(31 downto 28) & instr(25 downto 0) & "00";
  pcreg: entity work.flopr generic map(32) port map(clk, reset, pcnext, pc);
  pcadd1: entity work.adder port map(pc, x"00000004", pcplus4);
  immsh: entity work.sl2 port map(signimm, signimmsh);
  pcadd2: entity work.adder port map(pcplus4, signimmsh, pcbranch);
  pcbrmux: entity work.mux2 generic map(32) port map(pcplus4, pcbranch,
                                                     pcsrc, pcnextbr);
  pcmux: entity work.mux2 generic map(32) port map(pcnextbr, pcjump, jump, pcnext);

  -- register file logic
  rf: entity work.regfile port map(clk, regwrite, rs1, rs2,
                                   writereg, result, srca,
                                   writedata);
  wrmux: entity work.mux2 generic map(5) port map(rs2, rd,
                                                  regdst, writereg);
  resmux: entity work.mux2 generic map(32) port map(aluout, readdata,
                                                    memtoreg, result);
  se: entity work.signext port map(imm1, signimm);

  -- ALU logic
  srcbmux: entity work.mux2 generic map(32) port map(writedata, signimm, alusrc, srcb);
  mainalu: entity work.alu port map(clk, srca, srcb, alucontrol, aluout, zero);

end;
