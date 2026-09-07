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
      Branch_Address : Unsigned_64;
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for LR_Type use record
      Branch_Address at 0 range 0 .. 63;
   end record;

   -- 1.7 Count Register (CTR)

   type CTR_Type is record
      CTR : Unsigned_64;
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for CTR_Type use record
      CTR at 0 range 0 .. 63;
   end record;

   -- 1.8 Machine State Register (MSR)

   SF_32 : constant := 0; -- The 64-bit processor runs in 32-bit mode.
   SF_64 : constant := 1; -- The 64-bit processor runs in 64-bit mode.

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
      SF        : Bits_1  := SF_64;
      Reserved1 : Bits_44 := 0;
      POW       : Boolean;          -- Power management enable
      Reserved2 : Bits_1  := 0;
      ILE       : Boolean;          -- Interrupt little-endian mode.
      EE        : Boolean;          -- External interrupt enable
      PR        : Bits_1;           -- Privilege level
      FP        : Boolean;          -- Floating-point available
      ME        : Boolean;          -- Machine check enable
      FE0       : Bits_1;           -- Floating-point exception mode 0
      SE        : Boolean;          -- Single-step trace enable (Optional)
      BE        : Boolean;          -- Branch trace enable (Optional)
      FE1       : Bits_1;           -- Floating-point exception mode 1
      Reserved3 : Bits_1  := 0;
      IP        : Bits_1;           -- Interrupt prefix
      IR        : Boolean;          -- Instruction address translation
      DR        : Boolean;          -- Data address translation
      Reserved4 : Bits_2  := 0;
      RI        : Boolean;          -- Recoverable interrupt
      LE        : Boolean;          -- Little-endian mode enable
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for MSR_Type use record
      SF        at 0 range  0 ..  0;
      Reserved1 at 0 range  1 .. 44;
      POW       at 0 range 45 .. 45;
      Reserved2 at 0 range 46 .. 46;
      ILE       at 0 range 47 .. 47;
      EE        at 0 range 48 .. 48;
      PR        at 0 range 49 .. 49;
      FP        at 0 range 50 .. 50;
      ME        at 0 range 51 .. 51;
      FE0       at 0 range 52 .. 52;
      SE        at 0 range 53 .. 53;
      BE        at 0 range 54 .. 54;
      FE1       at 0 range 55 .. 55;
      Reserved3 at 0 range 56 .. 56;
      IP        at 0 range 57 .. 57;
      IR        at 0 range 58 .. 58;
      DR        at 0 range 59 .. 59;
      Reserved4 at 0 range 60 .. 61;
      RI        at 0 range 62 .. 62;
      LE        at 0 range 63 .. 63;
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
      BEPI     : Bits_47;      -- Block effective page index.
      Reserved : Bits_4  := 0;
      BL       : Bits_11;      -- Block length.
      VS       : Boolean;      -- Supervisor mode valid bit.
      VP       : Boolean;      -- User mode valid bit.
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for UBAT_Type use record
      BEPI     at 0 range  0 .. 46;
      Reserved at 0 range 47 .. 50;
      BL       at 0 range 51 .. 61;
      VS       at 0 range 62 .. 62;
      VP       at 0 range 63 .. 63;
   end record;

   type LBAT_Type is record
      BRPN      : Bits_47;      -- This field is used in conjunction with the BL field to generate high-order bits of the physical address of the block.
      Reserved1 : Bits_10 := 0;
      W         : Boolean;      -- Memory/cache access mode bits Write-through
      I         : Boolean;      -- Memory/cache access mode bits Caching-inhibited
      M         : Boolean;      -- Memory/cache access mode bits Memory coherence
      G         : Boolean;      -- Memory/cache access mode bits Guarded
      Reserved2 : Bits_1  := 0;
      PP        : Bits_2;       -- Protection bits for block
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for LBAT_Type use record
      BRPN      at 0 range  0 .. 46;
      Reserved1 at 0 range 47 .. 56;
      W         at 0 range 57 .. 57;
      I         at 0 range 58 .. 58;
      M         at 0 range 59 .. 59;
      G         at 0 range 60 .. 60;
      Reserved2 at 0 range 61 .. 61;
      PP        at 0 range 62 .. 63;
   end record;

   -- 1.11 (2.3.3) SDR1

   type SDR1_Type is record
      HTABORG  : Bits_46 := 0; -- Physical base address of page table
      Reserved : Bits_13 := 0;
      HTABSIZE : Bits_5  := 0; -- Encoded size of page table (used to generate mask)
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for SDR1_Type use record
      HTABORG  at 0 range  0 .. 45;
      Reserved at 0 range 46 .. 58;
      HTABSIZE at 0 range 59 .. 63;
   end record;

   -- 1.12 (2.2.1.1) Address Space Register (ASR)

   type ASR_Type is record
      PAST     : Bits_52;      -- Physical Address of Segment Table
      Reserved : Bits_12 := 0;
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for ASR_Type use record
      PAST     at 0 range  0 .. 51;
      Reserved at 0 range 52 .. 63;
   end record;

   -- 1.13 Segment Registers (SRs)

   type SRx_Type is null record;

   -- 1.14 Data Address Register (DAR)

   type DAR_Type is record
      DAR : Unsigned_64; -- The effective address generated by a memory access instruction is placed in the DAR if the access causes an exception (for example, an alignment exception).
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for DAR_Type use record
      DAR at 0 range 0 .. 63;
   end record;

   -- 1.15 SPRG0–SPRG3

   type SPRGx_Type is record
      SPRG : Unsigned_64;
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for SPRGx_Type use record
      SPRG at 0 range 0 .. 63;
   end record;

   -- 1.17 Machine Status Save/Restore Register 0 (SRR0)

   -- __INF__ bits 62..63 are marked "Reserved", but since this is an
   -- instruction address that is always 32-bit aligned, include them
   -- in the SRR field to simplify the handling
   type SRR0_Type is record
      SRR : Unsigned_64; -- set to point to an instruction such that all prior instructions have completed execution and no subsequent instruction has begun execution.
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for SRR0_Type use record
      SRR at 0 range 0 .. 63;
   end record;

   -- 1.18 Machine Status Save/Restore Register 1 (SRR1)

   type SRR1_Type is record
      SRR : Unsigned_64; -- used to save machine status on exceptions and to restore machine status when an rfi instruction is executed.
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for SRR1_Type use record
      SRR at 0 range 0 .. 63;
   end record;

   -- 1.21 Data Address Breakpoint Register (DABR)

   type DABR_Type is record
      DAB : Bits_61 := 0;     -- Data address breakpoint
      BT  : Boolean := False; -- Breakpoint translation enable
      DW  : Boolean := False; -- Data write enable
      DR  : Boolean := False; -- Data read enable
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for DABR_Type use record
      DAB at 0 range  0 .. 60;
      BT  at 0 range 61 .. 61;
      DW  at 0 range 62 .. 62;
      DR  at 0 range 63 .. 63;
   end record;

pragma Style_Checks (On);

end PowerPC_Definitions;
