# HDMI2USB-vmodvga

VGA capture expansion board for HDMI2USB (or Digilent Atlys prototype board).


## Documentation

 * [Project blog](https://dreamsxtrinsic.blogspot.com/) for weekly and daily updates
 * [vMod-VGA Code Block Diagram](https://docs.google.com/drawings/d/1-_QcqhuEnqGTb0JCZim7DaP1v0BfKb7fcv-28n1iaC0/edit?usp=sharing)
 * [Code structure explained in this document](https://docs.google.com/document/d/11dfCeLtNUrjcst97REtgqLIln-_pKwHgGT3xKjOamxs/edit?usp=sharing)
 * [vMod-VGA VHDCI Pin Usage](https://docs.google.com/spreadsheets/d/1f-rBfR98f_ZZNIB7GFV79CGSHQNpj47uOU0JDwOJnV8/edit?usp=sharing)
 * [AD9984A Register Settings](https://docs.google.com/spreadsheets/d/1GH8NDtB8ceGhJEVZQujcXdxDPSw_wLqhg_3s436kkSs/edit?usp=sharing) for easier register settings
 * [Code Test points](https://docs.google.com/spreadsheets/d/12sMpliuKs6eSY12Fc8JHHKd0Y-Cz1OmEMRZJ5Vne3Vg/edit?usp=sharing) I compiled during whole project during
 * [Autodetection guidelines](https://docs.google.com/document/d/1ZhDz50rve5UmnmyKynxySLHqfFuOwBPM7pYFoHo9uvs/edit?usp=sharing)
 * [I2C Tools & Debugging](https://docs.google.com/document/d/1rNem5J1_V4QUOei_MHRzZVJfjsTon8fnE3eTlhzsrj8/edit?usp=sharing)
 * [PCB v02 Requirements Doc](https://docs.google.com/document/d/1EVi7m_RxV2RLTFDjguj92tawxPkJdG1kjHW0T4Z_cDw/edit?usp=sharing)


# GSoC Project Report: VGA capture expansion board for HDMI2USB on Digilent Atlys

By Rohit | Published [Saturday, August 30,
2014](http://dreamsxtrinsic.blogspot.de/2014/08/gsoc-project-report-vga-capture.html "2014-08-30T17:25:00+05:30")

### Original Goals

The goal of this project was to develop a VGA Capture expansion board
for HDMI2USB on Digilent Atlys. The deliverables for the project were
usable product with associated hardware, software and documentation.

Details of original goals were:

 * Working PCB for VGA Capture
 * Working VGA Capture code for the hardware
 * Integration of this code with HDMI2USB
 * EDID Capability for the VGA Capture expansion board
 * Documentation for all the code and hardware

Original Proposal: [http://goo.gl/rRtSrS](http://goo.gl/rRtSrS)

### Final Outcome

I achieved quite significant success, along with associated failures, in
this project. While I failed to reach all the original proposed goal I
have succeeded in getting the following working:

 * Nice and working PCB for VGA Capturing using Atlys
 * Working, but not perfect, VGA Capture HDL code
 * Integrated the VGA capture code into HDMI2USB.


The Expansion PCB features a VGA digitizing IC from Analog Devices,
AD9984A and has support for auto-detection and as well as EDID. Its
design is production-ready unless issues crop in future during continued
development on this project.

![top.png](https://lh3.googleusercontent.com/LNUcLJBlsjbtbOsicPc6ZIcJ-qRzUcAVwwIa8b49APpkA9gS3bzrZaIVeoypq8hRR2qowVpeI8bxQHMDPgtDTj_ZfmHJPqdSFigSl0NS6bKXtbakKraPVvZB_ilbH5f4sw)![bottom.png](https://lh3.googleusercontent.com/puaC4yHfU94Gl0gge0WK2PHvX1tgh9nUnwE8pWct023yc3g9syjJufuXGoaUjA0GXOLGbCUqbb8Ke4bALpM1pYt20ymBrBuSVQGoTLUYkXxSMAMTAVspZ8McKQzoIcsa8w)

![DSC00446.JPG](https://lh6.googleusercontent.com/rV1dzqT0o22iBvIsnD-6c5gc7FIIWrOQoJo5Fji2HG955M0Pipq2U461ZcXFxvExe4MW3mYEQ3PJkzV8cGb_N8aOEyj7zrOJj76ILB-Kleh52Fhd6S78VbPplX2lxeBu5g)

The VGA capture code, on other hand, needs improvement and ruggedness to
field working environment. It is currently working very well with the
latest PCB version, but continued development is required on it.

Video of current progress:
[https://www.youtube.com/watch?v=zSpOugDc2fM](https://www.youtube.com/watch?v=zSpOugDc2fM)

## Community Outcome

With this project. I was able to get VGA capture working, albeit not
perfectly. Most of the project time duration was spent on PCBv01, which
was later realized to be buggy, after testing the PCBv02. I created a
new PCB design which was fabricated by hackvana and I tested it. It has
significant improvements over previous design namely test pads,
intuitive layout, length-matched traces, VGA splitter output,
autodetection capability, EDID capability and friendly silkscreen. Most
importantly, it works much better than previous version!

The code is rudimentary, but it works. It is able to capture digitized
VGA sent by AD9984A and output it using HDMI. It also features a
picoblaze core for I2C configuration of AD9984A. Missing  features are
autodetection, EDID hacking capability and most important, automated
test infrastructure.

Upon completion, the major benefit this project provides is giving VGA
capture capability to HDMI2USB hardware using expansion board. Minor
benefits it provides are autodetection feature for boards, UART-I2C
bridge, EDID hacking & logging and test infrastructure (not yet

## How to replicate results

Required:

 1. Digilent Atlys
 2. Properly set up Xilinx and Digilent toolchain. Refer to [HDMI2USB Wiki](https://github.com/timvideos/HDMI2USB/wiki) for this
 3. VGA Capture Expansion PCB

Repository Link:
[https://github.com/rohit91/HDMI2USB-vmodvga](https://github.com/rohit91/HDMI2USB-vmodvga)

One can either directly order PCBs using the Gerbers present in the
repository or modify the KiCad files and generate own gerbers. The
silkscreen is labelled with each component and values for easier
assembly.

Once the PCB is successfully assembled, its time to test them. Start
with testing power supplies at the labelled test points (VD, PD & OVDD).
They should be 1.8V, 1.8V & 3.3V respectively.

Now one can load the bitfile from HDMI\_Test\_v06 repo or
HDMI2USB-vModVGA-TestBitFiles repo. The name of bitfile is
[hdmi\_test\_v06.bit](https://github.com/rohit91/HDMI_Test_v06/blob/master/ise/hdmi_test_v06.bit).

For those willing to modify/edit/improve the code, use the
HDMI\_Test\_v06  repository and load the project into Xilinx ISE, modify
code as per your ideas and generate bitfile for flashing into Atlys.

There is no need for any I2C initialization for AD9984A as I’ve added
I2C core into the projects. Even then if you want to see I2C
Initialization scripts for BeagleBoneBlack, then they are located in i2c
directory.

For any issues or help you can contact me on IRC: rohitksingh on
\#timvideos channel or Email:
[rohit.singh@gmx.com](mailto:rohit.singh@gmx.com). I would be very happy
to help

## To Do / How to help?

There are quite a few issues still remaining with VGA Capture HDL code.
I encourage everyone to fork and develop code for the VGA capture. I
have 11 spare Rev02 PCBs remaining with me, and would happily courier
one to anyone interested in contributing in development.

Here are issues remaining:

Major:

 * Improve/cleanup the VGA Capture code
 * Add automated test & verification feature

Minor:

 * Add EDID hack feature
 * Add Autodetection code.
 * Add UART-I2C bridge


## Learnings

I have to admit I learned *significantly* during the whole project duration.
Learnings I would cherish lifelong are Git(Hub), KiCad, improved SMD soldering
skills, vast VHDL experience especially on clock issues etc and finally basics
of open-source development and community culture! I wonder how I survived
without Github until now. Having used KiCad so much during these months, I feel
like an outsider to Eagle now.  I made many new wonderful friends during the
project duration! And best of all, I’m now officially a [hardware hacker of
HDMI2USB](https://github.com/orgs/timvideos/teams/hardware-hackers)!
