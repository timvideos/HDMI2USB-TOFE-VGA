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
LIBS:SP724AH
LIBS:TPD7S019
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 5 5
Title "TOFE VGA Expansion Board - VGA"
Date "$Id$"
Rev ""
Comp "Kenny Duffus <kenny@duffus.org>"
Comment1 "License: CC BY SA 4.0 or TAPR"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 4400 4950 0    60   BiDi ~ 0
VGAOUT_SCL
Text HLabel 4400 5050 0    60   BiDi ~ 0
VGAOUT_SDA
$Comp
L DE-15 PVO0
U 1 1 563F19C1
P 10750 5350
F 0 "PVO0" V 10720 5350 60  0000 C CNN
F 1 "DE-15" V 10830 5350 60  0000 C CNN
F 2 "DE-15:TE-1-1734530-1" H 10750 5350 60  0001 C CNN
F 3 "~" H 10750 5350 60  0000 C CNN
	1    10750 5350
	1    0    0    1   
$EndComp
NoConn ~ 10400 5000
NoConn ~ 10400 5700
Text HLabel 4400 5450 0    60   Input ~ 0
VGAOUT_B
Text HLabel 4400 5550 0    60   Input ~ 0
VGAOUT_G
Text HLabel 4400 5650 0    60   Input ~ 0
VGAOUT_R
$Comp
L GND #PWR044
U 1 1 563F85E4
P 4900 5800
F 0 "#PWR044" H 4900 5550 50  0001 C CNN
F 1 "GND" V 4900 5600 50  0000 C CNN
F 2 "" H 4900 5800 60  0000 C CNN
F 3 "" H 4900 5800 60  0000 C CNN
	1    4900 5800
	-1   0    0    -1  
$EndComp
Text Notes 3830 3935 0    157  ~ 31
VGA Out
Text HLabel 4400 5300 0    60   Input ~ 0
VGAOUT_HSYNC
Text HLabel 4400 5200 0    60   Input ~ 0
VGAOUT_VSYNC
$Comp
L R RVO51
U 1 1 56419F6C
P 8150 4500
F 0 "RVO51" V 8230 4500 50  0000 C CNN
F 1 "4K7" V 8150 4500 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 8080 4500 30  0001 C CNN
F 3 "" H 8150 4500 30  0000 C CNN
	1    8150 4500
	1    0    0    -1  
$EndComp
$Comp
L R RVO50
U 1 1 5641A01D
P 7950 4500
F 0 "RVO50" V 8030 4500 50  0000 C CNN
F 1 "4K7" V 7950 4500 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 7880 4500 30  0001 C CNN
F 3 "" H 7950 4500 30  0000 C CNN
	1    7950 4500
	1    0    0    -1  
$EndComp
$Comp
L R RVO31
U 1 1 5641A1E0
P 5850 4500
F 0 "RVO31" V 5930 4500 50  0000 C CNN
F 1 "2K2" V 5850 4500 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 5780 4500 30  0001 C CNN
F 3 "" H 5850 4500 30  0000 C CNN
	1    5850 4500
	1    0    0    -1  
$EndComp
$Comp
L R RVO30
U 1 1 5641A20F
P 5650 4500
F 0 "RVO30" V 5730 4500 50  0000 C CNN
F 1 "2K2" V 5650 4500 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 5580 4500 30  0001 C CNN
F 3 "" H 5650 4500 30  0000 C CNN
	1    5650 4500
	1    0    0    -1  
$EndComp
$Comp
L +3V3 #PWR045
U 1 1 5641A682
P 5450 4100
F 0 "#PWR045" H 5450 3950 50  0001 C CNN
F 1 "+3V3" H 5450 4240 50  0000 C CNN
F 2 "" H 5450 4100 60  0000 C CNN
F 3 "" H 5450 4100 60  0000 C CNN
	1    5450 4100
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X04 PVO_I2C3
U 1 1 5692BCA4
P 5300 6000
F 0 "PVO_I2C3" V 5495 6000 50  0000 C CNN
F 1 "VGA Out I2C 3v" V 5400 6000 50  0000 C CNN
F 2 "CON-SMD-2.54:HARWIN-M20-87-4x1" H 5300 6000 50  0001 C CNN
F 3 "" H 5300 6000 50  0000 C CNN
	1    5300 6000
	0    1    1    0   
$EndComp
$Comp
L CONN_01X04 PVO_I2C5
U 1 1 5692D0C0
P 8550 3850
F 0 "PVO_I2C5" V 8745 3850 50  0000 C CNN
F 1 "VGA Out I2C 5v" V 8650 3850 50  0000 C CNN
F 2 "CON-SMD-2.54:HARWIN-M20-87-4x1" H 8550 3850 50  0001 C CNN
F 3 "" H 8550 3850 50  0000 C CNN
	1    8550 3850
	0    -1   -1   0   
$EndComp
Text Notes 3850 4150 0    60   ~ 0
Analog VGA Signals\nNoise Sensitive
Text HLabel 1600 3100 2    60   Output ~ 0
COMP_Y
Text HLabel 1600 3450 2    60   Output ~ 0
COMP_Pb
Text HLabel 1600 3800 2    60   Output ~ 0
COMP_Pr
$Comp
L GNDA #PWR046
U 1 1 579715ED
P 1850 4600
F 0 "#PWR046" H 1850 4350 50  0001 C CNN
F 1 "GNDA" H 1850 4450 50  0000 C CNN
F 2 "" H 1850 4600 60  0000 C CNN
F 3 "" H 1850 4600 60  0000 C CNN
	1    1850 4600
	1    0    0    -1  
$EndComp
$Comp
L 3-RCA P601
U 1 1 579715F7
P 1250 3550
F 0 "P601" H 1250 4100 50  0000 C CNN
F 1 "3-RCA" V 1450 3500 50  0001 C CNN
F 2 "3-RCA:MR-100H" H 1250 3200 50  0001 C CNN
F 3 "" H 1250 3200 50  0000 C CNN
	1    1250 3550
	-1   0    0    -1  
