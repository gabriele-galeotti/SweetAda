-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc.adb                                                                                                --
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

package body LibGCC
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use type System.Bit_Order;
   use type GCC.Types.SI_Type;
   use type GCC.Types.USI_Type;
   use type GCC.Types.DI_Type;
   use type GCC.Types.UDI_Type;

   type USI_2 is array (0 .. 1) of GCC.Types.USI_Type
      with Alignment => GCC.Types.UDI_Type'Alignment,
           Pack      => True;

   BigEndian    : constant Boolean := System.Default_Bit_Order = System.High_Order_First;
   LittleEndian : constant Boolean := System.Default_Bit_Order = System.Low_Order_First;
   -- BE_ByteOrder is 1 if target has big-endian bit order, else 0
   -- LE_ByteOrder is 1 if target has little-endian bit order, else 0
   BE_ByteOrder : constant := Boolean'Pos (BigEndian);
   LE_ByteOrder : constant := Boolean'Pos (LittleEndian);
   -- index offsets of 32-bit vector values
   HI64 : constant := BE_ByteOrder * 0 + LE_ByteOrder * 1;
   LO64 : constant := BE_ByteOrder * 1 + LE_ByteOrder * 0;

   procedure UMul32x32
      (M1 : in     GCC.Types.USI_Type;
       M2 : in     GCC.Types.USI_Type;
       RH :    out GCC.Types.USI_Type;
       RL :    out GCC.Types.USI_Type);

   function UMulSIDI3
      (M1 : GCC.Types.USI_Type;
       M2 : GCC.Types.USI_Type)
      return GCC.Types.UDI_Type;

   function UDivModDI4
      (N : in     GCC.Types.UDI_Type;
       D : in     GCC.Types.UDI_Type;
       R : in out GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- UMul32x32
   ----------------------------------------------------------------------------
   procedure UMul32x32
      (M1 : in     GCC.Types.USI_Type;
       M2 : in     GCC.Types.USI_Type;
       RH :    out GCC.Types.USI_Type;
       RL :    out GCC.Types.USI_Type)
      is
   separate;

   ----------------------------------------------------------------------------
   -- UMulSIDI3
   ----------------------------------------------------------------------------
   function UMulSIDI3
      (M1 : GCC.Types.USI_Type;
       M2 : GCC.Types.USI_Type)
      return GCC.Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- MulDI3
   ----------------------------------------------------------------------------
   function MulDI3
      (M1 : GCC.Types.UDI_Type;
       M2 : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UDivModDI4
   ----------------------------------------------------------------------------
   function UDivModDI4
      (N : in     GCC.Types.UDI_Type;
       D : in     GCC.Types.UDI_Type;
       R : in out GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- DivDI3
   ----------------------------------------------------------------------------
   function DivDI3
      (N : GCC.Types.DI_Type;
       D : GCC.Types.DI_Type)
      return GCC.Types.DI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- ModDI3
   ----------------------------------------------------------------------------
   function ModDI3
      (N : GCC.Types.DI_Type;
       D : GCC.Types.DI_Type)
      return GCC.Types.DI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UDivDI3
   ----------------------------------------------------------------------------
   function UDivDI3
      (N : GCC.Types.UDI_Type;
       D : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UModDI3
   ----------------------------------------------------------------------------
   function UModDI3
      (N : GCC.Types.UDI_Type;
       D : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- CmpDI2
   ----------------------------------------------------------------------------
   function CmpDI2
      (A : GCC.Types.DI_Type;
       B : GCC.Types.DI_Type)
      return GCC.Types.SI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UCmpDI2
   ----------------------------------------------------------------------------
   function UCmpDI2
      (A : GCC.Types.UDI_Type;
       B : GCC.Types.UDI_Type)
      return GCC.Types.SI_Type
      is
   separate;

end LibGCC;
