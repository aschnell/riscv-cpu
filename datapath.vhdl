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

    ctl:        in controls_t
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

  signal pc_plus4:      std_ulogic_vector(XLEN - 1 downto 0);
  signal pc_jmp1:       std_ulogic_vector(XLEN - 1 downto 0);
  signal pc_jmp2:       std_ulogic_vector(XLEN - 1 downto 0);
  signal pc_next:       std_ulogic_vector(XLEN - 1 downto 0);

  signal rs1:           std_ulogic_vector(XLEN - 1 downto 0);
  signal rd:            std_ulogic_vector(XLEN - 1 downto 0);

  signal srca:          std_ulogic_vector(XLEN - 1 downto 0);
  signal srcb:          std_ulogic_vector(XLEN - 1 downto 0);

  signal b:             std_ulogic;     -- do the branch
  signal j:             std_ulogic_vector(1 downto 0);

begin

  -- get immediate from instruction

  imm_0: entity work.imm port map(clk, instr, ctl.imm_ctl, imm);

  -- PC logic

  pc_reg: entity work.flopr port map(clk, reset, pc_next, pc);

  pc_adder1: entity work.adder port map(pc, x"00000004", pc_plus4);
  pc_adder2: entity work.adder port map(pc, imm, pc_jmp1);
  pc_adder3: entity work.adder port map(rs1, imm, pc_jmp2);

  branch_0: entity work.branch port map(clk, rs1, rs2, ctl.branch_ctl, b);

  -- For branch instruction ctl.jmp_ctl is "00" (pc + 4). If the branch is taken
  -- we override ctl.jmp_ctl to "01" (pc + imm).
  j <= "01" when b = '1' else ctl.jmp_ctl;

  -- TODO combine jmp_ctl and a branch bit info a pc_ctl?

  pc_mux: entity work.mux3 port map(pc_plus4, pc_jmp1, pc_jmp2, j, pc_next);

  -- register logic

  rfile_0: entity work.rfile port map(
    clk, ctl.rd_write, rs1_idx, rs2_idx, rd_idx, rs1, rs2, rd
  );

  rd_mux: entity work.mux3 port map(
    aluout, readdata, pc_plus4,
    -- TODO somehow yosys sees a loop for rd_src
    ctl.rd_src,
    rd
  );

  -- ALU logic

  srca_mux: entity work.mux2 port map(rs1, pc, ctl.alu_srca, srca);
  srcb_mux: entity work.mux2 port map(rs2, imm, ctl.alu_srcb, srcb);

  alu_0: entity work.alu port map(clk, srca, srcb, ctl.alu_ctl, aluout);

  /*
  process(clk) is
  begin
    if rising_edge(clk) then
      report "rs1:" & to_string(rs1_idx) & " rs2:" & to_string(rs2_idx) & " rd:" & to_string(rd_idx);
      -- report "pcjmp1:" & to_hstring(pcjmp1);
      -- report "pcjmp2:" & to_hstring(pcjmp2);
      -- report "pctmp:" & to_hstring(pctmp);
      -- report "pcnext:" & to_hstring(pcnext);
    end if;
  end process;
  */

end architecture rtl;
