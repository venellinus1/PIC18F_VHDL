ENTITY TEST_CONTROL IS END;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.CPU_LIB.ALL;

ARCHITECTURE TEST_CONTROL_ARCH OF TEST_CONTROL IS
COMPONENT CONTROL
	PORT 	(
	CLK		: IN	STD_LOGIC;
	RESET_NAI	: IN	STD_LOGIC;
	--
	PCounter_in	: IN	STD_LOGIC_VECTOR (20 DOWNTO 0);
	PCounter_out	: OUT	STD_LOGIC_VECTOR (20 DOWNTO 0);
	INSTRUCTION_TYPE: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	 
END COMPONENT;

--------------------------------
--COMPONENT RAM
--	PORT	(
--	CLK		: IN	STD_LOGIC;
--	RESET_NAI	: IN	STD_LOGIC;
--	--
--	RW_in		: IN	STD_LOGIC;
--	DATA_in		: IN 	STD_LOGIC_VECTOR (7 DOWNTO 0);
--	DATA_out	: OUT 	STD_LOGIC_VECTOR (7 DOWNTO 0);
--	ADDRESS_in	: IN	STD_LOGIC_VECTOR (11 DOWNTO 0);
--	RAM_SELECT_in	: IN	STD_LOGIC
--		);
--END COMPONENT;	
---------------------------------


CONSTANT	Clock_cycles	: TIME := 10 ns;
CONSTANT	PERIOD          : TIME  := 10 ns;
--
SIGNAL	CLK_sig			: STD_LOGIC:= '0'; 
SIGNAL	RESET_NAI_sig		: STD_LOGIC;
--
SIGNAL	PCounter_in_sig		: STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL	PCounter_out_sig	: STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL	INSTRUCTION_TYPE_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
----ram signals--
SIGNAL	DATA_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	DATA_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	ADDRESS_in_sig		: STD_LOGIC_VECTOR (11 DOWNTO 0);
SIGNAL	RW_in_sig		: STD_LOGIC;
SIGNAL	RAM_SELECT_in_sig	: STD_LOGIC;

----rom signals--
SIGNAL	INSTRUCTION_out_sig	: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	PC_in_sig		: STD_LOGIC_VECTOR (20 DOWNTO 0);
SIGNAL	ROM_SELECT_in_sig	: STD_LOGIC;
----ALU signals
SIGNAL	WREG_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	WREG_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	STATUS_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	STATUS_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	INSTR_ALU_in_sig	: ALU_INSTRUCTION;
SIGNAL	RESULT_out_sig		: STD_LOGIC_VECTOR (8 DOWNTO 0);
SIGNAL	OPERAND_ALU_in_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	ALU_SELECT_sig		: STD_LOGIC;

--
BEGIN
--RAM1:	RAM PORT MAP (CLK_sig,RESET_NAI_sig,RW_in_sig,DATA_in_sig,DATA_out_sig,ADDRESS_in_sig,RAM_SELECT_in_sig);
	
	uut: CONTROL PORT MAP
		(
	CLK			=> CLK_sig, 
	RESET_NAI		=> RESET_NAI_sig, 
	--
	PCounter_in		=> PCounter_in_sig,
	INSTRUCTION_TYPE	=> INSTRUCTION_TYPE_sig
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
PCounter_in_sig	<= B"000000000000000000000";
STATUS_in_sig	<= (OTHERS => '0');

DATA_in_sig	<= (OTHERS => '0');
WAIT FOR 4*Clock_cycles;
RESET_NAI_sig	<= '1';	
PCounter_in_sig	<= B"000000000000000000000";
--RAM_SELECT_in_sig	<= '1';
--ADDRESS_in_sig		<= B"000000000110";
--DATA_in_sig		<= X"12";
--RW_in_sig		<= '0';

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000000001";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000000010";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000000011";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000000100";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000000101";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000000110";
WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000000111";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000001000";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000001001";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000001010";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000001011";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000001100";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000001101";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000001110";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000001111";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000010000";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000010001";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000010010";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000010011";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000010100";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000010101";
WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000010110";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000010111";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000011000";
WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000011001";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000011010";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000011011";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000011100";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000011101";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000011110";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000011111";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000100000";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000100001";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000100010";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000100011";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000100100";

WAIT FOR 4*Clock_cycles;
PCounter_in_sig	<= B"000000000000000100101";


WAIT FOR 200*Clock_cycles;
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
	
