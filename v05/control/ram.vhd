LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY RAM IS
PORT	(
	CLK		: IN	STD_LOGIC;
	RESET_NAI	: IN	STD_LOGIC;
	--
	RW_in		: IN	STD_LOGIC;
	DATA_in		: IN 	STD_LOGIC_VECTOR (7 DOWNTO 0);
	DATA_out	: OUT 	STD_LOGIC_VECTOR (7 DOWNTO 0);
	ADDRESS_in	: IN	STD_LOGIC_VECTOR (11 DOWNTO 0);
	STATUS_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	STATUS_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PORTA_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PORTA_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PORTB_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PORTB_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	LATA_in		: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	LATA_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	LATB_in		: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	LATB_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TRISA_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TRISA_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TRISB_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TRISB_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	OSCTUNE_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	OSCTUNE_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PIE1_in		: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PIE1_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PIR1_in		: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PIR1_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	IPR1_in		: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	IPR1_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PIE2_in		: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PIE2_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PIR2_in		: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	PIR2_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	IPR2_in		: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	IPR2_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	EECON1_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	EECON1_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	EECON2_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	EECON2_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	EEDATA_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	EEDATA_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	EEADR_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	EEADR_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	BAUDCTL_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	BAUDCTL_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	RCSTA_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	RCSTA_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TXSTA_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TXSTA_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TXREG_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TXREG_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	RCREG_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	RCREG_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	SPBRG_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	SPBRG_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	SPBRGH_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	SPBRGH_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	T3CON_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	T3CON_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TMR3L_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TMR3L_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TMR3H_in	: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	TMR3H_out	: OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);

	RAM_SELECT_in	: IN	STD_LOGIC
	);
END RAM;

ARCHITECTURE TEST_RAM_ARCH OF RAM IS

SIGNAL	CLK_sig		: STD_LOGIC; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
----
TYPE 	T_RAM IS ARRAY (0 TO 383) OF STD_LOGIC_VECTOR (7 DOWNTO 0);	
SIGNAL	RAM_DATA : T_RAM;
----
SIGNAL	DATA_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	DATA_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	ADDRESS_in_sig		: STD_LOGIC_VECTOR (11 DOWNTO 0);
SIGNAL	RW_in_sig		: STD_LOGIC;
SIGNAL	RAM_SELECT_in_sig	: STD_LOGIC;
------cpu register signals--------------
SIGNAL	STATUS_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	STATUS_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PORTA_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PORTA_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PORTB_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PORTB_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	LATA_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	LATA_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	LATB_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	LATB_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TRISA_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TRISA_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TRISB_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TRISB_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	OSCTUNE_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	OSCTUNE_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PIE1_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PIE1_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PIR1_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PIR1_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	IPR1_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	IPR1_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PIE2_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PIE2_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PIR2_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	PIR2_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	IPR2_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	IPR2_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	EECON1_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	EECON1_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	EECON2_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	EECON2_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	EEDATA_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	EEDATA_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	EEADR_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	EEADR_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	BAUDCTL_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	BAUDCTL_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	RCSTA_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	RCSTA_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TXSTA_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TXSTA_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TXREG_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TXREG_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	RCREG_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	RCREG_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	SPBRG_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	SPBRG_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	SPBRGH_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	SPBRGH_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	T3CON_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	T3CON_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR3L_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR3L_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR3H_in_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR3H_out_sig		: STD_LOGIC_VECTOR (7 DOWNTO 0);


BEGIN
DATA_in_sig		<= DATA_in;
DATA_out		<= DATA_out_sig;	
ADDRESS_in_sig		<= ADDRESS_in;
RW_in_sig		<= RW_in;
RAM_SELECT_in_sig	<= RAM_SELECT_in;

PROCESS(CLK,RESET_NAI)	
BEGIN
IF RESET_NAI = '0' THEN	
	DATA_out_sig	<= (OTHERS => '0');
	RAM_DATA 	<=
