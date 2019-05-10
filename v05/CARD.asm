			
			#INCLUDE P16F84A.INC   


			COUNT		EQU	H'10'		;
			MSECH		EQU	H'11'		;
			SEC			EQU H'12'		;
			MIN			EQU H'13'		;
			HOUR		EQU	H'14'	
			MSECL		EQU	H'15'
			PARITYLRC	EQU	H'16'
			CHARBUF		EQU	H'17'
			CHAR_BUF	EQU	H'18'
			BUFCOUNT	EQU	H'19'
			FLAG		EQU	H'1A'
			PB			EQU	H'1B'
			GPVAR		EQU	H'1C'			
			COUNT1		EQU	H'1D'
			POINTER		EQU H'1E'	
			PA			EQU	H'1F'
			GPVAR1		EQU	H'46'		
			COUNT2		EQU	H'47'
			ADRH		EQU	H'48'	
			ADRL		EQU	H'49'
			BUFFER		EQU	H'49'
			VARADRH		EQU	H'4A'
			VARADRL		EQU	H'4B'
			START_CODE	EQU	B'01011000'
			END_CODE	EQU	B'11111000'

			found_start	EQU	0
			found_end	EQU	1	
			bad_parity	EQU	2	
			bad_lrc		EQU	3
			buf_end		EQU	4
			read_buf	EQU	5
			LSB			EQU	0x00
			MSB			EQU	0x07	
			
				
			BUF_LO		EQU	H'20'
			BUF_HI		EQU	H'45'
							
			#define		RS232RX 	PORTB,3
			#define		RS232DTR 	PORTB,4
			#define		RS232DSR	PORTB,5

			#define		CRDPRSNT	PORTB,0
			#define		CRDDATA 	PORTB,1
			#define		CRDSTROBE 	PORTB,2

			#define		SDA			PORTA,0
			#define		SCL			PORTA,1

	
			ORG		H'000'
			GOTO	START
			ORG		H'004'
			GOTO	CARD_INSERTED
			ORG 	H'006'
			GOTO	RTC


;***********************************************************
;*  CARD_INSERTED IS INVOKED WHEN A CARD IS PRESENT
;*	THE PROCEDURES READS THE CARD THAN SENDS DATA TO THE EEPROM24C512 
;***********************************************************
;OPTION_REG<6> TRQBVA DA E CLEAR ZA DA E PO FALLING EDGE
CARD_INSERTED
			CLRF		POINTER
			MOVLW		START_CODE
			MOVWF		PARITYLRC
			CLRF		FLAG
			BSF			FLAG,bad_lrc
								

WT_DWN_STR	BTFSC		PORTB,2
			GOTO		WT_DWN_STR
CHKDATA		BTFSS		PORTB,0
			GOTO		DATA011
DATA1		BSF			STATUS,C
			MOVLW		0X80
			XORWF		PARITYLRC
			GOTO		STOREDATA
DATA011		BCF			STATUS,C
STOREDATA	RRF			CHARBUF	

			BTFSS		STATUS,C
			GOTO		GOT_CHAR
			BTFSS		FLAG,found_start
			GOTO		WT_UP_STR
			MOVLW		B'11111000'
			BCF			STATUS,Z
			ANDWF		CHAR_BUF
			MOVLW		START_CODE
			XORWF		CHAR_BUF,W		
			BTFSS		STATUS,Z
			GOTO		WT_UP_STR
			BSF			FLAG,found_start

NEXTCHAR	BCF			PARITYLRC,MSB
			CLRF		CHAR_BUF
			BSF			CHAR_BUF,4			

WT_UP_STR	BTFSC		PORTB,2
			GOTO		WT_UP_STR			
			GOTO		WT_DWN_STR

GOT_CHAR	BSF			FLAG,bad_parity
			MOVF		CHAR_BUF,W
			XORWF		PARITYLRC
			BTFSS		FLAG,found_end
			GOTO		NOT_LRC
			BCF			STATUS,Z	
			MOVF		PARITYLRC,W
			ANDLW		B'01111000'
			BTFSS		STATUS,Z
			BCF			FLAG,bad_lrc

