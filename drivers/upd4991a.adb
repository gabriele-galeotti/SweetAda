-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ rtc.adb                                                                                                   --
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

with Ada.Unchecked_Conversion;
with LLutils;

package body uPD4991A
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use LLutils;

   ----------------------------------------------------------------------------
   -- Register data types
   ----------------------------------------------------------------------------

   type Register_Type is
      (S1,  S10, MI1,  MI10, H1, H10, DATE, D1,
       D10, MO1, MO10, Y1, Y10, CR1, CR2, MODE);
   for Register_Type use
      (16#0#, 16#1#, 16#2#, 16#3#, 16#4#, 16#5#, 16#6#, 16#7#,
       16#8#, 16#9#, 16#A#, 16#B#, 16#C#, 16#D#, 16#E#, 16#F#);

   -- register data type for S1, MI1, H1, D1, MO1, Y1, Y10
   type DATA4_Type is record
      DATA   : Bits_4;
      Unused : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DATA4_Type use record
      DATA   at 0 range 0 .. 3;
      Unused at 0 range 4 .. 7;
   end record;

   -- register data type for S10, MI10, W
   type DATA3_Type is record
      DATA   : Bits_3;
      Unused : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DATA3_Type use record
      DATA   at 0 range 0 .. 2;
      Unused at 0 range 3 .. 7;
   end record;

   -- register data type for H10
   type H10_Type is record
      H      : Bits_2;
      PM_AM  : Bits_1;
      Unused : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for H10_Type use record
      H      at 0 range 0 .. 1;
      PM_AM  at 0 range 2 .. 2;
      Unused at 0 range 3 .. 7;
   end record;

   -- register data type for D10
   type D10_Type is record
      D      : Bits_2;
      Unused : Bits_6 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for D10_Type use record
      D      at 0 range 0 .. 1;
      Unused at 0 range 2 .. 7;
   end record;

   -- register data type for MO10
   type MO10_Type is record
      M      : Bits_1;
      Unused : Bits_7 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MO10_Type use record
      M      at 0 range 0 .. 0;
      Unused at 0 range 1 .. 7;
   end record;

   -- CONTROL REGISTER1 (TIME COUNTER CONTROL)
   type CR1_Type is record
      RESET      : Boolean := False;
      ADJUST     : Boolean := False; -- (+/–)30 s
      CLOCK_STOP : Boolean := False;
      WAIT       : Boolean := False;
      Unused     : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CR1_Type use record
      RESET      at 0 range 0 .. 0;
      ADJUST     at 0 range 1 .. 1;
      CLOCK_STOP at 0 range 2 .. 2;
      WAIT       at 0 range 3 .. 3;
      Unused     at 0 range 4 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (CR1_Type, Unsigned_8);

   -- modes for MODE
   MODE_BASIC1    : constant := 2#0000#; -- 0 * 0 0 BASIC TIME MODE
   MODE_ALRMTP1   : constant := 2#0001#; -- 0 * 0 1 ALARM SET & TP1 CONTROL MODE
   MODE_ALRMTP2   : constant := 2#0010#; -- 0 * 1 0 ALARM SET & TP2 CONTROL MODE
   MODE_BASIC2    : constant := 2#0011#; -- 0 * 1 1 BASIC TIME MODE
   MODE_INHIBITED : constant := 2#1000#; -- 1 * * * Inhibited

   -- Register_Read/Write

   function Register_Read
      (D : Descriptor_Type;
       R : Register_Type)
      return Unsigned_8
      with Inline => True;

   procedure Register_Write
      (D     : in Descriptor_Type;
       R     : in Register_Type;
       Value : in Unsigned_8)
      with Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Register_Read
   ----------------------------------------------------------------------------
   function Register_Read
      (D : Descriptor_Type;
       R : Register_Type)
      return Unsigned_8
      is
   begin
      return D.Read_8 (Build_Address (
                D.Base_Address,
                Register_Type'Enum_Rep (R),
                D.Scale_Address
                ));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Register_Write
      (D     : in Descriptor_Type;
       R     : in Register_Type;
       Value : in Unsigned_8)
      is
   begin
      D.Write_8 (Build_Address (
         D.Base_Address,
         Register_Type'Enum_Rep (R),
         D.Scale_Address),
         Value
         );
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Time_Read
   ----------------------------------------------------------------------------
   procedure Time_Read
      (D : in     Descriptor_Type;
       T :    out Time.TM_Time)
      is
   begin
      Register_Write (D, CR1, To_U8 (CR1_Type'(
         WAIT   => True,
         others => <>
         )));
      T.Sec   := Natural (To_U8 (BCD_Type (
                    (Register_Read (D, S1)  and 16#0F#)          or
                    ShL ((Register_Read (D, S10) and 16#0F#), 4)
                    )));
      T.Min   := Natural (To_U8 (BCD_Type (
                    (Register_Read (D, MI1) and 16#0F#)           or
                    ShL ((Register_Read (D, MI10) and 16#0F#), 4)
                    )));
      T.Hour  := Natural (To_U8 (BCD_Type (
                    (Register_Read (D, H1) and 16#0F#)           or
                    ShL ((Register_Read (D, H10) and 16#0F#), 4)
                    )));
      T.MDay  := Natural (To_U8 (BCD_Type (
                    (Register_Read (D, D1) and 16#0F#)           or
                    ShL ((Register_Read (D, D10) and 16#0F#), 4)
                    )));
      T.Mon   := Natural (To_U8 (BCD_Type (
                    (Register_Read (D, MO1) and 16#0F#)           or
                    ShL ((Register_Read (D, MO10) and 16#0F#), 4)
                    )));
      T.Year  := Natural (To_U8 (BCD_Type (
                    (Register_Read (D, Y1) and 16#0F#)           or
                    ShL ((Register_Read (D, Y10) and 16#0F#), 4)
                    )));
      Register_Write (D, CR1, To_U8 (CR1_Type'(
         WAIT   => False,
         others => <>
         )));
      T.Year  := @ + (if @ < 70 then 100 else 0);
      T.WDay  := 0;
      T.YDay  := 0;
      T.IsDST := 0;
   end Time_Read;

   ----------------------------------------------------------------------------
   -- Time_Set
   ----------------------------------------------------------------------------
   procedure Time_Set
      (D : in Descriptor_Type;
       T : in Time.TM_Time)
      is
   begin
      Register_Write (D, S1, Unsigned_8 (To_BCD (Unsigned_8 (T.Sec))));
      Register_Write (D, S10, ShR (Unsigned_8 (To_BCD (Unsigned_8 (T.Sec))), 4));
      Register_Write (D, MI1, Unsigned_8 (To_BCD (Unsigned_8 (T.Min))));
      Register_Write (D, MI10, ShR (Unsigned_8 (To_BCD (Unsigned_8 (T.Min))), 4));
      Register_Write (D, H1, Unsigned_8 (To_BCD (Unsigned_8 (T.Hour))));
      Register_Write (D, H10, ShR (Unsigned_8 (To_BCD (Unsigned_8 (T.Hour))), 4));
      Register_Write (D, D1, Unsigned_8 (To_BCD (Unsigned_8 (T.MDay))));
      Register_Write (D, D10, ShR (Unsigned_8 (To_BCD (Unsigned_8 (T.MDay))), 4));
      Register_Write (D, MO1, Unsigned_8 (To_BCD (Unsigned_8 (T.Mon))));
      Register_Write (D, MO10, ShR (Unsigned_8 (To_BCD (Unsigned_8 (T.Mon))), 4));
      Register_Write (D, Y1, Unsigned_8 (To_BCD (Unsigned_8 (T.Year - 100))));
      Register_Write (D, Y10, ShR (Unsigned_8 (To_BCD (Unsigned_8 (T.Year - 100))), 4));
   end Time_Set;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      (D : in out Descriptor_Type)
      is
   begin
      Register_Write (D, MODE, MODE_BASIC1);
      Register_Write (D, CR2, 0);
      Register_Write (D, CR1, 0);
   end Init;

end uPD4991A;
