ENTITY TEST_ALU IS END;


--PACKAGE MY_LIB IS 
--	TYPE	ALU_INSTRUCTION IS (ADDWF,ADDWFC,ANDWF,DECF,DECFSZ,DCFSNZ,INCF,INFSNZ,IORWF,SUBWF,SUBWFB,XORWF);
--END MY_LIB;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.CPU_LIB.ALL;	

ARCHITECTURE TEST_ALU_ARCH OF TEST_ALU IS
COMPONENT ALU
	PORT 	(
	CLK		: IN	STD_LOGIC;
	RESET_NAI	: IN	STD_LOGIC;
	--
	INSTR_ALU_in	: IN	ALU_INSTRUCTION;--ALU_INSTRUCTION;		
 	WREG_in		: IN 	STD_LOGIC_VECTOR (7 DOWNTO 0);		
	WREG_out	: OUT 	STD_LOGIC_VECTOR (7 DOWNTO 0);
	RESULT_out	: OUT	STD_LOGIC_VECTOR (8 DOWNTO 0);
	STATUS_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	STATUS_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	OPERAND_ALU_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	 
END COMPONENT;

CONSTANT	Clock_cycles		: TIME := 10 ns;
CONSTANT	PERIOD          	: TIME  := 10 ns;
--
SIGNAL	CLK_sig		: STD_LOGIC:= '0'; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
--
SIGNAL	WREG_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	WREG_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	STATUS_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	STATUS_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	INSTR_ALU_in_sig	: ALU_INSTRUCTION;
SIGNAL	RESULT_out_sig		: STD_LOGIC_VECTOR (8 DOWNTO 0);
SIGNAL	OPERAND_ALU_in_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);



--
BEGIN
	uut: ALU PORT MAP
		(
	CLK			=> CLK_sig, 
	RESET_NAI		=> RESET_NAI_sig, 
	--
	WREG_in			=> WREG_in_sig,
	WREG_out		=> WREG_out_sig,
	INSTR_ALU_in		=> INSTR_ALU_in_sig,
	RESULT_out		=> RESULT_out_sig,
	STATUS_in		=> STATUS_in_sig,
	STATUS_out		=> STATUS_out_sig,
	OPERAND_ALU_in		=> OPERAND_ALU_in_sig
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
INSTR_ALU_in_sig	<= SUBWFB;
OPERAND_ALU_in_sig	<= X"FF";
WREG_in_sig		<= X"12";
STATUS_in_sig (0)	<= '1';

WAIT FOR 2*Clock_cycles;
INSTR_ALU_in_sig	<= ADDWF;
WAIT FOR 2*Clock_cycles;
INSTR_ALU_in_sig	<= ADDWFC;
WAIT FOR 2*Clock_cycles;
INSTR_ALU_in_sig	<= ANDWF;
WAIT FOR 2*Clock_cycles;
INSTR_ALU_in_sig	<= DECF;
WAIT FOR 2*Clock_cycles;
INSTR_ALU_in_sig	<= INCF;
WAIT FOR 2*Clock_cycles;
INSTR_ALU_in_sig	<= IORWF;
WAIT FOR 2*Clock_cycles;
INSTR_ALU_in_sig	<= XORWF;

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
	
