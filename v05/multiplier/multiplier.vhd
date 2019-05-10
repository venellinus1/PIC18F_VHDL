LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY   MULTIPLIER IS 
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
	 
END MULTIPLIER;

ARCHITECTURE MULTIPLYING OF MULTIPLIER IS

SIGNAL	CLK_sig		: STD_LOGIC; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
	
--
SIGNAL	RESULT_OUT_sig		: STD_LOGIC_VECTOR (15 DOWNTO 0);	--the result register
SIGNAL	MULTIPLICAND1_in_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);	--first byte 	
SIGNAL	MULTIPLICAND2_in_sig	: STD_LOGIC_VECTOR (15 DOWNTO 0);	--second byte to multiply
SIGNAL	RESULT_RDY_sig		: STD_LOGIC;				-- help signal to check if intermediate results are ready
SIGNAL	COUNT			: STD_LOGIC_VECTOR (7 DOWNTO 0);
--
SIGNAL	RESULT_OUT_sig0		: STD_LOGIC_VECTOR (15 DOWNTO 0);	-- 8 registers to save intermediate results
SIGNAL	RESULT_OUT_sig1		: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	RESULT_OUT_sig2		: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	RESULT_OUT_sig3		: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	RESULT_OUT_sig4		: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	RESULT_OUT_sig5		: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	RESULT_OUT_sig6		: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	RESULT_OUT_sig7		: STD_LOGIC_VECTOR (15 DOWNTO 0);




BEGIN
MULTIPLICAND2_in_sig	<= MULTIPLICAND2_in;
	
MULTIPLICAND1_in_sig	<= MULTIPLICAND1_in;
RESULT_OUT		<= RESULT_OUT_sig;
TEST			<= RESULT_RDY_sig;
TEST16BIT		<= RESULT_OUT_sig7;

PROCESS (CLK,RESET_NAI)
BEGIN
	IF RESET_NAI = '0' THEN
		RESULT_OUT_sig	<= (OTHERS => '0');
		RESULT_RDY_sig	<= '0';
	ELSIF CLK'EVENT AND CLK = '1' THEN
		IF RESULT_RDY_sig = '1' THEN				--check if interediate registers are ready
			RESULT_RDY_sig	<= '0';				-- if so get the final result
			RESULT_OUT_sig <=	RESULT_OUT_sig0 + 	-- multiplication is following the algorythm:
		     				RESULT_OUT_sig1 + 	-- result=(m1(0) * m2)+..+(m1(7) * m2)  	
			    			RESULT_OUT_sig2 + 
						RESULT_OUT_sig3 + 
			    			RESULT_OUT_sig4 + 
						RESULT_OUT_sig5 +
					  	RESULT_OUT_sig6 + 
						RESULT_OUT_sig7;

		ELSIF RESULT_RDY_sig = '0' THEN				-- intermediate registers are not ready
			RESULT_RDY_sig	<= '1';				-- get their values
			IF MULTIPLICAND1_in_sig(0) = '1' THEN		-- and set RESULT_RDY_sig to READY = 1
				RESULT_OUT_sig0	<= MULTIPLICAND2_in_sig;
			ELSIF MULTIPLICAND1_in_sig(0) = '0' THEN
 				RESULT_OUT_sig0	<= (OTHERS => '0');
			END IF;

			IF MULTIPLICAND1_in_sig(1) = '1' THEN
				RESULT_OUT_sig1	<= MULTIPLICAND2_in_sig (14 DOWNTO 0) & '0'; 
			ELSIF MULTIPLICAND1_in_sig(1) = '0' THEN
	 			RESULT_OUT_sig1	<= (OTHERS => '0');
			END IF;
	
			IF MULTIPLICAND1_in_sig(2) = '1' THEN
				RESULT_OUT_sig2	<= MULTIPLICAND2_in_sig (13 DOWNTO 0) & B"00";
			ELSIF MULTIPLICAND1_in_sig(2) = '0' THEN
 				RESULT_OUT_sig2	<= (OTHERS => '0');
			END IF;
	
			IF MULTIPLICAND1_in_sig(3) = '1' THEN
				RESULT_OUT_sig3	<= MULTIPLICAND2_in_sig (12 DOWNTO 0) & B"000";
			ELSIF MULTIPLICAND1_in_sig(3) = '0' THEN
 				RESULT_OUT_sig3	<= (OTHERS => '0');
			END IF;
		
			IF MULTIPLICAND1_in_sig(4) = '1' THEN
				RESULT_OUT_sig4	<= MULTIPLICAND2_in_sig (11 DOWNTO 0) & B"0000";
			ELSIF MULTIPLICAND1_in_sig(4) = '0' THEN
 				RESULT_OUT_sig4	<= (OTHERS => '0');
			END IF;
	
			IF MULTIPLICAND1_in_sig(5) = '1' THEN
				RESULT_OUT_sig5	<= MULTIPLICAND2_in_sig (10 DOWNTO 0) & B"00000";
			ELSIF MULTIPLICAND1_in_sig(5) = '0' THEN
 				RESULT_OUT_sig5	<= (OTHERS => '0');
			END IF;
			
			IF MULTIPLICAND1_in_sig(6) = '1' THEN
				RESULT_OUT_sig6	<= MULTIPLICAND2_in_sig (9 DOWNTO 0) & B"000000";
			ELSIF MULTIPLICAND1_in_sig(6) = '0' THEN
 				RESULT_OUT_sig6	<= (OTHERS => '0');
			END IF;
	

			IF MULTIPLICAND1_in_sig(7) = '1' THEN
				RESULT_OUT_sig7	<= MULTIPLICAND2_in_sig (8 DOWNTO 0) & B"0000000";
			ELSIF MULTIPLICAND1_in_sig(7) = '0' THEN
 				RESULT_OUT_sig7	<= (OTHERS => '0');
			END IF;
		END IF;
	END IF;
END PROCESS;



--		FOR I IN 0 TO 7 LOOP
--		IF MULTIPLICAND1_in_sig(I) = '1' AND RESULT_RDY_sig = '1' THEN
--				RESULT_OUT_sig <= RESULT_OUT_sig + MULTIPLICAND2_in_sig;
--				RESULT_RDY_sig <= '0';
		--	
		--	ELSIF MULTIPLICAND1_in_sig(I) = '0' THEN
		--		MULTIPLICAND2_in_sig (15 DOWNTO 0) <=  MULTIPLICAND2_in_sig (14 DOWNTO 0) & '0';
--		END IF;
		--END LOOP;	
-----------------------------------------------------
--------working----------------------------
	--	IF RESULT_RDY_sig = '0' THEN
		--		RESULT_RDY_sig	<= '1';	
		--		MULT2_RESULT_RDY_sig	<= MULTIPLICAND2_in_sig (14 DOWNTO 0) & '0';				
		--	ELSIF MULTIPLICAND1_in_sig(I) = '0' AND RESULT_RDY_sig = '1' THEN
		--		RESULT_RDY_sig <= '0';
		--		MULTIPLICAND2_in_sig <= MULT2_RESULT_RDY_sig;
		--	ELSIF MULTIPLICAND1_in_sig(I) = '1' AND RESULT_RDY_sig = '1' THEN
		--		RESULT_OUT_sig	<= RESULT_OUT_sig + MULT2_RESULT_RDY_sig;
		--		RESULT_RDY_sig <= '0';
		--		MULTIPLICAND2_in_sig <= MULT2_RESULT_RDY_sig;
	
		--	END IF;


END MULTIPLYING;


