PACKAGE CPU_LIB IS 
	TYPE	ALU_INSTRUCTION IS (ADDWF,ADDWFC,ANDWF,DECF,DECFSZ,DCFSNZ,INCF,INFSNZ,IORWF,SUBWF,SUBWFB,XORWF);
END CPU_LIB;


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE WORK.CPU_LIB.ALL;

ENTITY   ALU IS 
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
	OPERAND_ALU_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	ALU_SELECT	: IN	STD_LOGIC
	);
	 
END ALU;

ARCHITECTURE TEST_ALU_ARCH OF ALU IS

SIGNAL	CLK_sig		: STD_LOGIC; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
--
--
SIGNAL	WREG_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	WREG_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	STATUS_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	STATUS_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	INSTR_ALU_in_sig	: ALU_INSTRUCTION;
SIGNAL	RESULT_out_sig		: STD_LOGIC_VECTOR (8 DOWNTO 0);
SIGNAL	OPERAND_ALU_in_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	ALU_SELECT_sig		: STD_LOGIC;

BEGIN

WREG_in_sig		<= WREG_in;
WREG_out		<= WREG_out_sig;
INSTR_ALU_in_sig	<= INSTR_ALU_in;
RESULT_out		<= RESULT_out_sig;
STATUS_in_sig		<= STATUS_in;
STATUS_out		<= STATUS_out_sig;
OPERAND_ALU_in_sig	<= OPERAND_ALU_in;
ALU_SELECT_sig		<= ALU_SELECT;

PROCESS(CLK,RESET_NAI)			
BEGIN
IF RESET_NAI = '0' THEN	
	WREG_out_sig	<=	(OTHERS => '0');
	STATUS_out_sig	<=	(OTHERS => '0');
	RESULT_out_sig	<=	(OTHERS => '0');
 
