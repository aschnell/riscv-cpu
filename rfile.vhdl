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

  process(clk) is
  begin
    if rising_edge(clk) then
      if we3 = '1' and addr3 /= 0 then
        report "write rx" & to_string(to_integer(addr3)) & ":" & to_string(data3_in);
        ram_data(to_integer(addr3)) <= data3_in;
      end if;
    end if;
  end process;

  -- not dealing with rx0 during read seems to be faster

  process(all) is
  begin
    -- if addr1 = 0 then
    -- data1_out <= x"00000000";
    -- else
    data1_out <= ram_data(to_integer(addr1));
    -- end if;
  end process;

  process(all) is
  begin
    -- if addr2 = 0 then
    -- data2_out <= x"00000000";
    -- else
    data2_out <= ram_data(to_integer(addr2));
    -- end if;
  end process;

  -- rtl_synthesis off
  probe_rx1 <= ram_data(1);
  probe_rx2 <= ram_data(2);
  probe_rx3 <= ram_data(3);
  -- rtl_synthesis on

  /*
  process(clk) is
  begin
    if rising_edge(clk) then
      report "rs1:" & to_string(addr1) & " " & to_string(ram_data(to_integer(addr1)));
      report "rs2:" & to_string(addr2) & " " & to_string(ram_data(to_integer(addr2)));
    end if;
  end process;
  */

end architecture rtl;
