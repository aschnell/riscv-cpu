library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

package probe is

  -- I want external names :(

  -- rtl_synthesis off

  signal probe_fake: std_ulogic := '0';

  signal probe_in_imem0: std_ulogic_vector(31 downto 0);
  signal probe_in_imem1: std_ulogic_vector(31 downto 0);
  signal probe_in_imem2: std_ulogic_vector(31 downto 0);
  signal probe_in_imem3: std_ulogic_vector(31 downto 0);
  signal probe_in_imem4: std_ulogic_vector(31 downto 0);
  signal probe_in_imem5: std_ulogic_vector(31 downto 0);
  signal probe_in_imem6: std_ulogic_vector(31 downto 0);
  signal probe_in_imem7: std_ulogic_vector(31 downto 0);

  signal probe_out_instr: std_ulogic_vector(31 downto 0);

  signal probe_in_dmem0: std_ulogic_vector(XLEN - 1 downto 0) := (others => '0');
  signal probe_in_dmem1: std_ulogic_vector(XLEN - 1 downto 0) := (others => '0');
  signal probe_in_dmem2: std_ulogic_vector(XLEN - 1 downto 0) := (others => '0');
  signal probe_in_dmem3: std_ulogic_vector(XLEN - 1 downto 0) := (others => '0');

  signal probe_out_dmem0: std_ulogic_vector(XLEN - 1 downto 0);
  signal probe_out_dmem1: std_ulogic_vector(XLEN - 1 downto 0);
  signal probe_out_dmem2: std_ulogic_vector(XLEN - 1 downto 0);
  signal probe_out_dmem3: std_ulogic_vector(XLEN - 1 downto 0);

  signal probe_in_x1: std_ulogic_vector(XLEN - 1 downto 0) := (others => '0');
  signal probe_in_x2: std_ulogic_vector(XLEN - 1 downto 0) := (others => '0');
  signal probe_in_x3: std_ulogic_vector(XLEN - 1 downto 0) := (others => '0');

  signal probe_out_x1: std_ulogic_vector(XLEN - 1 downto 0);
  signal probe_out_x2: std_ulogic_vector(XLEN - 1 downto 0);
  signal probe_out_x3: std_ulogic_vector(XLEN - 1 downto 0);

  -- rtl_synthesis on

end package;
