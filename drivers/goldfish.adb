-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ goldfish.adb                                                                                              --
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

with LLutils;

package body Goldfish
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
      (TIME_LOW,
       TIME_HIGH,
       ALARM_LOW,
       ALARM_HIGH,
       IRQ_ENABLED,
       CLEAR_ALARM,
       ALARM_STATUS,
       CLEAR_INTERRUPT);
   for Register_Type use
      (16#00#, 16#04#, 16#08#, 16#0C#, 16#10#, 16#14#, 16#18#, 16#1C#);

   -- Register_Read/Write

   function Register_Read
      (D : Descriptor_Type;
       R : Register_Type)
      return Unsigned_32
      with Inline => True;

   procedure Register_Write
      (D     : in Descriptor_Type;
       R     : in Register_Type;
       Value : in Unsigned_32)
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
      return Unsigned_32
      is
   begin
      return D.Read_32 (Build_Address (
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
       Value : in Unsigned_32)
      is
   begin
      D.Write_32 (Build_Address (
         D.Base_Address,
         Register_Type'Enum_Rep (R),
         D.Scale_Address),
         Value
         );
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Read_Clock
   ----------------------------------------------------------------------------
   -- strictly adhere to Goldfish RTC specifications
   ----------------------------------------------------------------------------
   procedure Read_Clock
      (D : in     Descriptor_Type;
       T :    out Time.TM_Time)
      is
      Time_L  : Unsigned_32;
      Time_H  : Unsigned_32;
      Time_ns : Integer_64;
   begin
      Time_L  := Register_Read (D, TIME_LOW);
      Time_H  := Register_Read (D, TIME_HIGH);
      Time_ns := Integer_64 (Make_Word (Time_H, Time_L));
      Time.Make_Time (Unsigned_32 (Time_ns / 10**9), T);
      T.IsDST := 0;
      T.YDay  := 0;
   end Read_Clock;

end Goldfish;