$EndComp
Text Notes 950  2700 0    60   ~ 0
Analog VGA Signals\nNoise Sensitive
$Comp
L GNDA #PWR047
U 1 1 579C600A
P 8695 6115
F 0 "#PWR047" H 8695 5865 50  0001 C CNN
F 1 "GNDA" H 8695 5965 50  0000 C CNN
F 2 "" H 8695 6115 60  0000 C CNN
F 3 "" H 8695 6115 60  0000 C CNN
	1    8695 6115
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR048
U 1 1 579C6010
P 9015 6115
F 0 "#PWR048" H 9015 5865 50  0001 C CNN
F 1 "GND" H 9015 5965 50  0000 C CNN
F 2 "" H 9015 6115 60  0000 C CNN
F 3 "" H 9015 6115 60  0000 C CNN
	1    9015 6115
	1    0    0    -1  
$EndComp
$Comp
L C CVO0
U 1 1 579C6016
P 8855 5785
F 0 "CVO0" H 8880 5885 50  0000 L CNN
F 1 "100n" H 8880 5685 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 8893 5635 50  0001 C CNN
F 3 "" H 8855 5785 50  0000 C CNN
	1    8855 5785
	0    1    1    0   
$EndComp
Text Notes 8175 6075 0    60   ~ 0
Place near \nVGA Out \nconnector
Text Label 6200 4150 0    60   ~ 0
VCC3V3
Text Label 7200 4155 0    60   ~ 0
VCC5V0
Text Label 4880 5050 2    35   ~ 0
VGAOUT3V_SDA
Text Label 9700 4600 0    35   ~ 0
VGAOUT5V_SCL
Text Label 9700 4900 0    35   ~ 0
VGAOUT5V_SDA
Text Notes 2500 2450 2    157  ~ 31
Component In
$Comp
L JUMPER JVO60
U 1 1 57AB51C6
P 9500 3850
F 0 "JVO60" H 9500 4000 50  0000 C CNN
F 1 "JUMPER" H 9500 3770 50  0000 C CNN
F 2 "CON-SMD-2.54:HARWIN-M20-87-2x1" H 9500 3850 50  0001 C CNN
F 3 "" H 9500 3850 50  0000 C CNN
	1    9500 3850
	1    0    0    -1  
$EndComp
$Comp
L D_Schottky_x2_KCom_AAK DVO60
U 1 1 57AB8C47
P 10050 3850
F 0 "DVO60" V 10200 3650 50  0000 C CNN
F 1 "BAT54C" V 10300 3650 50  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-23" H 10050 3850 50  0001 C CNN
F 3 "" H 10050 3850 50  0000 C CNN
	1    10050 3850
	0    -1   -1   0   
$EndComp
Text Label 4875 4950 2    35   ~ 0
VGAOUT3V_SCL
Text Label 9700 4700 0    35   ~ 0
VGAOUT_VSYNC
Text Label 9700 4800 0    35   ~ 0
VGAOUT_HSYNC
Text Label 9700 5800 0    35   ~ 0
VGAOUT_B
Text Label 9700 5900 0    35   ~ 0
VGAOUT_G
Text Label 9700 6000 0    35   ~ 0
VGAOUT_R
$Comp
L +5V #PWR049
U 1 1 57AD1593
P 9100 3800
F 0 "#PWR049" H 9100 3650 50  0001 C CNN
F 1 "+5V" H 9100 3940 50  0000 C CNN
F 2 "" H 9100 3800 60  0000 C CNN
F 3 "" H 9100 3800 60  0000 C CNN
	1    9100 3800
	1    0    0    -1  
$EndComp
$Comp
L TPD7S019 UVO_I2C0
U 1 1 57ABC29E
P 6850 5150
F 0 "UVO_I2C0" H 7150 4300 60  0000 C CNN
F 1 "TPD7S019" H 7150 4200 60  0000 C CNN
F 2 "Housings_SSOP:SSOP-16_3.9x4.9mm_Pitch0.635mm" H 7150 4100 60  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tpd7s019.pdf" H 8050 4000 60  0001 C CNN
	1    6850 5150
	1    0    0    -1  
$EndComp
$Comp
L C CVO61
U 1 1 57AD3B66
P 6100 4450
F 0 "CVO61" H 6125 4550 50  0000 L CNN
F 1 "100n" H 6125 4350 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 6138 4300 50  0001 C CNN
F 3 "" H 6100 4450 50  0000 C CNN
	1    6100 4450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR050
U 1 1 57AD40D1
P 6100 4650
F 0 "#PWR050" H 6100 4400 50  0001 C CNN
F 1 "GND" H 6100 4500 50  0000 C CNN
F 2 "" H 6100 4650 60  0000 C CNN
F 3 "" H 6100 4650 60  0000 C CNN
	1    6100 4650
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR051
U 1 1 57AD47F8
P 6850 6250
F 0 "#PWR051" H 6850 6000 50  0001 C CNN
F 1 "GND" H 6850 6100 50  0000 C CNN
F 2 "" H 6850 6250 60  0000 C CNN
F 3 "" H 6850 6250 60  0000 C CNN
	1    6850 6250
	-1   0    0    -1  
$EndComp
$Comp
L C CVO63
U 1 1 57AD4A0B
P 6100 6050
F 0 "CVO63" H 6125 6150 50  0000 L CNN
F 1 "100n" H 6125 5950 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 6138 5900 50  0001 C CNN
F 3 "" H 6100 6050 50  0000 C CNN
	1    6100 6050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR052
U 1 1 57AD4BBD
P 6100 6250
F 0 "#PWR052" H 6100 6000 50  0001 C CNN
F 1 "GND" H 6100 6100 50  0000 C CNN
F 2 "" H 6100 6250 60  0000 C CNN
F 3 "" H 6100 6250 60  0000 C CNN
	1    6100 6250
	-1   0    0    -1  
$EndComp
$Comp
L +5V #PWR053
U 1 1 57AD7439
P 6900 4100
F 0 "#PWR053" H 6900 3950 50  0001 C CNN
F 1 "+5V" H 6900 4240 50  0000 C CNN
F 2 "" H 6900 4100 60  0000 C CNN
F 3 "" H 6900 4100 60  0000 C CNN
	1    6900 4100
	1    0    0    -1  
