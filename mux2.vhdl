library ieee;
use ieee.std_logic_1164.all;

-- two-input multiplexer

entity mux2 is
  generic(width: integer);
  port(
    d0, d1: in  std_ulogic_vector(width - 1 downto 0);
    s:      in  std_ulogic;
    y:      out std_ulogic_vector(width - 1 downto 0)
  );
end;

architecture rtl of mux2 is
begin
  y <= d1 when s else
       d0;
end;
