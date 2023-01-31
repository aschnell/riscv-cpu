library ieee;
use ieee.std_logic_1164.all;

entity sl1 is
  port(
    a: in  std_ulogic_vector(31 downto 0);
    y: out std_ulogic_vector(31 downto 0)
  );
end;

architecture rtl of sl1 is
begin
  y <= a(30 downto 0) & "0";
end;
