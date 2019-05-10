
library ieee;
USE IEEE.std_logic_1164.ALL;
--use work.count_types.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity testbench is end;


architecture stimonly of testbench is

COMPONENT count 
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
	 
end COMPONENT;
CONSTANT	Clock_cycles		: TIME := 10 ns;
CONSTANT	PERIOD          	: TIME  := 10 ns;


SIGNAL	CLK_sig		: STD_LOGIC :='0'; 
SIGNAL	RESET_NAI_sig	: STD_LOGIC;
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
SIGNAL  TMR01L_in_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR01L_out_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR01H_in_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR01H_out_sig	: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL	TMR0IF_out_sig	: STD_LOGIC;


begin ----instantiate the component




uut: count port map

			(
			
	CLK		=> CLK_sig, 
	RESET_NAI	=> RESET_NAI_sig, 
	--
	T08BIT_in	=> T08BIT_in_sig, 
 	PSA_in		=> PSA_in_sig, 
 	FOSC4_in	=> FOSC4_in_sig, 
	RA4T0CL_in	=> RA4T0CL_in_sig, 
	T0PS_in		=> T0PS_in_sig, 
	T0CS_in		=> T0CS_in_sig, 
	T0SE_in		=> T0SE_in_sig, 
	TMR0on_in	=> TMR0on_in_sig, 
	--
        TMR01L_in 	=> TMR01L_in_sig, 
	TMR01L_out	=> OPEN,--TMR01L_out_sig, 
	TMR01H_in 	=> TMR01H_in_sig, 
	TMR01H_out	=> OPEN,--TMR01H_out_sig, 
	TMR0IF_out	=> OPEN--TMR0IF_out_sig 
		    
		    
		    );
---provide stimulus and check the result---


PROCESS
BEGIN


CLK_sig <= NOT (CLK_sig) after PERIOD/2.0;
WAIT ON CLK_sig;

END PROCESS;



PROCESS


BEGIN
--------------------------------------------------------------------------------
RESET_NAI_sig	<= '0';	

T08BIT_in_sig	<= '1';	
PSA_in_sig	<= '1'; 	
FOSC4_in_sig	<= '0'; 	
RA4T0CL_in_sig	<= '0'; 	
T0PS_in_sig	<= B"010";  
T0CS_in_sig	<= '0'; 	
T0SE_in_sig	<= '0'; 	
TMR0on_in_sig	<= '0'; 	
	--
TMR01L_in_sig	<= X"FF"; 
--TMR01L_out_sig	<= (OTHERS => '0'); 
TMR01H_in_sig	<= X"1F"; 
--TMR01H_out_sig	<= (OTHERS => '0'); 
--TMR0IF_out_sig	<= '0';	

WAIT FOR 2*Clock_cycles;
RESET_NAI_sig	<= '1';	

WAIT FOR 2*Clock_cycles;

	--



WAIT FOR 100000*Clock_cycles;
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




end;	
	
