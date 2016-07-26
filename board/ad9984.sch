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
Sheet 4 5
Title "TOFE VGA Expansion Board - AD9984"
Date "2015-11-25"
Rev "1.0"
Comp "Kenny Duffus <kenny@duffus.org>"
Comment1 "License: CC BY"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L AD9984 U401
U 1 1 53727604
P 7150 3800
F 0 "U401" H 7250 3700 60  0000 C CNN
F 1 "AD9984" H 7250 3850 60  0000 C CNN
F 2 "analog-devices2:analog-devices2-LQFP80" H 6350 4050 60  0001 C CNN
F 3 "~" H 6350 4050 60  0000 C CNN
	1    7150 3800
	1    0    0    -1  
$EndComp
$Comp
L C-RESCUE-vgaExp C410
U 1 1 53749308
P 6250 1450
F 0 "C410" V 6100 1400 40  0000 L CNN
F 1 "82n" V 6300 1250 40  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 6288 1300 30  0001 C CNN
F 3 "~" H 6250 1450 60  0000 C CNN
	1    6250 1450
	1    0    0    -1  
$EndComp
$Comp
L C-RESCUE-vgaExp C411
U 1 1 5374931F
P 6450 1450
F 0 "C411" V 6600 1400 40  0000 L CNN
F 1 "8.2n" V 6500 1250 40  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 6488 1300 30  0001 C CNN
F 3 "~" H 6450 1450 60  0000 C CNN
	1    6450 1450
	1    0    0    -1  
$EndComp
NoConn ~ 5400 4650
Text Label 6850 5250 3    60   ~ 0
R9
Text Label 6950 5250 3    60   ~ 0
R8
Text Label 7050 5250 3    60   ~ 0
R7
Text Label 7150 5250 3    60   ~ 0
R6
Text Label 7250 5250 3    60   ~ 0
R5
Text Label 7350 5250 3    60   ~ 0
R4
Text Label 7450 5250 3    60   ~ 0
R3
Text Label 7550 5250 3    60   ~ 0
R2
Text Label 7650 5250 3    60   ~ 0
R1
Text Label 7750 5250 3    60   ~ 0
R0
Text Label 8950 2550 0    60   ~ 0
B0
Text Label 8950 2650 0    60   ~ 0
B1
Text Label 8950 2750 0    60   ~ 0
B2
Text Label 8950 2850 0    60   ~ 0
B3
Text Label 8950 2950 0    60   ~ 0
B4
Text Label 8950 3050 0    60   ~ 0
B5
Text Label 8950 3150 0    60   ~ 0
B6
Text Label 8950 3250 0    60   ~ 0
B7
Text Label 8950 3350 0    60   ~ 0
B8
Text Label 8950 3450 0    60   ~ 0
B9
Text Label 8950 3750 0    60   ~ 0
G0
Text Label 8950 3850 0    60   ~ 0
G1
Text Label 8950 3950 0    60   ~ 0
G2
Text Label 8950 4050 0    60   ~ 0
G3
Text Label 8950 4150 0    60   ~ 0
G4
Text Label 8950 4250 0    60   ~ 0
G5
Text Label 8950 4350 0    60   ~ 0
G6
Text Label 8950 4450 0    60   ~ 0
G7
Text Label 8950 4550 0    60   ~ 0
G8
Text Label 8950 4650 0    60   ~ 0
G9
Entry Wire Line
	9100 2550 9200 2650
Entry Wire Line
	9100 2650 9200 2750
Entry Wire Line
	9100 2750 9200 2850
Entry Wire Line
	9100 2850 9200 2950
Entry Wire Line
	9100 2950 9200 3050
Entry Wire Line
	9100 3050 9200 3150
Entry Wire Line
	9100 3150 9200 3250
Entry Wire Line
	9100 3250 9200 3350
Entry Wire Line
	9100 3350 9200 3450
Entry Wire Line
	9100 3450 9200 3550
Text HLabel 9350 2550 2    60   Output ~ 0
B[0..9]
Entry Wire Line
	9100 3750 9200 3850
Entry Wire Line
	9100 3850 9200 3950
Entry Wire Line
	9100 3950 9200 4050
Entry Wire Line
	9100 4050 9200 4150
Entry Wire Line
	9100 4150 9200 4250
Entry Wire Line
	9100 4250 9200 4350
Entry Wire Line
	9100 4350 9200 4450
Entry Wire Line
	9100 4450 9200 4550
Entry Wire Line
	9100 4550 9200 4650
Entry Wire Line
	9100 4650 9200 4750
Text HLabel 9350 4850 2    60   Output ~ 0
G[0..9]
Entry Wire Line
	6850 5500 6950 5600
Entry Wire Line
	6950 5500 7050 5600
Entry Wire Line
	7050 5500 7150 5600
Entry Wire Line
	7150 5500 7250 5600
