LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TEST_TIMER2 IS END;
ARCHITECTURE TEST_TIMER2_ARCH OF TEST_TIMER2 IS
COMPONENT TIMER2
	PORT 	(
	CLK		: IN	STD_LOGIC;
	RESET_NAI	: IN	STD_LOGIC;
	--
	TOUTPS_in	: IN	STD_LOGIC_VECTOR (3 DOWNTO 0);		
 	T2CKPS_in	: IN 	STD_LOGIC_VECTOR (1 DOWNTO 0);
	TMR2ON_in	: IN	STD_LOGIC;
	TMR2IF_out	: OUT	STD_LOGIC;
	PR2_in		: IN 	STD_LOGIC_VECTOR (7 DOWNTO 0);		--set to FF upon Reset
	PR2_out		: OUT 	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TMR2_out	: OUT	STD_LOGIC
	);
	 
END COMPONENT;

CONSTANT	Clock_cycles		: TIME := 10 ns;
CONSTANT	PERIOD          	: TIME  := 10 ns;
--
SIGNAL	CLK_sig		: STD_LOGIC:= '0'; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
--
SIGNAL	TOUTPS_in_sig		: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL	T2CKPS_in_sig		: STD_LOGIC_VECTOR (1 DOWNTO 0); 	
SIGNAL	TMR2IF_out_sig		: STD_LOGIC;				
SIGNAL	TMR2ON_in_sig		: STD_LOGIC;
SIGNAL	TMR2_out_sig		: STD_LOGIC;
SIGNAL	PR2_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PR2_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	POSTSCALE_OUT_sig	: STD_LOGIC;
SIGNAL	POSTSCALE_int		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PRESCALE_OUT_sig	: STD_LOGIC;
SIGNAL	PRESCALE_int		: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL	PRESCALE_REG_sig	: STD_LOGIC_VECTOR (3 DOWNTO 0);


--
BEGIN
	uut: TIMER2 PORT MAP
		(
	CLK		=> CLK_sig, 
	RESET_NAI	=> RESET_NAI_sig, 
	--
	TOUTPS_in	=> TOUTPS_in_sig,
	T2CKPS_in	=> T2CKPS_in_sig,
	TMR2ON_in	=> TMR2ON_in_sig,   
	TMR2IF_out	=> TMR2IF_out_sig,
	PR2_in		=> PR2_in_sig,
	PR2_out		=> PR2_out_sig, 	
	TMR2_out	=> TMR2_out_sig
	);

PROCESS
BEGIN
CLK_sig <= NOT (CLK_sig) after PERIOD/2.0;
WAIT ON CLK_sig;

END PROCESS;
--------------------------------------------------------------------------------
	
PROCESS
BEGIN
--------------------------------------------------------------------------------
RESET_NAI_sig	<= '0';	
PR2_in_sig	<= X"FF";
T2CKPS_in_sig	<= (OTHERS => '0');
TOUTPS_in_sig	<= (OTHERS => '0');

WAIT FOR 2*Clock_cycles;
RESET_NAI_sig	<= '1';	

WAIT FOR 2*Clock_cycles;
TOUTPS_in_sig	<= X"5";
T2CKPS_in_sig	<= B"11";
PR2_in_sig	<= X"20";
WAIT FOR 100000*Clock_cycles;
--========================
REPORT " ";
REPORT " ";
REPORT " ";
REPORT " ";
REPORT " ";


Assert FALSE
    Report "End of Test Bench"
    Severity FAILURE;
    
    WAIT; -- This WAIT should not be removed
END PROCESS;
END;	
	
