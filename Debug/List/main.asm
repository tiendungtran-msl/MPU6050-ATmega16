
;CodeVisionAVR C Compiler V3.40 Advanced
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _time_count=R4
	.DEF _time_count_msb=R5

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x0:
	.DB  0x47,0x6F,0x63,0x5F,0x52,0x6F,0x6C,0x6C
	.DB  0x20,0x3A,0x0,0x47,0x6F,0x63,0x5F,0x50
	.DB  0x69,0x74,0x63,0x68,0x3A,0x0,0x25,0x33
	.DB  0x64,0x0
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0B
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x0B
	.DW  _0x3+11
	.DW  _0x0*2+11

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;unsigned long previous_time, current_time, eslapsed_time;
;float AccX,AccY,AccZ,Gyro_x,Gyro_y,Gyro_z, Temp;
;void MPU6050_Init()
; 0000 0010 {

	.CSEG
_MPU6050_Init:
; .FSTART _MPU6050_Init
; 0000 0011 delay_ms(150);                                          /* Power up time >100ms  ...
	LDI  R26,LOW(150)
	CALL SUBOPT_0x0
; 0000 0012 I2C_Start_Wait(0xD0);                                   /* Start with device wri ...
; 0000 0013 I2C_Write(SMPLRT_DIV);                                  /* Access to sample rate ...
	LDI  R26,LOW(25)
	CALL _I2C_Write
; 0000 0014 I2C_Write(0x07);                                        /* 1KHz sample rate */
	LDI  R26,LOW(7)
	CALL SUBOPT_0x1
; 0000 0015 I2C_Stop();
; 0000 0016 delay_ms(100);
; 0000 0017 
; 0000 0018 I2C_Start_Wait(0xD0);
; 0000 0019 I2C_Write(PWR_MGMT_1);                                  /* Write to power manage ...
	LDI  R26,LOW(107)
	CALL _I2C_Write
; 0000 001A I2C_Write(0x01);                                        /* PLL with X axis gyros ...
	LDI  R26,LOW(1)
	CALL SUBOPT_0x1
; 0000 001B I2C_Stop();
; 0000 001C delay_ms(100);
; 0000 001D 
; 0000 001E I2C_Start_Wait(0xD0);
; 0000 001F I2C_Write(CONFIG);                                      /* Write to Configuratio ...
	LDI  R26,LOW(26)
	CALL _I2C_Write
; 0000 0020 I2C_Write(0x00);                                        /* Fs = 8KHz */
	LDI  R26,LOW(0)
	CALL SUBOPT_0x1
; 0000 0021 I2C_Stop();
; 0000 0022 delay_ms(100);
; 0000 0023 
; 0000 0024 I2C_Start_Wait(0xD0);
; 0000 0025 I2C_Write(GYRO_CONFIG);                                 /* Write to Gyro configu ...
	LDI  R26,LOW(27)
	CALL _I2C_Write
; 0000 0026 I2C_Write(0x18);                                        /* Full scale range +/-  ...
	LDI  R26,LOW(24)
	CALL SUBOPT_0x1
; 0000 0027 I2C_Stop();
; 0000 0028 delay_ms(100);
; 0000 0029 
; 0000 002A I2C_Start_Wait(0xD0);
; 0000 002B I2C_Write(INT_ENABLE);                                  /* Write to interrupt en ...
	LDI  R26,LOW(56)
	CALL _I2C_Write
; 0000 002C I2C_Write(0x01);
	LDI  R26,LOW(1)
	CALL _I2C_Write
; 0000 002D I2C_Stop();
	CALL _I2C_Stop
; 0000 002E delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 002F }
	RET
; .FEND
;void MPU_Start_Loc()
; 0000 0032 {
_MPU_Start_Loc:
; .FSTART _MPU_Start_Loc
; 0000 0033 I2C_Start_Wait(0xD0);                                   /* I2C start with device ...
	LDI  R26,LOW(208)
	CALL _I2C_Start_Wait
; 0000 0034 I2C_Write(ACCEL_XOUT_H);                                /* Write start location  ...
	LDI  R26,LOW(59)
	CALL _I2C_Write
; 0000 0035 I2C_Repeated_Start(0xD1);                               /* I2C start with device ...
	LDI  R26,LOW(209)
	CALL _I2C_Repeated_Start
; 0000 0036 }
	RET
; .FEND
;void Read_RawValue()
; 0000 0039 {
_Read_RawValue:
; .FSTART _Read_RawValue
; 0000 003A MPU_Start_Loc();			                            /* Read Gyro values */
	RCALL _MPU_Start_Loc
; 0000 003B AccX = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
	CALL SUBOPT_0x2
	PUSH R31
	PUSH R30
	CALL _I2C_Read_Ack
	LDI  R31,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_AccX)
	LDI  R27,HIGH(_AccX)
	CALL SUBOPT_0x3
; 0000 003C AccY = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
	PUSH R31
	PUSH R30
	CALL _I2C_Read_Ack
	LDI  R31,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_AccY)
	LDI  R27,HIGH(_AccY)
	CALL SUBOPT_0x3
