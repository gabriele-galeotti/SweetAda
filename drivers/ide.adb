-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ide.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with LLutils;
with Console;

package body IDE is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use LLutils;

   ----------------------------------------------------------------------------
   -- Register types
   ----------------------------------------------------------------------------

   type IDE_Register_Type is (DATA, ERROR, SC, SN, CL, CM, HEAD, STATUS, FEATURE, COMMAND, CONTROL);
   for IDE_Register_Type use (
                              --           name      access notes
                              16#0000#, -- DATA      R/W
                              16#0001#, -- ERROR     R
                              16#0002#, -- SC
                              16#0003#, -- SN               LBA #0
                              16#0004#, -- CL               LBA #1
                              16#0005#, -- CM               LBA #2
                              16#0006#, -- HEAD
                              16#0007#, -- STATUS    R
                              16#0011#, -- FEATURE   W
                              16#0017#, -- COMMAND   W
                              16#2206#  -- CONTROL   W      16#0206#
                             );

   IDE_Register_Offset : constant array (IDE_Register_Type) of Storage_Offset :=
      [
       DATA    => 0,
       ERROR   => 1,
       FEATURE => 1,
       SC      => 2,
       SN      => 3,
       CL      => 4,
       CM      => 5,
       HEAD    => 6,
       STATUS  => 7,
       COMMAND => 7,
       CONTROL => 16#0206#
      ];

   -- ERROR Register

   type ERROR_Type is
   record
      AMNF  : Boolean; -- Address Mark Not Found
      TK0NF : Boolean; -- TracK 0 Not Found
      ABRT  : Boolean; -- ABoRTed command
      MCR   : Boolean; -- Media Change Requested
      IDNF  : Boolean; -- ID Not Found
      MC    : Boolean; -- Media Change
      UNC   : Boolean; -- UNCorrectable data error
      BBK   : Boolean; -- Bad Block Detected
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ERROR_Type use
   record
      AMNF  at 0 range 0 .. 0;
      TK0NF at 0 range 1 .. 1;
      ABRT  at 0 range 2 .. 2;
      MCR   at 0 range 3 .. 3;
      IDNF  at 0 range 4 .. 4;
      MC    at 0 range 5 .. 5;
      UNC   at 0 range 6 .. 6;
      BBK   at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (ERROR_Type, Unsigned_8);
   function To_ERROR is new Ada.Unchecked_Conversion (Unsigned_8, ERROR_Type);

   -- HEAD Register

   type HEAD_Type is
   record
      HS      : Natural range 0 .. 15; -- Head Select
      DRV     : Drive_Type;            -- MASTER/SLAVE
      Unused1 : Bits.Bits_1;
      L       : Boolean;               -- LBA mode
      Unused2 : Bits.Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for HEAD_Type use
   record
      HS      at 0 range 0 .. 3;
      DRV     at 0 range 4 .. 4;
      Unused1 at 0 range 5 .. 5;
      L       at 0 range 6 .. 6;
      Unused2 at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (HEAD_Type, Unsigned_8);
   function To_HEAD is new Ada.Unchecked_Conversion (Unsigned_8, HEAD_Type);

   -- STATUS Register

   type STATUS_Type is
   record
      ERR  : Boolean;
      IDX  : Boolean;
      CORR : Boolean;
      DRQ  : Boolean;
      SKC  : Boolean;
      WFT  : Boolean;
      RDY  : Boolean;
      BSY  : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for STATUS_Type use
   record
      ERR  at 0 range 0 .. 0;
      IDX  at 0 range 1 .. 1;
      CORR at 0 range 2 .. 2;
      DRQ  at 0 range 3 .. 3;
      SKC  at 0 range 4 .. 4;
      WFT  at 0 range 5 .. 5;
      RDY  at 0 range 6 .. 6;
      BSY  at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (STATUS_Type, Unsigned_8);
   function To_STATUS is new Ada.Unchecked_Conversion (Unsigned_8, STATUS_Type);

   -- Local declarations

   CMD_PIO_READ  : constant := 16#20#;
   CMD_PIO_WRITE : constant := 16#30#;

   D : IDE_Descriptor_Type;

   -- Local subprograms

   function Register_Read (
                           Descriptor : IDE_Descriptor_Type;
                           Register   : IDE_Register_Type
                          ) return Unsigned_8 with
      Inline => True;

   procedure Register_Write (
                             Descriptor : in IDE_Descriptor_Type;
                             Register   : in IDE_Register_Type;
                             Value      : in Unsigned_8
                            ) with
      Inline => True;

   function Register_Read (
                           Descriptor : IDE_Descriptor_Type;
                           Register   : IDE_Register_Type
                          ) return Unsigned_16 with
      Inline => True;

   procedure Register_Write (
                             Descriptor : in IDE_Descriptor_Type;
                             Register   : in IDE_Register_Type;
                             Value      : in Unsigned_16
                            ) with
      Inline => True;

   function DATA_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_16 with
      Inline => True;
   procedure DATA_Write (Descriptor : IDE_Descriptor_Type; Value : in Unsigned_16) with
      Inline => True;
   function ERROR_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 with
      Inline => True;
   procedure FEATURE_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) with
      Inline => True;
   function SC_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 with
      Inline => True;
   procedure SC_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) with
      Inline => True;
   function SN_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 with
      Inline => True;
   procedure SN_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) with
      Inline => True;
   function CL_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 with
      Inline => True;
   procedure CL_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) with
      Inline => True;
   function CM_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 with
      Inline => True;
   procedure CM_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) with
      Inline => True;
   function HEAD_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 with
      Inline => True;
   procedure HEAD_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) with
      Inline => True;
   procedure DRIVE_Set (Descriptor : in IDE_Descriptor_Type; Drive_Number : in Drive_Type) with
      Inline => True;
   function STATUS_Read (Descriptor : in IDE_Descriptor_Type) return STATUS_Type with
      Inline => True;
   procedure COMMAND_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) with
      Inline => True;

   function Is_Drive_Ready (Descriptor : IDE_Descriptor_Type) return Boolean;
   function Is_DRQ_Active (Descriptor : IDE_Descriptor_Type) return Boolean;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Register_Read (8-bit)
   ----------------------------------------------------------------------------
   function Register_Read (
                           Descriptor : IDE_Descriptor_Type;
                           Register   : IDE_Register_Type
                          ) return Unsigned_8 is
   begin
      return Descriptor.Read_8 (Build_Address (
                                               Descriptor.Base_Address,
                                               IDE_Register_Offset (Register),
                                               Descriptor.Scale_Address
                                              ));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write (8-bit)
   ----------------------------------------------------------------------------
   procedure Register_Write (
                             Descriptor : in IDE_Descriptor_Type;
                             Register   : in IDE_Register_Type;
                             Value      : in Unsigned_8
                            ) is
   begin
      Descriptor.Write_8 (Build_Address (
                                         Descriptor.Base_Address,
                                         IDE_Register_Offset (Register),
                                         Descriptor.Scale_Address
                                        ), Value);
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Register_Read (16-bit)
   ----------------------------------------------------------------------------
   function Register_Read (
                           Descriptor : IDE_Descriptor_Type;
                           Register   : IDE_Register_Type
                          ) return Unsigned_16 is
   begin
      return Descriptor.Read_16 (Build_Address (
                                                Descriptor.Base_Address,
                                                IDE_Register_Offset (Register),
                                                Descriptor.Scale_Address
                                               ));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write (16-bit)
   ----------------------------------------------------------------------------
   procedure Register_Write (
                             Descriptor : in IDE_Descriptor_Type;
                             Register   : in IDE_Register_Type;
                             Value      : in Unsigned_16
                            ) is
   begin
      Descriptor.Write_16 (Build_Address (
                                          Descriptor.Base_Address,
                                          IDE_Register_Offset (Register),
                                          Descriptor.Scale_Address
                                         ), Value);
   end Register_Write;

   ----------------------------------------------------------------------------
   -- ???_Read/Write
   ----------------------------------------------------------------------------

   function DATA_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_16 is
   begin
      return Register_Read (Descriptor, DATA);
   end DATA_Read;

   procedure DATA_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_16) is
   begin
      Register_Write (Descriptor, DATA, Value);
   end DATA_Write;

   function ERROR_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, ERROR);
   end ERROR_Read;

   procedure FEATURE_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, FEATURE, Value);
   end FEATURE_Write;

   function SC_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, SC);
   end SC_Read;

   procedure SC_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, SC, Value);
   end SC_Write;

   function SN_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, SN);
   end SN_Read;

   procedure SN_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, SN, Value);
   end SN_Write;

   function CL_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, CL);
   end CL_Read;

   procedure CL_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, CL, Value);
   end CL_Write;

   function CM_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, CM);
   end CM_Read;

   procedure CM_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, CM, Value);
   end CM_Write;

   function HEAD_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, HEAD);
   end HEAD_Read;

   procedure HEAD_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, HEAD, (Value and 16#0F#) or 16#E0#);
   end HEAD_Write;

   procedure DRIVE_Set (Descriptor : in IDE_Descriptor_Type; Drive_Number : in Drive_Type) is
      Drive_Value : Unsigned_8;
   begin
      case Drive_Number is
         when MASTER => Drive_Value := 16#00#;
         when SLAVE  => Drive_Value := 16#10#;
      end case;
      Register_Write (Descriptor, HEAD, (HEAD_Read (Descriptor) and 16#EF#) or Drive_Value);
   end DRIVE_Set;

   function STATUS_Read (Descriptor : IDE_Descriptor_Type) return STATUS_Type is
   begin
      return To_STATUS (Register_Read (Descriptor, STATUS));
   end STATUS_Read;

   procedure COMMAND_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, COMMAND, Value);
   end COMMAND_Write;

   --------------------------------------------------------------------------
   -- Init
   --------------------------------------------------------------------------
   procedure Init (Descriptor : in IDE_Descriptor_Type) is
   begin
      D := Descriptor;
   end Init;

   --------------------------------------------------------------------------
   -- Is_Drive_Ready
   --------------------------------------------------------------------------
   function Is_Drive_Ready (Descriptor : IDE_Descriptor_Type) return Boolean is
      Success : Boolean := False;
   begin
      for Loop_Count in 1 .. 100_000 loop
         declare
            Drive_Status : STATUS_Type;
         begin
            Drive_Status := STATUS_Read (Descriptor);
            -- if BSY is set, no other bits are valid
            if not Drive_Status.BSY and then Drive_Status.RDY then
               Success := True;
               exit;
            end if;
         end;
      end loop;
      return Success;
   end Is_Drive_Ready;

   --------------------------------------------------------------------------
   -- Is_DRQ_Active
   --------------------------------------------------------------------------
   function Is_DRQ_Active (Descriptor : IDE_Descriptor_Type) return Boolean is
      Success : Boolean := False;
   begin
      for Loop_Count in 1 .. 100_000 loop
         if STATUS_Read (Descriptor).DRQ then
            Success := True;
            exit;
         end if;
      end loop;
      return Success;
   end Is_DRQ_Active;

   --------------------------------------------------------------------------
   -- Read
   --------------------------------------------------------------------------
   procedure Read (
                   S       : in  Sector_Type;
                   B       : out Block_Type;
                   Success : out Boolean
                  ) is
      type HD_Buffer_Type is array (0 .. 255) of Unsigned_16 with
         Pack => True;
      Buffer : HD_Buffer_Type with
         Address => B (0)'Address;
   begin
      ----------------------------------------------------
      DRIVE_Set (D, MASTER);
      if not Is_Drive_Ready (D) then
         Console.Print ("Drive not ready.", NL => True);
         Success := False;
         return;
      end if;
      -- perform read ------------------------------------
      SN_Write (D, Unsigned_8 (S mod 2**8));
      CL_Write (D, Unsigned_8 ((S / 2**8) mod 2**8));
      CM_Write (D, Unsigned_8 ((S / 2**16) mod 2**8));
      HEAD_Write (D, 0);
      FEATURE_Write (D, 0);
      SC_Write (D, 1);
      COMMAND_Write (D, CMD_PIO_READ);
      ----------------------------------------------------
      for Index in Buffer'Range loop
         exit when not Is_DRQ_Active (D);
         Buffer (Index) := DATA_Read (D);
      end loop;
      ----------------------------------------------------
      Success := True;
   end Read;

   --------------------------------------------------------------------------
   -- Write
   --------------------------------------------------------------------------
   procedure Write (
                    S       : in  Sector_Type;
                    B       : in  Block_Type;
                    Success : out Boolean
                   ) is
      type HD_Buffer_Type is array (0 .. 255) of Unsigned_16 with
         Pack => True;
      Buffer : HD_Buffer_Type with
         Address => B (0)'Address;
   begin
      ----------------------------------------------------
      DRIVE_Set (D, MASTER);
      if not Is_Drive_Ready (D) then
         Console.Print ("Drive not ready.", NL => True);
         Success := False;
         return;
      end if;
      -- perform write -----------------------------------
      SN_Write (D, Unsigned_8 (S mod 2**8));
      CL_Write (D, Unsigned_8 ((S / 2**8) mod 2**8));
      CM_Write (D, Unsigned_8 ((S / 2**16) mod 2**8));
      HEAD_Write (D, 0);
      FEATURE_Write (D, 0);
      SC_Write (D, 1);
      COMMAND_Write (D, CMD_PIO_WRITE);
      ----------------------------------------------------
      for Index in Buffer'Range loop
         exit when not Is_DRQ_Active (D);
         DATA_Write (D, Buffer (Index));
      end loop;
      ----------------------------------------------------
      Success := True;
   end Write;

end IDE;
