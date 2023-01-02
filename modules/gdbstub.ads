-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gdbstub.ads                                                                                               --
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

with Interfaces;

package Gdbstub is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   type Debug_Mode_Type is
      (
       DEBUG_NONE,
       DEBUG_ERROR,
       DEBUG_WARNING,
       DEBUG_BREAKPOINT,
       DEBUG_COMMAND,
       DEBUG_COMMUNICATION,
       DEBUG_BYPASS
      );

   type Target_State_Type is (TARGET_BREAKPOINT, TARGET_STOPPED);

   type Getchar_Ptr is access procedure (C : out Character);
   type Putchar_Ptr is access procedure (C : in Character);

   Enable_Flag : Integer := 0;

   procedure Enter_Stub (Cause : in Target_State_Type; Thread_ID : in Natural);
   procedure Init (
                   Getchar : in Getchar_Ptr;
                   Putchar : in Putchar_Ptr;
                   Mode    : in Debug_Mode_Type
                  );

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   PACKET_BUFFER_SIZE : constant := 1024;

   RX_Packet_Buffer : String (1 .. PACKET_BUFFER_SIZE) with
      Suppress_Initialization => True;
   RX_Packet_Length : Natural range 0 .. RX_Packet_Buffer'Last;
   RX_Packet_Index  : Positive range 1 .. RX_Packet_Buffer'Last;

   TX_Packet_Buffer : String (1 .. PACKET_BUFFER_SIZE) with
      Suppress_Initialization => True;
   TX_Packet_Index  : Natural range 0 .. TX_Packet_Buffer'Last;

   subtype Byte_Text_Type is String (1 .. 2);

   procedure Byte_Text (Value : in Interfaces.Unsigned_8; Packet : in out Byte_Text_Type);
   procedure Notify_Packet_Error (Error_Message : in String);

end Gdbstub;
