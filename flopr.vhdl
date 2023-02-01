library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

-- flip-flop with synchronous reset

entity flopr is
  port(
    clk:        in  std_ulogic;
    reset:      in  std_ulogic;
    d:          in  std_ulogic_vector(XLEN - 1 downto 0);
    q:          out std_ulogic_vector(XLEN - 1 downto 0)
  );
end;

architecture rtl of flopr is
begin

  process(clk, reset) is
  begin
    if reset then
      q <= (others => '0');
    elsif rising_edge(clk) then
      q <= d;
    end if;
  end process;

end architecture rtl;
