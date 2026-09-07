-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc_definitions.ads                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package PowerPC_Definitions
   with Pure => True
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

   -- 1.6 Link Register (LR)

   type LR_Type is record
      Branch_Address : Unsigned_32;
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for LR_Type use record
      Branch_Address at 0 range 0 .. 31;
   end record;

   -- 1.7 Count Register (CTR)

   type CTR_Type is record
      CTR : Unsigned_32;
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for CTR_Type use record
      CTR at 0 range 0 .. 31;
   end record;

   -- 1.8 Machine State Register (MSR)

   PR_US : constant := 0; -- The processor can execute both user- and supervisor-level instructions.
   PR_U  : constant := 1; -- The processor can only execute user-level instructions.

   type FE_Type is record
      FE0 : Bits_1;
      FE1 : Bits_1;
   end record;

   FE_DISABLED    : constant FE_Type := (0, 0); -- Floating-point exceptions disabled
   FE_IMPRECISENR : constant FE_Type := (0, 1); -- Floating-point imprecise nonrecoverable
   FE_IMPRECISE   : constant FE_Type := (1, 0); -- Floating-point imprecise recoverable
   FE_PRECISE     : constant FE_Type := (1, 1); -- Floating-point precise mode

   IP_LOW  : constant := 0; -- Interrupts are vectored to the physical address 0x000n_nnnn.
   IP_HIGH : constant := 1; -- Interrupts are vectored to the physical address 0xFFFn_nnnn.

   type MSR_Type is record
      Reserved1 : Bits_13 := 0;
      POW       : Boolean;      -- Power management enable
      Reserved2 : Bits_1  := 0;
      ILE       : Boolean;      -- Interrupt little-endian mode.
      EE        : Boolean;      -- External interrupt enable
      PR        : Bits_1;       -- Privilege level
      FP        : Boolean;      -- Floating-point available
      ME        : Boolean;      -- Machine check enable
      FE0       : Bits_1;       -- Floating-point exception mode 0
      SE        : Boolean;      -- Single-step trace enable (Optional)
      BE        : Boolean;      -- Branch trace enable (Optional)
      FE1       : Bits_1;       -- Floating-point exception mode 1
      Reserved3 : Bits_1  := 0;
      IP        : Bits_1;       -- Interrupt prefix
      IR        : Boolean;      -- Instruction address translation
      DR        : Boolean;      -- Data address translation
      Reserved4 : Bits_2  := 0;
      RI        : Boolean;      -- Recoverable interrupt
      LE        : Boolean;      -- Little-endian mode enable
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for MSR_Type use record
      Reserved1 at 0 range  0 .. 12;
      POW       at 0 range 13 .. 13;
      Reserved2 at 0 range 14 .. 14;
      ILE       at 0 range 15 .. 15;
      EE        at 0 range 16 .. 16;
      PR        at 0 range 17 .. 17;
      FP        at 0 range 18 .. 18;
      ME        at 0 range 19 .. 19;
      FE0       at 0 range 20 .. 20;
      SE        at 0 range 21 .. 21;
      BE        at 0 range 22 .. 22;
      FE1       at 0 range 23 .. 23;
      Reserved3 at 0 range 24 .. 24;
      IP        at 0 range 25 .. 25;
      IR        at 0 range 26 .. 26;
      DR        at 0 range 27 .. 27;
      Reserved4 at 0 range 28 .. 29;
      RI        at 0 range 30 .. 30;
      LE        at 0 range 31 .. 31;
   end record;

   -- 1.10 BAT Registers

   BL_128k : constant := 2#000_0000_0000#; -- 128 Kbytes
   BL_256k : constant := 2#000_0000_0001#; -- 256 Kbytes
   BL_512k : constant := 2#000_0000_0011#; -- 512 Kbytes
   BL_1M   : constant := 2#000_0000_0111#; -- 1 Mbyte
   BL_2M   : constant := 2#000_0000_1111#; -- 2 Mbytes
   BL_4M   : constant := 2#000_0001_1111#; -- 4 Mbytes
   BL_8M   : constant := 2#000_0011_1111#; -- 8 Mbytes
   BL_16M  : constant := 2#000_0111_1111#; -- 16 Mbytes
   BL_32M  : constant := 2#000_1111_1111#; -- 32 Mbytes
   BL_64M  : constant := 2#001_1111_1111#; -- 64 Mbytes
   BL_128M : constant := 2#011_1111_1111#; -- 128 Mbytes
   BL_256M : constant := 2#111_1111_1111#; -- 256 Mbytes

   type UBAT_Type is record
      BEPI     : Bits_15;      -- Block effective page index.
      Reserved : Bits_4  := 0;
      BL       : Bits_11;      -- Block length.
      VS       : Boolean;      -- Supervisor mode valid bit.
      VP       : Boolean;      -- User mode valid bit.
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for UBAT_Type use record
      BEPI     at 0 range  0 .. 14;
      Reserved at 0 range 15 .. 18;
      BL       at 0 range 19 .. 29;
      VS       at 0 range 30 .. 30;
      VP       at 0 range 31 .. 31;
   end record;

   type LBAT_Type is record
      BRPN      : Bits_15;       -- This field is used in conjunction with the BL field to generate high-order bits of the physical address of the block.
      Reserved1 : Bits_10 := 0;
      W         : Boolean;       -- Memory/cache access mode bits Write-through
      I         : Boolean;       -- Memory/cache access mode bits Caching-inhibited
      M         : Boolean;       -- Memory/cache access mode bits Memory coherence
      G         : Boolean;       -- Memory/cache access mode bits Guarded
      Reserved2 : Bits_1  := 0;
      PP        : Bits_2  := 0;  -- Protection bits for block
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for LBAT_Type use record
      BRPN      at 0 range  0 .. 14;
      Reserved1 at 0 range 15 .. 24;
      W         at 0 range 25 .. 25;
      I         at 0 range 26 .. 26;
      M         at 0 range 27 .. 27;
      G         at 0 range 28 .. 28;
      Reserved2 at 0 range 29 .. 29;
      PP        at 0 range 30 .. 31;
   end record;

   -- 1.11 (2.3.3) SDR1

   type SDR1_Type is record
      HTABORG  : Bits_16 := 0; -- Physical base address of page table
      Reserved : Bits_7  := 0;
      HTABMASK : Bits_9  := 0; -- Encoded size of page table (used to generate mask)
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for SDR1_Type use record
      HTABORG  at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 22;
      HTABMASK at 0 range 23 .. 31;
   end record;

   -- 1.12 (2.2.1.1) Address Space Register (ASR)

   type ASR_Type is null record;

   -- 1.13 Segment Registers (SRs)

   type SRx_Type is record
      T        : Bits_1  := 0; -- T = 0 selects this format
      Ks       : Boolean;      -- Supervisor-state protection key
      Kp       : Boolean;      -- User-state protection key
      N        : Boolean;      -- No-execute protection bit
      Reserved : Bits_4  := 0;
      VSID     : Bits_24;      -- Virtual segment ID
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for SRx_Type use record
      T        at 0 range 0 ..  0;
      Ks       at 0 range 1 ..  1;
      Kp       at 0 range 2 ..  2;
      N        at 0 range 3 ..  3;
      Reserved at 0 range 4 ..  7;
      VSID     at 0 range 8 .. 31;
   end record;

   -- 1.14 Data Address Register (DAR)

   type DAR_Type is record
      DAR : Unsigned_32; -- The effective address generated by a memory access instruction is placed in the DAR if the access causes an exception (for example, an alignment exception).
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for DAR_Type use record
      DAR at 0 range 0 .. 31;
   end record;

   -- 1.15 SPRG0–SPRG3

   type SPRGx_Type is record
      SPRG : Unsigned_32;
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for SPRGx_Type use record
      SPRG at 0 range 0 .. 31;
   end record;

   -- 1.17 Machine Status Save/Restore Register 0 (SRR0)

   -- __INF__ bits 30..31 are marked "Reserved", but since this is an
   -- instruction address that is always 32-bit aligned, include them
   -- in the SRR field to simplify the handling
   type SRR0_Type is record
      SRR : Unsigned_32; -- set to point to an instruction such that all prior instructions have completed execution and no subsequent instruction has begun execution.
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for SRR0_Type use record
      SRR at 0 range 0 .. 31;
   end record;

   -- 1.18 Machine Status Save/Restore Register 1 (SRR1)

   type SRR1_Type is record
      SRR : Unsigned_32; -- used to save machine status on exceptions and to restore machine status when an rfi instruction is executed.
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for SRR1_Type use record
      SRR at 0 range 0 .. 31;
   end record;

   -- 1.21 Data Address Breakpoint Register (DABR)

   type DABR_Type is record
      DAB : Bits_29 := 0;     -- Data address breakpoint
      BT  : Boolean := False; -- Breakpoint translation enable
      DW  : Boolean := False; -- Data write enable
      DR  : Boolean := False; -- Data read enable
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for DABR_Type use record
      DAB at 0 range  0 .. 28;
      BT  at 0 range 29 .. 29;
      DW  at 0 range 30 .. 30;
      DR  at 0 range 31 .. 31;
   end record;

pragma Style_Checks (On);

end PowerPC_Definitions;
