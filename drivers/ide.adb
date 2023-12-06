-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ide.adb                                                                                                   --
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

   type Register_Type is (DATA, ERROR, SC, SN, CL, CM, HEAD, STATUS, FEATURE, COMMAND, CONTROL);
   for Register_Type use
      (          -- name      access notes
       16#0000#, -- DATA      R/W
       16#0001#, -- ERROR     R
       16#0002#, -- SC
       16#0003#, -- SN               LBA #0
       16#0004#, -- CL               LBA #1
       16#0005#, -- CM               LBA #2
       16#0006#, -- HEAD             value = ((x and 16#0F#) or 16#E0#)
       16#0007#, -- STATUS    R
       16#0011#, -- FEATURE   W
       16#0017#, -- COMMAND   W
       16#2206#  -- CONTROL   W      16#0206#
      );

   Register_Offset : constant array (Register_Type) of Storage_Offset :=
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

   type ERROR_Type is record
      AMNF  : Boolean; -- Address Mark Not Found
      TK0NF : Boolean; -- TracK 0 Not Found
      ABRT  : Boolean; -- ABoRTed command
      MCR   : Boolean; -- Media Change Requested
      IDNF  : Boolean; -- ID Not Found
      MC    : Boolean; -- Media Change
      UNC   : Boolean; -- UNCorrectable data error
      BBK   : Boolean; -- Bad Block Detected
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ERROR_Type use record
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

   type HEAD_Type is record
      HS      : Natural range 0 .. 15; -- Head Select
      DRV     : Drive_Type;            -- MASTER/SLAVE
      Unused1 : Bits.Bits_1;
      L       : Boolean;               -- LBA mode
      Unused2 : Bits.Bits_1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for HEAD_Type use record
      HS      at 0 range 0 .. 3;
      DRV     at 0 range 4 .. 4;
      Unused1 at 0 range 5 .. 5;
      L       at 0 range 6 .. 6;
      Unused2 at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (HEAD_Type, Unsigned_8);
   function To_HEAD is new Ada.Unchecked_Conversion (Unsigned_8, HEAD_Type);

   -- STATUS Register

   type STATUS_Type is record
      ERR  : Boolean;
      IDX  : Boolean;
      CORR : Boolean;
      DRQ  : Boolean;
      SKC  : Boolean;
      WFT  : Boolean;
      RDY  : Boolean;
      BSY  : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for STATUS_Type use record
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

   ----------------------------------------------------------------------------
   -- Local declarations
   ----------------------------------------------------------------------------

   CMD_PIO_READ  : constant := 16#20#;
   CMD_PIO_WRITE : constant := 16#30#;

   ----------------------------------------------------------------------------
   -- Local subprograms
   ----------------------------------------------------------------------------

   function Register_Read_8
      (D : in Descriptor_Type;
       R : in Register_Type)
      return Unsigned_8
      with Inline => True;

   procedure Register_Write_8
      (D     : in Descriptor_Type;
       R     : in Register_Type;
       Value : in Unsigned_8)
      with Inline => True;

   function Register_Read_16
      (D : in Descriptor_Type;
       R : in Register_Type)
      return Unsigned_16
      with Inline => True;

   procedure Register_Write_16
      (D     : in Descriptor_Type;
       R     : in Register_Type;
       Value : in Unsigned_16)
      with Inline => True;

   function HEAD_Set
      (H : in Unsigned_8)
      return Unsigned_8
      with Inline => True;

   procedure DRIVE_Set
      (D            : in Descriptor_Type;
       Drive_Number : in Drive_Type)
      with Inline => True;

   function Is_Drive_Ready
      (D : in Descriptor_Type)
      return Boolean;

   function Is_DRQ_Active
      (D : in Descriptor_Type)
      return Boolean;

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
   function Register_Read_8
      (D : in Descriptor_Type;
       R : in Register_Type)
      return Unsigned_8
      is
   begin
      return D.Read_8 (Build_Address (D.Base_Address, Register_Offset (R), D.Scale_Address));
   end Register_Read_8;

   ----------------------------------------------------------------------------
   -- Register_Write (8-bit)
   ----------------------------------------------------------------------------
   procedure Register_Write_8
      (D     : in Descriptor_Type;
       R     : in Register_Type;
       Value : in Unsigned_8)
      is
   begin
      D.Write_8 (Build_Address (D.Base_Address, Register_Offset (R), D.Scale_Address), Value);
   end Register_Write_8;

   ----------------------------------------------------------------------------
   -- Register_Read (16-bit)
   ----------------------------------------------------------------------------
   function Register_Read_16
      (D : in Descriptor_Type;
       R : in Register_Type)
      return Unsigned_16
      is
   begin
      return D.Read_16 (Build_Address (D.Base_Address, Register_Offset (R), D.Scale_Address));
   end Register_Read_16;

   ----------------------------------------------------------------------------
   -- Register_Write (16-bit)
   ----------------------------------------------------------------------------
   procedure Register_Write_16
      (D     : in Descriptor_Type;
       R     : in Register_Type;
       Value : in Unsigned_16)
      is
   begin
      D.Write_16 (Build_Address (D.Base_Address, Register_Offset (R), D.Scale_Address), Value);
   end Register_Write_16;

   --------------------------------------------------------------------------
   -- Is_Drive_Ready
   --------------------------------------------------------------------------
   function Is_Drive_Ready
      (D : in Descriptor_Type)
      return Boolean
      is
      Success : Boolean := False;
   begin
      for Loop_Count in 1 .. 100_000 loop
         declare
            Drive_Status : STATUS_Type;
         begin
            Drive_Status := To_STATUS (Register_Read_8 (D, STATUS));
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
   function Is_DRQ_Active
      (D : in Descriptor_Type)
      return Boolean
      is
      Success : Boolean := False;
   begin
      for Loop_Count in 1 .. 100_000 loop
         if To_STATUS (Register_Read_8 (D, STATUS)).DRQ then
            Success := True;
            exit;
         end if;
      end loop;
      return Success;
   end Is_DRQ_Active;

   --------------------------------------------------------------------------
   -- HEAD_Set
   --------------------------------------------------------------------------
   function HEAD_Set
      (H : in Unsigned_8)
      return Unsigned_8
      is
   begin
      return ((H and 16#0F#) or 16#E0#);
   end HEAD_Set;

   --------------------------------------------------------------------------
   -- DRIVE_Set
   --------------------------------------------------------------------------
   procedure DRIVE_Set
      (D            : in Descriptor_Type;
       Drive_Number : in Drive_Type)
      is
      Drive_Value : Unsigned_8;
   begin
      case Drive_Number is
         when MASTER => Drive_Value := 16#00#;
         when SLAVE  => Drive_Value := 16#10#;
      end case;
      Register_Write_8 (D, HEAD, (Register_Read_8 (D, HEAD) and 16#EF#) or Drive_Value);
   end DRIVE_Set;

   --------------------------------------------------------------------------
   -- Read
   --------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       S       : in     Sector_Type;
       B       :    out Block_Type;
       Success :    out Boolean)
      is
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
      Register_Write_8 (D, SN, Unsigned_8 (S mod 2**8));
      Register_Write_8 (D, CL, Unsigned_8 ((S / 2**8) mod 2**8));
      Register_Write_8 (D, CM, Unsigned_8 ((S / 2**16) mod 2**8));
      Register_Write_8 (D, HEAD, HEAD_Set (0));
      Register_Write_8 (D, FEATURE, 0);
      Register_Write_8 (D, SC, 1);
      Register_Write_8 (D, COMMAND, CMD_PIO_READ);
      ----------------------------------------------------
      for Index in Buffer'Range loop
         exit when not Is_DRQ_Active (D);
         Buffer (Index) := Register_Read_16 (D, DATA);
      end loop;
      ----------------------------------------------------
      Success := True;
   end Read;

   --------------------------------------------------------------------------
   -- Write
   --------------------------------------------------------------------------
   procedure Write
      (D       : in     Descriptor_Type;
       S       : in     Sector_Type;
       B       : in     Block_Type;
       Success :    out Boolean)
      is
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
      Register_Write_8 (D, SN, Unsigned_8 (S mod 2**8));
      Register_Write_8 (D, CL, Unsigned_8 ((S / 2**8) mod 2**8));
      Register_Write_8 (D, CM, Unsigned_8 ((S / 2**16) mod 2**8));
      Register_Write_8 (D, HEAD, HEAD_Set (0));
      Register_Write_8 (D, FEATURE, 0);
      Register_Write_8 (D, SC, 1);
      Register_Write_8 (D, COMMAND, CMD_PIO_WRITE);
      ----------------------------------------------------
      for Index in Buffer'Range loop
         exit when not Is_DRQ_Active (D);
         Register_Write_16 (D, DATA, Buffer (Index));
      end loop;
      ----------------------------------------------------
      Success := True;
   end Write;

   --------------------------------------------------------------------------
   -- Init
   --------------------------------------------------------------------------
   procedure Init
      (D : in out Descriptor_Type)
      is
   begin
      null;
   end Init;

end IDE;
