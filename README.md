
![alt text](https://www.sweetada.org/images/banner.jpg)

<scroll down for the news>

## SweetAda overview

Welcome to SweetAda.

SweetAda is a lightweight development framework whose purpose is the
implementation of Ada-based software systems.

The code produced by SweetAda is able to run on a wide range of machines, from
ARM&reg; embedded boards up to x86-64-class machines, as well as MIPS&reg; machines
and Virtex&reg;/Spartan&reg; PowerPC&reg;/MicroBlaze&reg; FPGAs. It could theoretically
run even on System/390&reg; IBM&reg; mainframes (indeed it runs on the Hercules
emulator). SweetAda is not an operating system, however it includes a set of both low-
and high-level primitives and kernel services, like memory management, PCI bus handling,
FAT mass-storage handling, which could be used as building blocks in the construction of
complex software-controlled devices.

SweetAda has some distinctive characteristics, like:
- is ROMable
- could use a ZFP run-time
- has no dependencies; neither external libraries nor underlying code are needed

SweetAda uses standard GNU toolchains, GNU Make and a decent POSIX&reg; shell
environment. In a Linux&reg; workstation the latter is quite standard, while for a
Windows&#174; machine you can download and install either MSYS2 (preferred) or
Cygwin&reg;. Anyway, SweetAda comes with a port of Make and support for CMD/PowerShell
CLI. Being completely makefile- and script- driven, SweetAda has many hooks which
allow a nicely integration in a GUI environment such as, e.g., Eclipse, Kate or Visual
Studio Code.

To make SweetAda generic and, at the same time, reliable, it is regularly
tested against an heterogeneous set of machines which are able to succesfully
execute the system code; a brief list could be given, e.g.:

- PC-style PIIX3/PIIX4 motherboards (ROM-boot)
- Cobalt RaQ 2 router MIPS RM5231 (ROM-boot)
- DECstation 5000/133 MIPS R3000 (ROM-boot)
- Memec FX12 Virtex-4 PPC405 (JTAG-boot)
- DigiNS7520 board ARM7TDMI (JTAG-boot)
- Terasic DE10-Lite Nios&reg;II softcore (JTAG-boot)
- MVME1600-011 PPC603 VME board (JTAG-boot)
- Force SPARC&reg;/CPU-3CE VME board (ROM-boot)
- Malta&trade; MIPS (ROM-boot)
- M5235BCC ColdFire development board (ROM-boot)
- SPARCstation&trade; 5 (ROM-boot)
- Spartan 3E MicroBlaze softcore (JTAG-boot)
- Raspberry Pi&trade; 3 ARMv8 (microSD-boot)

Some machines are supported through a virtual emulator like QEMU&trade, and as
an option, a virtual IOEMU physical I/O system could be used, which allows software
code to interact with a visual environment.

Great care has been put in the design and development of SweetAda.
The software code is logically organized, written with aesthetically precise
guidelines, and is compiled by a build machinery which enforces a very high
severity level. Usefulness, simplicity and expandability rather than extreme
or obscure optimizations are the key features behind the project. Nevertheless,
SweetAda grants the implementation of appropriate customizations, down to
machine code level, to satisfy specific needs.

SweetAda is in a state of steady growth. BSPs, device drivers, a TLSF memory
allocator, TCP/IP basic functionalities, as well as low-level CAN primitives
are under heavy development. More target machines and additional feautures/modules
such as a tiny Python bytecode interpreter and expanded SFP runtimes are scheduled
in future releases.

Please note that much of the platform-specific code provided is given as an
example. The emphasis of SweetAda is not about operating system design but
rather on exploiting Ada language everywhere.

## NEWS

21/06/2023

Thanks to the work of Fernando Oleo Blanco ([https://irvise.xyz/](https://irvise.xyz/)), SweetAda got displayed
in the real world, running on a RISC-V SiFive(R) HiFive1 board.

The Ada-based system was shown at the FOSDEM '23 recently held in Brussels.

![alt text](https://media.licdn.com/dms/image/D4D22AQG6cf0OrSKm1A/feedshare-shrink_800/0/1686850573412?e=1690416000&v=beta&t=Bl5qFP6hv9ERZaaeCG-BGP_3s1g6epdgf5hQDuB5vFo)