Entry Wire Line
	7250 5500 7350 5600
Entry Wire Line
	7350 5500 7450 5600
Entry Wire Line
	7450 5500 7550 5600
Entry Wire Line
	7550 5500 7650 5600
Entry Wire Line
	7650 5500 7750 5600
Entry Wire Line
	7750 5500 7850 5600
Text HLabel 7950 5700 2    60   Output ~ 0
R[0..9]
$Comp
L GNDA #PWR021
U 1 1 5640DDDC
P 4200 5050
F 0 "#PWR021" H 4200 4800 50  0001 C CNN
F 1 "GNDA" H 4200 4900 50  0000 C CNN
F 2 "" H 4200 5050 60  0000 C CNN
F 3 "" H 4200 5050 60  0000 C CNN
	1    4200 5050
	1    0    0    -1  
$EndComp
Wire Wire Line
	8050 2450 8650 2450
Wire Wire Line
	8650 2450 8650 2750
Wire Wire Line
	8650 2750 9100 2750
Wire Wire Line
	7950 2450 7950 2400
Wire Wire Line
	7950 2400 8700 2400
Wire Wire Line
	8700 2400 8700 2650
Wire Wire Line
	8700 2650 9100 2650
Wire Wire Line
	7850 2450 7850 2350
Wire Wire Line
	7850 2350 8750 2350
Wire Wire Line
	8750 2350 8750 2550
Wire Wire Line
	8750 2550 9100 2550
Wire Wire Line
	7450 1650 7450 2450
Wire Wire Line
	7550 1650 7550 2450
Wire Wire Line
	6150 2350 6150 2450
Wire Wire Line
	6450 2350 6450 2450
Wire Wire Line
	6650 2350 6650 2450
Wire Wire Line
	6250 2250 6250 2450
Wire Wire Line
	6550 2250 6550 2450
Wire Wire Line
	6750 2250 6750 2450
Wire Wire Line
	7650 2350 7650 2450
Wire Wire Line
	7750 2300 7750 2450
Wire Wire Line
	8850 3650 9100 3650
Wire Wire Line
	7750 5150 7750 5500
Wire Wire Line
	7650 5150 7650 5500
Wire Wire Line
	7550 5150 7550 5500
Wire Wire Line
	7450 5150 7450 5500
Wire Wire Line
	7350 5150 7350 5500
Wire Wire Line
	7250 5150 7250 5500
Wire Wire Line
	7150 5150 7150 5500
Wire Wire Line
	7050 5150 7050 5500
Wire Wire Line
	6950 5150 6950 5500
Wire Wire Line
	6850 5150 6850 5500
Wire Wire Line
	6550 5150 6550 5250
Wire Wire Line
	6450 5150 6450 5250
Wire Wire Line
	6350 5150 6350 5250
Wire Wire Line
	6250 5150 6250 5900
Wire Wire Line
	6750 5150 6750 5350
Wire Wire Line
	7850 5150 7850 5250
Wire Wire Line
	7950 5150 8050 5150
Wire Wire Line
	8000 5150 8000 5250
Connection ~ 8000 5150
Wire Wire Line
	5900 5750 6250 5750
Connection ~ 5900 5750
Wire Wire Line
	5050 2950 5400 2950
Wire Wire Line
	5150 2850 5400 2850
Wire Wire Line
	5300 3050 5400 3050
Wire Wire Line
	5050 3350 5400 3350
Wire Wire Line
	5050 3550 5400 3550
Wire Wire Line
	5050 4150 5400 4150
Wire Wire Line
	5150 3250 5400 3250
Wire Wire Line
	5300 3450 5400 3450
Wire Wire Line
	5150 3650 5400 3650
Wire Wire Line
	5300 3850 5400 3850
Wire Wire Line
	5150 4050 5400 4050
Wire Wire Line
	5300 4250 5400 4250
Wire Wire Line
	4400 4450 5400 4450
Wire Wire Line
	5050 4750 5400 4750
Wire Wire Line
	4500 4450 4500 4550
Connection ~ 4500 4450
Wire Wire Line
	2850 3350 4750 3350
Wire Wire Line
	8850 2850 9100 2850
Wire Wire Line
	8850 2950 9100 2950
Wire Wire Line
	8850 3050 9100 3050
Wire Wire Line
	8850 3150 9100 3150
Wire Wire Line
	8850 3250 9100 3250
Wire Wire Line
	8850 3350 9100 3350
Wire Wire Line
	8850 3450 9100 3450
Wire Wire Line
	8850 3750 9100 3750
Wire Wire Line
	8850 3850 9100 3850
Wire Wire Line
	8850 3950 9100 3950
Wire Wire Line
	8850 4050 9100 4050
Wire Wire Line
	8850 4150 9100 4150
Wire Wire Line
	8850 4250 9100 4250
Wire Wire Line
	8850 4350 9100 4350
