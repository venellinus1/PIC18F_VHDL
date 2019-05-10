LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY   TIMER2 IS 
PORT 	(
	CLK		: IN	STD_LOGIC;
	RESET_NAI	: IN	STD_LOGIC;
	--
	TOUTPS_in	: IN	STD_LOGIC_VECTOR (3 DOWNTO 0);		
 	T2CKPS_in	: IN 	STD_LOGIC_VECTOR (1 DOWNTO 0);
	TMR2ON_in	: IN	STD_LOGIC;
	TMR2IF_out	: OUT	STD_LOGIC;
	PR2_in		: IN 	STD_LOGIC_VECTOR (7 DOWNTO 0);		--set to FF upon Reset
	PR2_out		: OUT 	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TMR2_out	: OUT	STD_LOGIC
	);
	 
END TIMER2;

ARCHITECTURE TEST_TIMER2_ARCH OF TIMER2 IS

SIGNAL	CLK_sig		: STD_LOGIC; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
--
SIGNAL	TOUTPS_in_sig		: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL	T2CKPS_in_sig		: STD_LOGIC_VECTOR (1 DOWNTO 0); 	
SIGNAL	TMR2IF_out_sig		: STD_LOGIC;				
SIGNAL	TMR2ON_in_sig		: STD_LOGIC;
SIGNAL	TMR2_out_sig		: STD_LOGIC;
SIGNAL	PR2_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);--:= X"FF";
SIGNAL	PR2_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
--SIGNAL	POSTSCALE_OUT_sig	: STD_LOGIC;
SIGNAL	POSTSCALE_int		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PRESCALE_OUT_sig	: STD_LOGIC;
SIGNAL	PRESCALE_int		: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL	PRESCALE_REG_sig	: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL	TMR2_COUNT_int		: STD_LOGIC_VECTOR (7 DOWNTO 0);	
SIGNAL	COMPARATOR_OUT_int	: STD_LOGIC;

BEGIN
TOUTPS_in_sig	<= TOUTPS_in;
T2CKPS_in_sig	<= T2CKPS_in;
TMR2IF_out	<= TMR2IF_out_sig;
TMR2ON_in_sig	<= TMR2ON_in;	
PR2_in_sig	<= PR2_in;
PR2_out		<= PR2_out_sig;
TMR2_out	<= TMR2_out_sig;

--PROCESS(CLK,RESET_NAI)			-- postscaller counter
--BEGIN
--IF RESET_NAI = '0' THEN	
--		POSTSCALE_OUT_sig	<= '0';
--		POSTSCALE_int		<= (OTHERS => '0');
	
--ELSIF CLK'EVENT AND CLK = '1' THEN
--		POSTSCALE_OUT_sig <= '0';
--		IF	POSTSCALE_int /= TOUTPS_in_sig	THEN
--				POSTSCALE_int	<= POSTSCALE_int + 1;
--		ELSIF	POSTSCALE_int = TOUTPS_in_sig 	THEN
--				POSTSCALE_int	<= X"00";
--				POSTSCALE_OUT_sig<= '1';
--		END IF;
--END IF;
--END PROCESS;

---------------------------------------------------------
PROCESS (CLK,RESET_NAI)			--prescaller + TMR2 counter and comparator module
BEGIN
	IF RESET_NAI = '0' THEN
		PRESCALE_OUT_sig	<= '0';
		PRESCALE_int		<= (OTHERS => '0');
		TMR2_COUNT_int		<= (OTHERS => '0');
		PR2_out_sig		<= X"FF";
		TMR2IF_out_sig		<= '0';
		POSTSCALE_int		<= (OTHERS => '0');

	ELSIF CLK'EVENT AND CLK = '1' THEN
		PRESCALE_OUT_sig	<= '0';
		COMPARATOR_OUT_int 	<= '0';
		PR2_out_sig		<= PR2_in_sig;	
		TMR2_out_sig		<= '0';
		TMR2IF_out_sig		<= '0';
		IF	PRESCALE_int /= PRESCALE_REG_sig	THEN
				PRESCALE_int	<= PRESCALE_int + 1;
		ELSIF	PRESCALE_int = PRESCALE_REG_sig		THEN
				PRESCALE_int	<= (OTHERS => '0');
				PRESCALE_OUT_sig<= '1';	
				IF  TMR2_COUNT_int /= PR2_out_sig	THEN 
					TMR2_COUNT_int <= TMR2_COUNT_int + 1;
				ELSIF TMR2_COUNT_int = PR2_out_sig	THEN
					TMR2_COUNT_int		<= X"00";
					COMPARATOR_OUT_int 	<= '1';
					IF	POSTSCALE_int /= TOUTPS_in_sig	THEN
						POSTSCALE_int	<= POSTSCALE_int + 1;
					ELSIF	POSTSCALE_int = TOUTPS_in_sig 	THEN
						POSTSCALE_int	<= X"00";
						TMR2IF_out_sig<= '1';
					END IF;
					TMR2_out_sig		<= '1';
				ELSE
					TMR2_COUNT_int <= TMR2_COUNT_int;
				END IF;	

		END IF;		
	END IF;
END PROCESS;
--------------------------------------------------------
PROCESS (T2CKPS_in_sig)			--prescaller configuration
BEGIN
	CASE T2CKPS_in_sig IS
		WHEN	B"00" =>
			PRESCALE_REG_sig <= X"1";
		WHEN	B"01" =>
			PRESCALE_REG_sig <= X"3";
		WHEN	B"10" =>
			PRESCALE_REG_sig <= X"F";
		WHEN	OTHERS =>
			PRESCALE_REG_sig <= X"F";
	END CASE;
END PROCESS;	
END TEST_TIMER2_ARCH;