; 0000 003D AccZ = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
	PUSH R31
	PUSH R30
	CALL _I2C_Read_Ack
	LDI  R31,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_AccZ)
	LDI  R27,HIGH(_AccZ)
	CALL SUBOPT_0x3
; 0000 003E Temp = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
	PUSH R31
	PUSH R30
	CALL _I2C_Read_Ack
	LDI  R31,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Temp)
	LDI  R27,HIGH(_Temp)
	CALL SUBOPT_0x3
; 0000 003F Gyro_x = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
	PUSH R31
	PUSH R30
	CALL _I2C_Read_Ack
	LDI  R31,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Gyro_x)
	LDI  R27,HIGH(_Gyro_x)
	CALL SUBOPT_0x3
; 0000 0040 Gyro_y = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
	PUSH R31
	PUSH R30
	CALL _I2C_Read_Ack
	LDI  R31,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Gyro_y)
	LDI  R27,HIGH(_Gyro_y)
	CALL SUBOPT_0x3
; 0000 0041 Gyro_z = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Nack());
	PUSH R31
	PUSH R30
	CALL _I2C_Read_Nack
	LDI  R31,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Gyro_z)
	LDI  R27,HIGH(_Gyro_z)
	CALL SUBOPT_0x4
	CALL __PUTDP1
; 0000 0042 I2C_Stop();
	CALL _I2C_Stop
; 0000 0043 }
	RET
