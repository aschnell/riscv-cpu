library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use work.common.all;
-- rtl_synthesis off
use work.probe.all;
-- rtl_synthesis on

-- three-port register file

entity rfile is
  port(
    clk:        in  std_ulogic;
    we3:        in  std_ulogic;
    addr1:      in  std_ulogic_vector(4 downto 0);
    addr2:      in  std_ulogic_vector(4 downto 0);
    addr3:      in  std_ulogic_vector(4 downto 0);
    data1_out:  out std_ulogic_vector(XLEN - 1 downto 0);
    data2_out:  out std_ulogic_vector(XLEN - 1 downto 0);
    data3_in:   in  std_ulogic_vector(XLEN - 1 downto 0)
  );
end;

architecture rtl of rfile is

  type ram_type is array (31 downto 0) of std_ulogic_vector(XLEN - 1 downto 0);

  signal ram_data: ram_type := (others => x"00000000");

begin

  process(clk) is
  begin
    if rising_edge(clk) then
      if we3 = '1' and addr3 /= 0 then
        ram_data(to_integer(addr3)) <= data3_in;
      end if;
    end if;
  end process;

  -- no special dealing for x0 during read is faster

  data1_out <= ram_data(to_integer(addr1));
  data2_out <= ram_data(to_integer(addr2));

  -- rtl_synthesis off
  probe_x1 <= ram_data(1);
  probe_x2 <= ram_data(2);
  probe_x3 <= ram_data(3);
  -- rtl_synthesis on

  -- rtl_synthesis off
  process(clk) is
  begin
    if rising_edge(clk) then

      report "rs1:" & to_string(addr1) & " " & to_string(ram_data(to_integer(addr1))) & " " &
             to_hstring(ram_data(to_integer(addr1)));

      report "rs2:" & to_string(addr2) & " " & to_string(ram_data(to_integer(addr2))) & " " &
             to_hstring(ram_data(to_integer(addr2)));

      if we3 = '1' and addr3 /= 0 then
        report "write r" & to_string(to_integer(addr3)) & ":" & to_string(data3_in) & " " &
          to_hstring(data3_in);
      end if;

    end if;
  end process;
  -- rtl_synthesis on

end architecture rtl;
