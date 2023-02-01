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

  constant INVALID_CTL : controls_t := (
    rd_write => 'X', alu_srca => ALU_SRCA_NONE, alu_srcb => ALU_SRCB_NONE,
    mem_write => 'X', rd_src => RD_SRC_NONE, jmp_ctl => JMP_NONE, alu_ctl => ALU_NONE,
    imm_ctl => IMM_NONE, mem_ctl => MEM_NONE, branch_ctl => BRANCH_NONE
  );

begin

  -- TODO detect unknown instructions?

  process(all) is
  begin
    case opcode is

      when OPCODE_ALUI =>
        case funct3 is

          when "000" | "001" | "010" | "011" | "100" | "110" | "111" =>
            -- addi, slli, slti, sltiu, xori, ori, andi
            ctl <= (rd_write => '1', alu_srca => ALU_SRCA_RS1, alu_srcb => ALU_SRCB_IMM,
                    mem_write => '0', rd_src => RD_SRC_ALU, jmp_ctl => JMP_PCP4, alu_ctl => "0" & funct3,
                    imm_ctl => IMM_I, mem_ctl => MEM_NONE, branch_ctl => BRANCH_NEVER);

          when "101" =>
            -- srli, srai
            ctl <= (rd_write => '1', alu_srca => ALU_SRCA_RS1, alu_srcb => ALU_SRCB_IMM,
                    mem_write => '0', rd_src => RD_SRC_ALU, jmp_ctl => JMP_PCP4, alu_ctl => funct7(5) & funct3,
                    imm_ctl => IMM_SHAMT, mem_ctl => MEM_NONE, branch_ctl => BRANCH_NEVER);

          when others =>
            ctl <= INVALID_CTL;

        end case;

      when OPCODE_ALU =>
        -- add, sub, sll, slt, sltu, xor, srl, sra, or, and
        ctl <= (rd_write => '1', alu_srca => ALU_SRCA_RS1, alu_srcb => ALU_SRCB_RS2,
                mem_write => '0', rd_src => RD_SRC_ALU, jmp_ctl => JMP_PCP4, alu_ctl => funct7(5) & funct3,
                imm_ctl => IMM_NONE, mem_ctl => MEM_NONE, branch_ctl => BRANCH_NEVER);

      when OPCODE_LOAD =>
        -- lb, lb, lw, lbu, lhu
        ctl <= (rd_write => '1', alu_srca => ALU_SRCA_RS1, alu_srcb => ALU_SRCB_IMM,
                mem_write => '0', rd_src => RD_SRC_MEM, jmp_ctl => JMP_PCP4, alu_ctl => ALU_ADD,
                imm_ctl => IMM_I, mem_ctl => funct3, branch_ctl => BRANCH_NEVER);

      when OPCODE_STORE =>
        -- sb, sh, sw
        ctl <= (rd_write => '0', alu_srca => ALU_SRCA_RS1, alu_srcb => ALU_SRCB_IMM,
                mem_write => '1', rd_src => RD_SRC_NONE, jmp_ctl => JMP_PCP4, alu_ctl => ALU_ADD,
                imm_ctl => IMM_S, mem_ctl => funct3, branch_ctl => BRANCH_NEVER);

      when OPCODE_LUI | OPCODE_AUIPC =>
        -- lui, auipc
        ctl <= (rd_write => '1', alu_srca => not opcode(5), alu_srcb => ALU_SRCB_IMM,
                mem_write => '0', rd_src => RD_SRC_ALU, jmp_ctl => JMP_PCP4, alu_ctl => ALU_OR,
                imm_ctl => IMM_U, mem_ctl => MEM_NONE, branch_ctl => BRANCH_NEVER);

      when OPCODE_BRANCH =>
        -- beq, bne, blt, bge, bltu, bgeu
        ctl <= (rd_write => '0', alu_srca => ALU_SRCA_NONE, alu_srcb => ALU_SRCB_NONE,
                mem_write => '0', rd_src => RD_SRC_NONE, jmp_ctl => JMP_PCP4, alu_ctl => ALU_NONE,
                imm_ctl => IMM_B, mem_ctl => MEM_NONE, branch_ctl => funct3);

      when OPCODE_JALR =>
        -- jalr
        ctl <= (rd_write => '1', alu_srca => ALU_SRCA_RS1, alu_srcb => ALU_SRCB_RS2,
                mem_write => '0', rd_src => RD_SRC_PCP4, jmp_ctl => JMP_RS1PIMM, alu_ctl => ALU_NONE,
                imm_ctl => IMM_I, mem_ctl => MEM_NONE, branch_ctl => BRANCH_NEVER);

      when OPCODE_JAL =>
        -- jal
        ctl <= (rd_write => '1', alu_srca => ALU_SRCA_RS1, alu_srcb => ALU_SRCB_RS2,
                mem_write => '0', rd_src => RD_SRC_PCP4, jmp_ctl => JMP_PCPIMM, alu_ctl => ALU_NONE,
                imm_ctl => IMM_J, mem_ctl => MEM_NONE, branch_ctl => BRANCH_NEVER);

      when others =>
        ctl <= INVALID_CTL;

    end case;
  end process;

  process(clk) is
  begin
    if rising_edge(clk) then
      report "opcode:" & to_string(opcode);
      report "funct3:" & to_string(funct3);
      report "alu_srca:" & to_string(ctl.alu_srca) & " alu_srcb:" & to_string(ctl.alu_srcb);
      report "imm_ctl:" & to_string(ctl.imm_ctl);
      report "jmp_ctl:" & to_string(ctl.jmp_ctl);
    end if;
  end process;

end architecture rtl;
