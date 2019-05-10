package count_types is
 subtype bit8 is integer range 0 to 255;
end count_types;

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

use work.count_types.all;

entity count is 
port 	(
	CLK		: IN	STD_LOGIC;
	RESET_NAI	: IN	STD_LOGIC;
	--
	T08BIT_in	: IN	STD_LOGIC;		
 	PSA_in		: IN	STD_LOGIC;
 	FOSC4_in	: IN 	STD_LOGIC;
	RA4T0CL_in	: IN 	STD_LOGIC;	
	T0PS_in		: IN 	STD_LOGIC_VECTOR (2 downto 0);
	T0CS_in		: IN 	STD_LOGIC;
	T0SE_in		: IN 	STD_LOGIC;
	TMR0on_in	: IN 	STD_LOGIC;
	--
        TMR01L_in 	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TMR01L_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TMR01H_in 	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TMR01H_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TMR0IF_out	: OUT	STD_LOGIC

	
	 );
	 
end count;


architecture synthesis of count 	is

--SIGNAL	CLK		: STD_LOGIC;
--SIGNAL	RESET_NAI	: STD_LOGIC;
	--
SIGNAL	T08BIT_in_sig	: STD_LOGIC;		
SIGNAL	PSA_in_sig	: STD_LOGIC;
SIGNAL	FOSC4_in_sig	: STD_LOGIC;
SIGNAL	RA4T0CL_in_sig	: STD_LOGIC;	
SIGNAL	T0PS_in_sig	: STD_LOGIC_VECTOR (2 downto 0);
SIGNAL	T0CS_in_sig	: STD_LOGIC;
SIGNAL	T0SE_in_sig	: STD_LOGIC;
SIGNAL	TMR0on_in_sig	: STD_LOGIC;
	--
SIGNAL	TMR01L_in_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR01L_out_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR01H_in_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR01H_out_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR0IF_out_sig	: STD_LOGIC;
-- internals
SIGNAL	MUX1OUT_sig	: STD_LOGIC;	
SIGNAL	RA4T0CL_in_int	: STD_LOGIC;
SIGNAL	PRESCALE_out_sig: STD_LOGIC;
SIGNAL	TMR01_out_sig	: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	TMR01_in_sig	: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL	PRESCALE_REG_sig: STD_LOGIC_VECTOR (7  DOWNTO 0);
SIGNAL	PRESCALE_int	: STD_LOGIC_VECTOR (7  DOWNTO 0);

begin

	
T08BIT_in_sig	<= T08BIT_in;		
PSA_in_sig	<= PSA_in;
FOSC4_in_sig	<= FOSC4_in;
RA4T0CL_in_sig	<= RA4T0CL_in;	
T0PS_in_sig	<= T0PS_in;
T0CS_in_sig	<= T0CS_in;
T0SE_in_sig	<= T0SE_in;
TMR0on_in_sig	<= TMR0on_in;
--
TMR01L_in_sig 	<= TMR01L_in;
TMR01L_out	<= TMR01L_out_sig;
TMR01H_in_sig 	<= TMR01H_in;
TMR01H_out	<= TMR01H_out_sig;
TMR0IF_out	<= TMR0IF_out_sig;
--
TMR01H_out_sig	<= TMR01_out_sig(15 DOWNTo 8); 
TMR01L_out_sig	<= TMR01_out_sig(7 DOWNTo 0);

TMR01_in_sig	<= TMR01H_in_sig & TMR01L_in_sig;
--

RA4T0CL_in_int	<= RA4T0CL_in_sig; -- to add edge detection



----------------------------------


MUX1OUT_sig <= FOSC4_in_sig WHEN T0CS_in_sig = '0' ELSE RA4T0CL_in_int;


--T0PS_in_sig

--TMR0on_in_sig

--MUX1OUT_sig

--TMR01L_in_sig
--TMR01H_in_sig
PROCESS(T0PS_in_sig) 		-- config prescaller counter 
BEGIN
			PRESCALE_REG_sig <= X"00";	

	CASE	T0PS_in_sig	IS
		WHEN	"000" =>
			PRESCALE_REG_sig <= X"01";
		WHEN	"001" =>
			PRESCALE_REG_sig <= X"03";
		WHEN	"010" =>
			PRESCALE_REG_sig <= X"07";
		WHEN	"011" =>
			PRESCALE_REG_sig <= X"0F";
		WHEN	"100" =>
			PRESCALE_REG_sig <= X"1F";
		WHEN	"101" =>
			PRESCALE_REG_sig <= X"3F";
		WHEN	"110" =>
			PRESCALE_REG_sig <= X"7F";
		WHEN	"111" =>
			PRESCALE_REG_sig <= X"FF";
		WHEN	OTHERS => 
			PRESCALE_REG_sig <= X"00";	
	END CASE;	