; .FEND
;float Roll_Acc (float AccX, float AccY, float AccZ)
; 0000 0046 {
_Roll_Acc:
; .FSTART _Roll_Acc
; 0000 0047 float Roll_Acc;
; 0000 0048 Roll_Acc = atan(AccY/sqrt(pow(AccX,2)+pow(AccZ,2)))*180/PI;
	CALL SUBOPT_0x5
;	AccX -> Y+12
;	AccY -> Y+8
;	AccZ -> Y+4
;	Roll_Acc -> Y+0
	CALL SUBOPT_0x6
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 0049 return Roll_Acc;
	RJMP _0x20A0009
; 0000 004A }
; .FEND
;float Pitch_Acc (float AccX, float AccY, float AccZ)
; 0000 004D {
_Pitch_Acc:
; .FSTART _Pitch_Acc
; 0000 004E float Pitch_Acc;
; 0000 004F Pitch_Acc = atan(-1*AccX/sqrt(pow(AccY,2)+pow(AccZ,2)))*180/PI;
	CALL SUBOPT_0x5
;	AccX -> Y+12
;	AccY -> Y+8
;	AccZ -> Y+4
;	Pitch_Acc -> Y+0
	__GETD2N 0xBF800000
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0x6
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x8
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xA
; 0000 0050 return Pitch_Acc;
	RJMP _0x20A0009
; 0000 0051 }
; .FEND
;float Angle_Gyr (float Gyro, float Acc)
; 0000 0054 {
_Angle_Gyr:
; .FSTART _Angle_Gyr
; 0000 0055 float Angle_Gyr = Acc, v;
; 0000 0056 previous_time = current_time;
	CALL __PUTPARD2
	SBIW R28,8
;	Gyro -> Y+12
;	Acc -> Y+8
;	Angle_Gyr -> Y+4
;	v -> Y+0
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	STS  _previous_time,R30
	STS  _previous_time+1,R31
	STS  _previous_time+2,R22
	STS  _previous_time+3,R23
; 0000 0057 current_time = millis();
	CALL _millis
	CLR  R22
	CLR  R23
	STS  _current_time,R30
	STS  _current_time+1,R31
	STS  _current_time+2,R22
	STS  _current_time+3,R23
; 0000 0058 eslapsed_time = (float)((current_time - previous_time));
	LDS  R26,_previous_time
	LDS  R27,_previous_time+1
	LDS  R24,_previous_time+2
	LDS  R25,_previous_time+3
	CALL SUBOPT_0xD
	CALL __SUBD12
	CALL __CDF1U
	LDI  R26,LOW(_eslapsed_time)
	LDI  R27,HIGH(_eslapsed_time)
	CALL __CFD1U
	CALL __PUTDP1
; 0000 0059 v = (Gyro)/16.4;
	__GETD2S 12
	__GETD1N 0x41833333
	CALL __DIVF21
	CALL SUBOPT_0xE
; 0000 005A Angle_Gyr += v*eslapsed_time/1000;                      /*Fs_SEL = 1*/
	LDS  R30,_eslapsed_time
	LDS  R31,_eslapsed_time+1
	LDS  R22,_eslapsed_time+2
	LDS  R23,_eslapsed_time+3
	CALL SUBOPT_0xF
	CALL __CDF1U
	CALL SUBOPT_0x10
	__GETD1N 0x447A0000
	CALL __DIVF21
	CALL SUBOPT_0x11
	CALL __ADDF12
	CALL SUBOPT_0xC
; 0000 005B return Angle_Gyr;
	CALL SUBOPT_0x12
_0x20A0009:
	ADIW R28,16
	RET
; 0000 005C }
; .FEND
;void main()
; 0000 005F {
_main:
; .FSTART _main
; 0000 0060 char buffer_X[5],buffer_Y[5]; //float_[10];
; 0000 0061 float R_Acc, P_Acc, R_Gyr, P_Gyr, Roll, Pitch;
; 0000 0062 previous_time = 0;
	SBIW R28,34
;	buffer_X -> Y+29
;	buffer_Y -> Y+24
;	R_Acc -> Y+20
;	P_Acc -> Y+16
;	R_Gyr -> Y+12
;	P_Gyr -> Y+8
;	Roll -> Y+4
;	Pitch -> Y+0
	LDI  R30,LOW(0)
	STS  _previous_time,R30
	STS  _previous_time+1,R30
	STS  _previous_time+2,R30
	STS  _previous_time+3,R30
; 0000 0063 current_time = 0;
	STS  _current_time,R30
	STS  _current_time+1,R30
	STS  _current_time+2,R30
	STS  _current_time+3,R30
; 0000 0064 eslapsed_time = 0;
	STS  _eslapsed_time,R30
	STS  _eslapsed_time+1,R30
	STS  _eslapsed_time+2,R30
	STS  _eslapsed_time+3,R30
; 0000 0065 I2C_Init();                                            /* Initialize I2C */
	CALL _I2C_Init
; 0000 0066 MPU6050_Init();                                        /* Initialize MPU6050 */
	RCALL _MPU6050_Init
; 0000 0067 LCD_Init();
	RCALL _LCD_Init
; 0000 0068 LCD_String_xy(0,0,"Goc_Roll :");
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	__POINTW2MN _0x3,0
	RCALL _LCD_String_xy
; 0000 0069 LCD_String_xy(1,0,"Goc_Pitch:");
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW2MN _0x3,11
	RCALL _LCD_String_xy
; 0000 006A millis_setup();
	CALL _millis_setup
; 0000 006B #asm("sei")
	SEI
; 0000 006C 
; 0000 006D while(1)
_0x4:
; 0000 006E {
; 0000 006F Read_RawValue();
	RCALL _Read_RawValue
; 0000 0070 
; 0000 0071 R_Acc = Roll_Acc(AccX, AccY, AccZ);
	CALL SUBOPT_0x13
	RCALL _Roll_Acc
	__PUTD1S 20
; 0000 0072 P_Acc = Pitch_Acc(AccX, AccY, AccZ);
	CALL SUBOPT_0x13
	RCALL _Pitch_Acc
	__PUTD1S 16
; 0000 0073 
; 0000 0074 R_Gyr = Angle_Gyr(Gyro_y, Roll);
	LDS  R30,_Gyro_y
	LDS  R31,_Gyro_y+1
	LDS  R22,_Gyro_y+2
	LDS  R23,_Gyro_y+3
	CALL __PUTPARD1
	CALL SUBOPT_0x9
	RCALL _Angle_Gyr
	__PUTD1S 12
; 0000 0075 P_Gyr = Angle_Gyr(Gyro_x, Pitch);
	LDS  R30,_Gyro_x
	LDS  R31,_Gyro_x+1
	LDS  R22,_Gyro_x+2
	LDS  R23,_Gyro_x+3
	CALL __PUTPARD1
	CALL SUBOPT_0x11
	RCALL _Angle_Gyr
	__PUTD1S 8
; 0000 0076 
; 0000 0077 Roll = 0.3*R_Gyr + 0.7*R_Acc;
	__GETD1S 12
	CALL SUBOPT_0x14
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 20
	CALL SUBOPT_0x15
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	CALL SUBOPT_0xC
; 0000 0078 Pitch = 0.3*P_Gyr + 0.7*P_Acc;
	CALL SUBOPT_0xB
	CALL SUBOPT_0x14
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 16
	CALL SUBOPT_0x15
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	CALL SUBOPT_0xE
; 0000 0079 
; 0000 007A sprintf(buffer_X,"%3d",(int)Pitch);
	MOVW R30,R28
	ADIW R30,29
	CALL SUBOPT_0x16
	CALL SUBOPT_0x12
	CALL SUBOPT_0x17
; 0000 007B sprintf(buffer_Y,"%3d",(int)Roll);
	MOVW R30,R28
	ADIW R30,24
	CALL SUBOPT_0x16
	CALL SUBOPT_0xB
	CALL SUBOPT_0x17
; 0000 007C 
; 0000 007D LCD_String_xy(0,10,buffer_X);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,31
	RCALL _LCD_String_xy
; 0000 007E LCD_String_xy(1,10,buffer_Y);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,26
	RCALL _LCD_String_xy
; 0000 007F }
	RJMP _0x4
; 0000 0080 }
_0x7:
	RJMP _0x7
; .FEND

	.DSEG
_0x3:
	.BYTE 0x16
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void LCD_Init()
; 0001 0004 {

	.CSEG
_LCD_Init:
; .FSTART _LCD_Init
; 0001 0005 LCD_Dir = 0xFF;     // Out chan B
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0001 0006 delay_ms(20);       // Doi LCD len nguon
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 0007 
; 0001 0008 LCD_Cmd(0x33);      // Muc fuction set
	LDI  R26,LOW(51)
	RCALL _LCD_Cmd
; 0001 0009 LCD_Cmd(0x32);      // Mode 4 bit
	LDI  R26,LOW(50)
	RCALL _LCD_Cmd
; 0001 000A LCD_Cmd(0x28);      // 2 dong _ 5x7 dots
	LDI  R26,LOW(40)
	RCALL _LCD_Cmd
; 0001 000B LCD_Cmd(0x0C);      // Hien len man hinh, tat con tro
	LDI  R26,LOW(12)
	RCALL _LCD_Cmd
; 0001 000C LCD_Cmd(0x06);      // Dich con tro
	LDI  R26,LOW(6)
	RCALL _LCD_Cmd
; 0001 000D LCD_Cmd(0x01);      // Xoa man hinh
	LDI  R26,LOW(1)
	RCALL _LCD_Cmd
; 0001 000E }
	RET
