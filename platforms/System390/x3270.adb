-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ x3270.adb                                                                                                 --
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
with System.Address_To_Access_Conversions;
with System.Storage_Elements;
with Ada.Unchecked_Deallocation;
with Interfaces;
with Definitions;
with Bits;
with S390;
with EBCDIC;

package body X3270 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use S390;
   use EBCDIC;

pragma Warnings (Off, "size is not a multiple of alignment");
   MSG_HDR_SIZE : constant := 6;
   type MSG_Header_Type is
   record
      WCC           : Unsigned_8;
      Command_SF    : Unsigned_8;
      SF_Parameters : Unsigned_8;
      Command_SBA   : Unsigned_8;
      SBA_AddressH  : Unsigned_8;
      SBA_AddressL  : Unsigned_8;
   end record with
      Alignment => 4,
      Size      => MSG_HDR_SIZE * Storage_Unit;
   for MSG_Header_Type use
   record
      WCC           at 0 range 0 .. 7;
      Command_SF    at 1 range 0 .. 7;
      SF_Parameters at 2 range 0 .. 7;
      Command_SBA   at 3 range 0 .. 7;
      SBA_AddressH  at 4 range 0 .. 7;
      SBA_AddressL  at 5 range 0 .. 7;
   end record;
pragma Warnings (On, "size is not a multiple of alignment");

   Parity     : constant := 16#01#;
   Reset      : constant := 16#02#;
   Line40     : constant := 16#04#;
   Line64     : constant := 16#08#;
   Line80     : constant := 16#0C#;
   RestoreKBD : constant := 16#40#;
   ResetMDT   : constant := 16#80#;

   Current_Row    : Natural;
   Current_Column : Natural;

   function To_Buffer_Address (R : in Natural; C : in Natural) return Unsigned_16 with
      Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- To_Buffer_Address
   ----------------------------------------------------------------------------
   function To_Buffer_Address (R : in Natural; C : in Natural) return Unsigned_16 is
      BA : Unsigned_16;
   begin
      BA := Unsigned_16 (R * 80 + C);
      return (BA and 16#003F#) or (Shift_Left (BA and 16#FFC0#, 2) and 16#3F00#) or 16#4040#;
   end To_Buffer_Address;

   ----------------------------------------------------------------------------
   -- Clear_Screen
   ----------------------------------------------------------------------------
   procedure Clear_Screen is
      Message_Header : aliased MSG_Header_Type;
      Cursor_Address : Unsigned_16;
      procedure CLS (A : Address; L : Natural) with
         Import        => True,
         Convention    => Asm,
         External_Name => "x3270_cls";
   begin
      Cursor_Address := To_Buffer_Address (1, 1);
      Message_Header.WCC           := 16#C7#; -- WCC: reset+alarm+restore+resetMDT
      Message_Header.Command_SF    := 16#1D#; -- command: START FIELD
      Message_Header.SF_Parameters := 16#60#; -- PROTECTED, ALPHA, DISPLAY
      Message_Header.Command_SBA   := 16#11#; -- command: SET BUFFER ADDRESS
      Message_Header.SBA_AddressH  := HByte (Cursor_Address);
      Message_Header.SBA_AddressL  := LByte (Cursor_Address);
      CLS (Message_Header'Address, MSG_HDR_SIZE);
      Current_Row    := 1;
      Current_Column := 0;
   end Clear_Screen;

   ----------------------------------------------------------------------------
   -- Line_Feed
   ----------------------------------------------------------------------------
   procedure Line_Feed is
   begin
      Current_Row    := Current_Row + 1;
      Current_Column := 0;
   end Line_Feed;

   ----------------------------------------------------------------------------
   -- Write_Message_RC
   ----------------------------------------------------------------------------
   procedure Write_Message_RC (Message : in String; Row : in Natural; Column : in Natural) is
      subtype Work_Area is Byte_A4Array (1 .. MSG_HDR_SIZE + Message'Length);
      package Work_Area_Ops is new System.Address_To_Access_Conversions (Work_Area);
      use type Work_Area_Ops.Object_Pointer;
      subtype Work_Area_Ptr is Work_Area_Ops.Object_Pointer;
      procedure Free is new Ada.Unchecked_Deallocation (Work_Area, Work_Area_Ptr);
      Message_Ptr    : Work_Area_Ptr := new Work_Area;
      Message_Header : aliased MSG_Header_Type with
         Address    => Work_Area_Ops.To_Address (Message_Ptr),
         Import     => True,
         Convention => Ada;
      E_String       : aliased EBCDIC_String (Message'Range) with
         Address    => Message_Header'Address + MSG_HDR_SIZE,
         Import     => True,
         Convention => Ada;
      Cursor_Address : Unsigned_16;
      procedure Write (A : Address; L : Natural) with
         Import        => True,
         Convention    => Asm,
         External_Name => "x3270_write";
   begin
      Cursor_Address := To_Buffer_Address (Row, Column);
      Message_Header.WCC           := 16#C7#; -- WCC: reset+alarm+restore+resetMDT
      Message_Header.Command_SF    := 16#1D#; -- command: START FIELD
      Message_Header.SF_Parameters := 16#60#; -- PROTECTED, ALPHA, DISPLAY
      Message_Header.Command_SBA   := 16#11#; -- command: SET BUFFER ADDRESS
      Message_Header.SBA_AddressH  := HByte (Cursor_Address);
      Message_Header.SBA_AddressL  := LByte (Cursor_Address);
      To_EBCDIC (Message, E_String);
      Write (Message_Header'Address, MSG_HDR_SIZE + E_String'Length);
      if Message_Ptr /= null then
         Free (Message_Ptr);
      end if;
   end Write_Message_RC;

   ----------------------------------------------------------------------------
   -- Write_Message
   ----------------------------------------------------------------------------
   procedure Write_Message (Message : in String) is
   begin
      Write_Message_RC (Message, Current_Row, Current_Column);
      Line_Feed;
      -- Current_Column := Current_Column + Message'Length;
   end Write_Message;

end X3270;
