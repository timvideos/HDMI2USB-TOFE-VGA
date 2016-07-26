EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:TOFE
LIBS:EEPROM
LIBS:TOFE-VGA-cache
LIBS:analog-devices2
LIBS:vmodvga
LIBS:testpoint
LIBS:ad9984-power
LIBS:3-rca
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 6 6
Title "TOFE VGA - Component"
Date "2016-01-15"
Rev "1.0"
Comp "Kenny Duffus <kenny@duffus.org>"
Comment1 "License: CC BY"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 5450 3000 2    60   Input ~ 0
COMP_Y
Text HLabel 5450 3350 2    60   Input ~ 0
COMP_Pb
Text HLabel 5450 3700 2    60   Input ~ 0
COMP_Pr
$Comp
L GNDA #PWR051
U 1 1 5655AC8B
P 5000 4000
F 0 "#PWR051" H 5000 3750 50  0001 C CNN
F 1 "GNDA" H 5000 3850 50  0000 C CNN
F 2 "" H 5000 4000 60  0000 C CNN
F 3 "" H 5000 4000 60  0000 C CNN
	1    5000 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5200 3200 5000 3200
Wire Wire Line
	5350 3000 5450 3000
Wire Wire Line
	5350 3350 5450 3350
Wire Wire Line
	5350 3700 5450 3700
$Comp
L 3-RCA P601
U 1 1 5698F0C6
P 5200 3350
F 0 "P601" H 5200 3900 50  0000 C CNN
F 1 "3-RCA" V 5400 3300 50  0001 C CNN
F 2 "3-RCA:MR-100H" H 5200 3000 50  0001 C CNN
F 3 "" H 5200 3000 50  0000 C CNN
	1    5200 3350
	-1   0    0    -1  
$EndComp
Wire Wire Line
	5200 3900 5000 3900
Wire Wire Line
	5000 3200 5000 4000
Wire Wire Line
	5200 3550 5000 3550
Connection ~ 5000 3900
Connection ~ 5000 3550
$EndSCHEMATC