; .FEND
;void LCD_Cmd(unsigned char cmd)
; 0001 0011 {
_LCD_Cmd:
; .FSTART _LCD_Cmd
; 0001 0012 LCD_Port = (LCD_Port & 0x0F)|(cmd & 0xF0);      // Gui upper nibble
	CALL SUBOPT_0x18
;	cmd -> R17
; 0001 0013 RS = 0;                                         // RS=0 --> command transmit
	CBI  0x18,0
; 0001 0014 EN = 1;                                         // Enable
	CALL SUBOPT_0x19
; 0001 0015 delay_us(1);
; 0001 0016 EN = !EN;
	SBIS 0x18,1
	RJMP _0x20007
	CBI  0x18,1
	RJMP _0x20008
_0x20007:
	SBI  0x18,1
_0x20008:
; 0001 0017 delay_us(200);
	CALL SUBOPT_0x1A
; 0001 0018 LCD_Port = (LCD_Port & 0x0F) | (cmd << 4);      // Gui lower nibble
; 0001 0019 EN = 1;
; 0001 001A delay_us(1);
; 0001 001B EN = !EN;
	SBIS 0x18,1
	RJMP _0x2000B
	CBI  0x18,1
	RJMP _0x2000C
_0x2000B:
	SBI  0x18,1
_0x2000C:
; 0001 001C delay_ms(2);
	RJMP _0x20A0008
; 0001 001D }
; .FEND
;void LCD_Char(unsigned char data) // in ki tu
; 0001 0020 {
_LCD_Char:
; .FSTART _LCD_Char
; 0001 0021 LCD_Port = (LCD_Port & 0x0F) | (data & 0xF0);
	CALL SUBOPT_0x18
;	data -> R17
; 0001 0022 RS = 1;     // RS=1 --> data transmit
	SBI  0x18,0
; 0001 0023 EN = 1;
	CALL SUBOPT_0x19
; 0001 0024 delay_us(1);
; 0001 0025 EN = !EN;
	SBIS 0x18,1
	RJMP _0x20011
	CBI  0x18,1
	RJMP _0x20012
_0x20011:
	SBI  0x18,1
_0x20012:
; 0001 0026 delay_us(200);
	CALL SUBOPT_0x1A
; 0001 0027 LCD_Port = (LCD_Port & 0x0F) | (data << 4);
; 0001 0028 EN = 1;
; 0001 0029 delay_us(1);
; 0001 002A EN = !EN;
	SBIS 0x18,1
	RJMP _0x20015
	CBI  0x18,1
	RJMP _0x20016
_0x20015:
	SBI  0x18,1
_0x20016:
; 0001 002B delay_ms(2);
_0x20A0008:
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0001 002C }
	LD   R17,Y+
	RET
; .FEND
;void LCD_String(char *str)  // in chuoi
; 0001 002F {
_LCD_String:
; .FSTART _LCD_String
; 0001 0030 int i;
; 0001 0031 for(i=0;str[i]!=0;i++)
	CALL __SAVELOCR4
	MOVW R18,R26
;	*str -> R18,R19
;	i -> R16,R17
	__GETWRN 16,17,0
_0x20018:
	MOVW R30,R16
	ADD  R30,R18
	ADC  R31,R19
	LD   R30,Z
	CPI  R30,0
	BREQ _0x20019
; 0001 0032 {
; 0001 0033 LCD_Char (str[i]);
	MOVW R30,R16
	ADD  R30,R18
	ADC  R31,R19
	LD   R26,Z
	RCALL _LCD_Char
; 0001 0034 }
	__ADDWRN 16,17,1
	RJMP _0x20018
_0x20019:
; 0001 0035 }
	CALL __LOADLOCR4
	JMP  _0x20A0002