ELSIF CLK'EVENT AND CLK = '1' THEN
	IF ALU_SELECT_sig = '1' THEN	
	WREG_out_sig	<=	(OTHERS => '0');
	STATUS_out_sig	<=	(OTHERS => '0');
	RESULT_out_sig	<=	RESULT_out_sig;
	IF 	INSTR_ALU_in_sig = ADDWF  THEN	
		RESULT_out_sig		<= ('0' & WREG_in_sig) + ('0' & OPERAND_ALU_in_sig);

		STATUS_out_sig(0)	<= RESULT_out_sig(8);	-- bit Carry in Status Register
		STATUS_out_sig(1)	<= RESULT_out_sig(4);	-- bit Digital carry 
		IF RESULT_out_sig = B"000000000" THEN		-- bit Zero 		
			STATUS_out_sig(2) <= '1';
			IF RESULT_out_sig(8) = '1' THEN		-- bit Overflow
				STATUS_out_sig(3) <= '1';
			END IF;	
		END IF;
		IF RESULT_OUT_sig (7) = '1' THEN		-- bit Negative,for signed operations 
			STATUS_out_sig(4) <= '1';
		END IF;	

	ELSIF	INSTR_ALU_in_sig = ADDWFC THEN
		RESULT_out_sig	<= ('0' & WREG_in_sig) + ('0' & OPERAND_ALU_in_sig) + (B"00000000" & STATUS_in_sig(0) );
		
		STATUS_out_sig(0)	<= RESULT_out_sig(8);	-- bit Carry in Status Register
		STATUS_out_sig(1)	<= RESULT_out_sig(4);	-- bit Digital carry 
		IF RESULT_out_sig = B"000000000" THEN		-- bit Zero 		
			STATUS_out_sig(2) <= '1';
			IF RESULT_out_sig(8) = '1' THEN		-- bit Overflow
				STATUS_out_sig(3) <= '1';
			END IF;	
		END IF;
		IF RESULT_OUT_sig (7) = '1' THEN		-- bit Negative,for signed operations 
			STATUS_out_sig(4) <= '1';
		END IF;	


	ELSIF	INSTR_ALU_in_sig = ANDWF THEN
		RESULT_out_sig	<= ('0' & WREG_in_sig) AND ('0' & OPERAND_ALU_in_sig);
	
		IF RESULT_out_sig = B"000000000" THEN		-- bit Zero 		
			STATUS_out_sig(2) <= '1';
		END IF;
		IF RESULT_OUT_sig (7) = '1' THEN		-- bit Negative,for signed operations 
			STATUS_out_sig(4) <= '1';
		END IF;	



	ELSIF	INSTR_ALU_in_sig = DECF OR INSTR_ALU_in_sig = DECFSZ  THEN
		RESULT_out_sig	<= ('0' & OPERAND_ALU_in_sig) - 1;
		
		STATUS_out_sig(0)	<= RESULT_out_sig(8);	-- bit Carry in Status Register
		STATUS_out_sig(1)	<= RESULT_out_sig(4);	-- bit Digital carry 
		IF RESULT_out_sig = B"000000000" THEN		-- bit Zero 		
			STATUS_out_sig(2) <= '1';
			IF RESULT_out_sig(8) = '1' THEN		-- bit Overflow
				STATUS_out_sig(3) <= '1';
			END IF;	
		END IF;
		IF RESULT_OUT_sig (7) = '1' THEN		-- bit Negative,for signed operations 
			STATUS_out_sig(4) <= '1';
		END IF;	


	ELSIF	INSTR_ALU_in_sig = INCF	OR INSTR_ALU_in_sig = INFSNZ THEN
		RESULT_out_sig	<= ('0' & OPERAND_ALU_in_sig) + 1;
	
		STATUS_out_sig(0)	<= RESULT_out_sig(8);	-- bit Carry in Status Register
		STATUS_out_sig(1)	<= RESULT_out_sig(4);	-- bit Digital carry 
		IF RESULT_out_sig = B"000000000" THEN		-- bit Zero 		
			STATUS_out_sig(2) <= '1';
			IF RESULT_out_sig(8) = '1' THEN		-- bit Overflow
				STATUS_out_sig(3) <= '1';
			END IF;	
		END IF;
		IF RESULT_OUT_sig (7) = '1' THEN		-- bit Negative,for signed operations 
			STATUS_out_sig(4) <= '1';
		END IF;	


	ELSIF	INSTR_ALU_in_sig = IORWF THEN	
		RESULT_out_sig	<= ('0' & WREG_in_sig) OR ('0' & OPERAND_ALU_in_sig);
		
		IF RESULT_out_sig = B"000000000" THEN		-- bit Zero 		
			STATUS_out_sig(2) <= '1';
		END IF;
		IF RESULT_OUT_sig (7) = '1' THEN		-- bit Negative,for signed operations 
			STATUS_out_sig(4) <= '1';
		END IF;	


	ELSIF	INSTR_ALU_in_sig = XORWF THEN	
		RESULT_out_sig	<= ('0' & WREG_in_sig) XOR ('0' & OPERAND_ALU_in_sig);
	
		IF RESULT_out_sig = B"000000000" THEN		-- bit Zero 		
			STATUS_out_sig(2) <= '1';
		END IF;
		IF RESULT_OUT_sig (7) = '1' THEN		-- bit Negative,for signed operations 
			STATUS_out_sig(4) <= '1';
		END IF;	


	ELSIF	INSTR_ALU_in_sig = SUBWF THEN
		RESULT_out_sig	<= ('0' & OPERAND_ALU_in_sig) - ('0' & WREG_in_sig);  
		
		STATUS_out_sig(0)	<= RESULT_out_sig(8);	-- bit Carry in Status Register
		STATUS_out_sig(1)	<= RESULT_out_sig(4);	-- bit Digital carry 
		IF RESULT_out_sig = B"000000000" THEN		-- bit Zero 		
			STATUS_out_sig(2) <= '1';
			IF RESULT_out_sig(8) = '1' THEN		-- bit Overflow
				STATUS_out_sig(3) <= '1';
			END IF;	
		END IF;
		IF RESULT_OUT_sig (7) = '1' THEN		-- bit Negative,for signed operations 
			STATUS_out_sig(4) <= '1';
		END IF;	


	ELSIF	INSTR_ALU_in_sig = SUBWFB THEN	
		RESULT_out_sig	<= ('0' & OPERAND_ALU_in_sig) - ('0' & WREG_in_sig) - (B"00000000" & STATUS_in_sig(0) );
		
		STATUS_out_sig(0)	<= RESULT_out_sig(8);	-- bit Carry in Status Register
		STATUS_out_sig(1)	<= RESULT_out_sig(4);	-- bit Digital carry 
		IF RESULT_out_sig = B"000000000" THEN		-- bit Zero 		
			STATUS_out_sig(2) <= '1';
			IF RESULT_out_sig(8) = '1' THEN		-- bit Overflow
				STATUS_out_sig(3) <= '1';
			END IF;	
		END IF;
		IF RESULT_OUT_sig (7) = '1' THEN		-- bit Negative,for signed operations 
			STATUS_out_sig(4) <= '1';
		END IF;	


	END IF;
	END IF;
END IF;	
END PROCESS;
END TEST_ALU_ARCH;



