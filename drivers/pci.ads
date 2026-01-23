-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pci.ads                                                                                                   --
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

package PCI
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

   type Vendor_Id_Type is new Unsigned_16;
   type Device_Id_Type is new Unsigned_16;

   ----------------------------------------------------------------------------
   VENDOR_NAME_COMPAQ     : aliased constant String := "Compaq";
   VENDOR_ID_COMPAQ       : constant Vendor_Id_Type := 16#0E11#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_NCR        : aliased constant String := "NCR";
   VENDOR_ID_NCR          : constant Vendor_Id_Type := 16#1000#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_ATI        : aliased constant String := "ATI";
   VENDOR_ID_ATI          : constant Vendor_Id_Type := 16#1002#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_DEC        : aliased constant String := "DEC";
   VENDOR_ID_DEC          : constant Vendor_Id_Type := 16#1011#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_CIRRUS     : aliased constant String := "Cirrus";
   VENDOR_ID_CIRRUS       : constant Vendor_Id_Type := 16#1013#;
   DEVICE_ID_CLGD5446     : constant Device_Id_Type := 16#00B8#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_AMD        : aliased constant String := "AMD";
   VENDOR_ID_AMD          : constant Vendor_Id_Type := 16#1022#;
   DEVICE_ID_Am79C973     : constant Device_Id_Type := 16#2000#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_MOTOROLA   : aliased constant String := "Motorola";
   VENDOR_ID_MOTOROLA     : constant Vendor_Id_Type := 16#1057#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_UMC        : aliased constant String := "UMC";
   VENDOR_ID_UMC          : constant Vendor_Id_Type := 16#1060#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_SUN        : aliased constant String := "Sun Microsystems";
   VENDOR_ID_SUN          : constant Vendor_Id_Type := 16#108E#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_CMD        : aliased constant String := "CMD";
   VENDOR_ID_CMD          : constant Vendor_Id_Type := 16#1095#;
   DEVICE_ID_CMD670       : constant Device_Id_Type := 16#0670#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_WINBOND    : aliased constant String := "Winbond";
   VENDOR_ID_WINBOND      : constant Vendor_Id_Type := 16#10AD#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_PLX        : aliased constant String := "PLX";
   VENDOR_ID_PLX          : constant Vendor_Id_Type := 16#10B5#;
   DEVICE_ID_PLX9050      : constant Device_Id_Type := 16#9050#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_3COM       : aliased constant String := "3Com";
   VENDOR_ID_3COM         : constant Vendor_Id_Type := 16#10B7#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_AMCC       : aliased constant String := "AMCC";
   VENDOR_ID_AMCC         : constant Vendor_Id_Type := 16#10E8#;
   DEVICE_ID_PCICAN       : constant Device_Id_Type := 16#8406#; -- PCIcanx/PCIcan
   ----------------------------------------------------------------------------
   VENDOR_NAME_REALTEK    : aliased constant String := "RealTek";
   VENDOR_ID_REALTEK      : constant Vendor_Id_Type := 16#10EC#;
   DEVICE_ID_RTL8029      : constant Device_Id_Type := 16#8029#;
   ----------------------------------------------------------------------------
   VENDOR_NAME_MARVELL    : aliased constant String := "Marvell";
   VENDOR_ID_MARVELL      : constant Vendor_Id_Type := 16#11AB#;
   DEVICE_ID_GT64120      : constant Device_Id_Type := 16#4620#; -- Galileo GT-64120A
   ----------------------------------------------------------------------------
   VENDOR_NAME_QEMU       : aliased constant String := "QEMU";
   VENDOR_ID_QEMU         : constant Vendor_Id_Type := 16#1234#;
   DEVICE_ID_QEMU_VGA     : constant Device_Id_Type := 16#1111#; -- VGA controller
   ----------------------------------------------------------------------------
   VENDOR_NAME_OXFORDSEMI : aliased constant String := "Oxford Semiconductor";
   VENDOR_ID_OXFORDSEMI   : constant Vendor_Id_Type := 16#13FE#;
   DEVICE_ID_PCI_1612     : constant Device_Id_Type := 16#1600#; -- PCI-1612 4-port PCI Communication Card
   ----------------------------------------------------------------------------
   VENDOR_NAME_S3         : aliased constant String := "S3";
   VENDOR_ID_S3           : constant Vendor_Id_Type := 16#5333#;
   DEVICE_ID_86C764       : constant Device_Id_Type := 16#8811#; -- 86C764/765 [Trio32/64/64V+]
   ----------------------------------------------------------------------------
   VENDOR_NAME_INTEL      : aliased constant String := "Intel";
   VENDOR_ID_INTEL        : constant Vendor_Id_Type := 16#8086#;
   DEVICE_ID_82540EM      : constant Device_Id_Type := 16#100E#; -- 82540EM Gigabit Ethernet Controller
   DEVICE_ID_82371FB      : constant Device_Id_Type := 16#122E#; -- 82371FB PIIX
   DEVICE_ID_82441FX      : constant Device_Id_Type := 16#1237#; -- 82441FX PMC 440FX [Natoma]
   DEVICE_ID_PIIX3        : constant Device_Id_Type := 16#7000#; -- 82371SB PIIX3 [Natoma/Triton II]
   DEVICE_ID_82437VX      : constant Device_Id_Type := 16#7030#; -- 82437VX TVX 430VX [Triton VX]
   DEVICE_ID_PIIX4        : constant Device_Id_Type := 16#7110#; -- 82371AB/EB/MB PIIX4
   DEVICE_ID_82443BX      : constant Device_Id_Type := 16#7190#; -- 82443BX/ZX/DX Host bridge
   DEVICE_ID_82443BXAGP   : constant Device_Id_Type := 16#7191#; -- 82443BX/ZX/DX AGP bridge
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- PCI basic hardware definitions
   ----------------------------------------------------------------------------

   type Bus_Number_Type      is new Bits_8;
   type Device_Number_Type   is new Bits_5;
   type Function_Number_Type is new Bits_3;
   type Register_Number_Type is new Bits_8;

   type Confaddr_Type is record
      REGNUM   : Register_Number_Type := 0;
      FUNCNUM  : Function_Number_Type := 0;
      DEVNUM   : Device_Number_Type   := 0;
      BUSNUM   : Bus_Number_Type      := 0;
      Reserved : Bits_7               := 0;
      CONE     : Boolean              := True;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for Confaddr_Type use record
      REGNUM   at 0 range 0 .. 7;
      FUNCNUM  at 1 range 0 .. 2;
      DEVNUM   at 1 range 3 .. 7;
      BUSNUM   at 2 range 0 .. 7;
      Reserved at 3 range 0 .. 6;
      CONE     at 3 range 7 .. 7;
   end record;

   CONFADDR : constant Unsigned_16 := 16#0CF8#;
   CONFDATA : constant Unsigned_16 := 16#0CFC#;

   BUS0 : constant Bus_Number_Type := 0;

   -- standard register offsets of PCI Type 0 (non-bridge) configuration space header
   VID_Offset                     : constant := 16#00#;
   DID_Offset                     : constant := 16#02#;
   Command_Offset                 : constant := 16#04#;
   Status_Offset                  : constant := 16#06#;
   RID_Offset                     : constant := 16#08#;
   ClassCode_Offset               : constant := 16#09#;
   CacheLineSize_Offset           : constant := 16#0C#;
   LatencyTimer_Offset            : constant := 16#0D#;
   HeaderType_Offset              : constant := 16#0E#;
   BIST_Offset                    : constant := 16#0F#;
   BAR0_Offset                    : constant := 16#10#;
   BAR1_Offset                    : constant := 16#14#;
   BAR2_Offset                    : constant := 16#18#;
   BAR3_Offset                    : constant := 16#1C#;
   BAR4_Offset                    : constant := 16#20#;
   BAR5_Offset                    : constant := 16#24#;
   CardBusCISPointer_Offset       : constant := 16#28#;
   SubsystemVID_Offset            : constant := 16#2C#;
   SubsystemID_Offset             : constant := 16#2E#;
   ExpansionROMBaseAddress_Offset : constant := 16#30#;
   CapPointer_Offset              : constant := 16#34#;
   ILR_Offset                     : constant := 16#3C#;
   IPR_Offset                     : constant := 16#3D#;
   MinGNT_Offset                  : constant := 16#3E#;
   MaxLat_Offset                  : constant := 16#3F#;

   -- Command register
   type Command_Type is record
      IOEN     : Boolean := False; -- I/O space enable
      MEMEN    : Boolean := False; -- memory space enable
      BMEN     : Boolean := False; -- bus master enable
      SCYCEN   : Boolean := False; -- special cycle enable
      MWIEN    : Boolean := False; -- memory write invalidate
      VGASNOOP : Boolean := False; -- VGA snoop enable
      PERREN   : Boolean := False; -- parity error enable
      ADSTEP   : Boolean := False; -- address/data stepping enable
      SERREN   : Boolean := False; -- /SERR enable
      FBTBEN   : Boolean := False; -- fast back-to-back enable
      IRQEN    : Boolean := False; -- interrupt enable
      Reserved : Bits_5  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for Command_Type use record
      IOEN     at 0 range  0 ..  0;
      MEMEN    at 0 range  1 ..  1;
      BMEN     at 0 range  2 ..  2;
      SCYCEN   at 0 range  3 ..  3;
      MWIEN    at 0 range  4 ..  4;
      VGASNOOP at 0 range  5 ..  5;
      PERREN   at 0 range  6 ..  6;
      ADSTEP   at 0 range  7 ..  7;
      SERREN   at 0 range  8 ..  8;
      FBTBEN   at 0 range  9 ..  9;
      IRQEN    at 0 range 10 .. 10;
      Reserved at 0 range 11 .. 15;
   end record;

   ----------------------------------------------------------------------------
   -- Configuration space access types
   ----------------------------------------------------------------------------
   -- read/write in PCI configuration space must be done with 32-bit accesses
   ----------------------------------------------------------------------------

   type Cfg_Read_32_Ptr is access function (Port : Unsigned_16) return Unsigned_32;
   type Cfg_Write_32_Ptr is access procedure (Port : in Unsigned_16; Value : in Unsigned_32);

   type Descriptor_Type is record
      Read_32  : Cfg_Read_32_Ptr;
      Write_32 : Cfg_Write_32_Ptr;
   end record;

   ----------------------------------------------------------------------------
   -- subprograms
   ----------------------------------------------------------------------------

   -- Unsigned_8
   function Cfg_Read
      (Descriptor      : Descriptor_Type;
       Bus_Number      : Bus_Number_Type;
       Device_Number   : Device_Number_Type;
       Function_Number : Function_Number_Type;
       Register_Number : Register_Number_Type)
      return Unsigned_8
      with Inline => True;
   procedure Cfg_Write
      (Descriptor      : in Descriptor_Type;
       Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type;
       Register_Number : in Register_Number_Type;
       Value           : in Unsigned_8)
      with Inline => True;

   -- Unsigned_16
   function Cfg_Read
      (Descriptor      : Descriptor_Type;
       Bus_Number      : Bus_Number_Type;
       Device_Number   : Device_Number_Type;
       Function_Number : Function_Number_Type;
       Register_Number : Register_Number_Type)
      return Unsigned_16
      with Inline => True;
   procedure Cfg_Write
      (Descriptor      : in Descriptor_Type;
       Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type;
       Register_Number : in Register_Number_Type;
       Value           : in Unsigned_16)
      with Inline => True;

   -- Unsigned_32
   function Cfg_Read
      (Descriptor      : Descriptor_Type;
       Bus_Number      : Bus_Number_Type;
       Device_Number   : Device_Number_Type;
       Function_Number : Function_Number_Type;
       Register_Number : Register_Number_Type)
      return Unsigned_32
      with Inline => True;
   procedure Cfg_Write
      (Descriptor      : in Descriptor_Type;
       Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type;
       Register_Number : in Register_Number_Type;
       Value           : in Unsigned_32)
      with Inline => True;

   procedure Cfg_Detect_Device
      (Descriptor    : in     Descriptor_Type;
       Bus_Number    : in     Bus_Number_Type;
       Device_Number : in     Device_Number_Type;
       Vendor_Id     :    out Vendor_Id_Type;
       Device_Id     :    out Device_Id_Type;
       Success       :    out Boolean);

   procedure Cfg_Find_Device_By_Id
      (Descriptor    : in     Descriptor_Type;
       Bus_Number    : in     Bus_Number_Type;
       Vendor_Id     : in     Vendor_Id_Type;
       Device_Id     : in     Device_Id_Type;
       Device_Number :    out Device_Number_Type;
       Success       :    out Boolean);

end PCI;
