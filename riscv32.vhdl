library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

entity riscv32 is
  port(
    clk:        in  std_ulogic;
    reset:      in  std_ulogic;
    pc:                out std_ulogic_vector(XLEN - 1 downto 0);
    instr:      in  std_ulogic_vector(31 downto 0);
    mem_write:         out std_ulogic;
    aluout:            out std_ulogic_vector(XLEN - 1 downto 0);
    writedata:         out std_ulogic_vector(XLEN - 1 downto 0);
    readdata:          in  std_ulogic_vector(XLEN - 1 downto 0);
    mem_ctl:    out std_ulogic_vector(2 downto 0)
  );
end;

architecture rtl of riscv32 is

  signal rd_src_ctl:    std_ulogic_vector(1 downto 0);
  signal rd_write:      std_ulogic;

  signal alu_srca_ctl:  std_ulogic;
  signal alu_srcb_ctl:  std_ulogic;

  signal alu_ctl:       std_ulogic_vector(3 downto 0);
  signal imm_ctl:       std_ulogic_vector(2 downto 0);

  signal ctl:           controls_t;

  alias opcode:         std_ulogic_vector(6 downto 0) is instr(6 downto 0);
  alias funct3:         std_ulogic_vector(2 downto 0) is instr(14 downto 12);
  alias funct7:         std_ulogic_vector(6 downto 0) is instr(31 downto 25);

begin

  process(clk) is
  begin
    if rising_edge(clk) then
      report "PC: " & to_hstring(pc) & "  instr: " & to_string(instr) & " " & to_hstring(instr);
    end if;
  end process;

  controller_0: entity work.controller port map(
    clk, opcode, funct3, funct7, ctl
  );

  mem_write <= ctl.mem_write;
  mem_ctl <= ctl.mem_ctl;

  datapath_0: entity work.datapath port map(
    clk, reset, pc, instr, aluout, writedata, readdata, ctl
  );

end architecture rtl;
