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
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:24AA014
LIBS:vmodvga
LIBS:vgaExp-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 3
Title ""
Date "10 jul 2014"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 4900 4350 2    60   BiDi ~ 0
SCL_VGA_RX
Text HLabel 4900 4500 2    60   BiDi ~ 0
SDA_VGA_RX
Text HLabel 4900 5250 2    60   BiDi ~ 0
SCL_VGA_TX
Text HLabel 4900 5400 2    60   BiDi ~ 0
SDA_VGA_TX
Text HLabel 9450 3200 2    60   BiDi ~ 0
SCL_INT
Text HLabel 9450 3300 2    60   BiDi ~ 0
SDA_INT
Text HLabel 4900 5100 2    60   Input ~ 0
VCC
Text HLabel 8550 2550 1    60   Input ~ 0
OVDD
Text HLabel 8550 4200 3    60   Input ~ 0
GND
Text HLabel 2900 4350 0    60   BiDi ~ 0
SCL_VGA_RX_BUF
Text HLabel 2850 4500 0    60   BiDi ~ 0
SDA_VGA_RX_BUF
Text HLabel 2900 5250 0    60   BiDi ~ 0
SCL_VGA_TX_BUF
Text HLabel 2900 5400 0    60   BiDi ~ 0
SDA_VGA_TX_BUF
$Comp
L 24AA014 U5
U 1 1 53BEC2F7
P 8550 3400
F 0 "U5" H 8700 3750 60  0000 C CNN
F 1 "24AA014" H 8750 3050 60  0000 C CNN
F 2 "~" H 8550 3400 60  0000 C CNN
F 3 "~" H 8550 3400 60  0000 C CNN
	1    8550 3400
	1    0    0    -1  
$EndComp
$Comp
L TCA9617A U6
U 1 1 53BEC835
P 3900 4450
F 0 "U6" H 3900 4400 60  0000 C CNN
F 1 "TCA9617A" H 3900 4500 60  0000 C CNN
F 2 "" H 4150 4550 60  0000 C CNN
F 3 "" H 4150 4550 60  0000 C CNN
	1    3900 4450
	1    0    0    -1  
$EndComp
$Comp
L TCA9617A U7
U 1 1 53BEC842
P 3900 5350
F 0 "U7" H 3900 5300 60  0000 C CNN
F 1 "TCA9617A" H 3900 5400 60  0000 C CNN
F 2 "" H 4150 5450 60  0000 C CNN
F 3 "" H 4150 5450 60  0000 C CNN
	1    3900 5350
	1    0    0    -1  
$EndComp
Text HLabel 2900 4200 0    60   Input ~ 0
OVDD
Text HLabel 2900 5100 0    60   Input ~ 0
OVDD
Text HLabel 2900 5550 0    60   Input ~ 0
GND
Text HLabel 2900 4650 0    60   Input ~ 0
GND
NoConn ~ 4700 5550
NoConn ~ 4700 4650
Wire Wire Line
	9250 3200 9450 3200
Wire Wire Line
	9250 3300 9450 3300
Wire Wire Line
	8550 2550 8550 2900
Wire Wire Line
	8550 3900 8550 4200
Wire Wire Line
	7850 3600 7850 4050
Wire Wire Line
	7850 4050 8550 4050
Connection ~ 8550 4050
Wire Wire Line
	2900 4200 3100 4200
Wire Wire Line
	2900 4350 3100 4350
Wire Wire Line
	2900 4650 3100 4650
Wire Wire Line
	2900 5100 3100 5100
Wire Wire Line
	2900 5250 3100 5250
Wire Wire Line
	2900 5400 3100 5400
Wire Wire Line
	2900 5550 3100 5550
Wire Wire Line
	4700 4350 4900 4350
Wire Wire Line
	4700 4500 4900 4500
Wire Wire Line
	4700 5100 4900 5100
Wire Wire Line
	4700 5250 4900 5250
Wire Wire Line
	4700 5400 4900 5400
Text HLabel 4900 4200 2    60   Input ~ 0
VCC
Wire Wire Line
	4900 4200 4700 4200
Text HLabel 7600 3200 0    60   Input ~ 0
OVDD
Text HLabel 7600 3300 0    60   Input ~ 0
OVDD
Text HLabel 7600 3400 0    60   Input ~ 0
GND
Wire Wire Line
	7600 3200 7850 3200
Wire Wire Line
	7600 3300 7850 3300
Wire Wire Line
	7600 3400 7850 3400
Wire Wire Line
	3100 4500 2850 4500
$EndSCHEMATC
