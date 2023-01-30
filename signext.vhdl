library ieee;
use ieee.std_logic_1164.all;

-- sign extender

entity signext is
  port(a: in  std_ulogic_vector(11 downto 0);
       y: out std_ulogic_vector(31 downto 0));
end;

architecture behave of signext is
begin
  y <= x"fffff" & a when a(11) else x"00000" & a; 
end;