$EndComp
$Comp
L R RVO60
U 1 1 57AD87B0
P 10900 4050
F 0 "RVO60" V 10980 4050 50  0000 C CNN
F 1 "2K2" V 10900 4050 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 10830 4050 30  0001 C CNN
F 3 "" H 10900 4050 30  0000 C CNN
	1    10900 4050
	1    0    0    -1  
$EndComp
$Comp
L C CVO62
U 1 1 57AD927A
P 7600 4450
F 0 "CVO62" H 7625 4550 50  0000 L CNN
F 1 "100n" H 7625 4350 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 7638 4300 50  0001 C CNN
F 3 "" H 7600 4450 50  0000 C CNN
	1    7600 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	9015 5785 9005 5785
Wire Wire Line
	9015 6115 9015 5785
Wire Wire Line
	8695 5785 8705 5785
Wire Wire Line
	8695 6115 8695 5785
Connection ~ 1050 3750
Connection ~ 1050 4100
Wire Wire Line
	1250 3750 1050 3750
Wire Wire Line
	1050 3400 1050 4500
Wire Wire Line
	1050 4100 1250 4100
Wire Wire Line
	1500 3800 1600 3800
Wire Wire Line
	1500 3450 1600 3450
Wire Wire Line
	1500 3100 1600 3100
Wire Wire Line
	1250 3400 1050 3400
Wire Wire Line
	9850 3550 9850 4150
Wire Wire Line
	9850 4150 10050 4150
Connection ~ 9850 3850
Wire Wire Line
	10300 5200 10400 5200
Wire Wire Line
	9550 5800 10400 5800
Wire Wire Line
	9550 5450 9550 5800
Connection ~ 7600 5450
Wire Wire Line
	9450 5550 9450 5900
Wire Wire Line
	9450 5900 10400 5900
Connection ~ 7600 5550
Wire Wire Line
	9350 5650 9350 6000
Wire Wire Line
	9350 6000 10400 6000
Connection ~ 7600 5650
Wire Wire Line
	7600 5300 9550 5300
Wire Wire Line
	9550 5300 9550 4800
Wire Wire Line
	9550 4800 10400 4800
Wire Wire Line
	7600 5200 9450 5200
Wire Wire Line
	9450 5200 9450 4700
Wire Wire Line
	9450 4700 10400 4700
Wire Wire Line
	9000 4600 10400 4600
Wire Wire Line
	9100 4900 10400 4900
Wire Wire Line
	7600 4950 9000 4950
Wire Wire Line
	9100 5050 9100 4900
Wire Wire Line
	7600 5050 9100 5050
Wire Wire Line
	4400 4950 6200 4950
Wire Wire Line
	4400 5050 6200 5050
Wire Wire Line
	6200 5200 4400 5200
Wire Wire Line
	6200 5300 4400 5300
Wire Wire Line
	5650 4650 5650 5050
Wire Wire Line
	6600 4150 6600 4250
Wire Wire Line
	5450 4150 6600 4150
Wire Wire Line
	5850 4350 5850 4150
Wire Wire Line
	5450 4100 5450 5800
Connection ~ 5450 4150
Wire Wire Line
	5650 4350 5650 4150
Connection ~ 5650 4150
Connection ~ 5850 4150
Connection ~ 5650 5050
Connection ~ 5850 4950
Wire Wire Line
	5850 4950 5850 4650
Wire Wire Line
	5350 5800 5350 4950
Connection ~ 5350 4950
Wire Wire Line
	5250 5800 5250 5050
Connection ~ 5250 5050
Wire Wire Line
	5150 5800 5150 5750
Wire Wire Line
	5150 5750 4900 5750
Wire Wire Line
	4900 5750 4900 5800
Wire Wire Line
	10050 3550 9850 3550
Wire Wire Line
	10300 3850 10300 5200
Wire Wire Line
	9100 3800 9100 3850
Wire Wire Line
	9000 4950 9000 4600
Wire Wire Line
	4400 5650 9350 5650
Wire Wire Line
	4400 5550 9450 5550
Wire Wire Line
	4400 5450 9550 5450
Wire Wire Line
	6100 4300 6100 4150
Connection ~ 6100 4150
Wire Wire Line
	6100 4650 6100 4600
Wire Wire Line
	6850 6150 6850 6250
Wire Wire Line
	6100 6200 6100 6250
Wire Wire Line
	5835 5800 6200 5800
Wire Wire Line
	6100 5800 6100 5900
Wire Wire Line
	8500 4050 8500 4950
Wire Wire Line
	8600 4050 8600 5050
Wire Wire Line
	8700 4050 8700 4150
Connection ~ 8500 4950
Connection ~ 8600 5050
Wire Wire Line
	7950 4650 7950 4950
Connection ~ 7950 4950
Wire Wire Line
	8150 4650 8150 5050
Connection ~ 8150 5050
Wire Wire Line
	8400 4150 8400 4050
Wire Wire Line
	6900 4150 8400 4150
Wire Wire Line
	7950 4150 7950 4350
Wire Wire Line
	8150 4350 8150 4150
Connection ~ 8150 4150
Wire Wire Line
	6900 4100 6900 4250
Connection ~ 7950 4150
Wire Wire Line
	7200 4250 7200 4150
Connection ~ 7200 4150
Connection ~ 6900 4150
Wire Wire Line
	9100 3850 9200 3850
Wire Wire Line
	9800 3850 9850 3850
Wire Wire Line
	10250 3850 10900 3850
Wire Wire Line
	7600 4650 7600 4600
Wire Wire Line
	7600 4300 7600 4150
Connection ~ 7600 4150
$Comp
L C CVO60
U 1 1 57ADA026
P 10500 4050
F 0 "CVO60" H 10525 4150 50  0000 L CNN
F 1 "100n" H 10525 3950 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 10538 3900 50  0001 C CNN
F 3 "" H 10500 4050 50  0000 C CNN
	1    10500 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	10500 4250 10500 4200
