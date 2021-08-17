
--------------------------------------------------------------------------------

Latest news:

18/08/2021
- compiler warning and style switches have a separate file to be included in
  in the master Makefile, in order to increase handling and readability
13/08/2021
- burned as an EPROM, SweetAda correctly startups in an Amiga2000/68010 machine
- Nios II very primitive interrupt support (IIC)
- the srecord module lets you download an S-record code fragment in a machine
  and execute it

--------------------------------------------------------------------------------

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
- uses a ZFP run-time
- has no dependencies; neither external libraries nor underlying code are needed

SweetAda, in addition to the core source code, consists of a toolchain
(assembler, linker, Ada compiler and debugger) and (optionally) an emulator,
which is used to execute the final output code in a virtual target machine.
In order to use SweetAda, a decent POSIX&reg; environment with a Bash shell
and GNU Make are required. In a Linux&reg; workstation this is quite standard,
while for a Windows&#174; machine you can download and install either MSYS2
(preferred) or Cygwin&reg;. Anyway, SweetAda toolchains for Windows have an
integrated Make suited for a PowerShell CLI. Being completely makefile- and
script- driven, SweetAda has many hooks which allow a nicely integration in a
GUI environment such as, e.g., Eclipse, Kate or Visual Studio Code.

SweetAda comes with high-quality GNU toolchains based on recent stock official
FSF package releases, unpatched and compiled with strictly controlled options. The
emulators are mainly based on the latest QEMU&trade; official release, augmented with
the IOEMU physical I/O system, which allows software code to interact with a visual
environment.

To make SweetAda generic and, at the same time, reliable, it is regularly
tested against an heterogeneous set of machines which are able to succesfully
execute the system code; a brief list could be given, e.g.:<br/>
- PC-style PIIX3/PIIX4 motherboards (ROM-boot)<br/>
- Cobalt RaQ 2 router MIPS RM5231 (ROM-boot)<br/>
- DECstation 5000/133 MIPS R3000 (ROM-boot)<br/>
- Memec FX12 Virtex-4 PPC405 (JTAG-boot)<br/>
- DigiNS7520 board ARM7TDMI (JTAG-boot)<br/>
- Terasic DE10-Lite Nios&reg;II softcore (JTAG-boot)<br/>
- MVME1600-011 PPC603 VME board (JTAG-boot)<br/>
- Force SPARC&reg;/CPU-3CE VME board (ROM-boot)<br/>
- Malta&trade; MIPS (ROM-boot)<br/>
- M5235BCC ColdFire development board (ROM-boot)<br/>
- SPARCstation&trade; 5 (ROM-boot)<br/>
- Spartan 3E MicroBlaze softcore (JTAG-boot)<br/>
- Raspberry Pi&trade; 3 ARMv8 (microSD-boot)<br/>

Great care has been put in the design and development of SweetAda.
The software code is logically organized, written with aesthetically precise
guidelines, and is compiled by a build machinery which enforces a very high
severity level. Usefulness, simplicity and expandability rather than extreme
or obscure optimizations are the key features behind the project. Nevertheless,
SweetAda grants the possibility of employ appropriate customizations, down to
machine code level, to satisfy specific needs.

SweetAda is in a state of steady growth. BSPs, device drivers, a TLSF memory
allocator, TCP/IP basic functionalities, as well as low-level CAN primitives
are under heavy development. More target machines and additional feautures/modules
such as a tiny Python bytecode interpreter and expanded SFP runtimes are scheduled
in future releases.

Please note that much of the platform-specific code provided is given as an
example. The emphasis of SweetAda is not about operating system design but
rather on exploiting Ada language everywhere.

