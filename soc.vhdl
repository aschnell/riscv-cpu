library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

-- SoC with RISC-V 32 Bit Core and RAM

entity soc is
  port(
    clk:                 in std_ulogic;
    reset:               in std_ulogic;
    writedata, dataaddr: buffer std_ulogic_vector(31 downto 0);
    memwrite:            buffer std_ulogic
  );
end entity;

architecture rtl of soc is

  signal pc, instr:     std_ulogic_vector(31 downto 0);
  signal readdata:      std_ulogic_vector(31 downto 0);
  signal mem_ctl:        std_ulogic_vector(2 downto 0);

begin

  -- instantiate processor and memories

  riscv32_0: entity work.riscv32 port map(
    clk, reset, pc, instr,
    memwrite, dataaddr, writedata, readdata, mem_ctl
  );

  imem_0: entity work.imem port map(
    pc(7 downto 2), instr
  );

  dmem_0: entity work.dmem port map(
    clk, memwrite, dataaddr, writedata, mem_ctl, readdata
  );

end architecture rtl;
