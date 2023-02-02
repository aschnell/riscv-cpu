library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

entity core is
  port(
    clk:        in  std_ulogic;
    reset:      in  std_ulogic;
    pc:         out std_ulogic_vector(XLEN - 1 downto 0);
    instr:      in  std_ulogic_vector(31 downto 0);
    mem_write:  out std_ulogic;
    aluout:     out std_ulogic_vector(XLEN - 1 downto 0);
    writedata:  out std_ulogic_vector(XLEN - 1 downto 0);
    readdata:   in  std_ulogic_vector(XLEN - 1 downto 0);
    mem_ctl:    out std_ulogic_vector(2 downto 0)
  );
end;

architecture rtl of core is

  alias opcode: std_ulogic_vector(6 downto 0) is instr(6 downto 0);
  alias funct3: std_ulogic_vector(2 downto 0) is instr(14 downto 12);
  alias funct7: std_ulogic_vector(6 downto 0) is instr(31 downto 25);

  signal ctl:   controls_t;

begin

  controller_0: entity work.controller port map(
    clk, opcode, funct3, funct7, ctl
  );

  datapath_0: entity work.datapath port map(
    clk, reset, pc, instr, aluout, writedata, readdata, ctl
  );

  mem_write <= ctl.mem_write;
  mem_ctl <= ctl.mem_ctl;

  -- rtl_synthesis off
  process(clk) is
  begin
    if rising_edge(clk) then
      report "pc: " & to_hstring(pc) & "  instr: " & to_string(instr) & " " & to_hstring(instr);
    end if;
  end process;
  -- rtl_synthesis on

end architecture rtl;