NOT_LRC		MOVLW		END_CODE			
			BCF			STATUS,Z	
			XORWF		CHAR_BUF,W
			BTFSS		STATUS,Z
			BSF			FLAG,found_end
			BTFSS		STATUS,Z
			GOTO 		NEXTCHAR
			RLF 		CHAR_BUF
			MOVLW		0XF0
			ANDWF		CHAR_BUF
			RRF			CHAR_BUF
			RRF			CHAR_BUF
			RRF			CHAR_BUF

			INCF		POINTER
			MOVLW		D'37'
			BCF			STATUS,Z
			SUBWF		POINTER	
			BTFSS		STATUS,Z
			GOTO		NEXTCHAR
		
			CLRF		PA				;SEND DATA TO EEPROM
			CLRF		COUNT2
			CLRF		POINTER

			BSF			PA,0			;START CONDITION FOR EEPROM 
			MOVF		PA,W
			MOVWF		PORTA
		
			BSF			PA,1
			MOVF		PA,W
			MOVWF		PORTA
			
			BCF			PA,1
			MOVF		PA,W
			MOVWF		PORTA	

			BCF			PA,0
			MOVF		PA,W
			MOVWF		PORTA			;MEMORY STARTED


			MOVLW		D'7'				;SEND CONTROL BYTE
			MOVWF		COUNT2
			MOVLW		B'01010000'			;BIT0 = 0 > WRITE OP			
			MOVWF		GPVAR1	
			CALL		DS		
			CALL		ACK
			
			MOVF		ADRH,W
			MOVWF		GPVAR1
			MOVLW		D'7'
			MOVWF		COUNT2
			CALL		DS
			CALL		ACK

			MOVF		ADRL,W
			MOVWF		GPVAR1
			MOVLW		D'7'
			MOVWF		COUNT2
			CALL		DS
			CALL		ACK
		
			MOVF		HOUR,W
			MOVWF		GPVAR1
			MOVLW		D'7'
			MOVWF		COUNT2
			CALL		DS
			CALL		ACK

			MOVF		MIN,W
			MOVWF		GPVAR1
			MOVLW		D'7'
			MOVWF		COUNT2
			CALL		DS
			CALL		ACK

			MOVF		SEC,W
			MOVWF		GPVAR1
			MOVLW		D'7'
			MOVWF		COUNT2
			CALL		DS
			CALL		ACK

REP			MOVLW		BUF_LO
			MOVWF		FSR
			ADDWF		POINTER,W
			MOVWF		FSR	
			MOVF		INDF,W
			MOVWF		BUFFER
			
			MOVWF		GPVAR1
			MOVLW		D'7'
			MOVWF		COUNT2
			CALL		DS
			CALL		ACK

			INCF		POINTER
			BCF			STATUS,Z
			MOVF		POINTER,W
			ADDLW		H'20'
			SUBLW		H'45'	
			BTFSS		STATUS,Z
			GOTO		REP
			
			BSF			PA,0			;STOP CONDITION FOR EEPROM 
			MOVF		PA,W
			MOVWF		PORTA
		
			BSF			PA,1
			MOVF		PA,W
			MOVWF		PORTA

			BSF			FLAG,6				;MEMORY NOT EMPTY	
			RETURN

		
