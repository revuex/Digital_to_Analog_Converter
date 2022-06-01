--register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

--entity declaration
entity out_reg is
	generic (n: integer:= 4);
	port (
	  clk: std_logic; --system clock
	  enable: in std_logic; -- parallel load enable
	  rst_bar: in std_logic; -- asynchronous active low reset
	  d: in std_logic_vector (n-1 downto 0); -- data in
	  q: out std_logic_vector (n-1 downto 0) -- data out
	);
end out_reg; 

--architecture declaration
architecture behavioral_out_reg of out_reg is
--signal declaration
signal q_o: std_logic_vector(n-1 downto 0);
begin 
	d_ff: process(clk, rst_bar, d, enable)
	begin
		if (rst_bar = '0') then
			q_o <= (others => '0');
		elsif (rising_edge(clk) and enable = '1') then
			q_o <= d;
		end if;
	end process;
  --casting the signal to the output
	q <= q_o;
end behavioral_out_reg;
	
	