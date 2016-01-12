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
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 6 6
Title "TOFE VGA - Component"
Date "2015-11-25"
Rev "1.0"
Comp "Kenny Duffus <kenny@duffus.org>"
Comment1 "License: CC BY"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L BNC P601
U 1 1 5655ABB5
P 5200 3000
F 0 "P601" H 5210 3120 50  0000 C CNN
F 1 "Y" V 5310 2940 50  0000 C CNN
F 2 "" H 5200 3000 60  0001 C CNN
F 3 "" H 5200 3000 60  0000 C CNN
	1    5200 3000
	-1   0    0    -1  
$EndComp
$Comp
L BNC P602
U 1 1 5655ABED
P 5200 3450
F 0 "P602" H 5210 3570 50  0000 C CNN
F 1 "Pb" V 5310 3390 50  0000 C CNN
F 2 "" H 5200 3450 60  0001 C CNN
F 3 "" H 5200 3450 60  0000 C CNN
	1    5200 3450
	-1   0    0    -1  
$EndComp
$Comp
L BNC P603
U 1 1 5655AC38
P 5200 3900
F 0 "P603" H 5210 4020 50  0000 C CNN
F 1 "Pr" V 5310 3840 50  0000 C CNN
F 2 "" H 5200 3900 60  0001 C CNN
F 3 "" H 5200 3900 60  0000 C CNN
	1    5200 3900
	-1   0    0    -1  
$EndComp
Text HLabel 5450 3000 2    60   Input ~ 0
COMP_Y
Text HLabel 5450 3450 2    60   Input ~ 0
COMP_Pb
Text HLabel 5450 3900 2    60   Input ~ 0
COMP_Pr
$Comp
L GND #PWR051
U 1 1 5655AC8B
P 5000 4200
F 0 "#PWR051" H 5000 3950 50  0001 C CNN
F 1 "GND" H 5000 4050 50  0000 C CNN
F 2 "" H 5000 4200 60  0000 C CNN
F 3 "" H 5000 4200 60  0000 C CNN
	1    5000 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 4100 5200 4100
Wire Wire Line
	5000 3200 5000 4200
Wire Wire Line
	5200 3650 5000 3650
Connection ~ 5000 4100
Wire Wire Line
	5200 3200 5000 3200
Connection ~ 5000 3650
Wire Wire Line
	5350 3000 5450 3000
Wire Wire Line
	5350 3450 5450 3450
Wire Wire Line
	5350 3900 5450 3900
$EndSCHEMATC
