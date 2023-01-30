library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

entity top is
  port(
    CLK : in std_ulogic;      -- 16 MHz clock
    LED : out std_ulogic;     -- User/boot LED next to power LED
    USBPU : out std_ulogic;   -- USB pull-up resistor

    PIN_11 : in std_ulogic;
    PIN_12 : out std_ulogic;
    PIN_13 : out std_ulogic;
    PIN_14 : out std_ulogic
  );
end entity;

architecture rtl of top is

  signal reset: std_ulogic;
  signal memwrite: std_ulogic;
  signal writedata, dataaddr: std_ulogic_vector(31 downto 0);

begin

  -- drive USB pull-up resistor to '0' to disable USB
  USBPU <= '0';

  LED <= '0';

  soc: entity work.soc port map(
    CLK, reset, writedata, dataaddr, memwrite
  );

  reset <= PIN_11;

  PIN_12 <= memwrite;
  PIN_13 <= writedata(0);
  PIN_14 <= dataaddr(0);

end architecture rtl;
