LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TEST_MULTIPLIER IS END;
ARCHITECTURE TEST_MULTIPLIYING OF TEST_MULTIPLIER IS
COMPONENT MULTIPLIER
PORT 	(
	CLK		: IN	STD_LOGIC;
	RESET_NAI	: IN	STD_LOGIC;
	--
	MULTIPLICAND1_in: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);		
 	MULTIPLICAND2_in: IN	STD_LOGIC_VECTOR (15 DOWNTO 0);
 	RESULT_OUT	: OUT 	STD_LOGIC_VECTOR (15 DOWNTO 0);
	TEST		: OUT	STD_LOGIC;
	TEST16BIT	: OUT	STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	 
END COMPONENT;

CONSTANT	Clock_cycles		: TIME := 10 ns;
CONSTANT	PERIOD          	: TIME  := 10 ns;
--
SIGNAL	CLK_sig		: STD_LOGIC:= '0'; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
--
SIGNAL	RESULT_OUT_sig		: STD_LOGIC_VECTOR (15 DOWNTO 0);-- := X"00000000";
SIGNAL	MULTIPLICAND1_in_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);		
SIGNAL	MULTIPLICAND2_in_sig	: STD_LOGIC_VECTOR (15 DOWNTO 0);	
SIGNAL	RESULT_RDY_sig		: STD_LOGIC:='0';
SIGNAL	RESULT_OUT_sig7		: STD_LOGIC_VECTOR (15 DOWNTO 0);-- := X"00000000";

BEGIN
	uut: MULTIPLIER PORT MAP
		(
	CLK		=> CLK_sig, 
	RESET_NAI	=> RESET_NAI_sig, 
	--
	MULTIPLICAND1_in	=> MULTIPLICAND1_in_sig,
	MULTIPLICAND2_in	=> MULTIPLICAND2_in_sig,
	RESULT_OUT		=> RESULT_OUT_sig,
	TEST			=> RESULT_RDY_sig,
	TEST16BIT		=> RESULT_OUT_sig7		
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
RESET_NAI_sig		<= '0';	
MULTIPLICAND1_in_sig	<= X"FA";
MULTIPLICAND2_in_sig	<= X"00AC";

--RESULT_RDY_sig			<= '0';
--MULT2_RESULT_RDY_sig		<= X"0000";
--RESULT_OUT_sig		<= (OTHERS => '0');
WAIT FOR 2*Clock_cycles;
RESET_NAI_sig	<= '1';	

--WAIT FOR 4*Clock_cycles;
--RESULT_RDY_sig			<= '1';


WAIT FOR 100*Clock_cycles;
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
	
