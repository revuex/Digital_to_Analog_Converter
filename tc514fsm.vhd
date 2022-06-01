--Moore Finite State Machine for the Controller made with TC514
library ieee;
use ieee.std_logic_1164.all;

--entity declaration
entity TC514fsm is
	generic (n: integer := 4);
	port (
		soc : in std_logic; -- start conversion control input
		cmptr : in std_logic; -- TC 514 comparator status input
		max_cnt : in std_logic; -- maximum count status input
		clk : in std_logic; -- system clock
		clk_dvd : in std_logic; -- clock divided down
		rst_bar: in std_logic; -- synchronous reset
		a : out std_logic; -- conversion phase control
		b : out std_logic; -- conversion phase control
		busy_bar : out std_logic; -- active low busy status
		cnt_en : out std_logic; -- counter enable control to counter
		clr_cntr_bar : out std_logic; -- signal to clear counter
		load_result : out std_logic); -- load enable
end TC514fsm;  

--architecture declaration
architecture b of TC514fsm is
--composite data type declaration
	type state is (azero_idle, azero, int, zero_int, deint, clr_cntr);
	signal present_state, next_state: state; --signal declaration
  
	begin
  
	u0: process(clk)
	begin 
	    if (rising_edge(clk) and rst_bar = '0') then
        present_state <= azero;			
      elsif (rising_edge(clk) and rst_bar = '1') then
				present_state <= next_state;
			end if;
	end process;
	
	u1: process (clk, soc, clk_dvd, present_state, max_cnt, cmptr, rst_bar)
	begin
		case present_state is
						
			when azero =>
			if (max_cnt = '1') then
				next_state <= azero_idle;
			else
				next_state <= azero;
			end if;
			
			when azero_idle =>
			if (soc = '1') then
				next_state <= int;
			else
				next_state <= azero_idle;
			end if;
			
			when int =>
			if (max_cnt = '1' and clk_dvd = '1') then 
				next_state <= deint;
			else 
				next_state <= int;
			end if;
			
			when zero_int =>
			if (cmptr = '1') then
				next_state <= clr_cntr;
			else
				next_state <= zero_int;
			end if;
			
			when deint =>
			if (cmptr = '0') then
				next_state <= zero_int;
			else 
				next_state <= deint;
			end if;
			
			when others => next_state <= azero;

			end case;
			end process;
			
			u2: process(present_state)
			begin
				case present_state is
					when azero =>
					a <= '0';
					b <= '1';
					load_result <= '0';
					cnt_en <= '1';
					clr_cntr_bar <= '1';
					busy_bar <= '0';
					
					when azero_idle =>
					a <= '0';
					b <= '1';
					load_result <= '0';
					cnt_en <= '0';
					clr_cntr_bar <= '1';
					busy_bar <= '1'; 
					
					when int =>
					a <= '1';
					b <= '0';
					load_result <= '0';
					cnt_en <= '1';
					clr_cntr_bar <= '1';
					busy_bar <= '0';
					
					when deint =>
					a <= '1';
					b <= '1';
					load_result <= '0';
					cnt_en <= '1';
					clr_cntr_bar <= '1';
					busy_bar <= '0';
					
					when zero_int =>
					a <= '0';
					b <= '0';
					load_result <= '1';
					cnt_en <= '0';
					clr_cntr_bar <= '1';
					busy_bar <= '0';
					
					when clr_cntr =>
					a <= '0';
					b <= '1';
					load_result <= '0';
					cnt_en <= '0';
					clr_cntr_bar <= '0';
					busy_bar <= '0';
					
				end case;
			end process;						
end b;