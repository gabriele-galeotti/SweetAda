-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gt64120.ads                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package GT64120
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   GT64120_DEFAULT_ISD_ADDRESS : constant := 16#1400_0000#;

   -- 20.3 CPU Configuration

   WriteMode_PIPELINED : constant := 0;
   WriteMode_R4000     : constant := 1;

   Endianness_BIG    : constant := 0;
   Endianness_LITTLE : constant := 1;

   External_Hit_Delay_NotSampledInside : constant := 0;
   External_Hit_Delay_SampledInside    : constant := 1;

   CPU_WriteRate_DXDXDXDX : constant := 0;
   CPU_WriteRate_DDDD     : constant := 1;

   PCI_0_Override_Normal   : constant := 2#00#; -- Normal address decoding
   PCI_0_Override_1G       : constant := 2#01#; -- 1Gbyte PCI_0 Mem0 space
   PCI_0_Override_2G       : constant := 2#10#; -- 2Gbyte PCI_0 Mem0 space
   PCI_0_Override_Reserved : constant := 2#11#; -- Reserved

   PCI_1_Override_Normal   : constant := 2#00#; -- Normal address decoding
   PCI_1_Override_1G       : constant := 2#01#; -- 1Gbyte PCI_1 Mem0 space
   PCI_1_Override_2G       : constant := 2#10#; -- 2Gbyte PCI_1 Mem0 space
   PCI_1_Override_Reserved : constant := 2#11#; -- Reserved

   type CPU_Interface_Configuration_Type is record
      CacheOpMap         : Bits_9  := 0;     -- Cache Operation Mapping
      CachePres          : Boolean := False; -- Secondary Cache support
      Reserved1          : Bits_1  := 0;
      WriteMode          : Bits_1  := 0;
      Endianness         : Bits_1  := 0;     -- Byte Orientation
      Reserved2          : Bits_1  := 0;
      R5KL2              : Boolean := False; -- Second level cache present.
      External_Hit_Delay : Bits_1  := 0;     -- Register Second Level Cache Hit Signal
      CPU_WriteRate      : Bits_1  := 0;     -- CPU Data Write Rate
      Stop_Retry         : Boolean := False; -- Relevant only if PCI Retry was enabled (DAdr[6] was sampled 0 at reset).
      MultiGT            : Boolean := False; -- Multiple GT–64120A support
      SysADCValid        : Boolean := False; -- GT–64120A to CPU SysADC Connection
      PCI_0_Override     : Bits_2  := 0;     -- PCI_0_Override
      Reserved3          : Bits_2  := 0;
      PCI_1_Override     : Bits_2  := 0;     -- PCI_1_Override
      Reserved4          : Bits_6  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CPU_Interface_Configuration_Type use record
      CacheOpMap         at 0 range  0 ..  8;
      CachePres          at 0 range  9 ..  9;
      Reserved1          at 0 range 10 .. 10;
      WriteMode          at 0 range 11 .. 11;
      Endianness         at 0 range 12 .. 12;
      Reserved2          at 0 range 13 .. 13;
      R5KL2              at 0 range 14 .. 14;
      External_Hit_Delay at 0 range 15 .. 15;
      CPU_WriteRate      at 0 range 16 .. 16;
      Stop_Retry         at 0 range 17 .. 17;
      MultiGT            at 0 range 18 .. 18;
      SysADCValid        at 0 range 19 .. 19;
      PCI_0_Override     at 0 range 20 .. 21;
      Reserved3          at 0 range 22 .. 23;
      PCI_1_Override     at 0 range 24 .. 25;
      Reserved4          at 0 range 26 .. 31;
   end record;

   function To_U32
      (Value : CPU_Interface_Configuration_Type)
      return Unsigned_32
      with Inline => True;
   function To_CPUIC
      (Value : Unsigned_32)
      return CPU_Interface_Configuration_Type
      with Inline => True;

   -- 20.4 CPU Address Decode

   type PCI_Low_Decode_Address_Type is record
      Low      : Bits_15 := 0; -- The PCI_0 I/O address space is accessed when the decoded addresses are between Low and High.
      Reserved : Bits_17 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PCI_Low_Decode_Address_Type use record
      Low      at 0 range  0 .. 14;
      Reserved at 0 range 15 .. 31;
   end record;

   function To_U32
      (Value : PCI_Low_Decode_Address_Type)
      return Unsigned_32
      with Inline => True;
   function To_PCILD
      (Value : Unsigned_32)
      return PCI_Low_Decode_Address_Type
      with Inline => True;

   type PCI_High_Decode_Address_Type is record
      High     : Bits_7  := 0; -- The PCI_0 I/O address space is accessed when the decoded addresses are between Low and High.
      Reserved : Bits_25 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PCI_High_Decode_Address_Type use record
      High     at 0 range 0 ..  6;
      Reserved at 0 range 7 .. 31;
   end record;

   function To_U32
      (Value : PCI_High_Decode_Address_Type)
      return Unsigned_32
      with Inline => True;
   function To_PCIHD
      (Value : Unsigned_32)
      return PCI_High_Decode_Address_Type
      with Inline => True;

   -- 20.16 PCI Internal

   SyncMode_Default : constant := 2#000#; -- Default mode.
   SyncMode_2       : constant := 2#001#; -- When PCLK is >= TCLK/2
   SyncMode_SYNC2   : constant := 2#010#; -- When the two clocks are synchronized and PCLK >= TCLK/2
   SyncMode_3       : constant := 2#101#; -- When TCLK/2 > PCLK >= TCLK/3.
   SyncMode_SYNC3   : constant := 2#110#; -- When the two clocks are synchronized and TCLK/2 > PCLK >= TCLK/3.

   DRAMtoPCIErr_ALWAYS : constant := 0; -- PAR is always driven by the GT–64120A with even parity matching the address/data
   DRAMtoPCIErr_ECC    : constant := 1; -- In case of PCI read ... GT–64120A drives PAR with parity NOT matching the data

   type PCI_0_Command_Type is record
      MByteSwap    : Boolean := False; -- Master Byte Swap.
      SyncMode     : Bits_3  := 0;     -- Indicates the ratio between TClk and PClk
      Reserved1    : Bits_4  := 0;
      Reserved2    : Bits_2  := 0;
      MWordSwap    : Boolean := False; -- Master Word Swap
      SWordSwap    : Boolean := False; -- Slave Word Swap
      SSBWordSwap  : Boolean := False; -- Slave Swap BAR Word Swap.
      Reserved3    : Bits_3  := 0;
      SByteSwap    : Boolean := False; -- Slave Byte Swap.
      Reserved4    : Bits_9  := 0;
      DRAMtoPCIErr : Bits_1  := 0;     -- Propagate SDRAM ECC errors to PCI
      Reserved5    : Bits_5  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PCI_0_Command_Type use record
      MByteSwap    at 0 range  0 ..  0;
      SyncMode     at 0 range  1 ..  3;
      Reserved1    at 0 range  4 ..  7;
      Reserved2    at 0 range  8 ..  9;
      MWordSwap    at 0 range 10 .. 10;
      SWordSwap    at 0 range 11 .. 11;
      SSBWordSwap  at 0 range 12 .. 12;
      Reserved3    at 0 range 13 .. 15;
      SByteSwap    at 0 range 16 .. 16;
      Reserved4    at 0 range 17 .. 25;
      DRAMtoPCIErr at 0 range 26 .. 26;
      Reserved5    at 0 range 27 .. 31;
   end record;

   -- 20.2 Register Maps

