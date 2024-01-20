library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port(
    CLK:    in  std_ulogic;   -- 16 MHz clock
    LED:    out std_ulogic;   -- User/boot LED next to power LED
    USBPU:  out std_ulogic;   -- USB pull-up resistor

    PIN_17: out std_ulogic;
    PIN_18: out std_ulogic;
    PIN_19: out std_ulogic;
    PIN_20: out std_ulogic;
    PIN_21: out std_ulogic;
    PIN_22: out std_ulogic;
    PIN_23: out std_ulogic;
    PIN_24: out std_ulogic
  );
end entity;

architecture rtl of top is

  signal reset:         std_ulogic := '1';
  signal reset_counter: unsigned(1 downto 0) := "11";

  signal mem_we:        std_ulogic;
  signal mem_addr:      std_ulogic_vector(31 downto 0);
  signal mem_data:      std_ulogic_vector(31 downto 0);

begin

  -- drive USB pull-up resistor to '0' to disable USB
  USBPU <= '0';

  soc_0: entity work.soc port map(
    CLK, reset, mem_data, mem_addr, mem_we
  );

  -- reset for a few clock cycles
  process(CLK) is
  begin
    if rising_edge(CLK) then
      if reset_counter = 0 then
        reset <= '0';
      else
        reset_counter <= reset_counter - 1;
      end if;
    end if;
  end process;

  -- handle memory-mapped I/O devices
  process(CLK) is
  begin
    if rising_edge(CLK) then
      if mem_we = '1' and mem_addr = x"00080000" then
        LED <= mem_data(0);
      end if;
      if mem_we = '1' and mem_addr = x"00080001" then
        (PIN_24, PIN_23, PIN_22, PIN_21, PIN_20, PIN_19, PIN_18, PIN_17) <= mem_data(7 downto 0);
      end if;
    end if;
  end process;

end architecture rtl;