Wire Wire Line
	10900 3850 10900 3900
Connection ~ 10300 3850
Wire Wire Line
	10500 3900 10500 3850
Connection ~ 10500 3850
Wire Wire Line
	10900 4250 10900 4200
Wire Wire Line
	10500 4250 10900 4250
Wire Wire Line
	10700 4300 10700 4250
Connection ~ 10700 4250
Text HLabel 4200 1950 0    60   BiDi ~ 0
VGAIN_SCL
Text HLabel 4200 2050 0    60   BiDi ~ 0
VGAIN_SDA
$Comp
L DE-15 PVI0
U 1 1 57ADDCD4
P 10550 2350
F 0 "PVI0" V 10520 2350 60  0000 C CNN
F 1 "DE-15" V 10630 2350 60  0000 C CNN
F 2 "DE-15:TE-1-1734530-1" H 10550 2350 60  0001 C CNN
F 3 "~" H 10550 2350 60  0000 C CNN
	1    10550 2350
	1    0    0    1   
$EndComp
NoConn ~ 10200 2000
NoConn ~ 10200 2700
Text HLabel 4200 2450 0    60   Output ~ 0
VGAIN_B
Text HLabel 4200 2550 0    60   Output ~ 0
VGAIN_G
Text HLabel 4200 2650 0    60   Output ~ 0
VGAIN_R
$Comp
L GNDA #PWR054
U 1 1 57ADDCDF
P 9875 2500
F 0 "#PWR054" H 9875 2250 50  0001 C CNN
F 1 "GNDA" H 9875 2350 50  0000 C CNN
F 2 "" H 9875 2500 60  0000 C CNN
F 3 "" H 9875 2500 60  0000 C CNN
	1    9875 2500
	0    1    -1   0   
$EndComp
$Comp
L GND #PWR055
U 1 1 57ADDCE5
P 4700 2800
F 0 "#PWR055" H 4700 2550 50  0001 C CNN
F 1 "GND" V 4700 2600 50  0000 C CNN
F 2 "" H 4700 2800 60  0000 C CNN
F 3 "" H 4700 2800 60  0000 C CNN
	1    4700 2800
	-1   0    0    -1  
$EndComp
Text Notes 3830 935  0    157  ~ 31
VGA In
Text HLabel 4200 2300 0    60   Output ~ 0
VGAIN_HSYNC
Text HLabel 4200 2200 0    60   Output ~ 0
VGAIN_VSYNC
$Comp
L R RVI51
U 1 1 57ADDCEE
P 7950 1500
F 0 "RVI51" V 8030 1500 50  0000 C CNN
F 1 "4K7" V 7950 1500 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 7880 1500 30  0001 C CNN
F 3 "" H 7950 1500 30  0000 C CNN
	1    7950 1500
	1    0    0    -1  
$EndComp
$Comp
L R RVI50
U 1 1 57ADDCF4
P 7750 1500
F 0 "RVI50" V 7830 1500 50  0000 C CNN
F 1 "4K7" V 7750 1500 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 7680 1500 30  0001 C CNN
F 3 "" H 7750 1500 30  0000 C CNN
	1    7750 1500
	1    0    0    -1  
$EndComp
$Comp
L R RVI31
U 1 1 57ADDCFA
P 5650 1500
F 0 "RVI31" V 5730 1500 50  0000 C CNN
F 1 "2K2" V 5650 1500 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 5580 1500 30  0001 C CNN
F 3 "" H 5650 1500 30  0000 C CNN
	1    5650 1500
	1    0    0    -1  
$EndComp
$Comp
L R RVI30
U 1 1 57ADDD00
P 5450 1500
F 0 "RVI30" V 5530 1500 50  0000 C CNN
F 1 "2K2" V 5450 1500 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 5380 1500 30  0001 C CNN
F 3 "" H 5450 1500 30  0000 C CNN
	1    5450 1500
	1    0    0    -1  
$EndComp
$Comp
L +3V3 #PWR056
U 1 1 57ADDD06
P 5250 1100
F 0 "#PWR056" H 5250 950 50  0001 C CNN
F 1 "+3V3" H 5250 1240 50  0000 C CNN
F 2 "" H 5250 1100 60  0000 C CNN
F 3 "" H 5250 1100 60  0000 C CNN
	1    5250 1100
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X04 PVI_I2C3
U 1 1 57ADDD0C
P 5100 3000
F 0 "PVI_I2C3" V 5295 3000 50  0000 C CNN
F 1 "VGA In I2C 3v" V 5200 3000 50  0000 C CNN
F 2 "CON-SMD-2.54:HARWIN-M20-87-4x1" H 5100 3000 50  0001 C CNN
F 3 "" H 5100 3000 50  0000 C CNN
	1    5100 3000
	0    1    1    0   
$EndComp
$Comp
L CONN_01X04 PVI_I2C5
U 1 1 57ADDD12
P 8350 850
F 0 "PVI_I2C5" V 8545 850 50  0000 C CNN
F 1 "VGA In I2C 5v" V 8450 850 50  0000 C CNN
F 2 "CON-SMD-2.54:HARWIN-M20-87-4x1" H 8350 850 50  0001 C CNN
F 3 "" H 8350 850 50  0000 C CNN
	1    8350 850 
	0    -1   -1   0   
$EndComp
$Comp
L GNDA #PWR057
U 1 1 57ADDD18
P 8495 3115
F 0 "#PWR057" H 8495 2865 50  0001 C CNN
F 1 "GNDA" H 8495 2965 50  0000 C CNN
F 2 "" H 8495 3115 60  0000 C CNN
F 3 "" H 8495 3115 60  0000 C CNN
	1    8495 3115
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR058
U 1 1 57ADDD1E
P 8815 3115
F 0 "#PWR058" H 8815 2865 50  0001 C CNN
F 1 "GND" H 8815 2965 50  0000 C CNN
F 2 "" H 8815 3115 60  0000 C CNN
F 3 "" H 8815 3115 60  0000 C CNN
	1    8815 3115
	1    0    0    -1  
