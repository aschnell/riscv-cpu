library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

-- rtl_synthesis off
use work.probe.all;
-- rtl_synthesis on

-- data memory

entity dmem is
  port(
    clk, we:  in std_ulogic;
    a, wd:    in std_ulogic_vector(31 downto 0);
    mem_ctl:   in std_ulogic_vector(2 downto 0);
    rd:       out std_ulogic_vector(31 downto 0)
  );
end;


architecture behave of dmem is

  type ram_type is array (127 downto 0) of std_ulogic_vector(31 downto 0);

  signal ram_data: ram_type := (others => x"00000000");

begin

  -- rtl_synthesis off
  -- ram_data(1) <= probe_dmem1 when probe_fake_dmem = '1';
  -- rtl_synthesis on

  process(clk) is
  begin
    if rising_edge(clk) then
      if we then
        report "mem_ctl:" & to_string(mem_ctl) & " dmem[" & to_string(to_integer(a)) & "]:" & to_hstring(wd);

        case mem_ctl is

          when "000" =>
            case a(1 downto 0) is
              when "00" => ram_data(to_integer(a(7 downto 2)))(7 downto 0) <= wd(7 downto 0);
              when "01" => ram_data(to_integer(a(7 downto 2)))(15 downto 8) <= wd(7 downto 0);
              when "10" => ram_data(to_integer(a(7 downto 2)))(23 downto 16) <= wd(7 downto 0);
              when "11" => ram_data(to_integer(a(7 downto 2)))(31 downto 24) <= wd(7 downto 0);
              when others =>
            end case;

          when "001" =>
            case a(1) is
              when '0' => ram_data(to_integer(a(7 downto 2)))(15 downto 0) <= wd(15 downto 0);
              when '1' => ram_data(to_integer(a(7 downto 2)))(31 downto 16) <= wd(15 downto 0);
              when others =>
            end case;

          when "010" => ram_data(to_integer(a(7 downto 2))) <= wd;

          when others =>

        end case;

      end if;
    end if;
  end process;

  process(mem_ctl, a) is
  begin

    rd <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

    -- TODO sign ext

    case mem_ctl(1 downto 0) is

      when "00" =>
        case a(1 downto 0) is
          when "00" => rd <= x"000000" & ram_data(to_integer(a(7 downto 2)))(7 downto 0);
          when "01" => rd <= x"000000" & ram_data(to_integer(a(7 downto 2)))(15 downto 8);
          when "10" => rd <= x"000000" & ram_data(to_integer(a(7 downto 2)))(23 downto 16);
          when "11" => rd <= x"000000" & ram_data(to_integer(a(7 downto 2)))(31 downto 24);
          when others => -- rd <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end case;

      when "01" =>
        case a(1) is
          when '0' => rd <= x"0000" & ram_data(to_integer(a(7 downto 2)))(15 downto 0);
          when '1' => rd <= x"0000" & ram_data(to_integer(a(7 downto 2)))(31 downto 16);
          when others => -- rd <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end case;

      when "10" =>
        rd <= ram_data(to_integer(a(7 downto 2)));

      when others =>
        -- rd <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

    end case;

  end process;

  process(clk)
  begin
    if rising_edge(clk) then

      report "mem_ctl:" & to_string(mem_ctl) & " a:" & to_hstring(a) & " rd:" & to_hstring(rd);

    end if;
  end process;

  -- rtl_synthesis off
  probe_dmem1 <= ram_data(1);
  -- rtl_synthesis on

end architecture behave;
