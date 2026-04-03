-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ s390.ads                                                                                                  --
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

package S390
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

   ----------------------------------------------------------------------------
   -- Enterprise Systems Architecture/390 (TM)
   -- Principles of Operation
   -- SA22-7201-08
   ----------------------------------------------------------------------------

   type PSW_Type is record
      Reserved1   : Bits_32;
      Reserved2   : Bits_1;
      New_Address : Bits_31;
   end record
      with Alignment   => 8,
           Bit_Order   => High_Order_First,
           Object_Size => 64;
   for PSW_Type use record
      Reserved1   at 0 range  0 .. 31;
      Reserved2   at 0 range 32 .. 32;
      New_Address at 0 range 33 .. 63;
   end record;

   type RMS_Assigned_Locations_Type is record
      Restart_New_PSW                   : PSW_Type;
      Restart_Old_PSW                   : PSW_Type;
      Reserved                          : PSW_Type;
      External_Old_PSW                  : PSW_Type;
      Supervisor_Call_Old_PSW           : PSW_Type;
      Program_Old_PSW                   : PSW_Type;
      Machine_Check_Old_PSW             : PSW_Type;
      Input_Output_Old_PSW              : PSW_Type;
      External_New_PSW                  : PSW_Type;
      Supervisor_Call_Interruption_Code : Unsigned_16;
      IO_Address                        : Unsigned_16;
   end record
      with Alignment   => 8,
           Object_Size => 192 * 8;
   for RMS_Assigned_Locations_Type use record
      Restart_New_PSW                   at   0 range 0 .. 63;
      Restart_Old_PSW                   at   8 range 0 .. 63;
      Reserved                          at  16 range 0 .. 63;
      External_Old_PSW                  at  24 range 0 .. 63;
      Supervisor_Call_Old_PSW           at  32 range 0 .. 63;
      Program_Old_PSW                   at  40 range 0 .. 63;
      Machine_Check_Old_PSW             at  48 range 0 .. 63;
      Input_Output_Old_PSW              at  56 range 0 .. 63;
      External_New_PSW                  at  88 range 0 .. 63;
      Supervisor_Call_Interruption_Code at 138 range 0 .. 15;
      IO_Address                        at 186 range 0 .. 15;
   end record;

   RMS_Assigned_Locations : aliased RMS_Assigned_Locations_Type
      with Address    => System'To_Address (0),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

---------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Intcontext_Type is Integer;

   procedure Irq_Enable;
   procedure Irq_Disable;

pragma Style_Checks (On);

end S390;
