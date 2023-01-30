library ieee;
use ieee.std_logic_1164.all;

-- shift left by 2

entity sl2 is
  port(a: in  std_ulogic_vector(31 downto 0);
       y: out std_ulogic_vector(31 downto 0));
end;

architecture behave of sl2 is
begin
  y <= a(29 downto 0) & "00";
end;