; .FEND
;void LCD_String_xy(char row, char pos, char *str)
; 0001 0038 {
_LCD_String_xy:
; .FSTART _LCD_String_xy
; 0001 0039 if (row == 0 && pos < 16)
	CALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
	LDD  R18,Y+5
;	row -> R18
;	pos -> R19
;	*str -> R16,R17
	CPI  R18,0
	BRNE _0x2001B
	CPI  R19,16
	BRLO _0x2001C
_0x2001B:
	RJMP _0x2001A
_0x2001C:
; 0001 003A LCD_Cmd((pos & 0x0F)|0x80);
	MOV  R30,R19
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2002A
; 0001 003B else if (row == 1 && pos <16)
_0x2001A:
	CPI  R18,1
	BRNE _0x2001F
	CPI  R19,16
	BRLO _0x20020
_0x2001F:
	RJMP _0x2001E
_0x20020:
; 0001 003C LCD_Cmd((pos & 0x0F)|0xC0);
	MOV  R30,R19
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2002A:
	MOV  R26,R30
	RCALL _LCD_Cmd
; 0001 003D LCD_String(str);
_0x2001E:
	MOVW R26,R16
	RCALL _LCD_String
; 0001 003E }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;void LCD_Clear()
; 0001 0041 {
; 0001 0042 LCD_Cmd(0x01);      // Xoa
; 0001 0043 delay_ms(2);
; 0001 0044 LCD_Cmd (0x80); // Pagehome
; 0001 0045 }
;void LCD_Roll_Right(unsigned char times_roll)
; 0001 0048 {
; 0001 0049 unsigned char shift = 15;
; 0001 004A unsigned char i,k;
; 0001 004B for (i=0;i<times_roll;i++)
;	times_roll -> R18
;	shift -> R17
;	i -> R16
;	k -> R19
; 0001 004C {
; 0001 004D for (k=0;k<shift;k++)
; 0001 004E {
; 0001 004F LCD_Cmd(0x1C);
; 0001 0050 delay_ms(300);
; 0001 0051 }
; 0001 0052 for (k=0;k<shift;k++)
; 0001 0053 {
; 0001 0054 LCD_Cmd(0x18);
; 0001 0055 }
; 0001 0056 
; 0001 0057 }
; 0001 0058 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void I2C_Init()												/* I2C initialize function */
; 0002 0004 {

	.CSEG
_I2C_Init:
; .FSTART _I2C_Init
; 0002 0005 TWBR = BITRATE(TWSR = 0x00);							/* Get bit rate register value by formula */
	__GETD1N 0x40800000
	CALL __PUTPARD1
	OUT  0x1,R30
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL _pow
	__GETD2N 0x40000000
	CALL __MULF12
	__GETD2N 0x42800000
	CALL __DIVF21
	CALL __CFD1U
	OUT  0x0,R30
; 0002 0006 }
	RET
; .FEND
;unsigned char I2C_Start (char slave_write_address)			/* I2C start function */
; 0002 000A {
; 0002 000B unsigned char status;
; 0002 000C TWCR = (1<<TWSTA)|(1<<TWEN)|(1<<TWINT);					/* Enable TWI, generate start condit ...
;	slave_write_address -> R16
;	status -> R17
; 0002 000D while (!(TWCR & (1<<TWINT)));							/* Wait until TWI finish its current job (st ...
; 0002 000E status = TWSR & 0xF8;									/* Read TWI status register with masking lower thr ...
; 0002 000F if (status != 0x08)										/* Check weather start condition transmitted succes ...
; 0002 0010 return 0;												/* If not then return 0 to indicate start condition fail */
; 0002 0011 TWDR = slave_write_address;								/* If yes then write SLA+W in TWI data regist ...
; 0002 0012 TWCR = (1<<TWEN)|(1<<TWINT);							/* Enable TWI and clear interrupt flag */
; 0002 0013 while (!(TWCR & (1<<TWINT)));							/* Wait until TWI finish its current job (Wr ...
; 0002 0014 status = TWSR & 0xF8;									/* Read TWI status register with masking lower thr ...
; 0002 0015 if (status == 0x18)										/* Check weather SLA+W transmitted & ack received o ...
; 0002 0016 return 1;												/* If yes then return 1 to indicate ack received i.e. ready ...
; 0002 0017 if (status == 0x20)										/* Check weather SLA+W transmitted & nack received  ...
; 0002 0018 return 2;												/* If yes then return 2 to indicate nack received i.e. devi ...
; 0002 0019 else
; 0002 001A return 3;												/* Else return 3 to indicate SLA+W failed */
; 0002 001B }
;unsigned char I2C_Repeated_Start(char slave_read_address)	/* I2C repeated start  ...
; 0002 001E {
_I2C_Repeated_Start:
; .FSTART _I2C_Repeated_Start
; 0002 001F unsigned char status;
; 0002 0020 TWCR = (1<<TWSTA)|(1<<TWEN)|(1<<TWINT);					/* Enable TWI, generate start condit ...
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
;	slave_read_address -> R16
;	status -> R17
	LDI  R30,LOW(164)
	OUT  0x36,R30
; 0002 0021 while (!(TWCR & (1<<TWINT)));							/* Wait until TWI finish its current job (st ...
_0x4000D:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x4000D
; 0002 0022 status = TWSR & 0xF8;									/* Read TWI status register with masking lower thr ...
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	MOV  R17,R30
; 0002 0023 if (status != 0x10)										/* Check weather repeated start condition transmitt ...
	CPI  R17,16
	BREQ _0x40010
; 0002 0024 return 0;												/* If no then return 0 to indicate repeated start condition ...
	LDI  R30,LOW(0)
	RJMP _0x20A0006
; 0002 0025 TWDR = slave_read_address;								/* If yes then write SLA+R in TWI data registe ...
_0x40010:
	OUT  0x3,R16
; 0002 0026 TWCR = (1<<TWEN)|(1<<TWINT);							/* Enable TWI and clear interrupt flag */
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0002 0027 while (!(TWCR & (1<<TWINT)));							/* Wait until TWI finish its current job (Wr ...
_0x40011:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x40011
; 0002 0028 status = TWSR & 0xF8;									/* Read TWI status register with masking lower thr ...
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	MOV  R17,R30
; 0002 0029 if (status == 0x40)										/* Check weather SLA+R transmitted & ack received o ...
	CPI  R17,64
	BRNE _0x40014
; 0002 002A return 1;												/* If yes then return 1 to indicate ack received */
	LDI  R30,LOW(1)
	RJMP _0x20A0006
; 0002 002B if (status == 0x20)										/* Check weather SLA+R transmitted & nack received  ...
_0x40014:
	CPI  R17,32
	BRNE _0x40015
; 0002 002C return 2;												/* If yes then return 2 to indicate nack received i.e. devi ...
	LDI  R30,LOW(2)
	RJMP _0x20A0006
; 0002 002D else
_0x40015:
; 0002 002E return 3;												/* Else return 3 to indicate SLA+W failed */
	LDI  R30,LOW(3)
	RJMP _0x20A0006
; 0002 002F }
; .FEND
;void I2C_Stop()												/* I2C stop function */
; 0002 0032 {
_I2C_Stop:
; .FSTART _I2C_Stop
; 0002 0033 TWCR=(1<<TWSTO)|(1<<TWINT)|(1<<TWEN);					/* Enable TWI, generate stop condition ...
	LDI  R30,LOW(148)
	OUT  0x36,R30
; 0002 0034 while(TWCR & (1<<TWSTO));								/* Wait until stop condition execution */
_0x40017:
	IN   R30,0x36
	SBRC R30,4
	RJMP _0x40017
; 0002 0035 }
	RET
