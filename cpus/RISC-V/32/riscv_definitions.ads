-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ riscv_definitions.ads                                                                                     --
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
with Interfaces;
with Bits;

package RISCV_Definitions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Pure;

   use System;
   use Interfaces;
   use Bits;

   XLEN : constant := 32;

   -- Machine Status (mstatus)

   type mstatus_Type is
   record
      UIE       : Boolean;     -- User Interrupt Enable
      SIE       : Boolean;     -- Supervisor Interrupt Enable
      Reserved1 : Bits_1 := 0;
      MIE       : Boolean;     -- Machine Interrupt Enable
      UPIE      : Boolean;     -- User Previous Interrupt Enable
      SPIE      : Boolean;     -- Supervisor Previous Interrupt Enable
      Reserved2 : Bits_1 := 0;
      MPIE      : Boolean;     -- Machine Previous Interrupt Enabler
      SPP       : Boolean;     -- Supervisor Previous Privilege
      Reserved3 : Bits_2 := 0;
      MPP       : Bits_2;      -- Machine Previous Privilege
      FS        : Bits_2;      -- Floating Point State
      XS        : Bits_2;      -- User Mode Extension State
      MPRIV     : Boolean;     -- Modify Privilege (access memory as MPP)
      SUM       : Boolean;     -- Permit Supervisor User Memory Access
      MXR       : Boolean;     -- Make Executable Readable
      TVM       : Boolean;     -- Trap Virtual memory
      TW        : Boolean;     -- Timeout Wait (traps S-Mode wfi)
      TSR       : Boolean;     -- Trap SRET
      Reserved4 : Bits_8 := 0;
      SD        : Boolean;     -- State Dirty (FS and XS summary bit)
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for mstatus_Type use
   record
      UIE       at 0 range 0 .. 0;
      SIE       at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 2;
      MIE       at 0 range 3 .. 3;
      UPIE      at 0 range 4 .. 4;
      SPIE      at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      MPIE      at 0 range 7 .. 7;
      SPP       at 0 range 8 .. 8;
      Reserved3 at 0 range 9 .. 10;
      MPP       at 0 range 11 .. 12;
      FS        at 0 range 13 .. 14;
      XS        at 0 range 15 .. 16;
      MPRIV     at 0 range 17 .. 17;
      SUM       at 0 range 18 .. 18;
      MXR       at 0 range 19 .. 19;
      TVM       at 0 range 20 .. 20;
      TW        at 0 range 21 .. 21;
      TSR       at 0 range 22 .. 22;
      Reserved4 at 0 range 23 .. 30;
      SD        at 0 range 31 .. 31;
   end record;

   -- mtime

   type mtime_Type is
   record
      L : Unsigned_32 with Volatile_Full_Access => True;
      H : Unsigned_32 with Volatile_Full_Access => True;
   end record with
      Size => 64;
   for mtime_Type use
   record
      L at BE_ByteOrder * 4 + LE_ByteOrder * 0 range 0 .. 31;
      H at BE_ByteOrder * 0 + LE_ByteOrder * 4 range 0 .. 31;
   end record;

end RISCV_Definitions;
