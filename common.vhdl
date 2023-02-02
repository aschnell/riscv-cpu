library ieee;
use ieee.std_logic_1164.all;

package common is

  constant XLEN:            natural := 32;

  constant OPCODE_LOAD:     std_ulogic_vector(6 downto 0) := "0000011";
  constant OPCODE_ALUI:     std_ulogic_vector(6 downto 0) := "0010011"; -- ALU operation with immediate
  constant OPCODE_AUIPC:    std_ulogic_vector(6 downto 0) := "0010111";
  constant OPCODE_ALU:      std_ulogic_vector(6 downto 0) := "0110011"; -- ALU operation
  constant OPCODE_LUI:      std_ulogic_vector(6 downto 0) := "0110111";
  constant OPCODE_STORE:    std_ulogic_vector(6 downto 0) := "0100011";
  constant OPCODE_BRANCH:   std_ulogic_vector(6 downto 0) := "1100011";
  constant OPCODE_JALR:     std_ulogic_vector(6 downto 0) := "1100111";
  constant OPCODE_JAL:      std_ulogic_vector(6 downto 0) := "1101111";

  constant RD_SRC_ALU:      std_ulogic_vector(1 downto 0) := "00";
  constant RD_SRC_MEM:      std_ulogic_vector(1 downto 0) := "01";
  constant RD_SRC_PCP4:     std_ulogic_vector(1 downto 0) := "10"; -- pc + 4
  constant RD_SRC_NONE:     std_ulogic_vector(1 downto 0) := "XX";

  constant MEM_1B:          std_ulogic_vector(2 downto 0) := "000"; -- funct3 for OPCODE_LOAD and OPCODE_STORE
  constant MEM_2B:          std_ulogic_vector(2 downto 0) := "001"; -- funct3 for OPCODE_LOAD and OPCODE_STORE
  constant MEM_4B:          std_ulogic_vector(2 downto 0) := "010"; -- funct3 for OPCODE_LOAD and OPCODE_STORE
  constant MEM_1BU:         std_ulogic_vector(2 downto 0) := "100"; -- funct3 for OPCODE_LOAD and OPCODE_STORE
  constant MEM_2BU:         std_ulogic_vector(2 downto 0) := "101"; -- funct3 for OPCODE_LOAD and OPCODE_STORE
  constant MEM_NONE:        std_ulogic_vector(2 downto 0) := "XXX";

  constant IMM_I:           std_ulogic_vector(2 downto 0) := "001";
  constant IMM_S:           std_ulogic_vector(2 downto 0) := "010";
  constant IMM_U:           std_ulogic_vector(2 downto 0) := "011";
  constant IMM_B:           std_ulogic_vector(2 downto 0) := "100";
  constant IMM_J:           std_ulogic_vector(2 downto 0) := "101";
  constant IMM_SHAMT:       std_ulogic_vector(2 downto 0) := "110";
  constant IMM_NONE:        std_ulogic_vector(2 downto 0) := "XXX";

  constant ALU_ADD:         std_ulogic_vector(3 downto 0) := "0000"; -- '0' & funct3 for OPCODE_ALUI
  constant ALU_SLL:         std_ulogic_vector(3 downto 0) := "0001"; -- '0' & funct3 for OPCODE_ALUI
  constant ALU_SLT:         std_ulogic_vector(3 downto 0) := "0010"; -- '0' & funct3 for OPCODE_ALUI
  constant ALU_SLTU:        std_ulogic_vector(3 downto 0) := "0011"; -- '0' & funct3 for OPCODE_ALUI
  constant ALU_XOR:         std_ulogic_vector(3 downto 0) := "0100"; -- '0' & funct3 for OPCODE_ALUI
  constant ALU_SRL:         std_ulogic_vector(3 downto 0) := "0101"; -- '0' & funct3 for OPCODE_ALUI
  constant ALU_OR:          std_ulogic_vector(3 downto 0) := "0110"; -- '0' & funct3 for OPCODE_ALUI
  constant ALU_AND:         std_ulogic_vector(3 downto 0) := "0111"; -- '0' & funct3 for OPCODE_ALUI
  constant ALU_SUB:         std_ulogic_vector(3 downto 0) := "1000"; -- '1' & ALU_ADD(2..0)
  constant ALU_SRA:         std_ulogic_vector(3 downto 0) := "1101"; -- '1' & ALU_SRL(2..0)
  constant ALU_A:           std_ulogic_vector(3 downto 0) := "1110";
  constant ALU_B:           std_ulogic_vector(3 downto 0) := "1111";
  constant ALU_NONE:        std_ulogic_vector(3 downto 0) := "XXXX";

  constant ALU_SRCA_RS1:    std_ulogic := '0';
  constant ALU_SRCA_PC:     std_ulogic := '1';
  constant ALU_SRCA_NONE:   std_ulogic := 'X';

  constant ALU_SRCB_RS2:    std_ulogic := '0';
  constant ALU_SRCB_IMM:    std_ulogic := '1';
  constant ALU_SRCB_NONE:   std_ulogic := 'X';

  constant PC_PCP4:         std_ulogic_vector(1 downto 0) := "00"; -- pc + 4
  constant PC_PCPIMM:       std_ulogic_vector(1 downto 0) := "01"; -- pc + imm
  constant PC_RS1PIMM:      std_ulogic_vector(1 downto 0) := "10"; -- rs1 + imm
  constant PC_BRANCH:       std_ulogic_vector(1 downto 0) := "11"; -- depends on branch condition
  constant PC_NONE:         std_ulogic_vector(1 downto 0) := "XX";

  constant BRANCH_EQ:       std_ulogic_vector(2 downto 0) := "000"; -- funct3 for OPCODE_BRANCH
  constant BRANCH_NE:       std_ulogic_vector(2 downto 0) := "001"; -- funct3 for OPCODE_BRANCH
  constant BRANCH_LT:       std_ulogic_vector(2 downto 0) := "100"; -- funct3 for OPCODE_BRANCH
  constant BRANCH_GE:       std_ulogic_vector(2 downto 0) := "101"; -- funct3 for OPCODE_BRANCH
  constant BRANCH_LTU:      std_ulogic_vector(2 downto 0) := "110"; -- funct3 for OPCODE_BRANCH
  constant BRANCH_GEU:      std_ulogic_vector(2 downto 0) := "111"; -- funct3 for OPCODE_BRANCH
  constant BRANCH_NONE:     std_ulogic_vector(2 downto 0) := "XXX";

  type controls_t is record

    rd_write:   std_ulogic;                     -- enable write to rd
    rd_src:     std_ulogic_vector(1 downto 0);

    mem_write:  std_ulogic;                     -- enable write to memory
    mem_ctl:    std_ulogic_vector(2 downto 0);

    imm_ctl:    std_ulogic_vector(2 downto 0);

    alu_ctl:    std_ulogic_vector(3 downto 0);
    alu_srca:   std_ulogic;
    alu_srcb:   std_ulogic;

    pc_ctl:   std_ulogic_vector(1 downto 0);
    branch_ctl: std_ulogic_vector(2 downto 0);

  end record controls_t;

end package;

package body common is

end package body common;