; .FEND
;void I2C_Start_Wait(char slave_write_address)				/* I2C start wait function */
; 0002 0038 {
_I2C_Start_Wait:
; .FSTART _I2C_Start_Wait
; 0002 0039 unsigned char status;
; 0002 003A while (1)
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
;	slave_write_address -> R16
;	status -> R17
_0x4001A:
; 0002 003B {
; 0002 003C TWCR = (1<<TWSTA)|(1<<TWEN)|(1<<TWINT);				/* Enable TWI, generate start conditi ...
	LDI  R30,LOW(164)
	OUT  0x36,R30
; 0002 003D while (!(TWCR & (1<<TWINT)));						/* Wait until TWI finish its current job (sta ...
_0x4001D:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x4001D
; 0002 003E status = TWSR & 0xF8;								/* Read TWI status register with masking lower thre ...
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	MOV  R17,R30
; 0002 003F if (status != 0x08)									/* Check weather start condition transmitted success ...
	CPI  R17,8
	BRNE _0x4001A
; 0002 0040 continue;											/* If no then continue with start loop again */
; 0002 0041 TWDR = slave_write_address;							/* If yes then write SLA+W in TWI data registe ...
	OUT  0x3,R16
; 0002 0042 TWCR = (1<<TWEN)|(1<<TWINT);						/* Enable TWI and clear interrupt flag */
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0002 0043 while (!(TWCR & (1<<TWINT)));						/* Wait until TWI finish its current job (Wri ...
_0x40021:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x40021
; 0002 0044 status = TWSR & 0xF8;								/* Read TWI status register with masking lower thre ...
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	MOV  R17,R30
; 0002 0045 if (status != 0x18 )								/* Check weather SLA+W transmitted & ack received or ...
	CPI  R17,24
	BREQ _0x40024
; 0002 0046 {
; 0002 0047 I2C_Stop();										/* If not then generate stop condition */
	RCALL _I2C_Stop
; 0002 0048 continue;										/* continue with start loop again */
	RJMP _0x4001A
; 0002 0049 }
; 0002 004A break;												/* If yes then break loop */
_0x40024:
; 0002 004B }
; 0002 004C }
	RJMP _0x20A0006
