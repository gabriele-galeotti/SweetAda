-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ide.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
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

   type IDE_Register_Type is (DATA, WPC, SC, SN, CL, CM, HEAD, STATUS, COMMAND, CONTROL);
   for IDE_Register_Type use (
                              16#0000#, -- DATA
                              16#0001#, -- WPC
                              16#0002#, -- SC
                              16#0003#, -- SN (LBA0)
                              16#0004#, -- CL (LBA1)
                              16#0005#, -- CM (LBA2)
                              16#0006#, -- HEAD
                              16#0007#, -- STATUS
                              16#1007#, -- COMMAND
                              16#2206#  -- CONTROL 16#0206#
                             );

   IDE_Register_Offset : constant array (IDE_Register_Type) of Storage_Offset :=
      (
       DATA    => 0,
       WPC     => 1,
       SC      => 2,
       SN      => 3,       -- LBA0
       CL      => 4,       -- LBA1
       CM      => 5,       -- LBA2
       HEAD    => 6,
       STATUS  => 7,
       COMMAND => 7,
       CONTROL => 16#0206#
      );

   -- Status Register

   type IDE_Status_Type is
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
   for IDE_Status_Type use
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

   CMD_PIO_READ : constant := 16#20#;

   D : IDE_Descriptor_Type with
      Suppress_Initialization => True;

   function Register_Read (
                           Descriptor : IDE_Descriptor_Type;
                           Register   : IDE_Register_Type
                          ) return Unsigned_8;
   procedure Register_Write (
                             Descriptor : in IDE_Descriptor_Type;
                             Register   : in IDE_Register_Type;
                             Value      : in Unsigned_8
                            );
   function Register_Read (
                           Descriptor : IDE_Descriptor_Type;
                           Register   : IDE_Register_Type
                          ) return Unsigned_16;
   procedure Register_Write (
                             Descriptor : in IDE_Descriptor_Type;
                             Register   : in IDE_Register_Type;
                             Value      : in Unsigned_16
                            );
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
   -- Register_Read
   ----------------------------------------------------------------------------
   function Register_Read (
                           Descriptor : IDE_Descriptor_Type;
                           Register   : IDE_Register_Type
                          ) return Unsigned_8 is
   begin
      return Descriptor.Read_8 (
                                Build_Address (
                                               Descriptor.Base_Address,
                                               IDE_Register_Offset (Register),
                                               Descriptor.Scale_Address
                                              )
                               );
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Register_Write (
                             Descriptor : in IDE_Descriptor_Type;
                             Register   : in IDE_Register_Type;
                             Value      : in Unsigned_8
                            ) is
   begin
      Descriptor.Write_8 (
                          Build_Address (
                                         Descriptor.Base_Address,
                                         IDE_Register_Offset (Register),
                                         Descriptor.Scale_Address
                                        ),
                          Value
                         );
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Register_Read
   ----------------------------------------------------------------------------
   function Register_Read (
                           Descriptor : IDE_Descriptor_Type;
                           Register   : IDE_Register_Type
                          ) return Unsigned_16 is
   begin
      return Descriptor.Read_16 (
                                 Build_Address (
                                                Descriptor.Base_Address,
                                                IDE_Register_Offset (Register),
                                                Descriptor.Scale_Address
                                               )
                                );
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Register_Write (
                             Descriptor : in IDE_Descriptor_Type;
                             Register   : in IDE_Register_Type;
                             Value      : in Unsigned_16
                            ) is
   begin
      Descriptor.Write_16 (
                           Build_Address (
                                          Descriptor.Base_Address,
                                          IDE_Register_Offset (Register),
                                          Descriptor.Scale_Address
                                         ),
                           Value
                          );
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Local subprograms (generic)
   ----------------------------------------------------------------------------

   generic
      Register_Type : in IDE_Register_Type;
      type Output_Register_Type is private;
   function Typed_Register_Read (
                                 Descriptor : IDE_Descriptor_Type
                                ) return Output_Register_Type;
   pragma Inline (Typed_Register_Read);
   function Typed_Register_Read (
                                 Descriptor : IDE_Descriptor_Type
                                ) return Output_Register_Type is
      function Convert is new Ada.Unchecked_Conversion (Unsigned_8, Output_Register_Type);
   begin
      return Convert (Register_Read (Descriptor, Register_Type));
   end Typed_Register_Read;

   generic
      Register_Type : in IDE_Register_Type;
      type Input_Register_Type is private;
   procedure Typed_Register_Write (
                                   Descriptor : in IDE_Descriptor_Type;
                                   Value      : in Input_Register_Type
                                  );
   pragma Inline (Typed_Register_Write);
   pragma Unreferenced (Typed_Register_Write); -- __FIX__
   procedure Typed_Register_Write (
                                   Descriptor : in IDE_Descriptor_Type;
                                   Value      : in Input_Register_Type
                                  ) is
      function Convert is new Ada.Unchecked_Conversion (Input_Register_Type, Unsigned_8);
   begin
      Register_Write (Descriptor, Register_Type, Convert (Value));
   end Typed_Register_Write;

   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------

   function DATA_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_16;
   pragma Inline (DATA_Read);
   function DATA_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_16 is
   begin
      return Register_Read (Descriptor, DATA);
   end DATA_Read;

   function WPC_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8;
   pragma Inline (WPC_Read);
   function WPC_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, WPC);
   end WPC_Read;

   procedure WPC_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8);
   pragma Inline (WPC_Write);
   procedure WPC_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, WPC, Value);
   end WPC_Write;

   function SC_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8;
   pragma Inline (SC_Read);
   function SC_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, SC);
   end SC_Read;

   procedure SC_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8);
   pragma Inline (SC_Write);
   procedure SC_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, SC, Value);
   end SC_Write;

   function SN_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8;
   pragma Inline (SN_Read);
   function SN_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, SN);
   end SN_Read;

   procedure SN_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8);
   pragma Inline (SN_Write);
   procedure SN_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, SN, Value);
   end SN_Write;

   function CL_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8;
   pragma Inline (CL_Read);
   function CL_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, CL);
   end CL_Read;

   procedure CL_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8);
   pragma Inline (CL_Write);
   procedure CL_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, CL, Value);
   end CL_Write;

   function CM_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8;
   pragma Inline (CM_Read);
   function CM_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, CM);
   end CM_Read;

   procedure CM_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8);
   pragma Inline (CM_Write);
   procedure CM_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, CM, Value);
   end CM_Write;

   function HEAD_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8;
   pragma Inline (HEAD_Read);
   function HEAD_Read (Descriptor : IDE_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, HEAD);
   end HEAD_Read;

   procedure HEAD_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8);
   pragma Inline (HEAD_Write);
   procedure HEAD_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, HEAD, (Value and 16#0F#) or 16#E0#);
   end HEAD_Write;

   procedure DRIVE_Set (Descriptor : in IDE_Descriptor_Type; Drive_Number : in Drive_Type);
   pragma Inline (DRIVE_Set);
   procedure DRIVE_Set (Descriptor : in IDE_Descriptor_Type; Drive_Number : in Drive_Type) is
      Drive_Value : Unsigned_8;
   begin
      case Drive_Number is
         when MASTER => Drive_Value := 16#00#;
         when SLAVE  => Drive_Value := 16#10#;
      end case;
      Register_Write (Descriptor, HEAD, (HEAD_Read (Descriptor) and 16#EF#) or Drive_Value);
   end DRIVE_Set;

   function STATUS_Read is new Typed_Register_Read (STATUS, IDE_Status_Type);
   pragma Inline (STATUS_Read);

   procedure COMMAND_Write (Descriptor : in IDE_Descriptor_Type; Value : in Unsigned_8);
   pragma Inline (COMMAND_Write);
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
      for Loop_Count in 1 .. 10_0000 loop
         declare
            Drive_Status : IDE_Status_Type;
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
      for Loop_Count in 1 .. 10_0000 loop
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
      DRIVE_Set (D, MASTER);
      ----------------------------------------------------
      if not Is_Drive_Ready (D) then
         Console.Print ("Drive not ready.", NL => True);
         Success := False;
         return;
      end if;
      -- perform read ------------------------------------
      SN_Write (D, Unsigned_8 (S mod 2**8));
      CL_Write (D, Unsigned_8 ((S / 256) mod 2**8));
      CM_Write (D, Unsigned_8 ((S / 65536) mod 2**8));
      HEAD_Write (D, 0);
      WPC_Write (D, 0);
      SC_Write (D, 1); -- read 1 sector
      COMMAND_Write (D, CMD_PIO_READ);
      -- wait for DRQ active -----------------------------
      if not Is_DRQ_Active (D) then
         Console.Print ("Drive not active.", NL => True);
         Success := False;
         return;
      end if;
      ----------------------------------------------------
      for Index in Buffer'Range loop
         Buffer (Index) := DATA_Read (D);
      end loop;
      -- Console.Print_Memory (Buffer'Address, 512, 16);
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
      pragma Unreferenced (S);
      pragma Unreferenced (B);
   begin
      Success := True;
   end Write;

end IDE;
