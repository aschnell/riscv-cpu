library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

-- single cycle controller

entity controller is
  port(
    clk:        in  std_ulogic;
    opcode:     in  std_ulogic_vector(6 downto 0);
    funct3:     in  std_ulogic_vector(2 downto 0);
    funct7:     in  std_ulogic_vector(6 downto 0);
    ctl:        out controls_t
  );
end;

architecture rtl of controller is

  constant CTL_INVALID : controls_t := (
    rd_write => 'X', rd_src => RD_SRC_NONE, mem_write => 'X', mem_ctl => MEM_NONE,
    imm_ctl => IMM_NONE, alu_ctl => ALU_NONE, alu_srca => ALU_SRCA_NONE,
    alu_srcb => ALU_SRCB_NONE, pc_ctl => PC_NONE, branch_ctl => BRANCH_NONE
  );

begin

  -- TODO detect unknown instructions

  process(all) is
  begin

    case opcode is

      when OPCODE_ALUI =>
        case funct3 is

          when "000" | "001" | "010" | "011" | "100" | "110" | "111" =>
            -- addi, slli, slti, sltiu, xori, ori, andi
            ctl <= (rd_write => '1', rd_src => RD_SRC_ALU, mem_write => '0', mem_ctl => MEM_NONE,
                    imm_ctl => IMM_I,alu_ctl => "0" & funct3, alu_srca => ALU_SRCA_RS1,
                    alu_srcb => ALU_SRCB_IMM, pc_ctl => PC_PCP4, branch_ctl => BRANCH_NONE);

          when "101" =>
            -- srli, srai
            ctl <= (rd_write => '1', rd_src => RD_SRC_ALU, mem_write => '0',mem_ctl => MEM_NONE,
                    imm_ctl => IMM_SHAMT, alu_ctl => funct7(5) & funct3, alu_srca => ALU_SRCA_RS1,
                    alu_srcb => ALU_SRCB_IMM, pc_ctl => PC_PCP4, branch_ctl => BRANCH_NONE);

          when others =>
            ctl <= CTL_INVALID;

        end case;

      when OPCODE_ALU =>
        -- add, sub, sll, slt, sltu, xor, srl, sra, or, and
        ctl <= (rd_write => '1', rd_src => RD_SRC_ALU, mem_write => '0', mem_ctl => MEM_NONE,
                imm_ctl => IMM_NONE, alu_ctl => funct7(5) & funct3, alu_srca => ALU_SRCA_RS1,
                alu_srcb => ALU_SRCB_RS2, pc_ctl => PC_PCP4, branch_ctl => BRANCH_NONE);

      when OPCODE_LOAD =>
        -- lb, lb, lw, lbu, lhu
        ctl <= (rd_write => '1', rd_src => RD_SRC_MEM, mem_write => '0', mem_ctl => funct3,
                imm_ctl => IMM_I, alu_ctl => ALU_ADD, alu_srca => ALU_SRCA_RS1,
                alu_srcb => ALU_SRCB_IMM, pc_ctl => PC_PCP4, branch_ctl => BRANCH_NONE);

      when OPCODE_STORE =>
        -- sb, sh, sw
        ctl <= (rd_write => '0', rd_src => RD_SRC_NONE, mem_write => '1', mem_ctl => funct3,
                imm_ctl => IMM_S, alu_ctl => ALU_ADD, alu_srca => ALU_SRCA_RS1,
                alu_srcb => ALU_SRCB_IMM, pc_ctl => PC_PCP4, branch_ctl => BRANCH_NONE);

      when OPCODE_LUI | OPCODE_AUIPC =>
        -- lui, auipc
        ctl <= (rd_write => '1', rd_src => RD_SRC_ALU, mem_write => '0', mem_ctl => MEM_NONE,
                imm_ctl => IMM_U, alu_ctl => ALU_OR, alu_srca => not opcode(5),
                alu_srcb => ALU_SRCB_IMM, pc_ctl => PC_PCP4, branch_ctl => BRANCH_NONE);

      when OPCODE_BRANCH =>
        -- beq, bne, blt, bge, bltu, bgeu
        ctl <= (rd_write => '0', rd_src => RD_SRC_NONE, mem_write => '0', mem_ctl => MEM_NONE,
                imm_ctl => IMM_B, alu_ctl => ALU_NONE, alu_srca => ALU_SRCA_NONE,
                alu_srcb => ALU_SRCB_NONE, pc_ctl => PC_BRANCH, branch_ctl => funct3);

      when OPCODE_JALR =>
        -- jalr
        ctl <= (rd_write => '1', rd_src => RD_SRC_PCP4, mem_write => '0', mem_ctl => MEM_NONE,
                imm_ctl => IMM_I, alu_ctl => ALU_NONE, alu_srca => ALU_SRCA_RS1,
                alu_srcb => ALU_SRCB_RS2, pc_ctl => PC_RS1PIMM, branch_ctl => BRANCH_NONE);

      when OPCODE_JAL =>
        -- jal
        ctl <= (rd_write => '1', rd_src => RD_SRC_PCP4, mem_write => '0', mem_ctl => MEM_NONE,
                imm_ctl => IMM_J, alu_ctl => ALU_NONE, alu_srca => ALU_SRCA_RS1,
                alu_srcb => ALU_SRCB_RS2, pc_ctl => PC_PCPIMM, branch_ctl => BRANCH_NONE);

      when others =>
        ctl <= CTL_INVALID;

    end case;
  end process;

  -- rtl_synthesis off
  process(clk) is
  begin
    if rising_edge(clk) then
      report "opcode:" & to_string(opcode);
      report "funct3:" & to_string(funct3);
      report "funct7:" & to_string(funct7);
      report "imm_ctl:" & to_string(ctl.imm_ctl);
      report "alu_ctl:" & to_string(ctl.alu_ctl);
      report "alu_srca:" & to_string(ctl.alu_srca) & " alu_srcb:" & to_string(ctl.alu_srcb);
      report "pc_ctl:" & to_string(ctl.pc_ctl);
      report "branch_ctl:" & to_string(ctl.branch_ctl);
    end if;
  end process;
  -- rtl_synthesis on

end architecture rtl;
