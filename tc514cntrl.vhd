--Top level entity
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--entity declaration
entity tc514cntrl is 
	generic ( n : integer := 4);
	port (
		soc: in std_logic; -- start of conversion input
		rst_bar: in std_logic; -- reset
		clk: in std_logic; -- clock
		cmptr: in std_logic; -- from TC514 comparator
		a: out std_logic; -- TC514 phase control input
		b: out std_logic; -- TC514 phase control input
		dout: out std_logic_vector (n-1 downto 0); -- conversion result
		busy_bar: out std_logic -- converter busy
);

--pin declaration
attribute loc : string;
attribute loc of soc      : signal is "P2";
attribute loc of rst_bar  : signal is "P3";
attribute loc of clk      : signal is "P11";
attribute loc of cmptr    : signal is "P19";
attribute loc of a        : signal is "P20";
attribute loc of b        : signal is "P21";
attribute loc of dout     : signal is "P43,P42,p41,P40,P39,P38,P37,P36,P31,P30,P29,P28,P27,P26,P25,P24";
attribute loc of busy_bar : signal is "P18";

end tc514cntrl;

--architecture declaration
architecture b of tc514cntrl is
--signal declaration
signal clk_dvd_w: std_logic;
signal max_cnt_w: std_logic; 
signal cnt_en_w: std_logic;	
signal clr_cntr_bar_w: std_logic;
signal enable_w: std_logic;
signal d_w: std_logic_vector (n-1 downto 0);

--component declaration
component freq_div
	port (
	clk    : in std_logic; 
  rst_bar: in std_logic;
	divisor: in std_logic_vector(3 downto 0);
	clk_dvd: out std_logic);	
end component;

component binary_cntr
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
end component;

component out_reg
	generic (n: integer:= 4);
	port (
	  clk: std_logic; --system clock
	  enable: in std_logic; -- parallel load enable
	  rst_bar: in std_logic; -- synchronous reset
	  d: in std_logic_vector (n-1 downto 0); -- data in
	  q: out std_logic_vector (n-1 downto 0) -- data out
	);	
end component;

component tc514fsm
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
end component;

begin
--port map instantiation
u0: freq_div
	port map(
	  clk => clk, 
	  rst_bar => rst_bar,
	  divisor => "0100",
	  clk_dvd => clk_dvd_w);

u1: binary_cntr
	port map(
	  clk => clk,
	  cnten1 => cnt_en_w,
	  cnten2 => clk_dvd_w,
	  up => '1',
	  clr_bar => clr_cntr_bar_w,
	  rst_bar => rst_bar,
	  q => d_w, 
	  max_cnt => max_cnt_w);	

u2: tc514fsm
	port map(
	  soc => soc, 
	  cmptr  => cmptr,
	  max_cnt => max_cnt_w,
	  clk => clk, 
	  clk_dvd => clk_dvd_w,
	  rst_bar => rst_bar, 
	  a => a, 
	  b => b,
	  busy_bar => busy_bar, 
	  cnt_en => cnt_en_w,
	  clr_cntr_bar => clr_cntr_bar_w,
	  load_result => enable_w);
	
u3: out_reg
	port map( 
	  clk => clk,
	  enable => enable_w,
	  rst_bar => rst_bar,
	  d => d_w,
	  q => dout);


end b;