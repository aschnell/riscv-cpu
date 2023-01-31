library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use work.probe.all;

entity imem is
  port(
    a:  in  std_ulogic_vector(5 downto 0);
    rd: out std_ulogic_vector(31 downto 0)
  );
end;

architecture rtl of imem is

  type ram_type is array (0 to 127) of std_ulogic_vector(31 downto 0);

  signal ram_data: ram_type := (
    x"9300a000",
    x"13014001",
    x"9301e001",
    x"33023100",
    x"b3023140",

    x"23264000",
    x"23285000",
    x"83230001",
    x"23287000",

    x"b7543412",
    x"93848467",
    x"23289000",

    x"83001001",
    x"83002001",
    x"83003001",
    x"83004001",

    others => x"00000000"
  );

  function swap(t: std_ulogic_vector(31 downto 0)) return std_logic_vector is
  begin
    return t(7 downto 0) & t(15 downto 8) & t(23 downto 16) & t(31 downto 24);
  end function swap;

begin

  -- rtl_synthesis off
  ram_data(0) <= probe_imem0 when probe_fake_imem = '1';
  ram_data(1) <= probe_imem1 when probe_fake_imem = '1';
  ram_data(2) <= probe_imem2 when probe_fake_imem = '1';
  ram_data(3) <= probe_imem3 when probe_fake_imem = '1';
  -- rtl_synthesis on

  rd <= swap(ram_data(to_integer(a)));

end architecture rtl;