Wire Wire Line
	8850 4450 9100 4450
Wire Wire Line
	8850 4550 9100 4550
Wire Wire Line
	8850 4650 9100 4650
Wire Wire Line
	6650 5150 6650 5350
Wire Wire Line
	8950 4750 8850 4750
Wire Wire Line
	8850 3550 9000 3550
Connection ~ 6250 5750
Wire Wire Line
	7250 2200 7250 2450
Wire Wire Line
	7350 2200 7350 2450
Wire Wire Line
	2850 4150 4750 4150
Wire Wire Line
	2850 2950 4750 2950
Wire Bus Line
	9200 2550 9200 3550
Wire Bus Line
	9200 2550 9350 2550
Wire Bus Line
	9200 3850 9200 4850
Wire Bus Line
	9200 4850 9350 4850
Wire Bus Line
	6950 5600 7950 5600
Wire Bus Line
	7950 5600 7950 5700
Wire Wire Line
	5300 4950 2950 4950
Wire Wire Line
	3350 4950 3350 4850
Text HLabel 2150 2950 0    60   Input ~ 0
VGA_B
Text HLabel 2150 3350 0    60   Input ~ 0
VGA_G
Text HLabel 2150 4150 0    60   Input ~ 0
VGA_R
$Comp
L +3.3V #PWR022
U 1 1 56413478
P 7850 5250
F 0 "#PWR022" H 7850 5100 50  0001 C CNN
F 1 "+3.3V" V 7860 5470 50  0000 C CNN
F 2 "" H 7850 5250 60  0000 C CNN
F 3 "" H 7850 5250 60  0000 C CNN
	1    7850 5250
	-1   0    0    1   
$EndComp
$Comp
L +3.3V #PWR023
U 1 1 56413584
P 5900 5250
F 0 "#PWR023" H 5900 5100 50  0001 C CNN
F 1 "+3.3V" H 5900 5400 50  0000 C CNN
F 2 "" H 5900 5250 60  0000 C CNN
F 3 "" H 5900 5250 60  0000 C CNN
	1    5900 5250
	1    0    0    -1  
$EndComp
$Comp
L VD #PWR024
U 1 1 564135D1
P 5150 2850
F 0 "#PWR024" H 5150 2700 50  0001 C CNN
F 1 "VD" H 5150 2990 50  0000 C CNN
F 2 "" H 5150 2850 60  0000 C CNN
F 3 "" H 5150 2850 60  0000 C CNN
	1    5150 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5150 2850 5150 4050
Connection ~ 5150 3250
Connection ~ 5150 3650
Connection ~ 5300 4250
Connection ~ 5300 3850
Connection ~ 5300 3450
Wire Wire Line
	4200 5050 4200 4950
Connection ~ 4200 4950
$Comp
L R R408
U 1 1 56414305
P 5900 5500
F 0 "R408" V 5980 5500 50  0000 C CNN
F 1 "10K" V 5900 5500 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 5830 5500 30  0001 C CNN
F 3 "" H 5900 5500 30  0000 C CNN
	1    5900 5500
	1    0    0    -1  
$EndComp
$Comp
L R R409
U 1 1 564143A0
P 5900 6000
F 0 "R409" V 5980 6000 50  0000 C CNN
F 1 "10K" V 5900 6000 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 5830 6000 30  0001 C CNN
F 3 "" H 5900 6000 30  0000 C CNN
	1    5900 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 6150 5900 6250
$Comp
L GND #PWR025
U 1 1 5641452A
P 5900 6250
F 0 "#PWR025" H 5900 6000 50  0001 C CNN
F 1 "GND" H 5900 6100 50  0000 C CNN
F 2 "" H 5900 6250 60  0000 C CNN
F 3 "" H 5900 6250 60  0000 C CNN
	1    5900 6250
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 5650 5900 5850
Wire Wire Line
	5900 5350 5900 5250
$Comp
L R R407
U 1 1 564148C0
P 4500 4700
F 0 "R407" V 4580 4700 50  0000 C CNN
F 1 "1K" V 4500 4700 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 4430 4700 30  0001 C CNN
F 3 "" H 4500 4700 30  0000 C CNN
	1    4500 4700
	1    0    0    -1  
$EndComp
$Comp
L R R403
U 1 1 56414988
P 3350 4700
F 0 "R403" V 3430 4700 50  0000 C CNN
F 1 "75R" V 3350 4700 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 3280 4700 30  0001 C CNN
F 3 "" H 3350 4700 30  0000 C CNN
	1    3350 4700
	1    0    0    -1  
$EndComp
$Comp
L R R404
U 1 1 564149C3
P 3550 4700
F 0 "R404" V 3630 4700 50  0000 C CNN
F 1 "75R" V 3550 4700 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 3480 4700 30  0001 C CNN
F 3 "" H 3550 4700 30  0000 C CNN
	1    3550 4700
	1    0    0    -1  
