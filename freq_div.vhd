--frequency divider--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--entity declaration
entity freq_div is
	port(
	clk    : in std_logic; --system clock
  rst_bar: in std_logic; --asychronous active low reset
	divisor: in std_logic_vector(3 downto 0); --divisor
	clk_dvd: out std_logic); -- modulated output
end freq_div;	

--architecture declaration
architecture behavioral_freq_div of freq_div is
begin
	div: process(clk, rst_bar, divisor)
  --variable to hold the value of count
	variable count_v: unsigned(3 downto 0);
	begin 
		if (rst_bar = '0') then
			count_v := unsigned(divisor);
			clk_dvd <= '0';
		elsif (rst_bar = '1' and rising_edge(clk)) then
			case count_v is
				when "0001" =>
				count_v := unsigned(divisor);
				clk_dvd <= '0';
        
        when "0010" =>
				count_v := count_v -1;
				clk_dvd <= '1';		
				
				when others =>
				count_v := count_v -1;
				clk_dvd <= '0';	
				
				end case;
			end if;
		end process;
end;