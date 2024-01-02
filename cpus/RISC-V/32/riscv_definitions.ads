-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ riscv_definitions.ads                                                                                     --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package RISCV_Definitions
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

   -- The RISC-V Instruction Set Manual
   -- Volume II: Privileged Architecture
   -- Document Version 20211203

   XLEN : constant := 32;

   subtype MXLEN_Type is Unsigned_32;

   -- 3.1.6 Machine Status Registers (mstatus and mstatush)

   -- FS field status encoding
   FS_OFF     : constant := 2#00#; -- Off
   FS_INITIAL : constant := 2#01#; -- Initial
   FS_CLEAN   : constant := 2#10#; -- Clean
   FS_DIRTY   : constant := 2#11#; -- Dirty

   -- VS field status encoding
   VS_OFF     : constant := 2#00#; -- Off
   VS_INITIAL : constant := 2#01#; -- Initial
   VS_CLEAN   : constant := 2#10#; -- Clean
   VS_DIRTY   : constant := 2#11#; -- Dirty

   -- XS field status encoding
   XS_ALLOFF                 : constant := 2#00#; -- All off
   XS_NONEDIRTYORCLEANSOMEON : constant := 2#01#; -- None dirty or clean, some on
   XS_NONEDIRTYSOMECLEAN     : constant := 2#10#; -- None dirty, some clean
   XS_SOMEDIRTY              : constant := 2#11#; -- Some dirty

   type mstatus_Type is record
      Reserved1 : Bits_1;  -- WPRI
      SIE       : Boolean; -- Supervisor Interrupt Enable
      Reserved2 : Bits_1;  -- WPRI
      MIE       : Boolean; -- Machine Interrupt Enable
      Reserved3 : Bits_1;  -- WPRI
      SPIE      : Boolean; -- Supervisor Previous Interrupt Enable
      UBE       : Bits_1;  -- U-mode big-endian
      MPIE      : Boolean; -- Machine Previous Interrupt Enabler
      SPP       : Boolean; -- Supervisor Previous Privilege
      VS        : Bits_2;  -- Vector Extension State
      MPP       : Bits_2;  -- Machine Previous Privilege
      FS        : Bits_2;  -- Floating Point State
      XS        : Bits_2;  -- User Mode Extension State
      MPRV      : Boolean; -- Modify PRiVilege
      SUM       : Boolean; -- Permit Supervisor User Memory Access
      MXR       : Boolean; -- Make Executable Readable
      TVM       : Boolean; -- Trap Virtual memory
      TW        : Boolean; -- Timeout Wait (traps S-Mode wfi)
      TSR       : Boolean; -- Trap SRET
      Reserved4 : Bits_8;  -- WPRI
      SD        : Boolean; -- State Dirty (FS and XS summary bit)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for mstatus_Type use record
      Reserved1 at 0 range  0 ..  0;
      SIE       at 0 range  1 ..  1;
      Reserved2 at 0 range  2 ..  2;
      MIE       at 0 range  3 ..  3;
      Reserved3 at 0 range  4 ..  4;
      SPIE      at 0 range  5 ..  5;
      UBE       at 0 range  6 ..  6;
      MPIE      at 0 range  7 ..  7;
      SPP       at 0 range  8 ..  8;
      VS        at 0 range  9 .. 10;
      MPP       at 0 range 11 .. 12;
      FS        at 0 range 13 .. 14;
      XS        at 0 range 15 .. 16;
      MPRV      at 0 range 17 .. 17;
      SUM       at 0 range 18 .. 18;
      MXR       at 0 range 19 .. 19;
      TVM       at 0 range 20 .. 20;
      TW        at 0 range 21 .. 21;
      TSR       at 0 range 22 .. 22;
      Reserved4 at 0 range 23 .. 30;
      SD        at 0 range 31 .. 31;
   end record;

   type mstatush_Type is record
      Reserved1 : Bits_4;  -- WPRI
      SBE       : Boolean; -- S-mode big-endian
      MBE       : Boolean; -- M-mode big-endian
      Reserved2 : Bits_26; -- WPRI
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for mstatush_Type use record
      Reserved1 at 0 range 0 ..  3;
      SBE       at 0 range 4 ..  4;
      MBE       at 0 range 5 ..  5;
      Reserved2 at 0 range 6 .. 31;
   end record;

   -- 3.1.7 Machine Trap-Vector Base-Address Register (mtvec)

   mtvec_BASE_ADDRESS_LSB : constant := 2;
   mtvec_BASE_ADDRESS_MSB : constant := 31;

   subtype mtvec_BASE_Type is Bits_30;

   type mtvec_Type is record
      MODE : Bits_2;          -- MODE Sets the interrupt processing mode.
      BASE : mtvec_BASE_Type; -- Interrupt Vector Base Address.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for mtvec_Type use record
      MODE at 0 range 0 .. 1;
      BASE at 0 range 2 .. 31;
   end record;

   -- 3.1.9 Machine Interrupt Registers (mip and mie)

   type mip_Type is record
      Reserved1 : Bits_1 := 0;  -- WARL
      SSIP      : Boolean;      -- supervisor-level software interrupt pending
      Reserved2 : Bits_1 := 0;  -- WARL
      MSIP      : Boolean;      -- machine-level software interrupt pending
      Reserved3 : Bits_1 := 0;  -- WARL
      STIP      : Boolean;      -- supervisor-level timer interrupt pending
      Reserved4 : Bits_1 := 0;  -- WARL
      MTIP      : Boolean;      -- machine timer interrupt pending
      Reserved5 : Bits_1 := 0;  -- WARL
      SEIP      : Boolean;      -- supervisor-level external interrupt pending
      Reserved6 : Bits_1 := 0;  -- WARL
      MEIP      : Boolean;      -- machine-level external interrupt pending
      Reserved7 : Bits_4 := 0;  -- WARL
      Reserved8 : Bits_16 := 0; -- WARL
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for mip_Type use record
      Reserved1 at 0 range  0 ..  0;
      SSIP      at 0 range  1 ..  1;
      Reserved2 at 0 range  2 ..  2;
      MSIP      at 0 range  3 ..  3;
      Reserved3 at 0 range  4 ..  4;
      STIP      at 0 range  5 ..  5;
      Reserved4 at 0 range  6 ..  6;
      MTIP      at 0 range  7 ..  7;
      Reserved5 at 0 range  8 ..  8;
      SEIP      at 0 range  9 ..  9;
      Reserved6 at 0 range 10 .. 10;
      MEIP      at 0 range 11 .. 11;
      Reserved7 at 0 range 12 .. 15;
      Reserved8 at 0 range 16 .. 31;
   end record;

   type mie_Type is record
      Reserved1 : Bits_1 := 0;  -- WARL
      SSIE      : Boolean;      -- supervisor-level software interrupt enable
      Reserved2 : Bits_1 := 0;  -- WARL
      MSIE      : Boolean;      -- machine-level software interrupt enable
      Reserved3 : Bits_1 := 0;  -- WARL
      STIE      : Boolean;      -- supervisor-level timer interrupt enable
      Reserved4 : Bits_1 := 0;  -- WARL
      MTIE      : Boolean;      -- machine timer interrupt enable
      Reserved5 : Bits_1 := 0;  -- WARL
      SEIE      : Boolean;      -- supervisor-level external interrupt enable
      Reserved6 : Bits_1 := 0;  -- WARL
      MEIE      : Boolean;      -- machine-level external interrupt enable
      Reserved7 : Bits_4 := 0;  -- WARL
      Reserved8 : Bits_16 := 0; -- WARL
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for mie_Type use record
      Reserved1 at 0 range  0 ..  0;
      SSIE      at 0 range  1 ..  1;
      Reserved2 at 0 range  2 ..  2;
      MSIE      at 0 range  3 ..  3;
      Reserved3 at 0 range  4 ..  4;
      STIE      at 0 range  5 ..  5;
      Reserved4 at 0 range  6 ..  6;
      MTIE      at 0 range  7 ..  7;
      Reserved5 at 0 range  8 ..  8;
      SEIE      at 0 range  9 ..  9;
      Reserved6 at 0 range 10 .. 10;
      MEIE      at 0 range 11 .. 11;
      Reserved7 at 0 range 12 .. 15;
      Reserved8 at 0 range 16 .. 31;
   end record;

   -- 3.1.15 Machine Cause Register (mcause)

   subtype mcause_Exception_Code_Type is Bits_31;

   type mcause_Type is record
      Exception_Code : mcause_Exception_Code_Type; -- A code identifying the last exception.
      Interrupt      : Boolean;                    -- 1, if the trap was caused by an interrupt; 0 otherwise.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for mcause_Type use record
      Exception_Code at 0 range  0 .. 30;
      Interrupt      at 0 range 31 .. 31;
   end record;

   -- 3.2.1 Machine Timer Registers (mtime and mtimecmp)

   type mtime_Type is record
      L : Unsigned_32 with Volatile_Full_Access => True;
      H : Unsigned_32 with Volatile_Full_Access => True;
   end record
      with Size => 64;
   for mtime_Type use record
      L at BE_ByteOrder * 4 + LE_ByteOrder * 0 range 0 .. 31;
      H at BE_ByteOrder * 0 + LE_ByteOrder * 4 range 0 .. 31;
   end record;

end RISCV_Definitions;
