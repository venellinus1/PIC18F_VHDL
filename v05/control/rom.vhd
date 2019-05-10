LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;

ENTITY ROM IS
PORT	(
	CLK		: IN	STD_LOGIC;
	RESET_NAI	: IN	STD_LOGIC;
	--
	
	
	INSTRUCTION_out	: OUT 	STD_LOGIC_VECTOR (15 DOWNTO 0);
	PC_in		: IN	STD_LOGIC_VECTOR (20 DOWNTO 0);
	ROM_SELECT_in	: IN	STD_LOGIC
	);
END ROM;

ARCHITECTURE TEST_ROM_ARCH OF ROM IS

SIGNAL	CLK_sig		: STD_LOGIC; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
----
----
SIGNAL	INSTRUCTION_out_sig		: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	PC_in_sig		: STD_LOGIC_VECTOR (20 DOWNTO 0);
SIGNAL	ROM_SELECT_in_sig	: STD_LOGIC;

BEGIN
INSTRUCTION_out		<= INSTRUCTION_out_sig;	
PC_in_sig		<= PC_in;
ROM_SELECT_in_sig	<= ROM_SELECT_in;

PROCESS(CLK,RESET_NAI)	
--file vector_file: text is in "D:\Modeltech_5.8e\work\cpu1220\v04s\rom\test.hex";
--variable l:line;
--variable vector_time : time;
--variable r:real;
--variable good_number,good_val:boolean;
--variable space : character;
TYPE T_MEM IS ARRAY (0 TO 37) OF STD_LOGIC_VECTOR (15 DOWNTO 0);

VARIABLE I : INTEGER;
VARIABLE MEM_DATA : T_MEM :=
(X"EF02",
 X"F000",
 X"0E55",
 X"6E00",
 X"0EAA",
 X"2600",
 X"6E01",
 X"2200",
 X"d001",
 X"e701",
 X"e301",
 X"e201",
 X"e401",
 X"e601",
 X"e501",
 X"e003",
 X"e101",
 X"0000",
 X"0f15",
 X"0b05",
 X"0845",
 X"0a18",
 X"0919",
 X"6a00",
 X"6800",
 X"3e00",
 X"4a00",
 X"1200",
 X"3600",
 X"4600",
 X"3200",
 X"4200",
 X"5600",
 X"5e00",
 X"3a00",
 X"1a00",
 X"2e00",
 X"4e00"
 ); 

BEGIN
IF RESET_NAI = '0' THEN	
	INSTRUCTION_out_sig	<= (OTHERS => '0');
		
ELSIF CLK'EVENT AND CLK = '1' THEN
	
	IF ROM_SELECT_in_sig = '1' THEN
		INSTRUCTION_out_sig <= MEM_DATA(CONV_INTEGER(PC_in_sig));
	ELSIF ROM_SELECT_in_sig = '0' THEN 
		INSTRUCTION_out_sig <= "ZZZZZZZZZZZZZZZZ";
	END IF;	



END IF;
END PROCESS;	

END TEST_ROM_ARCH;


