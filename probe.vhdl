library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

package probe is

  -- I want external names :(

  -- rtl_synthesis off

  signal probe_fake_imem: std_ulogic := '0';
  signal probe_imem0: std_ulogic_vector(31 downto 0);
  signal probe_imem1: std_ulogic_vector(31 downto 0);
  signal probe_imem2: std_ulogic_vector(31 downto 0);
  signal probe_imem3: std_ulogic_vector(31 downto 0);
  signal probe_imem4: std_ulogic_vector(31 downto 0);
  signal probe_imem5: std_ulogic_vector(31 downto 0);
  signal probe_imem6: std_ulogic_vector(31 downto 0);
  signal probe_imem7: std_ulogic_vector(31 downto 0);

  signal probe_instr: std_ulogic_vector(31 downto 0);

  signal probe_dmem0: std_ulogic_vector(XLEN - 1 downto 0);
  signal probe_dmem1: std_ulogic_vector(XLEN - 1 downto 0);
  signal probe_dmem2: std_ulogic_vector(XLEN - 1 downto 0);
  signal probe_dmem3: std_ulogic_vector(XLEN - 1 downto 0);

  signal probe_rx1: std_ulogic_vector(XLEN - 1 downto 0);
  signal probe_rx2: std_ulogic_vector(XLEN - 1 downto 0);
  signal probe_rx3: std_ulogic_vector(XLEN - 1 downto 0);

  -- rtl_synthesis on

end package;
