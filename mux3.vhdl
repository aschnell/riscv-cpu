library ieee;
use ieee.std_logic_1164.all;

entity mux3 is
  generic(width: integer);
  port(
    d0, d1, d2: in  std_ulogic_vector(width - 1 downto 0);
    s:          in  std_ulogic_vector(1 downto 0);
    y:          out std_ulogic_vector(width - 1 downto 0)
  );
end;

architecture rtl of mux3 is
begin
  y <= d0 when s = "00" else
       d1 when s = "01" else
       d2;
end;