$EndComp
$Comp
L R R405
U 1 1 564149FC
P 3750 4700
F 0 "R405" V 3830 4700 50  0000 C CNN
F 1 "75R" V 3750 4700 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 3680 4700 30  0001 C CNN
F 3 "" H 3750 4700 30  0000 C CNN
	1    3750 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	5300 3050 5300 4950
Wire Wire Line
	3550 4850 3550 4950
Connection ~ 3550 4950
Wire Wire Line
	3750 4850 3750 4950
Connection ~ 3750 4950
$Comp
L GND #PWR026
U 1 1 56415296
P 6750 5350
F 0 "#PWR026" H 6750 5100 50  0001 C CNN
F 1 "GND" V 6750 5150 50  0000 C CNN
F 2 "" H 6750 5350 60  0000 C CNN
F 3 "" H 6750 5350 60  0000 C CNN
	1    6750 5350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR027
U 1 1 5641579B
P 8000 5250
F 0 "#PWR027" H 8000 5000 50  0001 C CNN
F 1 "GND" H 8000 5100 50  0000 C CNN
F 2 "" H 8000 5250 60  0000 C CNN
F 3 "" H 8000 5250 60  0000 C CNN
	1    8000 5250
	1    0    0    -1  
$EndComp
Text HLabel 6350 5250 3    60   Output ~ 0
HSOUT
Text HLabel 6450 5250 3    60   Output ~ 0
SOGOUT
Text HLabel 6550 5250 3    60   BiDi ~ 0
DATACK
$Comp
L PVD #PWR028
U 1 1 56415C22
P 6550 2250
F 0 "#PWR028" H 6550 2100 50  0001 C CNN
F 1 "PVD" H 6550 2390 50  0000 C CNN
F 2 "" H 6550 2250 60  0000 C CNN
F 3 "" H 6550 2250 60  0000 C CNN
	1    6550 2250
	1    0    0    -1  
$EndComp
Wire Wire Line
	6250 2250 6750 2250
Connection ~ 6550 2250
Wire Wire Line
	6000 2350 7650 2350
Connection ~ 6450 2350
Connection ~ 6650 2350
Wire Wire Line
	7050 2450 7050 2250
Wire Wire Line
	7150 2450 7150 2250
$Comp
L GND #PWR029
U 1 1 564164E1
P 6000 2350
F 0 "#PWR029" H 6000 2100 50  0001 C CNN
F 1 "GND" V 5900 2300 50  0000 C CNN
F 2 "" H 6000 2350 60  0000 C CNN
F 3 "" H 6000 2350 60  0000 C CNN
	1    6000 2350
	0    1    1    0   
$EndComp
Connection ~ 6150 2350
$Comp
L VD #PWR030
U 1 1 56416F9D
P 8950 4750
F 0 "#PWR030" H 8950 4600 50  0001 C CNN
F 1 "VD" V 9000 4750 50  0000 C CNN
F 2 "" H 8950 4750 60  0000 C CNN
F 3 "" H 8950 4750 60  0000 C CNN
	1    8950 4750
	0    1    1    0   
$EndComp
$Comp
L GND #PWR031
U 1 1 564170A0
P 9000 3550
F 0 "#PWR031" H 9000 3300 50  0001 C CNN
F 1 "GND" V 9050 3600 50  0000 C CNN
F 2 "" H 9000 3550 60  0000 C CNN
F 3 "" H 9000 3550 60  0000 C CNN
	1    9000 3550
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR032
U 1 1 564172D9
P 6900 1200
F 0 "#PWR032" H 6900 950 50  0001 C CNN
F 1 "GND" H 6900 1050 50  0000 C CNN
F 2 "" H 6900 1200 60  0000 C CNN
F 3 "" H 6900 1200 60  0000 C CNN
	1    6900 1200
	-1   0    0    1   
$EndComp
$Comp
L PVD #PWR033
U 1 1 56417326
P 6350 1200
F 0 "#PWR033" H 6350 1050 50  0001 C CNN
F 1 "PVD" H 6350 1340 50  0000 C CNN
F 2 "" H 6350 1200 60  0000 C CNN
F 3 "" H 6350 1200 60  0000 C CNN
	1    6350 1200
	1    0    0    -1  
$EndComp
Text HLabel 7050 2250 1    60   Input ~ 0
VSYNC0
Text HLabel 7150 2250 1    60   Input ~ 0
HSYNC0
$Comp
L R R415
U 1 1 56417669
P 7450 1500
F 0 "R415" V 7350 1500 50  0000 C CNN
F 1 "2k2" V 7450 1500 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 7380 1500 30  0001 C CNN
F 3 "" H 7450 1500 30  0000 C CNN
	1    7450 1500
	1    0    0    -1  
