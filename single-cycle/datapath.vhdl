library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

entity datapath is
  port(
    clk:        in  std_ulogic;
    reset:      in  std_ulogic;

    pc:         out std_ulogic_vector(XLEN - 1 downto 0);
    instr:      in  std_ulogic_vector(31 downto 0);

    aluout:     out std_ulogic_vector(XLEN - 1 downto 0);
    rs2:        out std_ulogic_vector(XLEN - 1 downto 0);
    readdata:   in  std_ulogic_vector(XLEN - 1 downto 0);

    ctl:        in  controls_t
  );
end;

architecture rtl of datapath is

  alias op:             std_ulogic_vector(6 downto 0) is instr(6 downto 0);
  alias funct3:         std_ulogic_vector(2 downto 0) is instr(14 downto 12);
  alias funct7:         std_ulogic_vector(6 downto 0) is instr(31 downto 25);

  alias rs1_idx:        std_ulogic_vector(4 downto 0) is instr(19 downto 15);
  alias rs2_idx:        std_ulogic_vector(4 downto 0) is instr(24 downto 20);
  alias rd_idx:         std_ulogic_vector(4 downto 0) is instr(11 downto 7);

  signal imm:           std_ulogic_vector(31 downto 0);

  signal pc_p4:         std_ulogic_vector(XLEN - 1 downto 0);
  signal pc_jmp1:       std_ulogic_vector(XLEN - 1 downto 0);
  signal pc_jmp2:       std_ulogic_vector(XLEN - 1 downto 0);
  signal pc_next:       std_ulogic_vector(XLEN - 1 downto 0);

  signal rs1:           std_ulogic_vector(XLEN - 1 downto 0);
  signal rd:            std_ulogic_vector(XLEN - 1 downto 0);

  signal srca:          std_ulogic_vector(XLEN - 1 downto 0);
  signal srcb:          std_ulogic_vector(XLEN - 1 downto 0);

  signal branch:        std_ulogic;
  signal flow:          std_ulogic_vector(1 downto 0);

begin

  -- get immediate from instruction

  imm_0: entity work.imm port map(clk, instr, ctl.imm_ctl, imm);

  -- PC logic

  pc_reg: entity work.flopr generic map(d_reset => x"00010000") port map(clk, reset, pc_next, pc);

  pc_adder1: entity work.adder port map(pc, x"00000004", pc_p4);
  pc_adder2: entity work.adder port map(pc, imm, pc_jmp1);
  pc_adder3: entity work.adder port map(rs1, imm, pc_jmp2);

  branch_0: entity work.branch port map(clk, rs1, rs2, ctl.branch_ctl, branch);

  process(all) is
  begin
    if ctl.pc_ctl = PC_BRANCH then
      flow <= PC_PCPIMM when branch = '1' else PC_PCP4;
    else
      flow <= ctl.pc_ctl;
    end if;
  end process;

  pc_mux: entity work.mux3 port map(pc_p4, pc_jmp1, pc_jmp2, flow, pc_next);

  -- register logic

  rfile_0: entity work.rfile port map(
    clk, reset, ctl.rd_write, rs1_idx, rs2_idx, rd_idx, rs1, rs2, rd
  );

  -- TODO somehow yosys sees a loop for rd_src
  rd_mux: entity work.mux3 port map(
    aluout, readdata, pc_p4, ctl.rd_src, rd
  );

  -- ALU logic

  srca_mux: entity work.mux2 port map(rs1, pc, ctl.alu_srca, srca);
  srcb_mux: entity work.mux2 port map(rs2, imm, ctl.alu_srcb, srcb);

  alu_0: entity work.alu port map(clk, srca, srcb, ctl.alu_ctl, aluout);

  -- rtl_synthesis off
  process(clk) is
  begin
    if rising_edge(clk) then
      report "rs1:" & to_string(rs1_idx) & " rs2:" & to_string(rs2_idx) & " rd:" & to_string(rd_idx);
      report "pc_p4:" & to_hstring(pc_p4);
      report "pc_jmp1:" & to_hstring(pc_jmp1);
      report "pc_jmp2:" & to_hstring(pc_jmp2);
      report "pc_next:" & to_hstring(pc_next);
    end if;
  end process;
  -- rtl_synthesis on

end architecture rtl;
