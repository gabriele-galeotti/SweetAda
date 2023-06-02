-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ne2000.adb                                                                                                --
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
with Bits;
with MMIO;
with CPU;
with Console;

package body NE2000 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Bits;

   ----------------------------------------------------------------------------
   -- Register mapping
   ----------------------------------------------------------------------------

   type Register_Type is
      (
       -- Command Register, all pages
       CR,
       -- Page 0 (R)
       CLDA0, CLDA1, BNRY, TSR, NCR, FIFO, ISRR, CRDA0, CRDA1, ID0, ID1, RSR, CNTR0, CNTR1, CNTR2,
       -- Remote DMA, RESET, all pages
       RDMA, RST,
       -- Page 1 (R/W)
       PAR0, PAR1, PAR2, PAR3, PAR4, PAR5, CURR, MAR0, MAR1, MAR2, MAR3, MAR4, MAR5, MAR6, MAR7,
       -- Page 2 (R)
       PSTARTR, PSTOPR, TPSRR, RCRR, TCRR, DCRR, IMRR,
       -- Page 3 (R/W)
       CR9346, CONFIG0, CONFIG2, CONFIG3, HLTCLK, ASID0, ASID1,
       -- Page 0 (W)
       PSTARTW, PSTOPW, TPSRW, TBCR0, TBCR1, ISRW, RSAR0, RSAR1, RBCR0, RBCR1, RCRW, TCRW, DCRW, IMRW
      );
   -- Page := RP_Type (Register_Type'Enum_Rep (Register) / 2**8);
   for Register_Type use
      (
       16#000#, -- CR      all
       16#001#, -- CLDA0   R   0
       16#002#, -- CLDA1   R   0
       16#003#, -- BNRY    R   0
       16#004#, -- TSR     R   0
       16#005#, -- NCR     R   0
       16#006#, -- FIFO    R   0
       16#007#, -- ISRR    R   0
       16#008#, -- CRDA0   R   0
       16#009#, -- CRDA1   R   0
       16#00A#, -- ID0     R   0
       16#00B#, -- ID1     R   0
       16#00C#, -- RSR     R   0
       16#00D#, -- CNTR0   R   0
       16#00E#, -- CNTR1   R   0
       16#00F#, -- CNTR2   R   0
       16#010#, -- RDMA    all
       16#01F#, -- RST     all
       -- Page 1
       16#101#, -- PAR0    R/W 1
       16#102#, -- PAR1    R/W 1
       16#103#, -- PAR2    R/W 1
       16#104#, -- PAR3    R/W 1
       16#105#, -- PAR4    R/W 1
       16#106#, -- PAR5    R/W 1
       16#107#, -- CURR    R/W 1
       16#108#, -- MAR0    R/W 1
       16#109#, -- MAR1    R/W 1
       16#10A#, -- MAR2    R/W 1
       16#10B#, -- MAR3    R/W 1
       16#10C#, -- MAR4    R/W 1
       16#10D#, -- MAR5    R/W 1
       16#10E#, -- MAR6    R/W 1
       16#10F#, -- MAR7    R/W 1
       -- Page 2
       16#201#, -- PSTARTR R   2
       16#202#, -- PSTOPW  R   2
       16#204#, -- TPSRR   R   0
       16#20C#, -- RCRR    R   2
       16#20D#, -- TCRR    R   2
       16#20E#, -- DCRR    R   2
       16#20F#, -- IMRR    R   2
       -- Page 3
       16#301#, -- CR9346  R/W 3
       16#303#, -- CONFIG0 R   3
       16#305#, -- CONFIG2 R/W 3
       16#306#, -- CONFIG3 R/W 3
       16#309#, -- HLTCLK  W   3
       16#30E#, -- ASID0   R   3
       16#30F#, -- ASID1   R   3
       -- Page 0 alias
       16#401#, -- PSTARTW W   0
       16#402#, -- PSTOPW  W   0
       16#404#, -- TPSRW   W   0
       16#405#, -- TBCR0   W   0
       16#406#, -- TBCR1   W   0
       16#407#, -- ISRW    W   0
       16#408#, -- RSAR0   W   0
       16#409#, -- RSAR1   W   0
       16#40A#, -- RBCR0   W   0
       16#40B#, -- RBCR1   W   0
       16#40C#, -- RCRW    W   0
       16#40D#, -- TCRW    W   0
       16#40E#, -- DCRW    W   0
       16#40F#  -- IMRW    W   0
      );

   ----------------------------------------------------------------------------
   -- CR: Command Register (00H; Type=R/W)
   ----------------------------------------------------------------------------

   subtype RD_Type is Bits_3;
   subtype PS_Type is Bits_2;

   -- RD field encoding
   RD_INVALID   : constant := 2#000#; -- Not allowed
   REMOTE_READ  : constant := 2#001#; -- Remote Read
   REMOTE_WRITE : constant := 2#010#; -- Remote Write
   SEND_PACKET  : constant := 2#011#; -- Send Packet
   ABRT_CMPLT   : constant := 2#100#; -- Abort/Complete remote DMA

   -- PS field encoding
   PAGE0 : constant := 2#00#;
   PAGE1 : constant := 2#01#;
   PAGE2 : constant := 2#10#;
   PAGE3 : constant := 2#11#;

   type CR_Type is
   record
      STP : Boolean; -- STOP
      STA : Boolean; -- START
      TXP : Boolean; -- TRANSMIT PACKET
      RD  : Bits_3;  -- REMOTE DMA COMMAND
      PS  : PS_Type; -- PAGE SELECT
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CR_Type use
   record
      STP at 0 range 0 .. 0;
      STA at 0 range 1 .. 1;
      TXP at 0 range 2 .. 2;
      RD  at 0 range 3 .. 5;
      PS  at 0 range 6 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (CR_Type, Unsigned_8);
   function To_CR is new Ada.Unchecked_Conversion (Unsigned_8, CR_Type);

   -- useful record aggregates for setting CR, (valid only for START = True)
   CR_NODMA : constant CR_Type := (STP => False, STA => True, TXP => False, RD => ABRT_CMPLT, PS => PAGE0);
   CR_RD    : constant CR_Type := (STP => False, STA => True, TXP => False, RD => REMOTE_READ, PS => PAGE0);
   CR_WR    : constant CR_Type := (STP => False, STA => True, TXP => False, RD => REMOTE_WRITE, PS => PAGE0);
   CR_TX    : constant CR_Type := (STP => False, STA => True, TXP => True, RD => ABRT_CMPLT, PS => PAGE0);

   -- Page select
   CR_PAGE0 : CR_Type renames CR_NODMA;
   CR_PAGE1 : constant CR_Type := (STP => False, STA => True, TXP => False, RD => ABRT_CMPLT, PS => PAGE1);
   CR_PAGE2 : constant CR_Type := (STP => False, STA => True, TXP => False, RD => ABRT_CMPLT, PS => PAGE2);

   ----------------------------------------------------------------------------
   -- TSR: Transmit Status Register (04H; Type=R in Page0)
   ----------------------------------------------------------------------------

   type TSR_Type is
   record
      PTX    : Boolean; -- PACKET TRANSMITTED
      Unused : Bits_1;
      COL    : Boolean; -- TRANSMIT COLLIDED
      ABT    : Boolean; -- TRANSMIT ABORTED
      CRS    : Boolean; -- CARRIER SENSE LOST
      FU     : Boolean; -- FIFO UNDERRUN not present in RTL8029
      CDH    : Boolean; -- CD HEARTBEAT
      OWC    : Boolean; -- OUT OF WINDOW COLLISION
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for TSR_Type use
   record
     PTX    at 0 range 0 .. 0;
     Unused at 0 range 1 .. 1;
     COL    at 0 range 2 .. 2;
     ABT    at 0 range 3 .. 3;
     CRS    at 0 range 4 .. 4;
     FU     at 0 range 5 .. 5;
     CDH    at 0 range 6 .. 6;
     OWC    at 0 range 7 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- ISR: Interrupt Status Register (07H; Type=R/W in Page0)
   ----------------------------------------------------------------------------

   type ISR_Type is
   record
      PRX : Boolean;
      PTX : Boolean;
      RXE : Boolean;
      TXE : Boolean;
      OVW : Boolean;
      CNT : Boolean;
      RDC : Boolean;
      RST : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ISR_Type use
   record
     PRX at 0 range 0 .. 0;
     PTX at 0 range 1 .. 1;
     RXE at 0 range 2 .. 2;
     TXE at 0 range 3 .. 3;
     OVW at 0 range 4 .. 4;
     CNT at 0 range 5 .. 5;
     RDC at 0 range 6 .. 6;
     RST at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (ISR_Type, Unsigned_8);
   function To_ISR is new Ada.Unchecked_Conversion (Unsigned_8, ISR_Type);

   ISR_PRX : constant ISR_Type := (PRX => True, others => False);
   ISR_PTX : constant ISR_Type := (PTX => True, others => False);
   ISR_RDC : constant ISR_Type := (RDC => True, others => False);
   ISR_RST : constant ISR_Type := (RST => True, others => False);
   ISR_ALL : constant ISR_Type := (others => True);

   ----------------------------------------------------------------------------
   -- RCR: Receive Configuration Register (0CH; Type=W in Page0, Type=R in Page2)
   ----------------------------------------------------------------------------

   type RCR_Type is
   record
      SEP    : Boolean; -- SAVE ERRORED PACKETS
      AR     : Boolean; -- ACCEPT RUNT PACKETS
      AB     : Boolean; -- ACCEPT BROADCAST
      AM     : Boolean; -- ACCEPT MULTICAST
      PRO    : Boolean; -- PROMISCUOUS PHYSICAL
      MON    : Boolean; -- MONITOR MODE
      Unused : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for RCR_Type use
   record
      SEP    at 0 range 0 .. 0;
      AR     at 0 range 1 .. 1;
      AB     at 0 range 2 .. 2;
      AM     at 0 range 3 .. 3;
      PRO    at 0 range 4 .. 4;
      MON    at 0 range 5 .. 5;
      Unused at 0 range 6 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (RCR_Type, Unsigned_8);
   function To_RCR is new Ada.Unchecked_Conversion (Unsigned_8, RCR_Type);

   ----------------------------------------------------------------------------
   -- RSR: Receive Status Register (0CH; Type=R in Page0)
   ----------------------------------------------------------------------------

   type RSR_Type is
   record
      PRX : Boolean; -- PACKET RECEIVED INTACT
      CRC : Boolean; -- CRC ERROR
      FAE : Boolean; -- FRAME ALIGNMENT ERROR
      FO  : Boolean; -- FIFO OVERRUN not present in original 8390
      MPA : Boolean; -- MISSED PACKET
      PHY : Boolean; -- PHYSICAL/MULTICAST ADDRESS
      DIS : Boolean; -- RECEIVER DISABLED
      DFR : Boolean; -- DEFERRING
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for RSR_Type use
   record
      PRX at 0 range 0 .. 0;
      CRC at 0 range 1 .. 1;
      FAE at 0 range 2 .. 2;
      FO  at 0 range 3 .. 3;
      MPA at 0 range 4 .. 4;
      PHY at 0 range 5 .. 5;
      DIS at 0 range 6 .. 6;
      DFR at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (RSR_Type, Unsigned_8);
   function To_RSR is new Ada.Unchecked_Conversion (Unsigned_8, RSR_Type);

   ----------------------------------------------------------------------------
   -- TCR: Transmit Configuration Register (0DH; Type=W in Page0, Type=R in Page2)
   ----------------------------------------------------------------------------

   LB_Normal    : constant := 2#00#; -- LOOPBACK MODE 0
   LB_Internal  : constant := 2#01#; -- LOOPBACK MODE 1
   LB_External2 : constant := 2#10#; -- LOOPBACK MODE 2
   LB_External3 : constant := 2#11#; -- LOOPBACK MODE 3

   type TCR_Type is
   record
      CRC    : Boolean; -- INHIBIT CRC
      LB     : Bits_2;  -- ENCODED LOOPBACK CONTROL
      ATD    : Boolean; -- AUTO TRANSMIT DISABLE
      OFST   : Boolean; -- COLLISION OFFSET ENABLE
      Unused : Bits_3;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for TCR_Type use
   record
      CRC    at 0 range 0 .. 0;
      LB     at 0 range 1 .. 2;
      ATD    at 0 range 3 .. 3;
      OFST   at 0 range 4 .. 4;
      Unused at 0 range 5 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (TCR_Type, Unsigned_8);
   function To_TCR is new Ada.Unchecked_Conversion (Unsigned_8, TCR_Type);

   ----------------------------------------------------------------------------
   -- DCR: Data Configuration Register (0EH; Type=W in Page0, Type=R in Page2)
   ----------------------------------------------------------------------------

   FT1 : constant := 2#00#; -- 1 word, 2 bytes
   FT2 : constant := 2#01#; -- 2 word, 4 bytes
   FT4 : constant := 2#10#; -- 4 word, 8 bytes
   FT6 : constant := 2#11#; -- 6 word, 12 bytes

   type DCR_Type is
   record
      WTS    : Boolean; -- WORD TRANSFER SELECT False => byte-wide, True => word-wide (16-bit)
      BOS    : Boolean; -- BYTE ORDER SELECT
      LAS    : Boolean; -- LONG ADDRESS SELECT
      LS     : Boolean; -- LOOPBACK SELECT
      AR     : Boolean; -- AUTO-INITIALIZE REMOTE
      FT     : Bits_2;  -- FIFO THRESHOLD SELECT
      Unused : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for DCR_Type use
   record
      WTS    at 0 range 0 .. 0;
      BOS    at 0 range 1 .. 1;
      LAS    at 0 range 2 .. 2;
      LS     at 0 range 3 .. 3;
      AR     at 0 range 4 .. 4;
      FT     at 0 range 5 .. 6;
      Unused at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (DCR_Type, Unsigned_8);

   ----------------------------------------------------------------------------
   -- IMR: Interrupt Mask Register (0FH; Type=W in Page0, Type=R in Page2)
   ----------------------------------------------------------------------------

   type IMR_Type is
   record
      PRXE : Boolean;
      PTXE : Boolean;
      RXEE : Boolean;
      TXEE : Boolean;
      OVWE : Boolean;
      CNTE : Boolean;
      RDCE : Boolean; -- enable remote DMA complete
      RSTE : Boolean; -- not present in original 8390
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for IMR_Type use
   record
     PRXE at 0 range 0 .. 0;
     PTXE at 0 range 1 .. 1;
     RXEE at 0 range 2 .. 2;
     TXEE at 0 range 3 .. 3;
     OVWE at 0 range 4 .. 4;
     CNTE at 0 range 5 .. 5;
     RDCE at 0 range 6 .. 6;
     RSTE at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (IMR_Type, Unsigned_8);
   function To_IMR is new Ada.Unchecked_Conversion (Unsigned_8, IMR_Type);

   ----------------------------------------------------------------------------
   -- 9346CR: 9346 Command Register (01H; Type=R/W except Bit0=R)
   ----------------------------------------------------------------------------

   EEM_Normal   : constant := 2#00#; -- Normal (DP8390 compatible)
   EEM_AutoLoad : constant := 2#01#; -- RTL8029AS load the contents of 9346 like when the RSTB signal is asserted.
   EEM_Prg9346  : constant := 2#10#; -- 9346 programming
   EEM_CfgWE    : constant := 2#11#; -- Config register write enable

   type CR9346_Type is
   record
      EEDO   : Bits_1 := 0; -- state of EEDO pin in auto-load or 9346 programming mode.
      EEDI   : Bits_1 := 0; -- state of EEDI pin in auto-load or 9346 programming mode.
      EESK   : Bits_1 := 0; -- state of EESK pin in auto-load or 9346 programming mode.
      EECS   : Bits_1 := 0; -- state of EECS pin in auto-load or 9346 programming mode.
      Unused : Bits_2 := 0;
      EEM    : Bits_2;      -- These 2 bits select the RTL8029AS operating mode.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CR9346_Type use
   record
      EEDO   at 0 range 0 .. 0;
      EEDI   at 0 range 1 .. 1;
      EESK   at 0 range 2 .. 2;
      EECS   at 0 range 3 .. 3;
      Unused at 0 range 4 .. 5;
      EEM    at 0 range 6 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (CR9346_Type, Unsigned_8);

   ----------------------------------------------------------------------------
   -- CONFIG0: RTL8029AS Configuration Register 0 (03H; Type=R)
   ----------------------------------------------------------------------------

   type CONFIG0_Type is
   record
      Unused1 : Bits_2 := 0;
      BNC     : Boolean;     -- RTL8029AS is using the 10Base2 thin cable as its networking medium.
      Unused2 : Bits_5 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CONFIG0_Type use
   record
      Unused1 at 0 range 0 .. 1;
      BNC     at 0 range 2 .. 2;
      Unused2 at 0 range 3 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (CONFIG0_Type, Unsigned_8);

   ----------------------------------------------------------------------------
   -- CONFIG2: RTL8029AS Configuration Register 2 (05H; Type=R except Bit[7:5]=R/W)
   ----------------------------------------------------------------------------

   BS_NoROM : constant := 2#00#; -- No Boot ROM
   BS_8K    : constant := 2#01#; -- 8K Boot ROM
   BS_16K   : constant := 2#10#; -- 16K Boot ROM
   BS_32K   : constant := 2#11#; -- 32K Boot ROM

   PL_TPCX    : constant := 2#00#; -- TP/CX auto-detect (10BaseT link test is enabled)
   PL_10BaseT : constant := 2#01#; -- 10BaseT with link test disabled
   PL_10Base5 : constant := 2#10#; -- 10Base5
   PL_10Base2 : constant := 2#11#; -- 10Base2

   type CONFIG2_Type is
   record
      BS     : Bits_2;      -- Select Boot ROM size
      Unused : Bits_2 := 0;
      PF     : Boolean;     -- Pause Flag
      FCE    : Boolean;     -- Flow Control Enable
      PL     : Bits_2;      -- Select network medium types.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CONFIG2_Type use
   record
      BS     at 0 range 0 .. 1;
      Unused at 0 range 2 .. 3;
      PF     at 0 range 4 .. 4;
      FCE    at 0 range 5 .. 5;
      PL     at 0 range 6 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (CONFIG2_Type, Unsigned_8);

   ----------------------------------------------------------------------------
   -- CONFIG3: RTL8029AS Configuration Register 3 (06H; Type=R except Bit[6,2:1]=R/W)
   ----------------------------------------------------------------------------

   LEDS0_L0COL  : constant := 0;
   LEDS0_L0LINK : constant := 1;

   LEDS1_L1RXL2TX    : constant := 0;
   LEDS1_L1CRSL2MCSB : constant := 1;

   type CONFIG3_Type is
   record
      Unused1  : Bits_1 := 0;
      PWRDN    : Boolean;     -- This bit, when set, puts RTL8029AS into power down mode.
      SLEEP    : Boolean;     -- This bit, when set, puts RTL8029AS into sleep mode.
      Reserved : Bits_1 := 0;
      LEDS0    : Bits_1;      -- These two bits select the outputs to LED2-0 pins.
      LEDS1    : Bits_1;      -- These two bits select the outputs to LED2-0 pins.
      FUDUP    : Boolean;     -- When this bit is set, RTL8029AS is set to the full-duplex mode
      Unused2  : Bits_1 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CONFIG3_Type use
   record
      Unused1  at 0 range 0 .. 0;
      PWRDN    at 0 range 1 .. 1;
      SLEEP    at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 3;
      LEDS0    at 0 range 4 .. 4;
      LEDS1    at 0 range 5 .. 5;
      FUDUP    at 0 range 6 .. 6;
      Unused2  at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (CONFIG3_Type, Unsigned_8);

   ----------------------------------------------------------------------------
   -- Ring descriptor
   ----------------------------------------------------------------------------

   RING_DESCRIPTOR_SIZE : constant := 4;

   type Ring_Descriptor_Type is
   record
      Receive_Status      : Unsigned_8;
      Next_Packet_Pointer : Unsigned_8;
      Receive_Byte_Count  : Unsigned_16; -- byte count, including this descriptor
   end record with
      Bit_Order => Low_Order_First,
      Size      => RING_DESCRIPTOR_SIZE * Storage_Unit;
   for Ring_Descriptor_Type use
   record
      Receive_Status      at 0 range 0 .. 7;
      Next_Packet_Pointer at 1 range 0 .. 7;
      Receive_Byte_Count  at 2 range 0 .. 15;
   end record;

   function To_RDT is new Ada.Unchecked_Conversion (Unsigned_32, Ring_Descriptor_Type);

   ----------------------------------------------------------------------------
   -- Local subprograms
   ----------------------------------------------------------------------------

   function Port_Address
      (Base_Address : in Unsigned_16;
       R            : in Register_Type)
      return Unsigned_16 with
      Inline => True;
   procedure Reset
      (D : in Descriptor_Type);
   procedure Setup
      (D : in out Descriptor_Type);
   procedure Update
      (D : in out Descriptor_Type);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Port_Address
   ----------------------------------------------------------------------------
   function Port_Address
      (Base_Address : in Unsigned_16;
       R            : in Register_Type)
      return Unsigned_16
      is
   begin
      return Base_Address + (Register_Type'Enum_Rep (R) and 16#FF#);
   end Port_Address;
   -- shorthand
   function PA
      (Base_Address : in Unsigned_16;
       R            : in Register_Type)
      return Unsigned_16 renames Port_Address;

   ----------------------------------------------------------------------------
   -- Reset
   ----------------------------------------------------------------------------
   procedure Reset
      (D : in Descriptor_Type)
      is
      BAR : Unsigned_16;
      function In8 (Port : in Unsigned_16) return Unsigned_8 renames D.Read_8.all;
      procedure Out8 (Port : in Unsigned_16; Value : in Unsigned_8) renames D.Write_8.all;
   begin
      BAR := D.BAR;
      Out8 (PA (BAR, RST), In8 (PA (BAR, RST))); -- read = enable RESET, then write = disable RESET
      loop
         exit when To_ISR (In8 (PA (BAR, ISRR))).RST;
      end loop;
      Out8 (PA (BAR, ISRW), To_U8 (ISR_RST)); -- clear interrupt
   end Reset;

   ----------------------------------------------------------------------------
   -- Probe
   ----------------------------------------------------------------------------
   procedure Probe
      (Device_Number : out PCI.Device_Number_Type;
       Success       : out Boolean)
      is
      use PCI;
   begin
      Cfg_Find_Device_By_Id (BUS0, VENDOR_ID_REALTEK, DEVICE_ID_RTL8029, Device_Number, Success);
      if Success then
         Console.Print (Unsigned_8 (Device_Number), Prefix => "RTL8029 @ PCI DevNum ", NL => True);
      end if;
   end Probe;

   ----------------------------------------------------------------------------
   -- Setup
   -- 11.0 Initialization Procedures
   ----------------------------------------------------------------------------
   procedure Setup
      (D : in out Descriptor_Type)
      is
      BAR : Unsigned_16;
      function In8 (Port : Unsigned_16) return Unsigned_8 renames D.Read_8.all;
      procedure Out8 (Port : in Unsigned_16; Value : in Unsigned_8) renames D.Write_8.all;
   begin
      Reset (D);
      BAR := D.BAR;
      -- Page 3 (NE2000 PCI only)
      if D.NE2000PCI then
         Out8 (PA (BAR, CR), To_U8 (CR_Type'(STP => True, STA => False, TXP => False, RD => ABRT_CMPLT, PS => PAGE3)));
         Out8 (PA (BAR, CR9346), To_U8 (CR9346_Type'(
            EEM    => EEM_CfgWE, -- Config register write enable
            others => <>
            )));
         Out8 (PA (BAR, CONFIG0), To_U8 (CONFIG0_Type'(
            BNC    => False,
            others => <>
            )));
         Out8 (PA (BAR, CONFIG2), To_U8 (CONFIG2_Type'(
            PF     => False,
            FCE    => False,
            PL     => PL_TPCX,
            others => <>
            )));
         Out8 (PA (BAR, CONFIG3), To_U8 (CONFIG3_Type'(
            PWRDN  => False,
            SLEEP  => False,
            LEDS0  => LEDS0_L0LINK,
            LEDS1  => LEDS1_L1RXL2TX,
            FUDUP  => False,
            others => <>
            )));
         Out8 (PA (BAR, CR9346), To_U8 (CR9346_Type'(
            EEM    => EEM_Normal, -- Normal (DP8390 compatible)
            others => <>
            )));
      end if;
      -- Page 0
      Out8 (PA (BAR, CR), To_U8 (CR_Type'(STP => True, STA => False, TXP => False, RD => ABRT_CMPLT, PS => PAGE0)));
      Out8 (
            -- DCR: FIFO threshold = 8, no auto-init remote DMA, BOS = 80x86, word-wide DMA transfers
            PA (BAR, DCRW),
            To_U8 (DCR_Type'(WTS => True, BOS => False, LAS => False, LS => True, AR => False, FT => FT4, Unused => 0))
           );
      Out8 (PA (BAR, RBCR0), 16#00#);   -- RBCR0: clear remote byte count LO
      Out8 (PA (BAR, RBCR1), 16#00#);   -- RBCR1: clear remote byte count HI
      Out8 (PA (BAR, RCRW), 16#14#);    -- RCR: accept broadcast packets __FIX__ perché anche PRO?
      Out8 (PA (BAR, TCRW), To_U8 (TCR_Type'(CRC => False, LB => LB_Internal, ATD => False, OFST => False, Unused => 0)));
      Out8 (PA (BAR, BNRY), 16#40#);    -- BNRY: set boundary
      Out8 (PA (BAR, PSTARTW), 16#40#); -- PSTART: set page start
      Out8 (PA (BAR, PSTOPW), 16#7F#);  -- PSTOP: set page stop
      Out8 (PA (BAR, ISRW), To_U8 (ISR_ALL));
      Out8 (PA (BAR, IMRW), To_U8 (IMR_Type'(PRXE => True, PTXE => True, others => False)));
      -- Page 1
      Out8 (PA (BAR, CR), To_U8 (CR_Type'(STP => True, STA => False, TXP => False, RD => ABRT_CMPLT, PS => PAGE1)));
      declare
         PAR : Register_Type := PAR0;
      begin
         for Index in D.MAC'Range loop
            Out8 (PA (BAR, PAR), D.MAC (Index));
            PAR := Register_Type'Succ (PAR);
         end loop;
      end;
      for MAR in Register_Type range MAR0 .. MAR7 loop
         Out8 (PA (BAR, MAR), 16#FF#);
      end loop;
      Out8 (PA (BAR, CURR), 16#40#); -- CURR: set current page
      D.Next_Ptr := 16#40#;
      -- Page 0: START and disable loopback
      Out8 (PA (BAR, CR), To_U8 (CR_Type'(STP => False, STA => True, TXP => False, RD => ABRT_CMPLT, PS => PAGE0)));
      Out8 (
            -- DCR: FIFO threshold = 8, no auto-init remote DMA, BOS = 80x86, word-wide DMA transfers
            PA (BAR, DCRW),
            To_U8 (DCR_Type'(WTS => True, BOS => False, LAS => False, LS => False, AR => False, FT => FT4, Unused => 0))
           );
      Out8 (PA (BAR, TCRW), To_U8 (TCR_Type'(CRC => False, LB => LB_Normal, ATD => False, OFST => False, Unused => 0)));
   end Setup;

   ----------------------------------------------------------------------------
   -- Interrupt_Handler
   ----------------------------------------------------------------------------
   procedure Interrupt_Handler
      (Descriptor_Address : in Address) is
      D      : Descriptor_Type with
         Address    => Descriptor_Address,
         Import     => True,
         Convention => Ada;
      BAR    : Unsigned_16;
      Status : ISR_Type;
      function In8 (Port : Unsigned_16) return Unsigned_8 renames D.Read_8.all;
      procedure Out8 (Port : in Unsigned_16; Value : in Unsigned_8) renames D.Write_8.all;
   begin
      BAR := D.BAR;
      -- Page 0 NODMA
      Out8 (PA (BAR, CR), To_U8 (CR_PAGE0));
      Status := To_ISR (In8 (PA (BAR, ISRR)));
      if Status.PRX then
         -- Out8 (PA (BAR, ISRW), To_U8 (ISR_PRX));
         Receive (D);
         -- Console.Print ("RX", NL => True);
         Out8 (PA (BAR, CR), To_U8 (CR_PAGE0));
         -- Out8 (PA (BAR, ISRW), To_U8 (ISR_PRX));
      end if;
      if Status.PTX then
         Out8 (PA (BAR, ISRW), To_U8 (ISR_PTX));
      end if;
   end Interrupt_Handler;

   ----------------------------------------------------------------------------
   -- Update
   ----------------------------------------------------------------------------
   procedure Update
      (D : in out Descriptor_Type)
      is
      BAR : Unsigned_16;
      procedure Out8 (Port : in Unsigned_16; Value : in Unsigned_8) renames D.Write_8.all;
   begin
      BAR := D.BAR;
      -- Page 1 NODMA
      Out8 (PA (BAR, CR), To_U8 (CR_PAGE1));
      Out8 (PA (BAR, CURR), 16#40#);         -- CURR: set current page
      -- Page 0 NODMA
      Out8 (PA (BAR, CR), To_U8 (CR_PAGE0));
      Out8 (PA (BAR, RBCR0), 16#00#);        -- RBCR0: clear remote byte count LO
      Out8 (PA (BAR, RBCR1), 16#00#);        -- RBCR1: clear remote byte count HI
      Out8 (PA (BAR, BNRY), 16#40#);         -- BNRY: set boundary
      -- update Next pointer
      D.Next_Ptr := 16#40#;
   end Update;

   ----------------------------------------------------------------------------
   -- Receive
   ----------------------------------------------------------------------------
   procedure Receive
      (D : in out Descriptor_Type)
      is
      BAR               : Unsigned_16;
      NIC_Packet_Header : Ring_Descriptor_Type;
      P                 : Pbuf_Ptr;
      Index             : Storage_Offset;
      function In8 (Port : Unsigned_16) return Unsigned_8 renames D.Read_8.all;
      function In16 (Port : Unsigned_16) return Unsigned_16 renames D.Read_16.all;
      function In32 (Port : Unsigned_16) return Unsigned_32 renames D.Read_32.all;
      procedure Out8 (Port : in Unsigned_16; Value : in Unsigned_8) renames D.Write_8.all;
      procedure Setup_DMA_Port (Memory_Address : in Unsigned_16; Byte_Count : in Unsigned_16);
      procedure Setup_DMA_Port (Memory_Address : in Unsigned_16; Byte_Count : in Unsigned_16) is
      begin
         -- Page 0 NODMA
         Out8 (PA (BAR, CR), To_U8 (CR_PAGE0));
         Out8 (PA (BAR, RSAR0), LByte (Memory_Address)); -- RSAR0: set remote start address LO
         Out8 (PA (BAR, RSAR1), HByte (Memory_Address)); -- RSAR1: set remote start address HI
         Out8 (PA (BAR, RBCR0), LByte (Byte_Count));     -- RBCR0: set remote byte count LO
         Out8 (PA (BAR, RBCR1), HByte (Byte_Count));     -- RBCR1: set remote byte count HI
      end Setup_DMA_Port;
      procedure Packet_Dump_Length;
      procedure Packet_Dump_Length is
      begin
         Console.Print (NIC_Packet_Header.Receive_Status,               Prefix => "RSR:           ", NL => True);
         Console.Print (Integer (NIC_Packet_Header.Receive_Byte_Count), Prefix => "packet length: ", NL => True);
      end Packet_Dump_Length;
   begin
      BAR := D.BAR;
      while True loop
         -- Page 0 NODMA
         Out8 (PA (BAR, CR), To_U8 (CR_PAGE0));
         exit when not To_RSR (In8 (PA (BAR, RSR))).PRX;
         -- Page 1 NODMA
         Out8 (PA (BAR, CR), To_U8 (CR_PAGE1));
         exit when In8 (PA (BAR, CURR)) /= D.Next_Ptr;
         Setup_DMA_Port (Unsigned_16 (D.Next_Ptr) * 2**8, RING_DESCRIPTOR_SIZE);
         -- Page 0 RD
         Out8 (PA (BAR, CR), To_U8 (CR_RD));
         if D.NE2000PCI then
            NIC_Packet_Header := To_RDT (In32 (PA (BAR, RDMA)));
         else
            declare
               type U16_2 is new Bits.U16_Array (0 .. 1) with Alignment => Unsigned_32'Alignment;
               PH : U16_2;
               function To_U32 is new Ada.Unchecked_Conversion (U16_2, Unsigned_32);
            begin
               PH (Bits.L16_8_IDX) := In16 (PA (BAR, RDMA));
               PH (Bits.H16_8_IDX) := In16 (PA (BAR, RDMA));
               NIC_Packet_Header := To_RDT (To_U32 (PH));
            end;
         end if;
         if To_RSR (NIC_Packet_Header.Receive_Status).CRC or else
            To_RSR (NIC_Packet_Header.Receive_Status).FAE or else
            To_RSR (NIC_Packet_Header.Receive_Status).MPA
         then
            -- RX error
            Update (D);
            return;
         end if;
         NIC_Packet_Header.Receive_Byte_Count := NIC_Packet_Header.Receive_Byte_Count - RING_DESCRIPTOR_SIZE;
         -- set read packet
         Setup_DMA_Port (
                         Unsigned_16 (D.Next_Ptr) * 2**8 + RING_DESCRIPTOR_SIZE,
                         NIC_Packet_Header.Receive_Byte_Count
                        );
         -- Page 0 RD
         Out8 (PA (BAR, CR), To_U8 (CR_RD));
         -- Out8 (PA (BAR, ISRW), To_U8 (ISR_PRX));
         -- Out8 (PA (BAR, ISRW), To_U8 (ISR_RDC));
         -- allocate a Pbuf
         P := Allocate (Natural (NIC_Packet_Header.Receive_Byte_Count));
         Out8 (PA (BAR, ISRW), To_U8 (ISR_PRX));
         if P = null then
            -- __FIX__ --------------------------------------------------
            -- dump packet information
            Packet_Dump_Length;
            Console.Print ("*** Error: no pbufs available", NL => True);
            loop null; end loop;
            -- update packet pointer according to NIC-created packet header informations
            -- Descriptor.Next_Ptr := NIC_Packet_Header.Next_Packet_Pointer;
            -- reselect PAGE1, otherwise the while loop test condition fails
            -- Out8 (BAR + 16#00#, To_U8 (CR_Type'(STP => True, STA => False, TXP => False, RD => ABRT_CMPLT, PS => PAGE1)));
            -- __FIX__ --------------------------------------------------
         else
            -- read packet data
            Index := 0;
            if D.NE2000PCI then
               loop
                  -- exit when To_ISR (In8 (BAR + 16#07#)).RDC;
                  MMIO.Write (Payload_Address (P) + Index, In32 (PA (BAR, RDMA)));
                  Index := Index + 4;
                  exit when Index >= Storage_Offset (NIC_Packet_Header.Receive_Byte_Count);
               end loop;
            else
               loop
                  -- exit when To_ISR (In8 (BAR + 16#07#)).RDC;
                  MMIO.Write (Payload_Address (P) + Index, In16 (PA (BAR, RDMA)));
                  Index := Index + 2;
                  exit when Index >= Storage_Offset (NIC_Packet_Header.Receive_Byte_Count);
               end loop;
            end if;
            -- update packet pointer according to NIC-created packet header informations
            D.Next_Ptr := NIC_Packet_Header.Next_Packet_Pointer;
            -- Console.Print_Memory (Payload_Address (P), Bits.Bytesize (NIC_Packet_Header.Receive_Byte_Count));
            declare
               Success : Boolean;
            begin
               Ethernet.Enqueue (Ethernet.Packet_Queue'Access, P, Success);
               if not Success then
                  Console.Print ("*** Error: no FIFO slots available", NL => True);
                  Free (P);
                  -- loop null; end loop;
               end if;
            end;
         end if;
      end loop;
      Update (D);
   end Receive;

   ----------------------------------------------------------------------------
   -- Transmit
   ----------------------------------------------------------------------------
   procedure Transmit
      (Descriptor_Address : in Address;
       P                  : in Pbuf_Ptr)
      is
      D          : Descriptor_Type with
         Address    => Descriptor_Address,
         Volatile   => True,
         Import     => True,
         Convention => Ada;
      BAR        : Unsigned_16;
      Byte_Idx   : Integer;
      Data       : Unsigned_32;
      Irq_State  : CPU.Irq_State_Type;
      function In8 (Port : Unsigned_16) return Unsigned_8 renames D.Read_8.all;
      procedure Out8 (Port : in Unsigned_16; Value : in Unsigned_8) renames D.Write_8.all;
      procedure Out32 (Port : in Unsigned_16; Value : in Unsigned_32) renames D.Write_32.all;
      procedure Packet_Dump;
      procedure Packet_Dump is
      begin
         Console.Print (P.all.Size, Prefix => "Packet tx is: ", NL => True);
         Console.Print_Memory (Payload_Address (P), Bits.Bytesize (P.all.Size));
      end Packet_Dump;
   begin
      Irq_State := CPU.Irq_State_Get;
      CPU.Irq_Disable;
      BAR := D.BAR;
      -- Page 0 NODMA
      Out8 (PA (BAR, CR), To_U8 (CR_PAGE0));
      Out8 (PA (BAR, RSAR0), 16#00#);                  -- RSAR0: set remote start address LO
      Out8 (PA (BAR, RSAR1), 16#42#);                  -- RSAR1: set remote start address HI
      Out8 (PA (BAR, RBCR0), Unsigned_8 (P.all.Size)); -- RBCR0: set remote byte count LO
      Out8 (PA (BAR, RBCR1), 16#00#);                  -- RBCR1: set remote byte count HI
      -- Page 0 WR
      Out8 (PA (BAR, CR), To_U8 (CR_WR));
      -- Packet_Dump;
      -- fill packet data
      Byte_Idx := 0;
      Data := 0;
      for Index in 0 .. P.all.Size - 1 loop
         Data := Shift_Left (Data, 8) or Unsigned_32 (P.all.Payload (Index));
         Byte_Idx := Byte_Idx + 1;
         if Index = P.all.Size - 1 then
            case Byte_Idx is
               when 3      => Data := Shift_Left (Data, 8);
               when 2      => Data := Shift_Left (Data, 16);
               when 1      => Data := Shift_Left (Data, 24);
               when others => null;
            end case;
            Byte_Idx := 4;
         end if;
         if Byte_Idx = 4 then
            Data := Byte_Swap (Data);
            Out32 (BAR + 16#10#, Data);
            Byte_Idx := 0;
            Data := 0;
         end if;
      end loop;
      -- TX packet
      Out8 (PA (BAR, TPSRW), 16#42#);                  -- TPSR: set start page address
      Out8 (PA (BAR, TBCR0), Unsigned_8 (P.all.Size)); -- TBCR0: set byte count LO
      Out8 (PA (BAR, TBCR1), 16#00#);                  -- TBCR1: set byte count HI
      -- Page 0 TX
      Out8 (PA (BAR, CR), To_U8 (CR_TX));
      CPU.Irq_State_Set (Irq_State);
   end Transmit;

   ----------------------------------------------------------------------------
   -- Init (ISA)
   ----------------------------------------------------------------------------
   procedure Init
      (D : in out Descriptor_Type)
      is
   begin
      D.NE2000PCI := False;
      D.BAR       := D.Base_Address;
      Setup (D);
   end Init;

   ----------------------------------------------------------------------------
   -- Init_PCI
   ----------------------------------------------------------------------------
   procedure Init_PCI
      (D : in out Descriptor_Type)
      is
      use PCI;
   begin
      -- initialize PCI interface, setup BAR
      Cfg_Write (BUS0, D.Device_Number, 0, BAR0_Register_Offset, D.Base_Address);
      -- enable MEMEN/IOEN
      Cfg_Write (BUS0, D.Device_Number, 0, CR_Register_Offset, Unsigned_8'(16#03#));
      -- interrupt routing line
      Cfg_Write (BUS0, D.Device_Number, 0, ILR_Register_Offset, D.PCI_Irq_Line);
      -- initialize NE2000
      D.NE2000PCI := True;
      D.BAR       := D.Base_Address and 16#FFE0#;
      Setup (D);
   end Init_PCI;

end NE2000;
