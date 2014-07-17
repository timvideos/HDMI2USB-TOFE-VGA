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
LIBS:testpoint
LIBS:vgaExp-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 3
Title ""
Date "11 jul 2014"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 5200 3450 2    60   BiDi ~ 0
SCL_VGA_RX
Text HLabel 5200 3600 2    60   BiDi ~ 0
SDA_VGA_RX
Text HLabel 5200 4350 2    60   BiDi ~ 0
SCL_VGA_TX
Text HLabel 5200 4500 2    60   BiDi ~ 0
SDA_VGA_TX
Text HLabel 8950 3650 2    60   BiDi ~ 0
SCL_INT
Text HLabel 8950 3750 2    60   BiDi ~ 0
SDA_INT
Text HLabel 5200 4200 2    60   Input ~ 0
VCC
Text HLabel 8050 3000 1    60   Input ~ 0
OVDD
Text HLabel 8050 4650 3    60   Input ~ 0
GND
Text HLabel 3200 3450 0    60   BiDi ~ 0
SCL_VGA_RX_BUF
Text HLabel 3150 3600 0    60   BiDi ~ 0
SDA_VGA_RX_BUF
Text HLabel 3200 4350 0    60   BiDi ~ 0
SCL_VGA_TX_BUF
Text HLabel 3200 4500 0    60   BiDi ~ 0
SDA_VGA_TX_BUF
$Comp
L 24AA014 U5
U 1 1 53BEC2F7
P 8050 3850
F 0 "U5" H 8200 4200 60  0000 C CNN
F 1 "24AA014" H 8250 3500 60  0000 C CNN
F 2 "~" H 8050 3850 60  0000 C CNN
F 3 "~" H 8050 3850 60  0000 C CNN
	1    8050 3850
	1    0    0    -1  
$EndComp
$Comp
L TCA9617A U6
U 1 1 53BEC835
P 4200 3550
F 0 "U6" H 4200 3500 60  0000 C CNN
F 1 "TCA9617A" H 4200 3600 60  0000 C CNN
F 2 "" H 4450 3650 60  0000 C CNN
F 3 "" H 4450 3650 60  0000 C CNN
	1    4200 3550
	1    0    0    -1  
$EndComp
$Comp
L TCA9617A U7
U 1 1 53BEC842
P 4200 4450
F 0 "U7" H 4200 4400 60  0000 C CNN
F 1 "TCA9617A" H 4200 4500 60  0000 C CNN
F 2 "" H 4450 4550 60  0000 C CNN
F 3 "" H 4450 4550 60  0000 C CNN
	1    4200 4450
	1    0    0    -1  
$EndComp
Text HLabel 3200 3300 0    60   Input ~ 0
OVDD
Text HLabel 3200 4200 0    60   Input ~ 0
OVDD
Text HLabel 3200 4650 0    60   Input ~ 0
GND
Text HLabel 3200 3750 0    60   Input ~ 0
GND
NoConn ~ 5000 4650
NoConn ~ 5000 3750
Wire Wire Line
	8750 3650 8950 3650
Wire Wire Line
	8750 3750 8950 3750
Wire Wire Line
	8050 3000 8050 3350
Wire Wire Line
	8050 4350 8050 4650
Wire Wire Line
	7350 4050 7350 4500
Wire Wire Line
	7350 4500 8050 4500
Connection ~ 8050 4500
Wire Wire Line
	3200 3300 3400 3300
Wire Wire Line
	3200 3450 3400 3450
Wire Wire Line
	3200 3750 3400 3750
Wire Wire Line
	3200 4200 3400 4200
Wire Wire Line
	3200 4350 3400 4350
Wire Wire Line
	3200 4500 3400 4500
Wire Wire Line
	3200 4650 3400 4650
Wire Wire Line
	5000 3450 5200 3450
Wire Wire Line
	5000 3600 5200 3600
Wire Wire Line
	5000 4200 5200 4200
Wire Wire Line
	5000 4350 5200 4350
Wire Wire Line
	5000 4500 5200 4500
Text HLabel 5200 3300 2    60   Input ~ 0
VCC
Wire Wire Line
	5200 3300 5000 3300
Text HLabel 7100 3650 0    60   Input ~ 0
OVDD
Text HLabel 7100 3750 0    60   Input ~ 0
OVDD
Text HLabel 7100 3850 0    60   Input ~ 0
GND
Wire Wire Line
	7100 3650 7350 3650
Wire Wire Line
	7100 3750 7350 3750
Wire Wire Line
	7100 3850 7350 3850
Wire Wire Line
	3400 3600 3150 3600
$EndSCHEMATC
