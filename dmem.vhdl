library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

-- data memory

entity dmem is
  port(
    clk, we:  in std_ulogic;
    a, wd:    in std_ulogic_vector(31 downto 0);
    rd:       out std_ulogic_vector(31 downto 0)
  );
end;

architecture behave of dmem is

  type ram_type is array (127 downto 0) of std_ulogic_vector(31 downto 0);
  signal ram_data: ram_type := (others => "00000000000000000000000000000000");

begin

  process(clk) is
  begin
    if rising_edge(clk) then
      if we then
        report "dmem[" & to_string(to_integer(a)) & "]: " & to_string(to_integer(wd));
        ram_data(to_integer(a(7 downto 2))) <= wd;
      end if;
    end if;
  end process;

  rd <= ram_data(to_integer(a(7 downto 2)));

end architecture behave;