END PROCESS;		
		
PROCESS(CLK,RESET_NAI)			-- prescaller counter
BEGIN
IF RESET_NAI = '0' THEN	
		PRESCALE_int	 <= (OTHERS => '0');
		PRESCALE_out_sig <= '0';	 
ELSIF CLK'EVENT AND CLK = '1' THEN
		PRESCALE_out_sig <= '0';
		IF	PRESCALE_int /= PRESCALE_REG_sig	THEN
				PRESCALE_int	<= PRESCALE_int + 1;
		ELSIF	PRESCALE_int = PRESCALE_REG_sig 	THEN
				PRESCALE_int	<= X"00";
				PRESCALE_out_sig<= '1';
		ELSE	
				PRESCALE_int	<= PRESCALE_int;
		END IF;
END IF;
END PROCESS;

PROCESS (CLK, RESET_NAI)
BEGIN
IF RESET_NAI = '0' THEN
		TMR01_out_sig	<= (OTHERS => '0');
		TMR0IF_out_sig	<= '0';
ELSIF CLK'EVENT AND CLK = '1' THEN
			TMR01_out_sig	<= TMR01_out_sig;
			TMR0IF_out_sig	<= '0';
	IF	PSA_in_sig = '0'	THEN		-- without prescaller
		IF	T08BIT_in_sig = '0'	THEN 	-- 16 bit mode
			IF	TMR01_out_sig /= X"FFFF"	THEN
							TMR01_out_sig	<= TMR01_out_sig + 1;
			ELSIF	TMR01_out_sig  = X"FFFF" 	THEN
							TMR01_out_sig	<= TMR01_in_sig;
							TMR0IF_out_sig	<= '1';
			ELSE	
							TMR01_out_sig	<= TMR01_out_sig;
			END IF;
		ELSIF	T08BIT_in_sig = '1'	THEN 	-- 8 bit mode
			IF	TMR01_out_sig /= X"00FF"	THEN
							TMR01_out_sig	<= TMR01_out_sig + 1;
			ELSIF	TMR01_out_sig  = X"00FF" 	THEN
							TMR01_out_sig	<= TMR01_in_sig;
							TMR0IF_out_sig	<= '1';
			ELSE	
							TMR01_out_sig	<= TMR01_out_sig;
			END IF;
		END IF;	
	ELSIF	PSA_in_sig = '1'	THEN		-- with prescaller
		IF	T08BIT_in_sig = '0'	THEN 	-- 16 bit mode
			IF	PRESCALE_out_sig = '1'	THEN	 	
				IF	TMR01_out_sig /= X"FFFF"	THEN
								TMR01_out_sig	<= TMR01_out_sig + 1;
				ELSIF	TMR01_out_sig  = X"FFFF" 	THEN
								TMR01_out_sig	<= TMR01_in_sig;
								TMR0IF_out_sig	<= '1';
				ELSE	
								TMR01_out_sig	<= TMR01_out_sig;
				END IF;
			ELSE
								TMR01_out_sig	<= TMR01_out_sig;
			END IF;
		ELSIF	T08BIT_in_sig = '1'	THEN 	-- 8 bit mode
			IF	PRESCALE_out_sig = '1'	THEN
				IF	TMR01_out_sig /= X"00FF"	THEN
								TMR01_out_sig	<= TMR01_out_sig + 1;
				ELSIF	TMR01_out_sig  = X"00FF" 	THEN
								TMR01_out_sig	<= TMR01_in_sig;
								TMR0IF_out_sig	<= '1';
				ELSE	
								TMR01_out_sig	<= TMR01_out_sig;
				END IF;
			ELSE
								TMR01_out_sig	<= TMR01_out_sig;
			END IF;
		END IF;	
	END IF;	
END IF;	
END PROCESS;

--PROCESS (TMR0IF)
end synthesis;
			