$EndComp
$Comp
L R R416
U 1 1 56417702
P 7550 1500
F 0 "R416" V 7650 1500 50  0000 C CNN
F 1 "2K2" V 7550 1500 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 7480 1500 30  0001 C CNN
F 3 "" H 7550 1500 30  0000 C CNN
	1    7550 1500
	1    0    0    -1  
$EndComp
Text HLabel 8250 2050 2    47   BiDi ~ 0
SDA_AD9984
Text HLabel 8250 1950 2    47   BiDi ~ 0
SCL_AD9984
Wire Wire Line
	7450 1950 8250 1950
Wire Wire Line
	7550 2050 8250 2050
Connection ~ 7550 2050
Connection ~ 7450 1950
Wire Wire Line
	7450 1350 7450 1250
Wire Wire Line
	7450 1250 7550 1250
Wire Wire Line
	7500 1250 7500 1200
Wire Wire Line
	7550 1250 7550 1350
Connection ~ 7500 1250
$Comp
L R R411
U 1 1 56417E0B
P 6850 1500
F 0 "R411" V 6930 1500 50  0000 C CNN
F 1 "1K" V 6850 1500 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 6780 1500 30  0001 C CNN
F 3 "" H 6850 1500 30  0000 C CNN
	1    6850 1500
	-1   0    0    1   
$EndComp
$Comp
L R R412
U 1 1 56417ED1
P 6950 1500
F 0 "R412" V 6850 1500 50  0000 C CNN
F 1 "1K" V 6950 1500 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 6880 1500 30  0001 C CNN
F 3 "" H 6950 1500 30  0000 C CNN
	1    6950 1500
	-1   0    0    1   
$EndComp
Wire Wire Line
	6850 1350 6850 1250
Wire Wire Line
	6850 1250 6950 1250
Wire Wire Line
	6900 1250 6900 1200
Wire Wire Line
	6950 1250 6950 1350
Connection ~ 6900 1250
Wire Wire Line
	6850 1650 6850 2450
Wire Wire Line
	6950 1650 6950 2450
$Comp
L R R410
U 1 1 56418825
P 6250 2050
F 0 "R410" V 6330 2050 50  0000 C CNN
F 1 "1K5" V 6250 2050 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 6180 2050 30  0001 C CNN
F 3 "" H 6250 2050 30  0000 C CNN
	1    6250 2050
	-1   0    0    1   
$EndComp
Wire Wire Line
	6350 2450 6350 2200
Wire Wire Line
	6250 2200 6450 2200
Wire Wire Line
	6450 2200 6450 1650
Connection ~ 6350 2200
Wire Wire Line
	6250 1650 6250 1900
Wire Wire Line
	6250 1250 6450 1250
Wire Wire Line
	6350 1250 6350 1200
Connection ~ 6350 1250
$Comp
L INDUCTOR L401
U 1 1 5641722B
P 2550 2950
F 0 "L401" V 2500 2950 50  0000 C CNN
F 1 "FERRITE" V 2650 2950 50  0001 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 2550 2950 60  0001 C CNN
F 3 "" H 2550 2950 60  0000 C CNN
	1    2550 2950
	0    -1   -1   0   
$EndComp
$Comp
L INDUCTOR L405
U 1 1 564173C0
P 2550 4150
F 0 "L405" V 2500 4150 50  0000 C CNN
F 1 "FERRITE" V 2650 4150 50  0001 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 2550 4150 60  0001 C CNN
F 3 "" H 2550 4150 60  0000 C CNN
	1    2550 4150
	0    -1   -1   0   
$EndComp
$Comp
L INDUCTOR L403
U 1 1 56417497
P 2550 3350
F 0 "L403" V 2500 3350 50  0000 C CNN
F 1 "FERRITE" V 2650 3350 50  0001 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 2550 3350 60  0001 C CNN
F 3 "" H 2550 3350 60  0000 C CNN
	1    2550 3350
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2150 2950 2250 2950
Wire Wire Line
	2250 3350 2150 3350
Wire Wire Line
	2150 4150 2250 4150
Text HLabel 6250 5900 3    60   Output ~ 0
VSOUT
$Comp
L TESTPOINT TP402
U 1 1 5642EB11
P 6150 5350
F 0 "TP402" V 6200 5300 60  0000 C CNN
F 1 "TESTPOINT" H 6150 5300 60  0001 C CNN
F 2 "2MM-TESTPOINT:2MM-TESTPOINT" H 6150 5350 60  0001 C CNN
F 3 "" H 6150 5350 60  0000 C CNN
	1    6150 5350
	-1   0    0    1   
