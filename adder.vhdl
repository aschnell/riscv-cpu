library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std_unsigned.all;
use work.common.all;

entity adder is
  port(
    a, b: in  std_ulogic_vector(XLEN - 1 downto 0);
    y:    out std_ulogic_vector(XLEN - 1 downto 0)
  );
end;

architecture rtl of adder is
begin

  y <= a + b;

end architecture rtl;