; .FEND
;unsigned char I2C_Write(char data)							/* I2C write function */
; 0002 004F {
_I2C_Write:
; .FSTART _I2C_Write
; 0002 0050 unsigned char status;
; 0002 0051 TWDR = data;											/* Copy data in TWI data register */
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
;	data -> R16
;	status -> R17
	OUT  0x3,R16
; 0002 0052 TWCR = (1<<TWEN)|(1<<TWINT);							/* Enable TWI and clear interrupt flag */
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0002 0053 while (!(TWCR & (1<<TWINT)));							/* Wait until TWI finish its current job (Wr ...
_0x40025:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x40025
; 0002 0054 status = TWSR & 0xF8;									/* Read TWI status register with masking lower thr ...
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	MOV  R17,R30
; 0002 0055 if (status == 0x28)										/* Check weather data transmitted & ack received or ...
	CPI  R17,40
	BRNE _0x40028
; 0002 0056 return 0;												/* If yes then return 0 to indicate ack received */
	LDI  R30,LOW(0)
	RJMP _0x20A0006
; 0002 0057 if (status == 0x30)										/* Check weather data transmitted & nack received o ...
_0x40028:
	CPI  R17,48
	BRNE _0x40029
; 0002 0058 return 1;												/* If yes then return 1 to indicate nack received */
	LDI  R30,LOW(1)
	RJMP _0x20A0006
; 0002 0059 else
_0x40029:
; 0002 005A return 2;												/* Else return 2 to indicate data transmission failed */
	LDI  R30,LOW(2)
	RJMP _0x20A0006
; 0002 005B }
; .FEND
;char I2C_Read_Ack()										    /* I2C read ack function */
; 0002 005E {
_I2C_Read_Ack:
; .FSTART _I2C_Read_Ack
; 0002 005F TWCR=(1<<TWEN)|(1<<TWINT)|(1<<TWEA);					/* Enable TWI, generation of ack and cl ...
	LDI  R30,LOW(196)
	OUT  0x36,R30
; 0002 0060 while (!(TWCR & (1<<TWINT)));							/* Wait until TWI finish its current job (re ...
_0x4002B:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x4002B
; 0002 0061 return TWDR;											/* Return received data */
	RJMP _0x20A0007
; 0002 0062 }
; .FEND
;char I2C_Read_Nack()										/* I2C read nack function */
; 0002 0065 {
_I2C_Read_Nack:
; .FSTART _I2C_Read_Nack
; 0002 0066 TWCR=(1<<TWEN)|(1<<TWINT);								/* Enable TWI and clear interrupt flag */
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0002 0067 while (!(TWCR & (1<<TWINT)));							/* Wait until TWI finish its current job (re ...
_0x4002E:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x4002E
; 0002 0068 return TWDR;											/* Return received data */
_0x20A0007:
	IN   R30,0x3
	RET
; 0002 0069 }
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;unsigned int time_count = 0;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0003 0006 {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0003 0007 time_count++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0003 0008 TCNT1H = 0xE0;
	LDI  R30,LOW(224)
	OUT  0x2D,R30
; 0003 0009 TCNT1L = 0xBF;
	LDI  R30,LOW(191)
	OUT  0x2C,R30
; 0003 000A }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;void timer1_init()
; 0003 000D {
_timer1_init:
; .FSTART _timer1_init
; 0003 000E // Thiet lap Timer1 che do Normal dem len
; 0003 000F TCCR1B = 0x01; // CS10=1, CS12=0 (prescaler 1)
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0003 0010 TCNT1H = 0xE0; // Chu ki dem 1ms
	LDI  R30,LOW(224)
	OUT  0x2D,R30
; 0003 0011 TCNT1L = 0xBF;
	LDI  R30,LOW(191)
	OUT  0x2C,R30
; 0003 0012 TIMSK = (1 << TOIE1); // Cho phép ngat khi timer1 tràn
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0003 0013 }
	RET
; .FEND
;unsigned int millis()
; 0003 0017 {
_millis:
; .FSTART _millis
; 0003 0018 unsigned int millis_return;
; 0003 0019 // Tat ngat de dam bao tinh dong nhat khi do giá tri
; 0003 001A #asm("cli")
	ST   -Y,R17
	ST   -Y,R16
;	millis_return -> R16,R17
	CLI
; 0003 001B millis_return = time_count;
	MOVW R16,R4
; 0003 001C #asm("sei")
	SEI
; 0003 001D return millis_return;
	MOVW R30,R16
_0x20A0006:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0003 001E }
; .FEND
;void millis_setup()
; 0003 0022 {
_millis_setup:
; .FSTART _millis_setup
; 0003 0023 timer1_init(); // Khoi tao timer1
	RCALL _timer1_init
; 0003 0024 #asm("sei"); // Bat ngat toàn cuc
	SEI
; 0003 0025 }
	RET
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL SUBOPT_0xF
	CALL _ftrunc
	CALL SUBOPT_0xE
    brne __floor1
__floor0:
	CALL SUBOPT_0x1B
	RJMP _0x20A0002
__floor1:
    brtc __floor0
	CALL SUBOPT_0x1C
	CALL __SUBF12
	RJMP _0x20A0002
; .FEND
_log:
; .FSTART _log
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x1D
	CALL __CPD02
	BRLT _0x200000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20A0005
_0x200000C:
	CALL SUBOPT_0x1E
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1D
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x200000D
	CALL SUBOPT_0x20
	CALL __ADDF12
	CALL SUBOPT_0x1F
	__SUBWRN 16,17,1
_0x200000D:
	CALL SUBOPT_0x21
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
	__GETD2N 0x3F654226
	CALL SUBOPT_0x10
	__GETD1N 0x4054114E
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1D
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x24
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL SUBOPT_0x4
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x20A0005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
; .FEND
_exp:
; .FSTART _exp
	CALL __PUTPARD2
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x25
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x200000F
	CALL SUBOPT_0x26
	RJMP _0x20A0004
_0x200000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2000010
	__GETD1N 0x3F800000
	RJMP _0x20A0004
_0x2000010:
	CALL SUBOPT_0x25
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20A0004
_0x2000011:
	CALL SUBOPT_0x25
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL SUBOPT_0x25
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	CALL SUBOPT_0x25
	CALL SUBOPT_0x4
	CALL SUBOPT_0x23
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x1D
	CALL __MULF12
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x24
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0x1E
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x24
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
_0x20A0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0xB
	CALL __CPD10
	BRNE _0x2000012
	CALL SUBOPT_0x26
	RJMP _0x20A0003
