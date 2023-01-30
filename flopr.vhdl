library ieee;
use ieee.std_logic_1164.all;

-- flip-flop with synchronous reset

entity flopr is
  generic(width: integer);
  port(
    clk, reset: in  std_ulogic;
    d:          in  std_ulogic_vector(width - 1 downto 0);
    q:          out std_ulogic_vector(width - 1 downto 0)
  );
end;

architecture asynchronous of flopr is
begin
  process(clk, reset) begin
    if reset then
      q <= (others => '0');
    elsif rising_edge(clk) then
      q <= d;
    end if;
  end process;
end;
