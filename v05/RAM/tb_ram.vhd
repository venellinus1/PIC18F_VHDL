ENTITY TEST_RAM IS END;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ARCHITECTURE TEST_RAM_ARCH OF TEST_RAM IS
COMPONENT RAM
	PORT 	(
	CLK		: IN	STD_LOGIC;
	RESET_NAI	: IN	STD_LOGIC;
	--
	RW_in		: IN	STD_LOGIC;
	DATA_in		: IN 	STD_LOGIC_VECTOR (7 DOWNTO 0);
	DATA_out	: OUT 	STD_LOGIC_VECTOR (7 DOWNTO 0);
	ADDRESS_in	: IN	STD_LOGIC_VECTOR (11 DOWNTO 0);
	RAM_SELECT_in	: IN	STD_LOGIC

		);
	 
END COMPONENT;

CONSTANT	Clock_cycles		: TIME := 10 ns;
CONSTANT	PERIOD          	: TIME  := 10 ns;
--
SIGNAL	CLK_sig		: STD_LOGIC:= '0'; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
--
SIGNAL	DATA_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	DATA_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	ADDRESS_in_sig		: STD_LOGIC_VECTOR (11 DOWNTO 0);
SIGNAL	RW_in_sig		: STD_LOGIC;
SIGNAL	RAM_SELECT_in_sig	: STD_LOGIC;

--
BEGIN
	uut: RAM PORT MAP
		(
	CLK			=> CLK_sig, 
	RESET_NAI		=> RESET_NAI_sig, 
	--
	DATA_in			=> DATA_in_sig,
	DATA_out		=> DATA_out_sig,	
	ADDRESS_in		=> ADDRESS_in_sig,
	RW_in			=> RW_in_sig,
	RAM_SELECT_in		=> RAM_SELECT_in_sig
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

WAIT FOR 2*Clock_cycles;
RESET_NAI_sig	<= '1';	

WAIT FOR 2*Clock_cycles;
RAM_SELECT_in_sig	<= '1'; --select ram
RW_in_sig		<= '0';	--select write op
--FOR I IN 0 TO 383 LOOP
--	ADDRESS_in_sig		<= CONV_INTEGER(I);
--END FOR;
ADDRESS_in_sig		<= X"000";
DATA_in_sig		<= X"AA";
WAIT FOR 2*Clock_cycles;

ADDRESS_in_sig		<= X"001";
DATA_in_sig		<= X"55";
WAIT FOR 2*Clock_cycles;

ADDRESS_in_sig		<= X"002";
DATA_in_sig		<= X"AA";

WAIT FOR 2*Clock_cycles;
RW_in_sig		<= '1';
ADDRESS_in_sig		<= X"000";
WAIT FOR 2*Clock_cycles;
ADDRESS_in_sig		<= X"001";

WAIT FOR 2*Clock_cycles;
ADDRESS_in_sig		<= X"002";


WAIT FOR 10*Clock_cycles;
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
	