(X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00"
);
	
	
ELSIF CLK'EVENT AND CLK = '1' THEN
	IF RAM_SELECT_in_sig = '1' THEN
		IF RW_in_sig = '0' THEN			-- write operation

			RAM_DATA (CONV_INTEGER(ADDRESS_in_sig)) <= DATA_in_sig;
			
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FD8" THEN --STATUS register
				STATUS_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FD8")	<= STATUS_in_sig;
			END IF;	
			--------------------------------------------------------	
			IF CONV_INTEGER(ADDRESS_in_sig) = X"F80" THEN --PORTA register
				PORTA_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"F80")	<= PORTA_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"F81" THEN --PORTB register
				PORTB_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"F81")	<= PORTB_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"F89" THEN --LATA register
				LATA_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"F89")	<= LATA_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"F8A" THEN --LATB register
				LATB_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"F8A")	<= LATB_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"F92" THEN --TRISA register
				TRISA_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"F92")	<= TRISA_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"F93" THEN --TRISB register
				TRISB_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"F93")	<= TRISB_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"F9B" THEN --OSCTUNE register
				OSCTUNE_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"F9B")	<= OSCTUNE_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"F9D" THEN --PIE1 register
				PIE1_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"F9D")	<= PIE1_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"F9E" THEN --PIR1 register
				PIR1_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"F9E")	<= PIR1_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"F9F" THEN --IPR1 register
				IPR1_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"F9F")	<= IPR1_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FA0" THEN --PIE2 register
				PIE2_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FA0")	<= PIE2_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FA1" THEN --PIR2 register
				PIR2_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FA1")	<= PIR2_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FA2" THEN --IPR2 register
				IPR2_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FA2")	<= IPR2_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FA6" THEN --EECON1 register
				EECON1_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FA6")	<= EECON1_in_sig;
			END IF;	
			--------------------------------------------------------	
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FA7" THEN --EECON2 register
				EECON2_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FA7")	<= EECON2_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FA8" THEN --EEDATA register
				EEDATA_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FA8")	<= EEDATA_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FA9" THEN --EEADR register
				EEADR_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FA9")	<= EEADR_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FAA" THEN --BAUDCTL register
				BAUDCTL_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FAA")	<= BAUDCTL_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FAB" THEN --RCSTA register
				RCSTA_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FAB")	<= RCSTA_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FAC" THEN --TXSTA register
				TXSTA_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FAC")	<= TXSTA_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FAD" THEN --TXREG register
				TXREG_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FAD")	<= TXREG_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FAE" THEN --RCREG register
				RCREG_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FAE")	<= RCREG_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FAF" THEN --SPBRG register
				SPBRG_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FAF")	<= SPBRG_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FB0" THEN --SPBRGH register
				SPBRGH_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FB0")	<= SPBRGH_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FB1" THEN --T3CON register
				T3CON_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FB1")	<= T3CON_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FB2" THEN --TMR3L register
				TMR3L_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FB2")	<= TMR3L_in_sig;
			END IF;	
			--------------------------------------------------------
			IF CONV_INTEGER(ADDRESS_in_sig) = X"FB3" THEN --TMR3H register
				TMR3H_in_sig		<= DATA_in_sig;
			ELSE
				RAM_DATA (X"FB3")	<= TMR3H_in_sig;
			END IF;	
			--------------------------------------------------------

			
			
			DATA_out_sig <= "ZZZZZZZZ";
		ELSIF RW_in_sig = '1' THEN		-- read operation
			DATA_out_sig <= RAM_DATA (CONV_INTEGER(ADDRESS_in_sig));
		END IF;	
	ELSIF RAM_SELECT_in_sig = '0' THEN 
		DATA_out_sig <= "ZZZZZZZZ";
	END IF;	
END IF;
END PROCESS;	

END TEST_RAM_ARCH;


