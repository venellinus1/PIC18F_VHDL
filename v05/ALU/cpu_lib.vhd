LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

PACKAGE CPU_LIB IS 
	TYPE	ALU_INSTRUCTION IS (ADDWF,ADDWFC,ANDWF,DECF,DECFSZ,DCFSNZ,INCF,INFSNZ,IORWF,SUBWF,SUBWFB,XORWF);
END CPU_LIB;