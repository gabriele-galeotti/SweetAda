-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ rtc.adb                                                                                                   --
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
   -- Register types
   ----------------------------------------------------------------------------

   type Register_Type is
      (S1,  S10, MI1,  MI10, H1, H10, DATE, D1,
       D10, MO1, MO10, Y1, Y10, CR1, CR2, MODE);
   for Register_Type use
      (16#0#, 16#1#, 16#2#, 16#3#, 16#4#, 16#5#, 16#6#, 16#7#,
       16#8#, 16#9#, 16#A#, 16#B#, 16#C#, 16#D#, 16#E#, 16#F#);

   -- register type for S1, MI1, H1, D1, MO1, Y1, Y10
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

   -- register type for S10, MI10, W
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

   -- register type for H10
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

   -- register type for D10
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

   -- register type for MO10
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

   -- register type for CD
   type CD_Type is record
      HOLD     : Boolean;     -- inhibits the 1Hz clock to the S1 counter
      BUSY     : Boolean;     -- shows the interface condition with microcontroller/microprocessors.
      IRQ_FLAG : Boolean;     -- indicates that an interrupt has occurred to the microcomputer if IRQ = 1.
      ADJ30    : Boolean;     -- 30-second adjustment
      Unused   : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CD_Type use record
      HOLD     at 0 range 0 .. 0;
      BUSY     at 0 range 1 .. 1;
      IRQ_FLAG at 0 range 2 .. 2;
      ADJ30    at 0 range 3 .. 3;
      Unused   at 0 range 4 .. 7;
   end record;

   -- constants for CE
   ITRPT_STND_STD : constant := 0; -- fixed cycle wave-form with a low-level pulse width of 7.8125ms ...
   ITRPT_STND_INT : constant := 1; -- no fixed cycle
   T_2      : constant := 2#00#; -- Duty CYCLE of "0" level when ITRPT/STND bit is "0".
   T_128    : constant := 2#01#; -- ''
   T_7680   : constant := 2#10#; -- ''
   T_460800 : constant := 2#11#; -- ''

   -- register type for CE
   type CE_Type is record
      MASK       : Boolean;     -- This bit controls the STD.P output.
      ITRPT_STND : Bits_1;      -- used to switch the STD.P output between its two modes of operation
      T          : Bits_2;      -- determine the period of the STD.P output in both interrupt and Fixed timing ...
      Unused     : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CE_Type use record
      MASK       at 0 range 0 .. 0;
      ITRPT_STND at 0 range 1 .. 1;
      T          at 0 range 2 .. 3;
      Unused     at 0 range 4 .. 7;
   end record;

   -- constants for CF
   HOUR_MODE_12 : constant := 0; -- 12 hour mode is selected and the PM/AM bit is valid.
   HOUR_MODE_24 : constant := 1; -- 24 hour mode is selected and the PM/AM bit is invalid.

   -- register type for CF
   type CF_Type is record
      REST      : Boolean;     -- used to clear the clock's internal divider/counter of less than a second.
      STOP      : Boolean;     -- inhibits carries into the 8192Hz divider stage.
      HOUR_MODE : Bits_1;      -- selection of 24/12 hour time modes.
      TEST      : Boolean;     -- the input to the SECONDS counter comes from the counter/divider stage instead of ...
      Unused    : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CF_Type use record
      REST      at 0 range 0 .. 0;
      STOP      at 0 range 1 .. 1;
      HOUR_MODE at 0 range 2 .. 2;
      TEST      at 0 range 3 .. 3;
      Unused    at 0 range 4 .. 7;
   end record;

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
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Read_Clock
      (D : in     Descriptor_Type;
       T :    out Time.TM_Time)
      is
   begin
      T.Sec   := Natural (Register_Read (D, S1) and 16#0F#) +
                 Natural (Register_Read (D, S10) and 16#0F#) * 10;
      T.Min   := Natural (Register_Read (D, MI1) and 16#0F#) +
                 Natural (Register_Read (D, MI10) and 16#0F#) * 10;
      T.Hour  := Natural (Register_Read (D, H1) and 16#0F#) +
                 Natural (Register_Read (D, H10) and 16#0F#) * 10;
      T.MDay  := Natural (Register_Read (D, D1) and 16#0F#) +
                 Natural (Register_Read (D, D10) and 16#0F#) * 10;
      T.Mon   := Natural (Register_Read (D, MO1) and 16#0F#) +
                 Natural (Register_Read (D, MO10) and 16#0F#) * 10;
      T.Year  := Natural (Register_Read (D, Y1) and 16#0F#) +
                 Natural (Register_Read (D, Y10) and 16#0F#) * 10;
      T.Year  := @ + (if @ < 70 then 100 else 0);
      T.WDay  := 0;
      T.YDay  := 0;
      T.IsDST := 0;
   end Read_Clock;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      (D : in out Descriptor_Type)
      is
   begin
      Register_Write (D, MODE, 0);
      Register_Write (D, CR2, 0);
      Register_Write (D, CR1, 0);
   end Init;

end uPD4991A;
