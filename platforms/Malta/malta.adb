-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ malta.adb                                                                                                 --
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

with Bits;
with MMIO;
with MIPS32;
with PC;
with Console;

package body Malta is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Bits;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Tclk_Init
   ----------------------------------------------------------------------------
   procedure Tclk_Init is
   begin
      MIPS32.CP0_Compare_Write (MIPS32.CP0_Count_Read + CP0_TIMER_COUNT);
   end Tclk_Init;

   ----------------------------------------------------------------------------
   -- PCI configuration space low-level access subprograms
   ----------------------------------------------------------------------------

   function PCI_PortIn (Port : Unsigned_16) return Unsigned_32 is
   begin
      return MMIO.Read_U32 (To_Address (GT64120_BASEADDRESS + Integer_Address (Port)));
   end PCI_PortIn;

   procedure PCI_PortOut (Port : in Unsigned_16; Value : in Unsigned_32) is
   begin
      MMIO.Write_U32 (To_Address (GT64120_BASEADDRESS + Integer_Address (Port)), Value);
   end PCI_PortOut;

   ----------------------------------------------------------------------------
   -- PCI_Init
   ----------------------------------------------------------------------------
   procedure PCI_Init is
      CPUIC : CPU_Interface_Configuration_Type;
   begin
      Cfg_Access_Descriptor.Read_32 := PCI_PortIn'Access;
      Cfg_Access_Descriptor.Write_32 := PCI_PortOut'Access;
      -- 4.5 CPU Interface Endianess, pg 47
      CPUIC_Read (GT_64120.CPU_Interface_Configuration'Address, CPUIC);
      CPUIC.Endianness := Endianness_BIG;
      CPUIC_Write (GT_64120.CPU_Interface_Configuration'Address, CPUIC);
      -- 3.6 Address Remapping
      -- remap PCI0MEM0 memory @ 0x00000000
      GT_64120.PCI_0_MEM0_Low_Decode_Address  := Make_PCILD (16#0000_0000#);
      GT_64120.PCI_0_MEM0_High_Decode_Address := Make_PCIHD (16#0000_0000#, 16#0200_0000#);
      -- remap PCI0MEM1 memory @ 0x18200000
      GT_64120.PCI_0_MEM1_Low_Decode_Address  := Make_PCILD (16#1820_0000#);
      GT_64120.PCI_0_MEM1_High_Decode_Address := Make_PCIHD (16#1820_0000#, 16#0020_0000#);
      -- remap PCI0IO @ 0x18000000
      GT_64120.PCI_0_IO_Low_Decode_Address  := Make_PCILD (16#1800_0000#);
      GT_64120.PCI_0_IO_High_Decode_Address := Make_PCIHD (16#1800_0000#, 16#0020_0000#);
   end PCI_Init;

   ----------------------------------------------------------------------------
   -- PCI_Devices_Detect
   ----------------------------------------------------------------------------
   procedure PCI_Devices_Detect is
      Success       : Boolean;
      Device_Number : Device_Number_Type;
      procedure Print_Device (DevName : in String; DevNum : in Device_Number_Type);
      procedure Print_Device (DevName : in String; DevNum : in Device_Number_Type) is
      begin
         Console.Print ("PCI device: ");
         Console.Print (DevName);
         Console.Print (Unsigned_8 (DevNum), Prefix => " @ DevFn ", NL => True);
      end Print_Device;
   begin
      -- Galileo GT-64120A - VID/DID/Devnum = 0x11AB/0x4620/0
      Cfg_Find_Device_By_Id (
                             GT64120_BUS_NUMBER,
                             Vendor_Id_Type (Byte_Swap (Unsigned_16 (DEVICE_ID_GT64120))),
                             Device_Id_Type (Byte_Swap (Unsigned_16 (VENDOR_ID_MARVELL))),
                             Device_Number,
                             Success
                            );
      if Success then
         Print_Device ("Galileo GT-64120", 0);
      end if;
      -- Intel PIIX4E - VID/DID/Devnum = 0x8086/0x7110/0xA
      Cfg_Find_Device_By_Id (
                             GT64120_BUS_NUMBER,
                             VENDOR_ID_INTEL,
                             DEVICE_ID_PIIX4,
                             Device_Number,
                             Success
                            );
      if Success then
         Print_Device ("i82371E PIIX4", Device_Number);
      end if;
      -- AMD Am79C973 - VID/DID/Devnum = 0x1022/0x2000/0xB
      Cfg_Find_Device_By_Id (
                             GT64120_BUS_NUMBER,
                             VENDOR_ID_AMD,
                             DEVICE_ID_Am79C973,
                             Device_Number,
                             Success
                            );
      if Success then
         Print_Device ("AMD Am79C973", Device_Number);
      end if;
      -- Cirrus CLGD5446 VGA - VID/DID/Devnum = 0x1013/0x00B8/0x12
      -- QEMU default
      Cfg_Find_Device_By_Id (
                             GT64120_BUS_NUMBER,
                             VENDOR_ID_CIRRUS,
                             DEVICE_ID_CLGD5446,
                             Device_Number,
                             Success
                            );
      if Success then
         Print_Device ("Cirrus CLGD5446", Device_Number);
      end if;
      -- QEMU VGA - VID/DID/Devnum = 0x1234/0x1111/0x12
      -- triggered by "-vga std" option
      Cfg_Find_Device_By_Id (
                             GT64120_BUS_NUMBER,
                             VENDOR_ID_QEMU,
                             DEVICE_ID_QEMU_VGA,
                             Device_Number,
                             Success
                            );
      if Success then
         Print_Device ("QEMU VGA", Device_Number);
      end if;
   end PCI_Devices_Detect;

   ----------------------------------------------------------------------------
   -- PIIX4_PIC_Init
   ----------------------------------------------------------------------------
   procedure PIIX4_PIC_Init is
   begin
      PC.PIC_Init (0, 8);
   end PIIX4_PIC_Init;

end Malta;