;***********************************************************
;*  THE FOLLOWING ROUTINE - RS232 SENDS DATA TO PC, IF PC
;*  IS PRESENT THRU THE COM1, ASYNCHRONOUSLY, MY OWN ALGORYTHM 	
;*  IT IS READING 24512 AND SENDING TO PC TILL THE END OF THE ADRES BUFFER
;***********************************************************
RS232		BTFSS	FLAG,6
			GOTO	ENDRS232			; IS DATA IN MEMORY 
			CLRF	PB
			CLRF	GPVAR1
			CALL	WAITDTRUP			;GL PROGRAMA SHTE ZACIKLI TYK, DOKATO DOIDE PC
			CALL	DSRUP
			CALL	WAITDTRDWN
			CALL	DSRDWN
			CALL	WAITDTRUP

			MOVF	ADRL,W
			MOVWF	VARADRL
			
			BSF			PA,0			;START CONDITION FOR EEPROM 
			MOVF		PA,W
			MOVWF		PORTA
		
			BSF			PA,1
			MOVF		PA,W
			MOVWF		PORTA
			
			BCF			PA,1
			MOVF		PA,W
			MOVWF		PORTA	

			BCF			PA,0
			MOVF		PA,W
			MOVWF		PORTA			;MEMORY STARTED

			MOVLW		D'7'				;SEND CONTROL BYTE
			MOVWF		COUNT2
			MOVLW		B'01010000'			;BIT0 = 0 > WRITE  OP			
			MOVWF		GPVAR1				;TO INITIALIZE ADRES
			CALL		DS		
			CALL		ACK

			MOVLW		D'0'			;START ADR	HIGH
			MOVWF		GPVAR1
			MOVLW		D'7'
			MOVWF		COUNT2
			CALL		DS
			CALL		ACK
	
			MOVLW		D'0'			;START ADR LOW
			MOVWF		GPVAR1
			MOVLW		D'7'
			MOVWF		COUNT2
			CALL		DS
			CALL		ACK
		
			BSF			PA,0			;STOP CONDITION FOR EEPROM 
			MOVF		PA,W
			MOVWF		PORTA
		
			BSF			PA,1
			MOVF		PA,W
			MOVWF		PORTA

			BSF			PA,0			;START CONDITION FOR EEPROM 
			MOVF		PA,W
			MOVWF		PORTA
		
			BSF			PA,1
			MOVF		PA,W
			MOVWF		PORTA
			
			BCF			PA,1
			MOVF		PA,W
			MOVWF		PORTA	

			BCF			PA,0
			MOVF		PA,W
			MOVWF		PORTA			;MEMORY STARTED


			MOVLW		D'7'				;SEND CONTROL BYTE
			MOVWF		COUNT2
			MOVLW		B'01010001'			;BIT0 = 0 > READ  OP			
			MOVWF		GPVAR1				;
			CALL		DS		
			CALL		ACK
			
NXTBUF		CALL		RDATA				;V GPVAR E BYTE OT 24512 ZA RS232
			MOVLW		D'7'
			MOVWF		COUNT1
			CALL		SENDRS
								
			DECFSZ		VARADRL
			GOTO		NXTBUF
			MOVF		ADRL,W
			MOVWF		VARADRL
			DECFSZ		VARADRH
			GOTO		NXTBUF
			
			BCF			FLAG,6			;MEMORY EMPTIED			
			
			BSF			PA,0			;STOP CONDITION FOR EEPROM 
			MOVF		PA,W
			MOVWF		PORTA
		
			BSF			PA,1
			MOVF		PA,W
			MOVWF		PORTA
			
ENDRS232	RETURN			
;*******************************************
;*******************************************
SENDRS		BCF		STATUS,C
			RRF		GPVAR
			BTFSS	STATUS,C
			GOTO	DATA0
			CALL	DATAUP
SETDSR		CALL	DSRUP
			BCF		STATUS,Z
			DECF	COUNT1	
			BTFSS	STATUS,Z
			GOTO	ENDBT
			CALL	WAITDTRDWN
			CALL	DSRDWN
			CALL	WAITDTRUP
			GOTO	SENDRS
DATA0		CALL	DATADWN
			GOTO	SETDSR	
ENDBT		RETURN


				

;*******************************************
;READS BYTE FROM 24512
;*******************************************
RDATA		MOVLW		D'8'
			MOVWF		COUNT2
			CLRF		GPVAR
NXTRD		RLF			GPVAR
			BCF			PORTA,0
			NOP
			NOP
			NOP
			BSF			PORTA,0
			NOP
			NOP
			NOP
			BTFSS		PORTA,1
			BSF			GPVAR,0
			DECFSZ		COUNT2
			GOTO		NXTRD				;IF IS 1 BSF, ELSE JUST ROTATE
			RETURN
			
;*******************************************
;SENDS BYTE TO 24512
;*******************************************
DS			BCF			STATUS,C
NEXTCBIT	RLF			GPVAR1
			BTFSS		STATUS,C
			GOTO		SET0_CALL
			CALL		SET1
			GOTO		ISEND
SET0_CALL	CALL		SET0
ISEND		BCF			STATUS,Z
			DECF		COUNT2		
			BTFSS		STATUS,Z
			GOTO		NEXTCBIT
			RETURN
;*******************************************
;*******************************************

SET1		BCF			PA,0
			BCF			PA,1
			MOVF		PA,W
			MOVWF		PORTA	
			BSF			PA,1
			MOVF		PA,W
			MOVWF		PORTA
			BSF			PA,0
			MOVF		PA,W
			MOVWF		PORTA
			RETURN		
;*******************************************
;*******************************************
			
SET0		BCF			PA,0
			BCF			PA,1
			MOVF		PA,W
			MOVWF		PORTA	
			BSF			PA,0
			MOVF		PA,W
			MOVWF		PORTA
			RETURN			
