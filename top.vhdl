library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port(
    CLK:    in std_ulogic;    -- 16 MHz clock
    LED:    out std_ulogic;   -- User/boot LED next to power LED
    USBPU:  out std_ulogic;   -- USB pull-up resistor

    PIN_11: out std_ulogic;
    PIN_12: out std_ulogic;
    PIN_13: out std_ulogic;
    PIN_14: out std_ulogic;
    PIN_15: out std_ulogic;
    PIN_16: out std_ulogic;
    PIN_17: out std_ulogic;
    PIN_18: out std_ulogic
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

  -- handle "IO mapped device"
  process(CLK) is
  begin
    if rising_edge(CLK) then
      if mem_we = '1' and mem_addr = x"00020000" then
        LED <= mem_data(5);
        (PIN_11, PIN_12, PIN_13, PIN_14, PIN_15, PIN_16, PIN_17, PIN_18) <= mem_data(7 downto 0);
      end if;
    end if;
  end process;

end architecture rtl;
