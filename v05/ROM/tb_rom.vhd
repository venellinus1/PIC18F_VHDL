
ENTITY TEST_ROM IS END;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ARCHITECTURE TEST_ROM_ARCH OF TEST_ROM IS
COMPONENT ROM
	PORT 	(
	CLK		: IN	STD_LOGIC;
	RESET_NAI	: IN	STD_LOGIC;
	--
	
	
	INSTRUCTION_out	: OUT 	STD_LOGIC_VECTOR (15 DOWNTO 0);
	PC_in		: IN	STD_LOGIC_VECTOR (20 DOWNTO 0);
	ROM_SELECT_in	: IN	STD_LOGIC

		);
	 
END COMPONENT;

CONSTANT	Clock_cycles		: TIME := 10 ns;
CONSTANT	PERIOD          	: TIME  := 10 ns;
--
SIGNAL	CLK_sig		: STD_LOGIC:='0'; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
----
----
SIGNAL	INSTRUCTION_out_sig		: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	PC_in_sig		: STD_LOGIC_VECTOR (20 DOWNTO 0);
SIGNAL	ROM_SELECT_in_sig	: STD_LOGIC;
--
BEGIN
	uut: ROM PORT MAP
		(
	CLK			=> CLK_sig, 
	RESET_NAI		=> RESET_NAI_sig, 
	--
	INSTRUCTION_out		=> INSTRUCTION_out_sig,	
	PC_in			=> PC_in_sig,
	ROM_SELECT_in		=> ROM_SELECT_in_sig
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
PC_in_sig		<= B"000000000000000000000";
WAIT FOR 2*Clock_cycles;
ROM_SELECT_in_sig	<= '1'; --select rom
WAIT FOR 2*Clock_cycles;
PC_in_sig		<= B"000000000000000000001"; --      

WAIT FOR 2*Clock_cycles;
PC_in_sig		<= B"000000000000000000010";

WAIT FOR 2*Clock_cycles;
PC_in_sig		<= B"000000000000000000011";

WAIT FOR 2*Clock_cycles;
PC_in_sig		<= B"000000000000000000100";

WAIT FOR 2*Clock_cycles;
PC_in_sig		<= B"000000000000000000101";

WAIT FOR 2*Clock_cycles;
PC_in_sig		<= B"000000000000000000110";

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
	
	