$EndComp
$Comp
L C CVI0
U 1 1 57ADDD24
P 8655 2785
F 0 "CVI0" H 8680 2885 50  0000 L CNN
F 1 "100n" H 8680 2685 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 8693 2635 50  0001 C CNN
F 3 "" H 8655 2785 50  0000 C CNN
	1    8655 2785
	0    1    1    0   
$EndComp
Text Notes 7975 3075 0    60   ~ 0
Place near \nVGA In\nconnector
Text Label 6000 1150 0    60   ~ 0
VCC3V3
Text Label 7000 1155 0    60   ~ 0
VCC5V0
Text Label 4680 2050 2    35   ~ 0
VGAIN3V_SDA
Text Label 9500 1600 0    35   ~ 0
VGAIN5V_SCL
Text Label 9500 1900 0    35   ~ 0
VGAIN5V_SDA
$Comp
L JUMPER JVI60
U 1 1 57ADDD30
P 9300 850
F 0 "JVI60" H 9300 1000 50  0000 C CNN
F 1 "JUMPER" H 9300 770 50  0000 C CNN
F 2 "CON-SMD-2.54:HARWIN-M20-87-2x1" H 9300 850 50  0001 C CNN
F 3 "" H 9300 850 50  0000 C CNN
	1    9300 850 
	1    0    0    -1  
$EndComp
$Comp
L D_Schottky_x2_KCom_AAK DVI60
U 1 1 57ADDD36
P 9850 850
F 0 "DVI60" V 10000 650 50  0000 C CNN
F 1 "BAT54C" V 10100 650 50  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-23" H 9850 850 50  0001 C CNN
F 3 "" H 9850 850 50  0000 C CNN
	1    9850 850 
	0    -1   -1   0   
$EndComp
Text Label 4675 1950 2    35   ~ 0
VGAIN3V_SCL
Text Label 9500 1700 0    35   ~ 0
VGAIN_VSYNC
Text Label 9500 1800 0    35   ~ 0
VGAIN_HSYNC
Text Label 9500 2800 0    35   ~ 0
VGAIN_B
Text Label 9500 2900 0    35   ~ 0
VGAIN_G
Text Label 9500 3000 0    35   ~ 0
VGAIN_R
$Comp
L +5V #PWR059
U 1 1 57ADDD42
P 8900 800
F 0 "#PWR059" H 8900 650 50  0001 C CNN
F 1 "+5V" H 8900 940 50  0000 C CNN
F 2 "" H 8900 800 60  0000 C CNN
F 3 "" H 8900 800 60  0000 C CNN
	1    8900 800 
	1    0    0    -1  
$EndComp
$Comp
L TPD7S019 UVI_I2C0
U 1 1 57ADDD48
P 6650 2150
F 0 "UVI_I2C0" H 6950 1300 60  0000 C CNN
F 1 "TPD7S019" H 6950 1200 60  0000 C CNN
F 2 "Housings_SSOP:SSOP-16_3.9x4.9mm_Pitch0.635mm" H 6950 1100 60  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tpd7s019.pdf" H 7850 1000 60  0001 C CNN
	1    6650 2150
	1    0    0    -1  
$EndComp
$Comp
L C CVI61
U 1 1 57ADDD4E
P 5900 1450
F 0 "CVI61" H 5925 1550 50  0000 L CNN
F 1 "100n" H 5925 1350 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 5938 1300 50  0001 C CNN
F 3 "" H 5900 1450 50  0000 C CNN
	1    5900 1450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR060
U 1 1 57ADDD54
P 5900 1650
F 0 "#PWR060" H 5900 1400 50  0001 C CNN
F 1 "GND" H 5900 1500 50  0000 C CNN
F 2 "" H 5900 1650 60  0000 C CNN
F 3 "" H 5900 1650 60  0000 C CNN
	1    5900 1650
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR061
U 1 1 57ADDD5A
P 6650 3250
F 0 "#PWR061" H 6650 3000 50  0001 C CNN
F 1 "GND" H 6650 3100 50  0000 C CNN
F 2 "" H 6650 3250 60  0000 C CNN
F 3 "" H 6650 3250 60  0000 C CNN
	1    6650 3250
	-1   0    0    -1  
$EndComp
$Comp
L C CVI63
U 1 1 57ADDD60
P 5900 3050
F 0 "CVI63" H 5925 3150 50  0000 L CNN
F 1 "100n" H 5925 2950 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 5938 2900 50  0001 C CNN
F 3 "" H 5900 3050 50  0000 C CNN
	1    5900 3050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR062
U 1 1 57ADDD66
P 5900 3250
F 0 "#PWR062" H 5900 3000 50  0001 C CNN
F 1 "GND" H 5900 3100 50  0000 C CNN
F 2 "" H 5900 3250 60  0000 C CNN
F 3 "" H 5900 3250 60  0000 C CNN
	1    5900 3250
	-1   0    0    -1  
$EndComp
$Comp
L +5V #PWR063
U 1 1 57ADDD72
P 6700 1100
F 0 "#PWR063" H 6700 950 50  0001 C CNN
F 1 "+5V" H 6700 1240 50  0000 C CNN
F 2 "" H 6700 1100 60  0000 C CNN
F 3 "" H 6700 1100 60  0000 C CNN
	1    6700 1100
	1    0    0    -1  
$EndComp
$Comp
L R RVI60
U 1 1 57ADDD78
P 10700 1050
F 0 "RVI60" V 10780 1050 50  0000 C CNN
F 1 "2K2" V 10700 1050 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 10630 1050 30  0001 C CNN
F 3 "" H 10700 1050 30  0000 C CNN
	1    10700 1050
	1    0    0    -1  
$EndComp
$Comp
L C CVI62
U 1 1 57ADDD7E
P 7400 1450
F 0 "CVI62" H 7425 1550 50  0000 L CNN
F 1 "100n" H 7425 1350 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 7438 1300 50  0001 C CNN
F 3 "" H 7400 1450 50  0000 C CNN
	1    7400 1450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR064