_0x2000012:
	CALL SUBOPT_0x9
	CALL __CPD02
	BRGE _0x2000013
	CALL SUBOPT_0x12
	CALL __CPD10
	BRNE _0x2000014
	__GETD1N 0x3F800000
	RJMP _0x20A0003
_0x2000014:
	CALL SUBOPT_0x9
	CALL SUBOPT_0x27
	RCALL _exp
	RJMP _0x20A0003
_0x2000013:
	CALL SUBOPT_0x12
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x1B
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x12
	CALL __CPD12
	BREQ _0x2000015
	CALL SUBOPT_0x26
	RJMP _0x20A0003
_0x2000015:
	CALL SUBOPT_0xB
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x27
	RCALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2000016
	CALL SUBOPT_0xB
	RJMP _0x20A0003
_0x2000016:
	CALL SUBOPT_0xB
	CALL __ANEGF1
_0x20A0003:
	ADIW R28,12
	RET
; .FEND
_xatan:
; .FSTART _xatan
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x12
	CALL SUBOPT_0x11
	CALL __MULF12
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1B
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x28
	CALL SUBOPT_0x11
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1B
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0xF
	CALL SUBOPT_0x28
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
; .FEND
_yatan:
; .FSTART _yatan
	CALL __PUTPARD2
	CALL SUBOPT_0xF
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2000020
	CALL SUBOPT_0xF
	RCALL _xatan
	RJMP _0x20A0002
_0x2000020:
	CALL SUBOPT_0xF
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x29
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x23
	RJMP _0x20A0002
_0x2000021:
	CALL SUBOPT_0x1C
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1C
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x29
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	RJMP _0x20A0002
; .FEND
_atan:
; .FSTART _atan
	CALL __PUTPARD2
	LDD  R26,Y+3
	TST  R26
	BRMI _0x200002C
	CALL SUBOPT_0xF
	RCALL _yatan
	RJMP _0x20A0002
_0x200002C:
	CALL SUBOPT_0x1B
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _yatan
	CALL __ANEGF1
_0x20A0002:
	ADIW R28,4
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	CALL __SAVELOCR6
	MOVW R18,R26
	LDD  R21,Y+6
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	MOVW R26,R18
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1RNS 18,4
_0x2020012:
	MOVW R26,R18
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	ST   Z,R21
_0x2020013:
	MOVW R26,R18
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	MOVW R26,R18
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	CALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x2A
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x2A
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x2B
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2C
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x2B
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x2B
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x2A
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x2A
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x2C
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x2A
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2C
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR6
	MOVW R30,R28
	CALL __ADDW1R15
	__GETWRZ 20,21,14
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x2020072:
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	MOVW R16,R26
	__PUTWSR 20,21,8
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0001:
	CALL __LOADLOCR6
	ADIW R28,12
	POP  R15
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_previous_time:
	.BYTE 0x4
_current_time:
	.BYTE 0x4
_eslapsed_time:
	.BYTE 0x4
_AccX:
	.BYTE 0x4
_AccY:
	.BYTE 0x4
_AccZ:
	.BYTE 0x4
_Gyro_x:
	.BYTE 0x4
_Gyro_y:
	.BYTE 0x4
_Gyro_z:
	.BYTE 0x4
_Temp:
	.BYTE 0x4
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(208)
	JMP  _I2C_Start_Wait

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	CALL _I2C_Write
	CALL _I2C_Stop
	LDI  R26,LOW(100)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	CALL _I2C_Read_Ack
	MOV  R31,R30
	LDI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x3:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTDP1
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	CALL __PUTPARD2
	SBIW R28,4
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6:
	CALL __PUTPARD1
	__GETD2N 0x40000000
	JMP  _pow

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__GETD1S 4
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xA:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	CALL _atan
	__GETD2N 0x43340000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40490FDB
	CALL __DIVF21
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDS  R30,_current_time
	LDS  R31,_current_time+1
	LDS  R22,_current_time+2
	LDS  R23,_current_time+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x13:
	LDS  R30,_AccX
	LDS  R31,_AccX+1
	LDS  R22,_AccX+2
	LDS  R23,_AccX+3
	CALL __PUTPARD1
	LDS  R30,_AccY
	LDS  R31,_AccY+1
	LDS  R22,_AccY+2
	LDS  R23,_AccY+3
	CALL __PUTPARD1
	LDS  R26,_AccZ
	LDS  R27,_AccZ+1
	LDS  R24,_AccZ+2
	LDS  R25,_AccZ+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	__GETD2N 0x3E99999A
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	__GETD2N 0x3F333333
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,22
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	CALL __CFD1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	SBI  0x18,1
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	__DELAY_USW 400
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OUT  0x18,R30
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1B:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	RCALL SUBOPT_0x1B
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1D:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1E:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0x1E
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	RCALL SUBOPT_0x1E
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	CALL _log
	RCALL SUBOPT_0x11
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2A:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ADDW1R15:
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

_frexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	MOVW R22,R30
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	MOVW R20,R18
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

_sqrt:
	rcall __PUTPARD2
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
