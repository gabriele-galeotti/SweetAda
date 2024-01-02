-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pci.adb                                                                                                   --
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

with Ada.Unchecked_Conversion;
with Console;

package body PCI
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function To_U32 is new Ada.Unchecked_Conversion (Confadd_Type, Unsigned_32);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Cfg_Read/Write
   ----------------------------------------------------------------------------

   -- Unsigned_8

   function Cfg_Read
      (Bus_Number      : Bus_Number_Type;
       Device_Number   : Device_Number_Type;
       Function_Number : Function_Number_Type;
       Register_Number : Register_Number_Type)
      return Unsigned_8
      is
      Offset : Unsigned_8 range 0 .. 3;
      Data   : Unsigned_32;
   begin
      Offset := Unsigned_8 (Register_Number and 16#03#);
      Data := Cfg_Read (Bus_Number, Device_Number, Function_Number, Register_Number);
      case Offset is
         when 0 => return LByte (Data);
         when 1 => return MByte (Data);
         when 2 => return NByte (Data);
         when 3 => return HByte (Data);
      end case;
   end Cfg_Read;

   procedure Cfg_Write
      (Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type;
       Register_Number : in Register_Number_Type;
       Value           : in Unsigned_8)
      is
      Offset : Unsigned_8 range 0 .. 3;
      Data   : Unsigned_32;
   begin
      Offset := Unsigned_8 (Register_Number and 16#03#);
      Data := Cfg_Read (Bus_Number, Device_Number, Function_Number, Register_Number);
      case Offset is
         when 0 => Data := (Data and 16#FFFF_FF00#) or             Unsigned_32 (Value);
         when 1 => Data := (Data and 16#FFFF_00FF#) or Shift_Left (Unsigned_32 (Value), 8);
         when 2 => Data := (Data and 16#FF00_FFFF#) or Shift_Left (Unsigned_32 (Value), 16);
         when 3 => Data := (Data and 16#00FF_FFFF#) or Shift_Left (Unsigned_32 (Value), 24);
      end case;
      Cfg_Write (Bus_Number, Device_Number, Function_Number, Register_Number, Data);
   end Cfg_Write;

   -- Unsigned_16

   function Cfg_Read
      (Bus_Number      : Bus_Number_Type;
       Device_Number   : Device_Number_Type;
       Function_Number : Function_Number_Type;
       Register_Number : Register_Number_Type)
      return Unsigned_16
      is
      Offset : Unsigned_8 range 0 .. 2;
      Data   : Unsigned_32;
   begin
      Offset := Unsigned_8 (Register_Number and 16#02#);
      -- pragma Assert (Offset /= 1)
      Data := Cfg_Read (Bus_Number, Device_Number, Function_Number, Register_Number);
      case Offset is
         when 0 => return LWord (Data);
         when 1 => return 0; -- __DNO__
         when 2 => return HWord (Data);
      end case;
   end Cfg_Read;

   procedure Cfg_Write
      (Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type;
       Register_Number : in Register_Number_Type;
       Value           : in Unsigned_16)
      is
      Offset : Unsigned_8 range 0 .. 2;
      Data   : Unsigned_32;
   begin
      Offset := Unsigned_8 (Register_Number and 16#02#);
      -- pragma Assert (Offset /= 1)
      Data := Cfg_Read (Bus_Number, Device_Number, Function_Number, Register_Number);
      case Offset is
         when 0 => Data := (Data and 16#FFFF_0000#) or Unsigned_32 (Value);
         when 1 => null; -- __DNO__
         when 2 => Data := (Data and 16#0000_FFFF#) or Shift_Left (Unsigned_32 (Value), 16);
      end case;
      Cfg_Write (Bus_Number, Device_Number, Function_Number, Register_Number, Data);
   end Cfg_Write;

   -- Unsigned_32

   function Cfg_Read
      (Bus_Number      : Bus_Number_Type;
       Device_Number   : Device_Number_Type;
       Function_Number : Function_Number_Type;
       Register_Number : Register_Number_Type)
      return Unsigned_32
      is
      Confadd_Value : Confadd_Type;
   begin
      Confadd_Value.REGNUM  := Register_Number and 16#FC#;
      Confadd_Value.FUNCNUM := Function_Number;
      Confadd_Value.DEVNUM  := Device_Number;
      Confadd_Value.BUSNUM  := Bus_Number;
      Cfg_Access_Descriptor.Write_32 (CONFADD, To_U32 (Confadd_Value));
      return Cfg_Access_Descriptor.Read_32 (CONFDATA);
   end Cfg_Read;

   procedure Cfg_Write
      (Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type;
       Register_Number : in Register_Number_Type;
       Value           : in Unsigned_32)
      is
      Confadd_Value : Confadd_Type;
   begin
      Confadd_Value.REGNUM  := Register_Number and 16#FC#;
      Confadd_Value.FUNCNUM := Function_Number;
      Confadd_Value.DEVNUM  := Device_Number;
      Confadd_Value.BUSNUM  := Bus_Number;
      Cfg_Access_Descriptor.Write_32 (CONFADD, To_U32 (Confadd_Value));
      Cfg_Access_Descriptor.Write_32 (CONFDATA, Value);
   end Cfg_Write;

   ----------------------------------------------------------------------------
   -- Cfg_Detect_Device
   ----------------------------------------------------------------------------
   -- Return Vendor/Device Ids for a device number.
   ----------------------------------------------------------------------------
   procedure Cfg_Detect_Device
      (Bus_Number    : in     Bus_Number_Type;
       Device_Number : in     Device_Number_Type;
       Vendor_Id     :    out Vendor_Id_Type;
       Device_Id     :    out Device_Id_Type;
       Success       :    out Boolean)
      is
      -- PCI bridge responds with an invalid value if device does not exist
      INVALID_DEVICE : constant := 16#FFFF_FFFF#;
      Data           : Unsigned_32;
   begin
      Data := Cfg_Read (Bus_Number, Device_Number, 0, 0);
      Vendor_Id := (Vendor_Id_Type (LWord (Data)));
      Device_Id := (Device_Id_Type (HWord (Data)));
      if Data /= INVALID_DEVICE then
         Success := True;
      else
         Success := False;
      end if;
   end Cfg_Detect_Device;

   ----------------------------------------------------------------------------
   -- Cfg_Find_Device_By_Id
   ----------------------------------------------------------------------------
   -- Return the device number for Vendor/Device Ids.
   ----------------------------------------------------------------------------
   procedure Cfg_Find_Device_By_Id
      (Bus_Number    : in     Bus_Number_Type;
       Vendor_Id     : in     Vendor_Id_Type;
       Device_Id     : in     Device_Id_Type;
       Device_Number :    out Device_Number_Type;
       Success       :    out Boolean)
      is
      Data : Unsigned_32;
   begin
      Device_Number := 0;
      Success := False;
      for Device_Number_Idx in Device_Number_Type loop
         Data := Cfg_Read (Bus_Number, Device_Number_Idx, 0, 0);
         if
            Vendor_Id_Type (LWord (Data)) = Vendor_Id and then
            Device_Id_Type (HWord (Data)) = Device_Id
         then
            Device_Number := Device_Number_Idx;
            Success := True;
            exit;
         end if;
      end loop;
   end Cfg_Find_Device_By_Id;

   ----------------------------------------------------------------------------
   -- Cfg_Dump
   ----------------------------------------------------------------------------
   -- Configuration space register dump.
   ----------------------------------------------------------------------------
   procedure Cfg_Dump
      (Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type)
      is
      Cfg_Space : Byte_Array (0 .. 255);
   begin
      for Index in Cfg_Space'Range loop
         Cfg_Space (Index) := Cfg_Read (
                                 Bus_Number,
                                 Device_Number,
                                 Function_Number,
                                 Register_Number_Type (Index)
                                 );
      end loop;
      Console.Print_Memory (Cfg_Space'Address, Cfg_Space'Length);
   end Cfg_Dump;

   ----------------------------------------------------------------------------
   -- BARs_Dump
   ----------------------------------------------------------------------------
   -- Print out BARs contents.
   -- BARs_Dump (BUS0, 16#0A#, 0);
   ----------------------------------------------------------------------------
   procedure BARs_Dump
      (Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type)
      is
      Data : Unsigned_32;
   begin
      Data := Cfg_Read (Bus_Number, Device_Number, Function_Number, BAR0_Register_Offset);
      Console.Print (Data, Prefix => "BAR0: ", NL => True);
      Data := Cfg_Read (Bus_Number, Device_Number, Function_Number, BAR1_Register_Offset);
      Console.Print (Data, Prefix => "BAR1: ", NL => True);
      Data := Cfg_Read (Bus_Number, Device_Number, Function_Number, BAR2_Register_Offset);
      Console.Print (Data, Prefix => "BAR2: ", NL => True);
      Data := Cfg_Read (Bus_Number, Device_Number, Function_Number, BAR3_Register_Offset);
      Console.Print (Data, Prefix => "BAR3: ", NL => True);
      Data := Cfg_Read (Bus_Number, Device_Number, Function_Number, BAR4_Register_Offset);
      Console.Print (Data, Prefix => "BAR4: ", NL => True);
   end BARs_Dump;

end PCI;