;*******************************************
;*******************************************
ACK			MOVLW		D'02'			;pa1 - vhod,ost - izhodi
WAITACK		MOVWF		TRISA
			BTFSC		PORTA,1
			GOTO		WAITACK	
			RETURN




;***********************************************************
;*  RS232 : PULLS RX UP
;***********************************************************
DATAUP		BSF		PB,3
			MOVF	PB,W
			MOVWF	PORTB
			RETURN

;***********************************************************
;*  RS232 : PULLS RX DOWN
;***********************************************************
DATADWN		BCF		PB,3
			MOVF	PB,W
			MOVWF	PORTB
			RETURN
;***********************************************************
;*  RS232 : WAITS PC TO PULL DTR DOWN
;***********************************************************
WAITDTRDWN	BTFSC	PORTB,4		
			GOTO	WAITDTRDWN
			RETURN

;***********************************************************
;*  RS232 :SETS DSR UP
;***********************************************************
DSRUP		BSF		PB,5
			MOVF	PB,W
			MOVWF	PORTB
			RETURN

;***********************************************************
;*  RS232 :SETS DSR DOWN
;***********************************************************
DSRDWN		BSF		PB,5
			MOVF	PB,W
			MOVWF	PORTB
			RETURN

;***********************************************************
;* RS232 : WAITS PC TO PULL DTR UP
;***********************************************************
WAITDTRUP	BTFSS	PORTB,4		
			GOTO	WAITDTRUP
			RETURN
;***********************************************************
;*  RTC IS INVOKED WHEN A TIMER0 INTERRUPT OCCURS 
;*	THEN THE ROUTINES TO MANAGE THE REAL TIME CLOCK ARE
;* 	EXECUTED; THE USED XTAL IS 4 MHZ
;***********************************************************
;IMPORTANT OPTION,TOIE (BIT5) TRQBVA DA E ENABLED,
;IMA PREKYSVANE OT TIMERA TRQBVA DA SE CLR OPTION,TOIF BIT3
RTC			
			BCF			OPTION_REG, T0IF
			BCF			STATUS,Z

			DECF		COUNT,1	
			BTFSS		STATUS, Z
			GOTO		ENDOFRTC
			BCF			STATUS, Z	;16 INTERRUPTS PASSED = 1MSEC
			MOVLW		D'16'
			MOVWF		COUNT

			DECF		MSECL,1
			BTFSS		STATUS, Z
			GOTO		ENDOFRTC						
			BCF			STATUS, Z	;256 MSECS PASSED 
			MOVLW		D'256'
			MOVWF		MSECL

			DECF		MSECH,1
			BTFSS		STATUS, Z
			GOTO		ENDOFRTC						
			BCF			STATUS, Z	;1000 MSECS PASSED 
			MOVLW		D'4'
			MOVWF		MSECH

			INCF		SEC,1
			MOVF		SEC, W
			SUBLW		D'60'
			BTFSS		STATUS, Z
			GOTO		ENDOFRTC						
			BCF			STATUS, Z	;60 SECS PASSED 
			MOVLW		D'0'
			MOVWF		SEC			

			INCF		MIN,1
			MOVF		MIN, W
			SUBLW		D'60'
			BTFSS		STATUS, Z
			GOTO		ENDOFRTC						
			BCF			STATUS,Z	;60 MINS PASSED 
			MOVLW		D'0'
			MOVWF		MIN						

			INCF		HOUR	
			MOVF		HOUR,W
			SUBLW		D'24'
			BTFSS		STATUS,Z
			GOTO		ENDOFRTC
			BCF			STATUS,Z	;24 HOURS PASSED 
			MOVLW		D'0'
			MOVWF		HOUR
ENDOFRTC	RETURN

;***********************************************************
;*  MAIN IS SIMPLY THE MAIN CYCLE
;***********************************************************
START		MOVLW		D'16'			;16
			MOVWF		COUNT
			MOVLW		D'256'			;256
			MOVWF		MSECL
			MOVLW		D'4'
			MOVWF		MSECH
			MOVLW		D'0'
			MOVWF		SEC
			MOVLW		D'0'
			MOVWF		MIN
			MOVLW		D'0'
			MOVWF		HOUR
			CLRF		ADRH
			CLRF		ADRL
MAIN		
			CALL		RS232
			GOTO		MAIN
			
			END
