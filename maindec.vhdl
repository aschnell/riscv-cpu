library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

entity maindec is
  port(
    clk:        in  std_ulogic;
    op:         in  std_ulogic_vector(6 downto 0);
    funct3:     in  std_ulogic_vector(2 downto 0);
    funct7:     in  std_ulogic_vector(6 downto 0);
    ctl:        out controls_t
  );
end;

architecture rtl of maindec is

  constant INVALID_CTL : controls_t := (
    rd_write => '-', alu_srca => '-', alu_srcb => '-', branch => '-',
    memwrite => '-', rd_src => "--", jump => '-', alu_ctl => "----",
    imm_ctl => "---", mem_ctl => "---"
  );

begin

  process(all)
  begin
    case op is

      when "0010011" =>
        case funct3 is

          when "000" =>
            -- addi
            ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '1', branch => '0',
                    memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0001",
                    imm_ctl => "001", mem_ctl => "000");

          when "010" =>
            -- slti
            ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '1', branch => '0',
                    memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "1011",
                    imm_ctl => "001", mem_ctl => "000");

          when "100" =>
            -- xori
            ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '1', branch => '0',
                    memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0101",
                    imm_ctl => "001", mem_ctl => "000");

          when "110" =>
            -- ori
            ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '1', branch => '0',
                    memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0100",
                    imm_ctl => "001", mem_ctl => "000");

          when "111" =>
            -- andi
            ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '1', branch => '0',
                    memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0011",
                    imm_ctl => "001", mem_ctl => "000");

          when others =>
            ctl <= INVALID_CTL;

        end case;

      when "0110011" =>
        case funct3 is

          when "000" =>

            case funct7 is

              when "0000000" =>
                -- add
                ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '0', branch => '0',
                        memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0001",
                        imm_ctl => "000", mem_ctl => "000");

              when "0100000" =>
                -- sub
                ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '0', branch => '0',
                        memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0010",
                        imm_ctl => "000", mem_ctl => "000");

              when others =>
                ctl <= INVALID_CTL;

            end case;

          when "001" =>
            case funct7 is

              when "0000000" =>
                -- sll
                ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '0', branch => '0',
                        memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0111",
                        imm_ctl => "000", mem_ctl => "000");

              when others =>
                ctl <= INVALID_CTL;

            end case;

          when "010" =>
            case funct7 is

              when "0000000" =>
                -- slt
                ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '0', branch => '0',
                        memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "1011",
                        imm_ctl => "000", mem_ctl => "000");

              when others =>
                ctl <= INVALID_CTL;

            end case;

          when "100" =>
            case funct7 is

              when "0000000" =>
                -- xor
                ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '0', branch => '0',
                        memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0101",
                        imm_ctl => "000", mem_ctl => "000");

              when others =>
                ctl <= INVALID_CTL;

            end case;

          when "101" =>
            case funct7 is

              when "0000000" =>
                -- srl
                ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '0', branch => '0',
                        memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0111",
                        imm_ctl => "000", mem_ctl => "000");

              when "0100000" =>
                -- sra
                ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '0', branch => '0',
                        memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "1000",
                        imm_ctl => "000", mem_ctl => "000");

              when others =>
                ctl <= INVALID_CTL;

            end case;

          when "110" =>
            case funct7 is

              when "0000000" =>
                -- or
                ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '0', branch => '0',
                        memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0100",
                        imm_ctl => "000", mem_ctl => "000");

              when others =>
                ctl <= INVALID_CTL;

            end case;

          when "111" =>
            case funct7 is

              when "0000000" =>
                -- and
                ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '0', branch => '0',
                        memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0011",
                        imm_ctl => "000", mem_ctl => "000");

              when others =>
                ctl <= INVALID_CTL;

            end case;

          when others =>
            ctl <= INVALID_CTL;

        end case;

      when "0000011" =>
        -- lb, lb, lw, lbu, lhu
        ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '1', branch => '0',
                memwrite => '0', rd_src => "01", jump => '0', alu_ctl => "0001",
                imm_ctl => "001", mem_ctl => funct3);

      when "0100011" =>
        -- sb, sh, sw
        ctl <= (rd_write => '0', alu_srca => '0', alu_srcb => '1', branch => '0',
                memwrite => '1', rd_src => "00", jump => '0', alu_ctl => "0001",
                imm_ctl => "010", mem_ctl => funct3);

      -- TODO bit 2 of op is ctl.alu_srca for lui and auipc
      when "0110111" =>
        -- lui
        ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '1', branch => '0',
                memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0101",
                imm_ctl => "011", mem_ctl => "000");

      when "0010111" =>
        -- auipc
        ctl <= (rd_write => '1', alu_srca => '1', alu_srcb => '1', branch => '0',
                memwrite => '0', rd_src => "00", jump => '0', alu_ctl => "0101",
                imm_ctl => "011", mem_ctl => "000");

      when "1101111" =>
        -- jal
        ctl <= (rd_write => '1', alu_srca => '0', alu_srcb => '0', branch => '0',
                memwrite => '0', rd_src => "10", jump => '1', alu_ctl => "0000",
                imm_ctl => "101", mem_ctl => "000");

      when others =>
        ctl <= INVALID_CTL;

    end case;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      report "op:" & to_string(op);
      report "alu_srca:" & to_string(ctl.alu_srca) & " alu_srcb:" & to_string(ctl.alu_srcb);
    end if;
  end process;

end;
