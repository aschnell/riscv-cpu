library ieee;
use ieee.std_logic_1164.all;

-- shift left by 12

entity sl12 is
  port(
    a: in  std_ulogic_vector(31 downto 0);
    y: out std_ulogic_vector(31 downto 0)
  );
end;

architecture rtl of sl12 is
begin
  y <= a(19 downto 0) & "000";
end;
