--binary counter
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

--entity declaration
entity binary_cntr is
	generic (n: integer := 4);
	port (
    clk: in std_logic; --system clock
	  cnten1 : in std_logic; -- acitve high count enable
	  cnten2 : in std_logic; -- active high count enable
	  up : in std_logic; -- count direction
	  clr_bar : in std_logic; -- synchrounous counter clear
	  rst_bar: in std_logic; -- synchronous reset
	  q: out std_logic_vector (n-1 downto 0);-- count
	  max_cnt: out std_logic);-- maximum count indication
end binary_cntr; 

--architecture declaration
architecture b_bin of binary_cntr is
--signal declaration
signal count: std_logic_vector (n-1 downto 0) := "0000";
begin
	p: process (clk, cnten1, cnten2, up, clr_bar, rst_bar)
	begin 
		if (rising_edge(clk)) then
			--rst_bar asserted, q set to 0
			if (rst_bar = '0') then
				q <= "0000";
				max_cnt <= '0';
		--clr_bar asserted, q set to 0
			elsif (clr_bar = '0') then
				count <= "0000";
				max_cnt <= '0';
		--cnten1 and cnten2 asserted, start counting and update q
			elsif (cnten1 = '1' and cnten2 = '1') then
				--if up is asserted, count up
				if (up = '1') then
					count <= count + '1';
					if (count = "1111") then
						max_cnt <= '1';
					--else count down
					else
					  count <= count - '1';	
					  end if;
				else
					  max_cnt <= '0';
				end if;
			end if;
		end if;
		q <= count;
		max_cnt <= '0';
		end process;
end b_bin;	