$EndComp
$Comp
L TESTPOINT TP401
U 1 1 564635D7
P 4400 4450
F 0 "TP401" V 4300 4600 60  0000 C CNN
F 1 "TESTPOINT" H 4400 4400 60  0001 C CNN
F 2 "2MM-TESTPOINT:2MM-TESTPOINT" H 4400 4450 60  0001 C CNN
F 3 "" H 4400 4450 60  0000 C CNN
	1    4400 4450
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6150 5350 6150 5150
$Comp
L TESTPOINT TP404
U 1 1 56463E75
P 6950 1750
F 0 "TP404" V 6850 1900 60  0000 C CNN
F 1 "TESTPOINT" H 6950 1700 60  0001 C CNN
F 2 "2MM-TESTPOINT:2MM-TESTPOINT" H 6950 1750 60  0001 C CNN
F 3 "" H 6950 1750 60  0000 C CNN
	1    6950 1750
	0    1    1    0   
$EndComp
$Comp
L TESTPOINT TP403
U 1 1 56463EBE
P 6850 1750
F 0 "TP403" V 6950 1900 60  0000 C CNN
F 1 "TESTPOINT" H 6850 1700 60  0001 C CNN
F 2 "2MM-TESTPOINT:2MM-TESTPOINT" H 6850 1750 60  0001 C CNN
F 3 "" H 6850 1750 60  0000 C CNN
	1    6850 1750
	0    -1   -1   0   
$EndComp
Connection ~ 6850 1750
Connection ~ 6950 1750
$Comp
L R R413
U 1 1 5655A164
P 7250 2050
F 0 "R413" V 7300 1850 50  0000 C CNN
F 1 "1K" V 7250 2050 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 7180 2050 30  0001 C CNN
F 3 "" H 7250 2050 30  0000 C CNN
	1    7250 2050
	1    0    0    -1  
$EndComp
$Comp
L R R414
U 1 1 5655A1B5
P 7350 2050
F 0 "R414" V 7400 1850 50  0000 C CNN
F 1 "1K" V 7350 2050 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 7280 2050 30  0001 C CNN
F 3 "" H 7350 2050 30  0000 C CNN
	1    7350 2050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR034
U 1 1 5655A202
P 7300 1800
F 0 "#PWR034" H 7300 1550 50  0001 C CNN
F 1 "GND" H 7250 1650 50  0000 C CNN
F 2 "" H 7300 1800 60  0000 C CNN
F 3 "" H 7300 1800 60  0000 C CNN
	1    7300 1800
	-1   0    0    1   
$EndComp
Wire Wire Line
	7250 1900 7250 1850
Wire Wire Line
	7250 1850 7350 1850
Wire Wire Line
	7300 1850 7300 1800
Wire Wire Line
	7350 1850 7350 1900
Connection ~ 7300 1850
$Comp
L C C409
U 1 1 5655BB93
P 4900 4750
F 0 "C409" V 4950 4800 50  0000 L CNN
F 1 "10n" V 4950 4550 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4938 4600 30  0001 C CNN
F 3 "" H 4900 4750 60  0000 C CNN
	1    4900 4750
	0    1    1    0   
$EndComp
$Comp
L C C407
U 1 1 5655BBE6
P 4900 4150
F 0 "C407" V 4950 4200 50  0000 L CNN
F 1 "47n" V 4950 3950 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4938 4000 30  0001 C CNN
F 3 "" H 4900 4150 60  0000 C CNN
	1    4900 4150
	0    1    1    0   
$EndComp
$Comp
L C C404
U 1 1 5655BCA4
P 4900 3550
F 0 "C404" V 4950 3600 50  0000 L CNN
F 1 "47n" V 4950 3350 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4938 3400 30  0001 C CNN
F 3 "" H 4900 3550 60  0000 C CNN
	1    4900 3550
	0    1    1    0   
$EndComp
$Comp
L C C403
U 1 1 5655BCF5
P 4900 3350
F 0 "C403" V 4950 3400 50  0000 L CNN
F 1 "47n" V 4950 3150 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4938 3200 30  0001 C CNN
F 3 "" H 4900 3350 60  0000 C CNN
	1    4900 3350
	0    1    1    0   
$EndComp
$Comp
L C C401
U 1 1 5655BD46
P 4900 2950
F 0 "C401" V 4950 3000 50  0000 L CNN
F 1 "47n" V 4950 2750 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4938 2800 30  0001 C CNN
F 3 "" H 4900 2950 60  0000 C CNN
	1    4900 2950
	0    1    1    0   
$EndComp
Text HLabel 2150 3750 0    60   Input ~ 0
COMP_Y
Text HLabel 2150 3150 0    60   Input ~ 0
COMP_Pb
Text HLabel 2150 4350 0    60   Input ~ 0
COMP_Pr
$Comp
L C C408
U 1 1 5655BF56
P 4900 4350
F 0 "C408" V 4950 4400 50  0000 L CNN
F 1 "47n" V 4950 4150 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4938 4200 30  0001 C CNN
F 3 "" H 4900 4350 60  0000 C CNN
	1    4900 4350
	0    1    1    0   
