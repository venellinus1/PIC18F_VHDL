

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--USE IEEE.STD_LOGIC_SIGNED.ALL;
USE WORK.CPU_LIB.ALL;

ENTITY	CONTROL IS
	PORT	(
	CLK		: IN		STD_LOGIC;
	RESET_NAI	: IN		STD_LOGIC;
	--
	PCounter_in	: IN		STD_LOGIC_VECTOR (20 DOWNTO 0);
	INSTRUCTION_TYPE: OUT		STD_LOGIC_VECTOR (7 DOWNTO 0);	
	PCounter_out	: OUT		STD_LOGIC_VECTOR (20 DOWNTO 0)
		);
END CONTROL;	


ARCHITECTURE TEST_CONTROL_ARCH OF CONTROL IS
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
COMPONENT ALU
	PORT	(
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
END COMPONENT;	
---------------------------------
SIGNAL	CLK_sig			: STD_LOGIC; 
SIGNAL	RESET_NAI_sig		: STD_LOGIC;
----shadows of input/output signals
SIGNAL	PCounter_in_sig		: STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL	PCounter_out_sig	: STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL	INSTRUCTION_TYPE_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
----internal signals
SIGNAL	INSTRUCTION		: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	NEXT_INSTRUCTION	: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	FETCHED_DATA_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	ALU_OPERATION_sig	: STD_LOGIC;
SIGNAL	WRITE_DATA_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	NEXT_STATE		: STATE;
SIGNAL	GOTO_OP_sig		: STD_LOGIC;
SIGNAL	NOP_sig			: STD_LOGIC;
SIGNAL	TWOWORDS_INSTRUCTION_sig: STD_LOGIC;
SIGNAL	LITERAL_OPERATION_sig	: STD_LOGIC;
SIGNAL	ADDRESS_LONG_sig	: STD_LOGIC_VECTOR (19 DOWNTO 0);
SIGNAL	STATUS_reg		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	BRANCH_OP_sig		: STD_LOGIC;
SIGNAL	INCFSZ_sig		: STD_LOGIC;
SIGNAL	DECFSZ_sig		: STD_LOGIC;
SIGNAL	INFSNZ_sig		: STD_LOGIC;
SIGNAL	DCFSNZ_sig		: STD_LOGIC;
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
PCounter_in_sig	<= PCounter_in;	
RAM1:	RAM PORT MAP (CLK,RESET_NAI,RW_in_sig,DATA_in_sig,DATA_out_sig,ADDRESS_in_sig,RAM_SELECT_in_sig);
ROM1:	ROM PORT MAP (CLK,RESET_NAI,INSTRUCTION_out_sig,PC_in_sig,ROM_SELECT_in_sig);
ALU1:	ALU PORT MAP (CLK,RESET_NAI,INSTR_ALU_in_sig,WREG_in_sig,WREG_out_sig,RESULT_out_sig,STATUS_in_sig,
		      STATUS_out_sig,OPERAND_ALU_in_sig,ALU_SELECT_sig);
ALU_SELECT_sig		<= '1';

PROCESS (CLK,RESET_NAI)
BEGIN
IF RESET_NAI = '0' THEN	
	INSTRUCTION_TYPE	<= X"00";
	INSTRUCTION		<= X"F000"; -- first instruction to be executed is NOP , till first stage passes
	NEXT_INSTRUCTION	<= X"F000"; -- and the instruction at PC(000000) is fetched
	ALU_OPERATION_sig	<= '0';
	NEXT_STATE		<= Q1;
	WRITE_DATA_sig		<= (OTHERS => '0');
	NOP_sig			<= '0';	
	GOTO_OP_sig		<= '0';
	ROM_SELECT_in_sig	<= '0';
	RAM_SELECT_in_sig	<= '0';
	RW_in_sig		<= '1';--read
	TWOWORDS_INSTRUCTION_sig<= '0';
	LITERAL_OPERATION_sig	<= '0';
	BRANCH_OP_sig		<= '0';
	INCFSZ_sig		<= '0';
	DECFSZ_sig		<= '0';	
	INFSNZ_sig		<= '0';
	DCFSNZ_sig		<= '0';
STATUS_in_sig		<= (OTHERS => '0');
OPERAND_ALU_in_sig	<= (OTHERS => '0');
WREG_in_sig		<= X"21";
ELSIF CLK'EVENT AND CLK = '1' THEN
ROM_SELECT_in_sig	<= '1';
STATUS_reg		<= STATUS_out_sig;			
STATUS_in_sig		<= STATUS_out_sig;		
		CASE NEXT_STATE IS 
		WHEN	Q1 =>	
			---stage1 Q1 -> FETCH and DECODE
			--ROM_SELECT_in_sig	<= '1';
			
			--following to be removed---------write op-----------

			--RAM_SELECT_in_sig	<= '1';
			--ADDRESS_in_sig	<= B"000000000000";
			--DATA_in_sig		<= X"45";
			--RW_in_sig		<= '0';
			--WREG_in_sig		<= X"21";
			--upper to be removed--------------read op----------
			--following to be removed

			--RAM_SELECT_in_sig	<= '1';
			--ADDRESS_in_sig	<= B"000000000110";
			--RW_in_sig		<= '1';
			--OPERAND_ALU_in_sig	<= DATA_out_sig;
			--INSTRUCTION_TYPE	<= INSTRUCTION_out_sig (15 DOWNTO 8);
			---upper to be removed
			 	
			PC_in_sig		<= PCounter_in_sig;
			
			
			
			IF 	(NOP_sig = '1') AND (TWOWORDS_INSTRUCTION_sig = '1') THEN --to put mark for 2 words inst
				TWOWORDS_INSTRUCTION_sig	<= '0';
				NEXT_STATE			<= NOP_Q2;
					
			ELSIF	NOP_sig = '1' AND TWOWORDS_INSTRUCTION_sig = '0' THEN 
				NOP_sig 	<= '0';
				NEXT_STATE	<= NOP_Q2;
			ELSE	
				RW_in_sig	<= '1';--read
				IF	INSTRUCTION(15 DOWNTO 10) = B"001001" THEN--1	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					INSTR_ALU_in_sig	<= ADDWF;
				
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"00001111" THEN	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					LITERAL_OPERATION_sig	<= '1';
					INSTR_ALU_in_sig	<= ADDWF;--andlw operation

				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"001000" THEN		 
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					INSTR_ALU_in_sig	<= ADDWFC;	
				
				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"000101" THEN	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					INSTR_ALU_in_sig	<= ANDWF;
				
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"00001011" THEN--5	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					INSTR_ALU_in_sig	<= ANDWF;-- andlw operation
	
			
				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"001010" THEN	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					INSTR_ALU_in_sig	<= INCF;

				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"001111" THEN--INCFSZ	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					INSTR_ALU_in_sig	<= INCF;
					INCFSZ_sig		<= '1';	
				
				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"010010" THEN--INFSNZ	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					INSTR_ALU_in_sig	<= INCF;
					INFSNZ_sig		<= '1';	
				
				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"001011" THEN--DECFSZ	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					INSTR_ALU_in_sig	<= DECF;
					DECFSZ_sig		<= '1';	
	
				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"010011" THEN--DCFSNZ --10	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					INSTR_ALU_in_sig	<= DECF;
					DCFSNZ_sig		<= '1';	

			
				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"000100" THEN	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';	
					INSTR_ALU_in_sig	<= IORWF;
				
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"00001001" THEN	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';	
					LITERAL_OPERATION_sig	<= '1';
					INSTR_ALU_in_sig	<= IORWF; -- IORLW instruction
				
				ELSIF	INSTRUCTION(15 DOWNTO 9) = B"0110100" THEN	
					RAM_SELECT_in_sig	<= '1';
					NEXT_STATE		<= ALU_OP_Q2;
					INSTR_ALU_in_sig	<= SETF;
				
				ELSIF	INSTRUCTION(15 DOWNTO 9) = B"0110101" THEN	
					RAM_SELECT_in_sig	<= '1';
					NEXT_STATE		<= ALU_OP_Q2;
					INSTR_ALU_in_sig	<= CLRF;
				
				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"010000" THEN	
					RAM_SELECT_in_sig	<= '1';
					NEXT_STATE		<= ALU_OP_Q2;
					INSTR_ALU_in_sig	<= RRNCF;
				
				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"010001" THEN	
					RAM_SELECT_in_sig	<= '1';
					NEXT_STATE		<= ALU_OP_Q2;
					INSTR_ALU_in_sig	<= RLNCF;	
	
				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"010111" THEN	
					RAM_SELECT_in_sig	<= '1';
					NEXT_STATE		<= ALU_OP_Q2;
					INSTR_ALU_in_sig	<= SUBWF;

				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"001110" THEN	
					RAM_SELECT_in_sig	<= '1';
					NEXT_STATE		<= ALU_OP_Q2;
					INSTR_ALU_in_sig	<= SWAPF;

				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"00001000" THEN--15	
					RAM_SELECT_in_sig	<= '1';
					LITERAL_OPERATION_sig	<= '1';
					NEXT_STATE		<= ALU_OP_Q2;
					INSTR_ALU_in_sig	<= SUBWF;--literal operation sublw
			
				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"010110" THEN	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					INSTR_ALU_in_sig	<= SUBWFB;
				
				ELSIF	INSTRUCTION(15 DOWNTO 10) = B"000110" THEN	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					INSTR_ALU_in_sig	<= XORWF;
				
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"00001010" THEN	
					NEXT_STATE		<= ALU_OP_Q2;
					RAM_SELECT_in_sig	<= '1';
					LITERAL_OPERATION_sig	<= '1';
					INSTR_ALU_in_sig	<= XORWF;--xorlw
			
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"11101111" THEN
					NEXT_STATE		<= GOTO_Q2;
					--TWOWORDS_INSTRUCTION_sig<= '1';
					GOTO_OP_sig		<= '1';
				
				ELSIF	INSTRUCTION(15 DOWNTO 0) = B"000000000000" 
					OR INSTRUCTION(15 DOWNTO 12) = B"1111" THEN--20
					NEXT_STATE		<= NOP_Q2;
				
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"00001110" THEN
					NEXT_STATE		<= MOV_OP_Q2;	
					
				ELSIF	INSTRUCTION(15 DOWNTO 9) = B"0110111" THEN
					NEXT_STATE		<= MOVWF_OP_Q2;
	
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"11100010" THEN--BC
					IF	STATUS_reg(0)	= '1' THEN
						BRANCH_OP_sig	<= '1';
		       			END IF;
					NEXT_STATE		<= BRANCH_OP_Q2;

				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"11100110" THEN--BN
					IF	STATUS_reg(4)	= '1' THEN
						BRANCH_OP_sig	<= '1';
		       			END IF;
					NEXT_STATE		<= BRANCH_OP_Q2;	
				
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"11100011" THEN--BNC --25
					IF	STATUS_reg(0)	= '0' THEN
						BRANCH_OP_sig	<= '1';
		       			END IF;
					NEXT_STATE		<= BRANCH_OP_Q2;
				
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"11100111" THEN--BNN
					IF	STATUS_reg(4)	= '0' THEN
						BRANCH_OP_sig	<= '1';
		       			END IF;
					NEXT_STATE		<= BRANCH_OP_Q2;	

				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"11100101" THEN--BNOV
					IF	STATUS_reg(3)	= '0' THEN
						BRANCH_OP_sig	<= '1';
		       			END IF;
					NEXT_STATE		<= BRANCH_OP_Q2;
				
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"11100001" THEN--BNZ
					IF	STATUS_reg(2)	= '0' THEN
						BRANCH_OP_sig	<= '1';
		       			END IF;
					NEXT_STATE		<= BRANCH_OP_Q2;
				
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"11100100" THEN--BOV
					IF	STATUS_reg(3)	= '1' THEN
						BRANCH_OP_sig	<= '1';
		       			END IF;
					NEXT_STATE		<= BRANCH_OP_Q2;
				
				ELSIF	INSTRUCTION(15 DOWNTO 8) = B"11100000" THEN--BZ --30
					IF	STATUS_reg(2)	= '1' THEN
						BRANCH_OP_sig	<= '1';
		       			END IF;
					NEXT_STATE		<= BRANCH_OP_Q2;
					
				ELSE	
					NEXT_STATE <= NOP_Q2; 
				END IF;
			END IF;	
		--------------------------ALU OP's------------------------------------
		WHEN	ALU_OP_Q2 =>---stage ALU Q2 -> fetch data
			IF LITERAL_OPERATION_sig = '1' THEN --literal op
				OPERAND_ALU_in_sig	<= INSTRUCTION (7 DOWNTO 0);
			ELSE	
				OPERAND_ALU_in_sig	<= DATA_out_sig;
			END IF;	
			NEXT_STATE		<= ALU_OP_Q3;

		
		WHEN	ALU_OP_Q3 =>---stage ALU Q3 -> execute
			DATA_in_sig		<= RESULT_out_sig(7 DOWNTO 0);
			NEXT_STATE		<= ALU_OP_Q4;
			----write to ram
			RAM_SELECT_in_sig	<= '1';
			ADDRESS_in_sig		<= B"0000" & INSTRUCTION (7 DOWNTO 0);---b"0000" address decode!!!!
		   	RW_in_sig		<= '0'; -- write ram
				
		WHEN	ALU_OP_Q4 =>---stage ALU Q4 -> write back, check for skips
			IF INCFSZ_sig = '1' THEN
				IF STATUS_reg(2) = '1' THEN
					NOP_sig		<= '1';
				END IF;	
			END IF;
			IF DECFSZ_sig = '1' THEN
				IF STATUS_reg(2) = '1' THEN
					NOP_sig		<= '1';
				END IF;	
			END IF;	
			IF INFSNZ_sig = '1' THEN
				IF STATUS_reg(2) = '0' THEN
					NOP_sig		<= '1';
				END IF;	
			END IF;
			IF DCFSNZ_sig = '1' THEN
				IF STATUS_reg(2) = '0' THEN
					NOP_sig		<= '1';
				END IF;	
			END IF;	
			----------------
			IF LITERAL_OPERATION_sig = '1' THEN 
				LITERAL_OPERATION_sig	<= '0';
				WREG_in_sig		<= RESULT_OUT_sig(7 DOWNTO 0);
			END IF;	
			----------------
			NEXT_INSTRUCTION	<= INSTRUCTION_out_sig;
			INSTRUCTION		<= NEXT_INSTRUCTION;
			ADDRESS_in_sig		<= B"0000" & NEXT_INSTRUCTION (7 DOWNTO 0);---b"0000" address decode!!!!
			NEXT_STATE		<= Q1;
		--------------------------END ALU OP's------------------------------------
		--------------------------NOP OP's----------------------------------------
		WHEN	NOP_Q1 =>
			NEXT_STATE		<= NOP_Q2;

		WHEN	NOP_Q2 =>---nop state Q2, check for goto
			IF	GOTO_OP_sig = '1' THEN
				PCounter_out_sig <= PCounter_in_sig OR (INSTRUCTION (11 DOWNTO 0) & B"000000000");
				GOTO_OP_sig	 <= '0';
			END IF;
			NOP_sig			<= '0';
			NEXT_STATE		<= NOP_Q3;

		WHEN	NOP_Q3 => 
			NEXT_STATE		<= NOP_Q4;

		WHEN	NOP_Q4 =>
			NEXT_INSTRUCTION	<= INSTRUCTION_out_sig;
			INSTRUCTION		<= NEXT_INSTRUCTION;
			IF	TWOWORDS_INSTRUCTION_sig = '1' THEN
				NEXT_STATE		<= NOP_Q1;
				TWOWORDS_INSTRUCTION_sig<= '1';
			ELSE	
				NEXT_STATE		<= Q1;
			END IF;	
		--------------------------END NOP OP's-------------------------------------
		--------------------------GOTO's-------------------------------------------
		WHEN	GOTO_Q2 =>
			PCounter_out_sig <= PCounter_in_sig OR (B"000000000000" & INSTRUCTION (7 DOWNTO 0) & '0');
			GOTO_OP_sig	 <= '1';
			NEXT_STATE	 <= GOTO_Q3;
	
		WHEN	GOTO_Q3 =>
			NEXT_STATE	<= GOTO_Q4;
		
		WHEN	GOTO_Q4 =>
			NEXT_INSTRUCTION	<= INSTRUCTION_out_sig;
			INSTRUCTION		<= NEXT_INSTRUCTION;
			NEXT_STATE		<= Q1;
		--------------------------END GOTO's----------------------------------------
		--------------------------MOV OP's------------------------------------------
		WHEN	MOV_OP_Q2 =>
			NEXT_STATE		<= MOV_OP_Q3;

		WHEN	MOV_OP_Q3 =>
			WREG_in_sig		<= INSTRUCTION (7 DOWNTO 0);
			NEXT_STATE		<= MOV_OP_Q4;
		
		WHEN	MOV_OP_Q4 =>	
			NEXT_INSTRUCTION	<= INSTRUCTION_out_sig;
			INSTRUCTION		<= NEXT_INSTRUCTION;
			NEXT_STATE		<= Q1;
		--------------------------END MOV OP's---------------------------------------
		--------------------------MOVWF OP's------------------------------------------
		WHEN	MOVWF_OP_Q2 =>
			RAM_SELECT_in_sig	<= '1';
			ADDRESS_in_sig		<= B"0000" & INSTRUCTION (7 DOWNTO 0);---b"0000" address decode!!!!
		   	RW_in_sig		<= '0'; -- write ram
			NEXT_STATE		<= MOVWF_OP_Q3;

		WHEN	MOVWF_OP_Q3 =>
			DATA_in_sig		<= WREG_OUT_sig;
			NEXT_STATE		<= MOVWF_OP_Q4;
		
		WHEN	MOVWF_OP_Q4 =>
			NEXT_INSTRUCTION	<= INSTRUCTION_out_sig;
			INSTRUCTION		<= NEXT_INSTRUCTION;
			NEXT_STATE		<= Q1;
		--------------------------END MOVWF OP's---------------------------------------
		--------------------------BEGIN BRANCH OP's---------------------------------------
		WHEN	BRANCH_OP_Q2 =>
			IF BRANCH_OP_sig /= '1' THEN
				NEXT_STATE <= BRANCH_OP_Q3;
			ELSE	
				IF INSTRUCTION (7) = '1' THEN
					PCounter_out	<= PCounter_in + 2 - INSTRUCTION (7 DOWNTO 0);
				ELSE
					PCounter_out	<= PCounter_in + 2 + INSTRUCTION (7 DOWNTO 0);
				END IF; ----------CHECK!!!!!---------------------------------	
				NEXT_STATE	<= BRANCH_OP_Q3;
				NOP_sig		<= '1';
				BRANCH_OP_sig	<= '0';
			END IF;
			
		
		WHEN	BRANCH_OP_Q3 =>
			NEXT_STATE <= BRANCH_OP_Q4;
		
		WHEN	BRANCH_OP_Q4 =>	
			NEXT_INSTRUCTION	<= INSTRUCTION_out_sig;
			INSTRUCTION		<= NEXT_INSTRUCTION;
			NEXT_STATE		<= Q1;
		--------------------------END BRANCH OP's---------------------------------------


		WHEN	OTHERS	=> 
			NEXT_STATE	<= Q1;
		END CASE;		
END IF;

END PROCESS;
--------------------------------------------------------------------------------
	
END;	
	
	

