library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

-- SoC with RISC-V 32 Bit Core and RAM

entity soc is
  port(
    clk:                in  std_ulogic;
    reset:              in  std_ulogic;
    writedata:          out std_ulogic_vector(XLEN - 1 downto 0);
    dataaddr:           out std_ulogic_vector(XLEN - 1 downto 0);
    mem_write:          out std_ulogic
  );
end entity;

architecture rtl of soc is

  signal pc:            std_ulogic_vector(XLEN - 1 downto 0);
  signal instr:         std_ulogic_vector(31 downto 0);
  signal readdata:      std_ulogic_vector(XLEN - 1 downto 0);
  signal mem_ctl:       std_ulogic_vector(2 downto 0);

begin

  -- instantiate processor and memories

  core_0: entity work.core port map(
    clk, reset, pc, instr, mem_write, dataaddr, writedata, readdata,
    mem_ctl
  );

  imem_0: entity work.imem port map(
    clk, reset, '1', pc, instr
  );

  dmem_0: entity work.dmem port map(
    clk, reset, mem_write, dataaddr, writedata, mem_ctl, readdata
  );

end architecture rtl;