U 1 1 57ADDD84
P 7400 1650
F 0 "#PWR064" H 7400 1400 50  0001 C CNN
F 1 "GND" H 7400 1500 50  0000 C CNN
F 2 "" H 7400 1650 60  0000 C CNN
F 3 "" H 7400 1650 60  0000 C CNN
	1    7400 1650
	-1   0    0    -1  
$EndComp
Wire Wire Line
	8815 2785 8805 2785
Wire Wire Line
	8815 3115 8815 2785
Wire Wire Line
	8495 2785 8505 2785
Wire Wire Line
	8495 3115 8495 2785
Wire Wire Line
	9650 550  9650 1150
Wire Wire Line
	9650 1150 9850 1150
Connection ~ 9650 850 
Wire Wire Line
	10100 2200 10200 2200
Wire Wire Line
	9350 2800 10200 2800
Wire Wire Line
	9350 2450 9350 2800
Connection ~ 7400 2450
Wire Wire Line
	9250 2550 9250 2900
Wire Wire Line
	9250 2900 10200 2900
Connection ~ 7400 2550
Wire Wire Line
	9150 2650 9150 3000
Wire Wire Line
	9150 3000 10200 3000
Connection ~ 7400 2650
Wire Wire Line
	8575 2300 9350 2300
Wire Wire Line
	9350 2300 9350 1800
Wire Wire Line
	9350 1800 10200 1800
Wire Wire Line
	8575 2200 9250 2200
Wire Wire Line
	9250 2200 9250 1700
Wire Wire Line
	9250 1700 10200 1700
Wire Wire Line
	8800 1600 10200 1600
Wire Wire Line
	8900 1900 10200 1900
Wire Wire Line
	7400 1950 8800 1950
Wire Wire Line
	8900 2050 8900 1900
Wire Wire Line
	7400 2050 8900 2050
Wire Wire Line
	4200 1950 6000 1950
Wire Wire Line
	4200 2050 6000 2050
Wire Wire Line
	4200 2200 5375 2200
Wire Wire Line
	4200 2300 5375 2300
Wire Wire Line
	5450 1650 5450 2050
Wire Wire Line
	6400 1150 6400 1250
Wire Wire Line
	5250 1150 6400 1150
Wire Wire Line
	5650 1350 5650 1150
Wire Wire Line
	5250 1100 5250 2800
Connection ~ 5250 1150
Wire Wire Line
	5450 1350 5450 1150
Connection ~ 5450 1150
Connection ~ 5650 1150
Connection ~ 5450 2050
Connection ~ 5650 1950
Wire Wire Line
	5650 1950 5650 1650
Wire Wire Line
	5150 2800 5150 1950
Connection ~ 5150 1950
Wire Wire Line
	5050 2800 5050 2050
Connection ~ 5050 2050
Wire Wire Line
	4950 2800 4950 2750
Wire Wire Line
	4950 2750 4700 2750
Wire Wire Line
	4700 2750 4700 2800
Wire Wire Line
	9850 550  9650 550 
Wire Wire Line
	10100 850  10100 2200
Wire Wire Line
	8900 800  8900 850 
Wire Wire Line
	8800 1950 8800 1600
Wire Wire Line
	4200 2650 9150 2650
Wire Wire Line
	4200 2550 9250 2550
Wire Wire Line
	4200 2450 9350 2450
Wire Wire Line
	5900 1300 5900 1150
Connection ~ 5900 1150
Wire Wire Line
	5900 1650 5900 1600
Wire Wire Line
	6650 3150 6650 3250
Wire Wire Line
	5900 3200 5900 3250
Wire Wire Line
	5630 2800 6000 2800
Wire Wire Line
	5900 2800 5900 2900
Wire Wire Line
	8300 1050 8300 1950
Wire Wire Line
	8400 1050 8400 2050
Wire Wire Line
	8500 1050 8500 1150
Connection ~ 8300 1950
Connection ~ 8400 2050
Wire Wire Line
	7750 1650 7750 1950
Connection ~ 7750 1950
Wire Wire Line
	7950 1650 7950 2050
Connection ~ 7950 2050
Wire Wire Line
	8200 1150 8200 1050
Wire Wire Line
	6700 1150 8200 1150
Wire Wire Line
	7750 1150 7750 1350
Wire Wire Line
	7950 1350 7950 1150
Connection ~ 7950 1150
Wire Wire Line
	6700 1100 6700 1250
Connection ~ 7750 1150
Wire Wire Line
	7000 1250 7000 1150
Connection ~ 7000 1150
Connection ~ 6700 1150
Wire Wire Line
	10200 2100 9950 2100
Wire Wire Line
	10200 2400 9950 2400
Wire Wire Line
	9875 2500 10200 2500
Connection ~ 9950 2500
Wire Wire Line
	8900 850  9000 850 
Wire Wire Line
	9600 850  9650 850 
Wire Wire Line
	10050 850  10700 850 
Wire Wire Line
	7400 1650 7400 1600
Wire Wire Line
	7400 1300 7400 1150
Connection ~ 7400 1150
$Comp
L C CVI60
U 1 1 57ADDDEE
P 10300 1050
F 0 "CVI60" H 10325 1150 50  0000 L CNN
F 1 "100n" H 10325 950 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 10338 900 50  0001 C CNN
F 3 "" H 10300 1050 50  0000 C CNN
	1    10300 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	10300 1250 10300 1200
Wire Wire Line
	10700 850  10700 900 
Connection ~ 10100 850 
Wire Wire Line
	10300 900  10300 850 
Connection ~ 10300 850 
Wire Wire Line
	10700 1250 10700 1200
Wire Wire Line
	10300 1250 10700 1250
Wire Wire Line
	10500 1300 10500 1250
Connection ~ 10500 1250
Wire Notes Line
	11050 3450 3500 3450
Wire Notes Line
	3500 3450 3500 500 
Wire Notes Line
	3500 500  11050 500 
Wire Notes Line
	11050 500  11050 3450
Wire Notes Line
	11050 3500 3500 3500