$EndComp
$Comp
L C C406
U 1 1 5655BFCD
P 4900 3950
F 0 "C406" V 4950 4000 50  0000 L CNN
F 1 "47n" V 4950 3750 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4938 3800 30  0001 C CNN
F 3 "" H 4900 3950 60  0000 C CNN
	1    4900 3950
	0    1    1    0   
$EndComp
$Comp
L C C405
U 1 1 5655C024
P 4900 3750
F 0 "C405" V 4950 3800 50  0000 L CNN
F 1 "47n" V 4950 3550 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4938 3600 30  0001 C CNN
F 3 "" H 4900 3750 60  0000 C CNN
	1    4900 3750
	0    1    1    0   
$EndComp
$Comp
L C C402
U 1 1 5655C079
P 4900 3150
F 0 "C402" V 4950 3200 50  0000 L CNN
F 1 "47n" V 4950 2950 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4938 3000 30  0001 C CNN
F 3 "" H 4900 3150 60  0000 C CNN
	1    4900 3150
	0    1    1    0   
$EndComp
Wire Wire Line
	5050 3150 5400 3150
Wire Wire Line
	5050 3750 5400 3750
Wire Wire Line
	5400 3950 5050 3950
Wire Wire Line
	5400 4350 5050 4350
Wire Wire Line
	4650 4550 5400 4550
$Comp
L R R406
U 1 1 5655C4FE
P 3950 4700
F 0 "R406" V 4030 4700 50  0000 C CNN
F 1 "75R" V 3950 4700 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 3880 4700 30  0001 C CNN
F 3 "" H 3950 4700 30  0000 C CNN
	1    3950 4700
	1    0    0    -1  
$EndComp
$Comp
L R R402
U 1 1 5655C559
P 3150 4700
F 0 "R402" V 3230 4700 50  0000 C CNN
F 1 "75R" V 3150 4700 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 3080 4700 30  0001 C CNN
F 3 "" H 3150 4700 30  0000 C CNN
	1    3150 4700
	1    0    0    -1  
$EndComp
$Comp
L R R401
U 1 1 5655C5B8
P 2950 4700
F 0 "R401" V 3030 4700 50  0000 C CNN
F 1 "75R" V 2950 4700 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 2880 4700 30  0001 C CNN
F 3 "" H 2950 4700 30  0000 C CNN
	1    2950 4700
	1    0    0    -1  
$EndComp
$Comp
L INDUCTOR L406
U 1 1 5655C732
P 2550 4350
F 0 "L406" V 2500 4350 50  0000 C CNN
F 1 "FERRITE" V 2650 4350 50  0001 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 2550 4350 60  0001 C CNN
F 3 "" H 2550 4350 60  0000 C CNN
	1    2550 4350
	0    -1   -1   0   
$EndComp
$Comp
L INDUCTOR L404
U 1 1 5655C8FF
P 2550 3750
F 0 "L404" V 2500 3750 50  0000 C CNN
F 1 "FERRITE" V 2650 3750 50  0001 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 2550 3750 60  0001 C CNN
F 3 "" H 2550 3750 60  0000 C CNN
	1    2550 3750
	0    -1   -1   0   
$EndComp
$Comp
L INDUCTOR L402
U 1 1 5655C9E4
P 2550 3150
F 0 "L402" V 2500 3150 50  0000 C CNN
F 1 "FERRITE" V 2650 3150 50  0001 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 2550 3150 60  0001 C CNN
F 3 "" H 2550 3150 60  0000 C CNN
	1    2550 3150
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2150 3150 2250 3150
Wire Wire Line
	2850 3150 4750 3150
Wire Wire Line
	4750 3550 4650 3550
Wire Wire Line
	4650 3550 4650 3350
Connection ~ 4650 3350
Wire Wire Line
	2150 3750 2250 3750
Wire Wire Line
	2850 3750 4750 3750
Wire Wire Line
	4750 3950 4650 3950
Wire Wire Line
	4650 3950 4650 3750
Connection ~ 4650 3750
Wire Wire Line
	2150 4350 2250 4350
Wire Wire Line
	2850 4350 4750 4350
Wire Wire Line
	3950 4850 3950 4950
Connection ~ 3950 4950
Wire Wire Line
	3150 4950 3150 4850
Connection ~ 3350 4950
Wire Wire Line
	2950 4950 2950 4850
Connection ~ 3150 4950
Wire Wire Line
	3950 4550 3950 4350
Connection ~ 3950 4350
Wire Wire Line
	3750 4550 3750 4150
Connection ~ 3750 4150
Wire Wire Line
	3550 4550 3550 3750
Connection ~ 3550 3750
Wire Wire Line
	3350 4550 3350 3350
Connection ~ 3350 3350
Wire Wire Line
	3150 4550 3150 3150
