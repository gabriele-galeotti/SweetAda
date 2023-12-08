-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ piix.ads                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;

package PIIX is

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

   ----------------------------------------------------------------------------
   -- function 0: PCI-to-ISA Bridge
   ----------------------------------------------------------------------------

   -- 2.2.9. XBCS—X-BUS CHIP SELECT REGISTER (Function 0)

   type XBCS_Type is record
      RTC       : Boolean;     -- RTC Address Location Enable.
      KBDC      : Boolean;     -- Keyboard Controller Address Location Enable.
      BIOSCS_WP : Boolean;     -- BIOSCS# Write Protect Enable.
      Reserved1 : Bits_1 := 0;
      IRQ12M    : Boolean;     -- IRQ12/M Mouse Function Enable.
      COPROCERR : Boolean;     -- Coprocessor Error function Enable.
      LOBIOS    : Boolean;     -- Lower BIOS Enable.
      EXTBIOS   : Boolean;     -- Extended BIOS Enable.
      APIC      : Boolean;     -- PIIX3: APIC Chip Select.
      Reserved2 : Bits_7 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for XBCS_Type use record
      RTC       at 0 range 0 .. 0;
      KBDC      at 0 range 1 .. 1;
      BIOSCS_WP at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 3;
      IRQ12M    at 0 range 4 .. 4;
      COPROCERR at 0 range 5 .. 5;
      LOBIOS    at 0 range 6 .. 6;
      EXTBIOS   at 0 range 7 .. 7;
      APIC      at 0 range 8 .. 8;
      Reserved2 at 0 range 9 .. 15;
   end record;

   -- 2.2.10. PIRQRC[A:D]—PIRQx ROUTE CONTROL REGISTERS (Function 0)

   IRQROUTE_RESERVED1  : constant := 2#0000#; -- Reserved
   IRQROUTE_RESERVED2  : constant := 2#0001#; -- Reserved
   IRQROUTE_RESERVED3  : constant := 2#0010#; -- Reserved
   IRQROUTE_IRQ3       : constant := 2#0011#; -- IRQ3
   IRQROUTE_IRQ4       : constant := 2#0100#; -- IRQ4
   IRQROUTE_IRQ5       : constant := 2#0101#; -- IRQ5
   IRQROUTE_IRQ6       : constant := 2#0110#; -- IRQ6
   IRQROUTE_IRQ7       : constant := 2#0111#; -- IRQ7
   IRQROUTE_RESERVED8  : constant := 2#1000#; -- Reserved
   IRQROUTE_IRQ9       : constant := 2#1001#; -- IRQ9
   IRQROUTE_IRQ10      : constant := 2#1010#; -- IRQ10
   IRQROUTE_IRQ11      : constant := 2#1011#; -- IRQ11
   IRQROUTE_IRQ12      : constant := 2#1100#; -- IRQ12
   IRQROUTE_RESERVED13 : constant := 2#1000#; -- Reserved
   IRQROUTE_IRQ14      : constant := 2#1110#; -- IRQ14
   IRQROUTE_IRQ15      : constant := 2#1111#; -- IRQ15

   type PIRQC_Type is record
      IRQROUTE   : Bits_4;      -- Interrupt Routing.
      Reserved   : Bits_3 := 0;
      IRQROUTEEN : NBoolean;    -- Interrupt Routing Enable. 0=Enable; 1=Disable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PIRQC_Type use record
      IRQROUTE   at 0 range 0 .. 3;
      Reserved   at 0 range 4 .. 6;
      IRQROUTEEN at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (PIRQC_Type, Unsigned_8);

   -- 2.2.11. TOM—TOP OF MEMORY REGISTER (Function 0)

   TOM_MB1  : constant := 2#0000#; -- 1 Mbyte
   TOM_MB2  : constant := 2#0001#; -- 2 Mbyte
   TOM_MB3  : constant := 2#0010#; -- 3 Mbyte
   TOM_MB4  : constant := 2#0011#; -- 4 Mbyte
   TOM_MB5  : constant := 2#0100#; -- 5 Mbyte
   TOM_MB6  : constant := 2#0101#; -- 6 Mbyte
   TOM_MB7  : constant := 2#0110#; -- 7 Mbyte
   TOM_MB8  : constant := 2#0111#; -- 8 Mbyte
   TOM_MB9  : constant := 2#1000#; -- 9 Mbyte
   TOM_MB10 : constant := 2#1001#; -- 10 Mbyte
   TOM_MB11 : constant := 2#1010#; -- 11 Mbyte
   TOM_MB12 : constant := 2#1011#; -- 12 Mbyte
   TOM_MB13 : constant := 2#1100#; -- 13 Mbyte
   TOM_MB14 : constant := 2#1100#; -- 14 Mbyte
   TOM_MB15 : constant := 2#1110#; -- 15 Mbyte
   TOM_MB16 : constant := 2#1111#; -- 16 Mbyte

   type TOM_Type is record
      Reserved        : Bits_1 := 0;
      ISADMAFWD       : Boolean;     -- ISA/DMA 512–640-Kbyte Region Forwarding Enable.
      ABSEGFWD        : Boolean;     -- PIIX3: A,B Segment Forwarding Enable.
      ISADMALOBIOSFWD : Boolean;     -- ISA/DMA Lower BIOS Forwarding Enable.
      TOM             : Bits_4;      -- Top Of Memory.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TOM_Type use record
      Reserved        at 0 range 0 .. 0;
      ISADMAFWD       at 0 range 1 .. 1;
      ABSEGFWD        at 0 range 2 .. 2;
      ISADMALOBIOSFWD at 0 range 3 .. 3;
      TOM             at 0 range 4 .. 7;
   end record;

   -- 2.2.13. MBIRQ[1:0]—MOTHERBOARD DEVICE IRQ ROUTE CONTROL REGISTERS (Function 0)

   -- use IRQROUTE_IRQx constants from PIRQC_Type

   type MBIRQ_Type is record
      IRQROUTE   : Bits_4;      -- Interrupt Routing.
      Reserved   : Bits_1 := 0;
      IRQ0       : Boolean;     -- PIIX3: IRQ0 Enable
      MIRQSHARE  : Boolean;     -- MIRQx/IRQx Sharing Enable.
      IRQROUTEEN : NBoolean;    -- Interrupt Routing Enable.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MBIRQ_Type use record
      IRQROUTE   at 0 range 0 .. 3;
      Reserved   at 0 range 4 .. 4;
      IRQ0       at 0 range 5 .. 5;
      MIRQSHARE  at 0 range 6 .. 6;
      IRQROUTEEN at 0 range 7 .. 7;
   end record;

   -- 2.2.16. APICBASE—APIC BASE ADDRESS RELOCATION REGISTER (Function 0) (PIIX3 Only)

   type APICBASE_Type is record
      Y        : Bits_2;      -- Y-Base Address.
      X        : Bits_4;      -- X-Base Address.
      A12MASK  : Boolean;     -- A12 Mask.
      Reserved : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for APICBASE_Type use record
      Y        at 0 range 0 .. 1;
      X        at 0 range 2 .. 5;
      A12MASK  at 0 range 6 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   XBCS     : constant := 16#4E#;
   PIRQRCA  : constant := 16#60#;
   PIRQRCB  : constant := 16#61#;
   PIRQRCC  : constant := 16#62#;
   PIRQRCD  : constant := 16#63#;
   TOM      : constant := 16#69#;
   MBIRQ0   : constant := 16#70#; -- Motherboard IRQ Route Control 0 R/W
   MBIRQ1   : constant := 16#71#; -- Motherboard IRQ Route Control 1 (PIIX3) R/W
   APICBASE : constant := 16#80#; -- PIIX3

   ----------------------------------------------------------------------------
   -- function 1: IDE Interface
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- function 2: Universal Serial Bus Interface (PIIX3 only)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- subprograms
   ----------------------------------------------------------------------------

   function Probe
      return Boolean;
   procedure Init;

end PIIX;