Wire Notes Line
	3500 3500 3500 6500
Wire Notes Line
	3500 6500 11050 6500
Wire Notes Line
	11050 6500 11050 3500
Text Notes 3850 1150 0    60   ~ 0
Analog VGA Signals\nNoise Sensitive
$Comp
L SP724AH UCVI0
U 1 1 57AE5E5F
P 2550 3750
F 0 "UCVI0" H 2750 3150 60  0000 C CNN
F 1 "SP724AH" H 2800 3050 60  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-23-6" H 2550 3050 60  0001 C CNN
F 3 "http://www.littelfuse.com/~/media/electronics/datasheets/tvs_diode_arrays/littelfuse_tvs_diode_array_sp724_datasheet.pdf.pdf" H 3850 2950 60  0001 C CNN
	1    2550 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	1400 3200 2100 3200
Wire Wire Line
	1500 3100 1500 3200
Connection ~ 1500 3200
Wire Wire Line
	1400 3550 2100 3550
Wire Wire Line
	1500 3450 1500 3550
Connection ~ 1500 3550
Wire Wire Line
	1400 3900 2100 3900
Wire Wire Line
	1500 3800 1500 3900
Connection ~ 1500 3900
Wire Wire Line
	2550 4500 2550 4450
Wire Wire Line
	1050 4500 2550 4500
Wire Wire Line
	1850 4600 1850 4500
Connection ~ 1850 4500
$Comp
L +5V #PWR065
U 1 1 57AEA714
P 2550 2800
F 0 "#PWR065" H 2550 2650 50  0001 C CNN
F 1 "+5V" H 2550 2940 50  0000 C CNN
F 2 "" H 2550 2800 60  0000 C CNN
F 3 "" H 2550 2800 60  0000 C CNN
	1    2550 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 2900 2550 2800
Wire Notes Line
	700  2150 3200 2150
Wire Notes Line
	3200 2150 3200 4850
Wire Notes Line
	3200 4850 700  4850
Wire Notes Line
	700  4850 700  2150
$Comp
L C CVO64
U 1 1 57ABE0F6
P 5835 6050
F 0 "CVO64" H 5860 6150 50  0000 L CNN
F 1 "100n" H 5860 5950 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 5873 5900 50  0001 C CNN
F 3 "" H 5835 6050 50  0000 C CNN
	1    5835 6050
	1    0    0    -1  
$EndComp
Wire Wire Line
	5835 5800 5835 5900
Connection ~ 6100 5800
Wire Wire Line
	5835 6200 5835 6230
Wire Wire Line
	5835 6230 6100 6230
Connection ~ 6100 6230
$Comp
L C CVI64
U 1 1 57ABE940
P 5630 3055
F 0 "CVI64" H 5655 3155 50  0000 L CNN
F 1 "100n" H 5655 2955 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 5668 2905 50  0001 C CNN
F 3 "" H 5630 3055 50  0000 C CNN
	1    5630 3055
	1    0    0    -1  
$EndComp
Wire Wire Line
	5630 2905 5630 2800
Connection ~ 5900 2800
Wire Wire Line
	5900 3235 5630 3235
Wire Wire Line
	5630 3235 5630 3205
Connection ~ 5900 3235
Text Notes 1115 7285 0    60   ~ 0
FIXME: Make the VGA In and VGA Out stuff line up.
Text Notes 775  5060 0    60   ~ 0
FIXME: Replace SP724AH with cheaper component.
$Comp
L GND #PWR066
U 1 1 57AD9280
P 7600 4650
F 0 "#PWR066" H 7600 4400 50  0001 C CNN
F 1 "GND" H 7600 4500 50  0000 C CNN
F 2 "" H 7600 4650 60  0000 C CNN
F 3 "" H 7600 4650 60  0000 C CNN
	1    7600 4650
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR067
U 1 1 57AD65F2
P 8700 4150
F 0 "#PWR067" H 8700 3900 50  0001 C CNN
F 1 "GND" H 8700 4000 50  0000 C CNN
F 2 "" H 8700 4150 60  0000 C CNN
F 3 "" H 8700 4150 60  0000 C CNN
	1    8700 4150
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR068
U 1 1 57ADA02C
P 10700 4300
F 0 "#PWR068" H 10700 4050 50  0001 C CNN
F 1 "GND" H 10700 4150 50  0000 C CNN
F 2 "" H 10700 4300 60  0000 C CNN
F 3 "" H 10700 4300 60  0000 C CNN
	1    10700 4300
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR069
U 1 1 57ADDDF4
P 10500 1300
F 0 "#PWR069" H 10500 1050 50  0001 C CNN
F 1 "GND" H 10500 1150 50  0000 C CNN
F 2 "" H 10500 1300 60  0000 C CNN
F 3 "" H 10500 1300 60  0000 C CNN
	1    10500 1300
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR070
U 1 1 57ADDD6C
P 8500 1150
F 0 "#PWR070" H 8500 900 50  0001 C CNN
F 1 "GND" H 8500 1000 50  0000 C CNN
F 2 "" H 8500 1150 60  0000 C CNN
F 3 "" H 8500 1150 60  0000 C CNN
	1    8500 1150
	-1   0    0    -1  
$EndComp
Wire Wire Line
	9950 2300 9950 2500
$Comp
L GND #PWR071
U 1 1 57F0893B
P 9875 2200
F 0 "#PWR071" H 9875 1950 50  0001 C CNN
F 1 "GND" H 9875 2050 50  0000 C CNN
F 2 "" H 9875 2200 60  0000 C CNN
F 3 "" H 9875 2200 60  0000 C CNN
	1    9875 2200
	0    1    -1   0   
$EndComp
Wire Wire Line
	9875 2200 10025 2200
Wire Wire Line
	9950 2100 9950 2200
Connection ~ 9950 2200
$Comp
L GNDA #PWR072
U 1 1 57F08E06
P 10100 5500
F 0 "#PWR072" H 10100 5250 50  0001 C CNN
F 1 "GNDA" H 10100 5350 50  0000 C CNN
F 2 "" H 10100 5500 60  0000 C CNN
F 3 "" H 10100 5500 60  0000 C CNN
	1    10100 5500
	0    1    -1   0   