pragma Warnings (Off, "* bits of ""GT64120_Type"" unused");
   type GT64120_Type is record
      CPU_Interface_Configuration    : CPU_Interface_Configuration_Type with Volatile_Full_Access => True;
      PCI_0_IO_Low_Decode_Address    : PCI_Low_Decode_Address_Type      with Volatile_Full_Access => True;
      PCI_0_IO_High_Decode_Address   : PCI_High_Decode_Address_Type     with Volatile_Full_Access => True;
      PCI_0_MEM0_Low_Decode_Address  : PCI_Low_Decode_Address_Type      with Volatile_Full_Access => True;
      PCI_0_MEM0_High_Decode_Address : PCI_High_Decode_Address_Type     with Volatile_Full_Access => True;
      ISD                            : Unsigned_32                      with Volatile_Full_Access => True;
      PCI_0_MEM1_Low_Decode_Address  : PCI_Low_Decode_Address_Type      with Volatile_Full_Access => True;
      PCI_0_MEM1_High_Decode_Address : PCI_High_Decode_Address_Type     with Volatile_Full_Access => True;
      PCI_1_IO_Low_Decode_Address    : PCI_Low_Decode_Address_Type      with Volatile_Full_Access => True;
      PCI_1_IO_High_Decode_Address   : PCI_High_Decode_Address_Type     with Volatile_Full_Access => True;
      PCI_1_MEM0_Low_Decode_Address  : PCI_Low_Decode_Address_Type      with Volatile_Full_Access => True;
      PCI_1_MEM0_High_Decode_Address : PCI_High_Decode_Address_Type     with Volatile_Full_Access => True;
      PCI_1_MEM1_Low_Decode_Address  : PCI_Low_Decode_Address_Type      with Volatile_Full_Access => True;
      PCI_1_MEM1_High_Decode_Address : PCI_High_Decode_Address_Type     with Volatile_Full_Access => True;
      MULTIGT                        : Unsigned_32                      with Volatile_Full_Access => True;
      SDRAMC                         : Unsigned_32                      with Volatile_Full_Access => True;
      SDRAMOM                        : Unsigned_32                      with Volatile_Full_Access => True;
      SDRAMBM                        : Unsigned_32                      with Volatile_Full_Access => True;
      SDRAMAD                        : Unsigned_32                      with Volatile_Full_Access => True;
      PCI_0_Command                  : PCI_0_Command_Type               with Volatile_Full_Access => True;
   end record
      with Alignment => 4,
           Size      => 16#CA0# * 8;
   for GT64120_Type use record
      CPU_Interface_Configuration    at 16#000# range 0 .. 31;
      PCI_0_IO_Low_Decode_Address    at 16#048# range 0 .. 31;
      PCI_0_IO_High_Decode_Address   at 16#050# range 0 .. 31;
      PCI_0_MEM0_Low_Decode_Address  at 16#058# range 0 .. 31;
      PCI_0_MEM0_High_Decode_Address at 16#060# range 0 .. 31;
      ISD                            at 16#068# range 0 .. 31;
      PCI_0_MEM1_Low_Decode_Address  at 16#080# range 0 .. 31;
      PCI_0_MEM1_High_Decode_Address at 16#088# range 0 .. 31;
      PCI_1_IO_Low_Decode_Address    at 16#090# range 0 .. 31;
      PCI_1_IO_High_Decode_Address   at 16#098# range 0 .. 31;
      PCI_1_MEM0_Low_Decode_Address  at 16#0A0# range 0 .. 31;
      PCI_1_MEM0_High_Decode_Address at 16#0A8# range 0 .. 31;
      PCI_1_MEM1_Low_Decode_Address  at 16#0B0# range 0 .. 31;
      PCI_1_MEM1_High_Decode_Address at 16#0B8# range 0 .. 31;
      MULTIGT                        at 16#120# range 0 .. 31;
      SDRAMC                         at 16#448# range 0 .. 31;
      SDRAMOM                        at 16#474# range 0 .. 31;
      SDRAMBM                        at 16#478# range 0 .. 31;
      SDRAMAD                        at 16#47C# range 0 .. 31;
      PCI_0_Command                  at 16#C00# range 0 .. 31;
   end record;
pragma Warnings (On, "* bits of ""GT64120_Type"" unused");

   -- Subprograms

   procedure CPUIC_Read
      (A     : in     Address;
       CPUIC :    out CPU_Interface_Configuration_Type);
   procedure CPUIC_Write
      (A     : in Address;
       CPUIC : in CPU_Interface_Configuration_Type);

   function Make_PCILD
      (Start_Address : Unsigned_64)
      return PCI_Low_Decode_Address_Type;
   function Make_PCIHD
      (Start_Address : Unsigned_64;
       Size          : Unsigned_64)
      return PCI_High_Decode_Address_Type;

pragma Style_Checks (On);

end GT64120;
