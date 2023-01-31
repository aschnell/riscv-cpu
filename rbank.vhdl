library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

-- rtl_synthesis off
use work.probe.all;
-- rtl_synthesis on

entity rbank is
  port(
    clk:           in  std_ulogic;
    we3:           in  std_ulogic;
    ra1, ra2, wa3: in  std_ulogic_vector(4 downto 0);
    wd3:           in  std_ulogic_vector(31 downto 0);
    rd1, rd2:      out std_ulogic_vector(31 downto 0)
  );
end;

architecture rtl of rbank is

  type ram_type is array (31 downto 0) of std_ulogic_vector(31 downto 0);

  signal ram_data: ram_type := (others => x"00000000");

begin

  -- three-ported register file
  -- read two ports combinationally
  -- write third port on rising edge of clock
  -- register 0 hardwired to 0

  /*
  process(clk) is
  begin
    if rising_edge(clk) then
      for i in 0 to 31 loop
        if ram_data(i) /= 0 then
          report "rx" & to_string(i) & ": " & to_string(to_integer(ram_data(i)));
        end if;
      end loop;
    end if;
  end process;
  */

  process(clk)
  begin
    if rising_edge(clk) then
      if we3 = '1' and wa3 /= 0 then
        report "rx" & to_string(to_integer(wa3)) & ":" & to_string(wd3);
        ram_data(to_integer(wa3)) <= wd3;
      end if;
    end if;
  end process;

  process(ra1)
  begin
    if (to_integer(ra1) = 0) then
      rd1 <= x"00000000";
    else
      rd1 <= ram_data(to_integer(ra1));
    end if;
  end process;

  process(ra2)
  begin
    if (to_integer(ra2) = 0) then
      rd2 <= x"00000000";
    else
      rd2 <= ram_data(to_integer(ra2));
    end if;
  end process;

  probe_rx1 <= ram_data(1);

end architecture rtl;
