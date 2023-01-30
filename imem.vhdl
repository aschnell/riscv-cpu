library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

-- instruction memory

entity imem is
  port(
    a:  in  std_ulogic_vector(5 downto 0);
    rd: out std_ulogic_vector(31 downto 0)
  );
end;

architecture behave of imem is

  type ram_type is array (0 to 127) of std_ulogic_vector(31 downto 0);

  signal ram_data: ram_type := (
    x"9300a000",
    x"13014001",
    x"9301e001",
    x"33023100",
    x"b3822140",
    x"370324f4",
    x"23204000",
    x"83230000",
    x"23207000",
    others => x"00000000"
  );

begin

  rd(7 downto 0) <= ram_data(to_integer(a))(31 downto 24);
  rd(15 downto 8) <= ram_data(to_integer(a))(23 downto 16);
  rd(23 downto 16) <= ram_data(to_integer(a))(15 downto 8);
  rd(31 downto 24) <= ram_data(to_integer(a))(7 downto 0);

end architecture behave;
