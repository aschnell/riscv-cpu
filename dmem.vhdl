library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use work.common.all;
-- rtl_synthesis off
use work.probe.all;
-- rtl_synthesis on

-- data memory

entity dmem is
  port(
    clk:        in  std_ulogic;
    we:         in  std_ulogic;                           -- write enable
    addr:       in  std_ulogic_vector(XLEN - 1 downto 0); -- address
    data_in:    in  std_ulogic_vector(XLEN - 1 downto 0); -- data in
    mem_ctl:    in  std_ulogic_vector(2 downto 0);
    data_out:   out std_ulogic_vector(XLEN - 1 downto 0)  -- data out
  );
end;

architecture rtl of dmem is

  type ram_type is array (0 to 63) of std_ulogic_vector(XLEN - 1 downto 0);

  signal ram_data: ram_type := (

    -- hello3.c

    -- switch
    x"3f000040", x"664f5b06", x"7f077d6d", x"0000006f",
    x"00000000", x"00000000", x"76000079", x"38000000",
    x"003f0000", x"006d0000", x"0000003e",

    -- string
    x"4c4c4548", x"5553204f", x"2d204553", x"32313020",
    x"36353433", x"20393837", x"0000202d",

    others => x"00000000"
  );

begin

  -- TODO Add a memory controller that accesses the real memory in a
  -- normal way, likely with a write mask for byte and half word
  -- writes.

  process(clk) is

    variable idx: integer;

  begin

    idx := to_integer(addr(7 downto 2));

    if rising_edge(clk) then
      if addr(31 downto 8) = x"000100" and we = '1' then

        report "mem_ctl:" & to_string(mem_ctl) & " dmem" & to_string(idx) & ":" & to_hstring(data_in);

        case mem_ctl is

          when MEM_1B =>
            case addr(1 downto 0) is
              when "00" => ram_data(idx)(7 downto 0) <= data_in(7 downto 0);
              when "01" => ram_data(idx)(15 downto 8) <= data_in(7 downto 0);
              when "10" => ram_data(idx)(23 downto 16) <= data_in(7 downto 0);
              when "11" => ram_data(idx)(31 downto 24) <= data_in(7 downto 0);
              when others =>
            end case;

          when MEM_2B =>
            case addr(1) is
              when '0' => ram_data(idx)(15 downto 0) <= data_in(15 downto 0);
              when '1' => ram_data(idx)(31 downto 16) <= data_in(15 downto 0);
              when others =>
            end case;

          when MEM_4B =>
            ram_data(idx) <= data_in;

          when others =>

        end case;

      end if;
    end if;
  end process;


  process(all) is

    variable idx: integer;
    variable tmp: std_ulogic_vector(31 downto 0);

  begin

    idx := to_integer(addr(7 downto 2));
    tmp := ram_data(idx);

    -- TODO that should be in soc.vhdl
    if addr(31 downto 8) = x"000100" then

      case mem_ctl is

        when MEM_1B =>
          case addr(1 downto 0) is
            when "00" => data_out <= (31 downto 8 => tmp(7)) & tmp(7 downto 0);
            when "01" => data_out <= (31 downto 8 => tmp(15)) & tmp(15 downto 8);
            when "10" => data_out <= (31 downto 8 => tmp(23)) & tmp(23 downto 16);
            when "11" => data_out <= (31 downto 8 => tmp(31)) & tmp(31 downto 24);
            when others =>
          end case;

        when MEM_2B =>
          case addr(1) is
            when '0' => data_out <= (31 downto 16 => tmp(15)) & tmp(15 downto 0);
            when '1' => data_out <= (31 downto 16 => tmp(31)) & tmp(31 downto 16);
            when others =>
          end case;

        when MEM_4B =>
          data_out <= ram_data(to_integer(addr(7 downto 2)));

        when MEM_1BU =>
          case addr(1 downto 0) is
            when "00" => data_out <= x"000000" & tmp(7 downto 0);
            when "01" => data_out <= x"000000" & tmp(15 downto 8);
            when "10" => data_out <= x"000000" & tmp(23 downto 16);
            when "11" => data_out <= x"000000" & tmp(31 downto 24);
            when others =>
          end case;

        when MEM_2BU =>
          case addr(1) is
            when '0' => data_out <= x"0000" & tmp(15 downto 0);
            when '1' => data_out <= x"0000" & tmp(31 downto 16);
            when others =>
          end case;

        when others =>
          data_out <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

      end case;

    else

      data_out <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

    end if;

  end process;

  -- rtl_synthesis off
  probe_dmem0 <= ram_data(0);
  probe_dmem1 <= ram_data(1);
  probe_dmem2 <= ram_data(2);
  probe_dmem3 <= ram_data(3);
  -- rtl_synthesis on

  -- rtl_synthesis off
  process(clk) is

    variable idx: integer;

  begin

    idx := to_integer(addr(7 downto 2));

    if rising_edge(clk) then
      if addr(31 downto 8) = x"000100" then
        report "mem_ctl:" & to_string(mem_ctl) & " addr:" & to_hstring(addr);

        if we = '1' then
          report "data_in:" & to_hstring(data_in);
        end if;

        report "data_out:" & to_hstring(data_out);
      end if;
    end if;

  end process;
  -- rtl_synthesis on

end architecture rtl;