$EndComp
Wire Wire Line
	10400 5100 10150 5100
Wire Wire Line
	10400 5400 10150 5400
Wire Wire Line
	10100 5500 10400 5500
Connection ~ 10150 5500
Wire Wire Line
	10150 5300 10150 5500
$Comp
L GND #PWR073
U 1 1 57F08E15
P 10100 5200
F 0 "#PWR073" H 10100 4950 50  0001 C CNN
F 1 "GND" H 10100 5050 50  0000 C CNN
F 2 "" H 10100 5200 60  0000 C CNN
F 3 "" H 10100 5200 60  0000 C CNN
	1    10100 5200
	0    1    -1   0   
$EndComp
Wire Wire Line
	10100 5200 10225 5200
Wire Wire Line
	10150 5100 10150 5200
Connection ~ 10150 5200
Wire Notes Line
	10100 5375 3500 5375
Text Notes 9575 5350 0    60   ~ 0
Digital
Text Notes 9575 5475 0    60   ~ 0
Analog
Wire Notes Line
	9875 2375 3500 2375
Text Notes 9375 2350 0    60   ~ 0
Digital
Text Notes 9375 2475 0    60   ~ 0
Analog
Wire Wire Line
	10400 5600 10225 5600
Wire Wire Line
	10225 5600 10225 5200
Wire Wire Line
	10150 5300 10400 5300
Connection ~ 10150 5400
Wire Notes Line
	10100 5375 10100 5250
Wire Notes Line
	10100 5250 11050 5250
Text Notes 10325 5300 0    20   ~ 0
RGND
Text Notes 10325 5400 0    20   ~ 0
GGND
Text Notes 10325 5500 0    20   ~ 0
BGND
Text Notes 10325 5100 0    20   ~ 0
SYNCGND
Text Notes 10325 5600 0    20   ~ 0
I2CGND\n
Text Notes 10125 2300 0    20   ~ 0
RGND
Text Notes 10125 2400 0    20   ~ 0
GGND
Text Notes 10125 2500 0    20   ~ 0
BGND
Text Notes 10125 2600 0    20   ~ 0
I2CGND\n
Text Notes 10125 2100 0    20   ~ 0
SYNCGND
Wire Wire Line
	9950 2300 10200 2300
Connection ~ 9950 2400
Wire Wire Line
	10200 2600 10025 2600
Wire Wire Line
	10025 2600 10025 2200
Wire Notes Line
	11050 2250 9875 2250
Wire Notes Line
	9875 2250 9875 2375
Wire Wire Line
	5375 2200 5375 2150
Wire Wire Line
	5375 2150 7425 2150
Wire Wire Line
	7725 2150 8575 2150
Wire Wire Line
	8575 2150 8575 2200
Wire Wire Line
	8575 2250 8575 2300
Wire Wire Line
	5375 2250 7425 2250
Wire Wire Line
	7725 2250 8575 2250
Wire Wire Line
	5375 2300 5375 2250
$Comp
L R RVIE5
U 1 1 57F10E89
P 8100 2200
F 0 "RVIE5" V 8100 2200 50  0000 C CNN
F 1 "0" V 8100 2200 50  0001 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 8030 2200 30  0001 C CNN
F 3 "" H 8100 2200 30  0000 C CNN
	1    8100 2200
	0    1    1    0   
$EndComp
$Comp
L R RVIE6
U 1 1 57F110C7
P 8100 2300
F 0 "RVIE6" V 8100 2300 50  0000 C CNN
F 1 "0" V 8100 2300 50  0001 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 8030 2300 30  0001 C CNN
F 3 "" H 8100 2300 30  0000 C CNN
	1    8100 2300
	0    1    1    0   
$EndComp
Wire Wire Line
	7400 2200 7950 2200
Wire Wire Line
	7400 2300 7950 2300
Wire Wire Line
	8250 2200 8300 2200
Wire Wire Line
	8300 2200 8300 2150
Connection ~ 8300 2150
Wire Wire Line
	8250 2300 8300 2300
Wire Wire Line
	8300 2300 8300 2250
Connection ~ 8300 2250
Wire Wire Line
	5625 2150 5625 2200
Connection ~ 5625 2150
Wire Wire Line
	5925 2200 6000 2200
Wire Wire Line
	6000 2300 5925 2300
Wire Wire Line
	5625 2250 5625 2300
Connection ~ 5625 2250
$Comp
L R RVIE3
U 1 1 57F1442B
P 7575 2150
F 0 "RVIE3" V 7575 2150 50  0000 C CNN
F 1 "0" V 7575 2150 50  0001 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 7505 2150 30  0001 C CNN
F 3 "" H 7575 2150 30  0000 C CNN
	1    7575 2150
	0    1    1    0   
$EndComp
$Comp
L R RVIE4
U 1 1 57F1455B
P 7575 2250
F 0 "RVIE4" V 7575 2250 50  0000 C CNN
F 1 "0" V 7575 2250 50  0001 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 7505 2250 30  0001 C CNN
F 3 "" H 7575 2250 30  0000 C CNN
	1    7575 2250
	0    1    1    0   
$EndComp
$Comp
L R RVIE1
U 1 1 57F14E8E
P 5775 2200
F 0 "RVIE1" V 5775 2200 50  0000 C CNN
F 1 "0" V 5775 2200 50  0001 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 5705 2200 30  0001 C CNN
F 3 "" H 5775 2200 30  0000 C CNN
	1    5775 2200
	0    1    1    0   
$EndComp
$Comp
L R RVIE2
U 1 1 57F14FC0
P 5775 2300
F 0 "RVIE2" V 5775 2300 50  0000 C CNN
F 1 "0" V 5775 2300 50  0001 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 5705 2300 30  0001 C CNN
F 3 "" H 5775 2300 30  0000 C CNN
	1    5775 2300
	0    1    1    0   
$EndComp
$EndSCHEMATC