Connection ~ 3150 3150
Wire Wire Line
	2950 4550 2950 2950
Connection ~ 2950 2950
Wire Wire Line
	4650 4550 4650 4750
Wire Wire Line
	4650 4750 4750 4750
Wire Wire Line
	4500 4850 4500 4950
Connection ~ 4500 4950
$Comp
L CONN_01X04 P401
U 1 1 5692F854
P 8000 1600
F 0 "P401" H 8000 1850 50  0000 C CNN
F 1 "AD9984 I2C" V 8100 1600 50  0000 C CNN
F 2 "CON-SMD-2.54:HARWIN-M20-87-4x1" H 8000 1600 50  0001 C CNN
F 3 "" H 8000 1600 50  0000 C CNN
	1    8000 1600
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR035
U 1 1 5692FBEE
P 8250 1850
F 0 "#PWR035" H 8250 1600 50  0001 C CNN
F 1 "GND" V 8250 1650 50  0000 C CNN
F 2 "" H 8250 1850 50  0000 C CNN
F 3 "" H 8250 1850 50  0000 C CNN
	1    8250 1850
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7850 1800 7850 2300
Wire Wire Line
	7850 2300 7750 2300
Wire Wire Line
	8150 1800 8150 1850
Wire Wire Line
	8150 1850 8250 1850
Wire Wire Line
	7950 1800 7950 1950
Connection ~ 7950 1950
Wire Wire Line
	8050 1800 8050 2050
Connection ~ 8050 2050
$Comp
L GNDA #PWR036
U 1 1 57976F35
P 3680 5980
F 0 "#PWR036" H 3680 5730 50  0001 C CNN
F 1 "GNDA" H 3680 5830 50  0000 C CNN
F 2 "" H 3680 5980 60  0000 C CNN
F 3 "" H 3680 5980 60  0000 C CNN
	1    3680 5980
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR037
U 1 1 57976FB5
P 4000 5980
F 0 "#PWR037" H 4000 5730 50  0001 C CNN
F 1 "GND" H 4000 5830 50  0000 C CNN
F 2 "" H 4000 5980 60  0000 C CNN
F 3 "" H 4000 5980 60  0000 C CNN
	1    4000 5980
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 5797716F
P 3840 5650
F 0 "C1" H 3865 5750 50  0000 L CNN
F 1 "C" H 3865 5550 50  0000 L CNN
F 2 "" H 3878 5500 50  0000 C CNN
F 3 "" H 3840 5650 50  0000 C CNN
	1    3840 5650
	0    1    1    0   
$EndComp
Wire Wire Line
	3680 5980 3680 5650
Wire Wire Line
	3680 5650 3690 5650
Wire Wire Line
	4000 5980 4000 5650
$Comp
L +3.3V #PWR038
U 1 1 5796E857
P 7500 1200
F 0 "#PWR038" H 7500 1050 50  0001 C CNN
F 1 "+3.3V" H 7500 1340 50  0000 C CNN
F 2 "" H 7500 1200 50  0000 C CNN
F 3 "" H 7500 1200 50  0000 C CNN
	1    7500 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	7700 1250 7700 1860
Wire Wire Line
	7700 1860 7850 1860
Connection ~ 7850 1860
Connection ~ 7550 1250
$Comp
L +3.3V #PWR039
U 1 1 5796EFF3
P 6650 5350
F 0 "#PWR039" H 6650 5200 50  0001 C CNN
F 1 "+3.3V" V 6660 5570 50  0000 C CNN
F 2 "" H 6650 5350 60  0000 C CNN
F 3 "" H 6650 5350 60  0000 C CNN
	1    6650 5350
	-1   0    0    1   
$EndComp
$Comp
L +3.3V #PWR040
U 1 1 5796F1FD
P 9100 3650
F 0 "#PWR040" H 9100 3500 50  0001 C CNN
F 1 "+3.3V" V 9110 3870 50  0000 C CNN
F 2 "" H 9100 3650 60  0000 C CNN
F 3 "" H 9100 3650 60  0000 C CNN
	1    9100 3650
	0    1    1    0   
$EndComp
Text Notes 3870 2340 0    60   ~ 0
1V8 - VD - Analog side 1V8 supply\n1V8 - PVD - Digital side 1V8 supply\n3V3 - +3.3V - IO Level
Wire Notes Line
	4620 2500 6020 2500
Wire Notes Line
	6020 2500 6020 4970
Wire Notes Line
	6020 4970 5550 4970
Wire Notes Line
	5550 4970 5550 6310
Wire Notes Line
	5550 6310 1270 6310
Wire Notes Line
	1270 6310 1270 2500
Wire Notes Line
	1270 2500 4610 2500
Text Notes 1360 2710 0    60   ~ 0
Analog VGA Signals\nNoise sensitive!
Wire Wire Line
	4000 5650 3990 5650
$EndSCHEMATC
