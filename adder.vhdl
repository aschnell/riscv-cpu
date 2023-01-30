library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std_unsigned.all;

-- adder

entity adder is
  port(
    a, b: in  std_ulogic_vector(31 downto 0);
    y:    out std_ulogic_vector(31 downto 0)
  );
end;

architecture behave of adder is
begin
  y <= a + b;
end;
