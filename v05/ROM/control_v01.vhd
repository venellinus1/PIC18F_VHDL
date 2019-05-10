
ENTITY TEST_CONTROL IS END;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY	CONTROL IS
	PORT	(
	CLK		: IN	STD_LOGIC;
	RESET_NAI	: IN	STD_LOGIC;
	--
	PCounter_in_sig : IN	STD_LOGIC_VECTOR (20 DOWNTO 0)
		);
END CONTROL;		

ARCHITECTURE TEST_CONTROL_ARCH OF TEST_CONTROL IS
---------------------------------	
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
--------------------------------
COMPONENT RAM
	PORT	(
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
---------------------------------
CONSTANT	Clock_cycles		: TIME := 10 ns;
CONSTANT	PERIOD          	: TIME  := 10 ns;
--
SIGNAL	CLK_sig		: STD_LOGIC:='0'; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
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
--
BEGIN
	uut: CONTROL PORT MAP
		(
	CLK			=> CLK_sig, 
	RESET_NAI		=> RESET_NAI_sig, 
	--
	INSTRUCTION_out		=> INSTRUCTION_out_sig,	
	PC_in			=> PC_in_sig,
	ROM_SELECT_in		=> ROM_SELECT_in_sig,
	--
	DATA_in			=> DATA_in_sig,
	DATA_out		=> DATA_out_sig,
	ADDRESS_in		=> ADDRESS_in_sig,
	RW_in			=> RW_in_sig,
	RAM_SELECT_in		=> RAM_SELECT_in_sig
		);

PROCESS


END PROCESS;
--------------------------------------------------------------------------------
	
--------------------------------------------------------------------------------
END;	
	
	
