-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ atmega128a.ads                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package ATmega128A
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
   -- ATmega128A
   -- Atmel-8151J-8-bit AVR Microcontroller_Datasheet_Complete-09/2015
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Definitions for some fields in various registers
   ----------------------------------------------------------------------------

   -- Table 12-3 Sector limits with different settings of SRL2:0

   SRL_Lxxxxxxxx_U1100FFFF : constant := 2#000#; -- Lower sector = N/A
                                                 -- Upper sector = 0x1100 - 0xFFFF
   SRL_L11001FFF_U2000FFFF : constant := 2#001#; -- Lower sector = 0x1100 - 0x1FFF
                                                 -- Upper sector = 0x2000 - 0xFFFF
   SRL_L11003FFF_U4000FFFF : constant := 2#010#; -- Lower sector = 0x1100 - 0x3FFF
                                                 -- Upper sector = 0x4000 - 0xFFFF
   SRL_L11005FFF_U6000FFFF : constant := 2#011#; -- Lower sector = 0x1100 - 0x5FFF
                                                 -- Upper sector = 0x6000 - 0xFFFF
   SRL_L11007FFF_U8000FFFF : constant := 2#100#; -- Lower sector = 0x1100 - 0x7FFF
                                                 -- Upper sector = 0x8000 - 0xFFFF
   SRL_L11009FFF_UA000FFFF : constant := 2#101#; -- Lower sector = 0x1100 - 0x9FFF
                                                 -- Upper sector = 0xA000 - 0xFFFF
   SRL_L1100BFFF_UC000FFFF : constant := 2#110#; -- Lower sector = 0x1100 - 0xBFFF
                                                 -- Upper sector = 0xC000 - 0xFFFF
   SRL_L1100DFFF_UE000FFFF : constant := 2#111#; -- Lower sector = 0x1100 - 0xDFFF
                                                 -- Upper sector = 0xE000 - 0xFFFF

   -- Table 12-5 Port C Pins Released as Normal Port Pins when the External Memory is Enabled

   --                                   # Bits for External Memory Address Released Port Pins
   XMM_NONE    : constant := 2#000#; -- 8 (Full 60 Kbytes space)           None
   XMM_PC7     : constant := 2#001#; -- 7                                  PC7
   XMM_PC7_PC6 : constant := 2#010#; -- 6                                  PC7 - PC6
   XMM_PC7_PC5 : constant := 2#011#; -- 5                                  PC7 - PC5
   XMM_PC7_PC4 : constant := 2#100#; -- 4                                  PC7 - PC4
   XMM_PC7_PC3 : constant := 2#101#; -- 3                                  PC7 - PC3
   XMM_PC7_PC2 : constant := 2#110#; -- 2                                  PC7 - PC2
   XMM_FULL    : constant := 2#111#; -- No Address high bits               Full Port C

   -- Table 12-4 Wait States

   type SRW_Type is record
      SRWn0 : Bits_1;
      SRWn1 : Bits_1;
   end record;

   SRW_NONE  : constant SRW_Type := (SRWn1 => 0, SRWn0 => 0); -- No wait-states
   SRW_RW1   : constant SRW_Type := (SRWn1 => 0, SRWn0 => 1); -- Wait one cycle during read/write strobe
   SRW_RW2   : constant SRW_Type := (SRWn1 => 1, SRWn0 => 0); -- Wait two cycles during read/write strobe
   SRW_RW2D1 : constant SRW_Type := (SRWn1 => 1, SRWn0 => 1); -- Wait two cycles during read/write and wait one cycle before driving out new address

   -- Table 14-2 Sleep Mode Select

   type SM_Type is record
      SM2 : Bits_1;
      SM0 : Bits_1;
      SM1 : Bits_1;
   end record;

   SM_IDLE    : constant SM_Type := (SM2 => 0, SM1 => 0, SM0 => 0); -- Idle
   SM_ADCNR   : constant SM_Type := (SM2 => 0, SM1 => 0, SM0 => 1); -- ADC Noise Reduction
   SM_PWDOWN  : constant SM_Type := (SM2 => 0, SM1 => 1, SM0 => 0); -- Power-down
   SM_PWSAVE  : constant SM_Type := (SM2 => 0, SM1 => 1, SM0 => 1); -- Power-save
   SM_RSVD1   : constant SM_Type := (SM2 => 1, SM1 => 0, SM0 => 0); -- Reserved
   SM_RSVD2   : constant SM_Type := (SM2 => 1, SM1 => 0, SM0 => 1); -- Reserved
   SM_STBY    : constant SM_Type := (SM2 => 1, SM1 => 1, SM0 => 0); -- Standby
   SM_EXTSTBY : constant SM_Type := (SM2 => 1, SM1 => 1, SM0 => 0); -- Extended Standby

   ----------------------------------------------------------------------------
   -- 11. AVR CPU Core
   ----------------------------------------------------------------------------

   -- 11.3.1. SREG – The AVR Status Register

   type SREG_Type is record
      C : Boolean := False; -- Carry flag
      Z : Boolean := False; -- Zero flag
      N : Boolean := False; -- Negative flag
      V : Boolean := False; -- Two's Complement Overflow flag
      S : Boolean := False; -- Sign bit
      H : Boolean := False; -- Half Carry flag
      T : Boolean := False; -- Bit Copy Storage
      I : Boolean := False; -- Global Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SREG_Type use record
      C at 0 range 0 .. 0;
      Z at 0 range 1 .. 1;
      N at 0 range 2 .. 2;
      V at 0 range 3 .. 3;
      S at 0 range 4 .. 4;
      H at 0 range 5 .. 5;
      T at 0 range 6 .. 6;
      I at 0 range 7 .. 7;
   end record;

   SREG_ADDRESS : constant := 16#5F#;

   SREG : aliased SREG_Type
      with Address              => System'To_Address (SREG_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- MCUCR
   ----------------------------------------------------------------------------

   -- 12.7.5. MCUCR – MCU Control Register
   -- 14.9.1. MCUCR – MCU Control Register
   -- 16.2.1. MCUCR – MCU Control Register

   type MCUCR_Type is record
      IVCE  : Boolean := False;          -- Interrupt Vector Change Enable
      IVSEL : Boolean := False;          -- Interrupt Vector Select
      SM2   : Bits_1  := SM_IDLE.SM2;    -- Sleep Mode Select Bit 2
      SM0   : Bits_1  := SM_IDLE.SM0;    -- Sleep Mode n Select Bits [n=1:0]
      SM1   : Bits_1  := SM_IDLE.SM1;    -- ''
      SE    : Boolean := False;          -- Sleep Enable
      SRW10 : Bits_1  := SRW_NONE.SRWn0; -- Wait-state Select Bit
      SRE   : Boolean := False;          -- External SRAM/XMEM Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCUCR_Type use record
      IVCE  at 0 range 0 .. 0;
      IVSEL at 0 range 1 .. 1;
      SM2   at 0 range 2 .. 2;
      SM0   at 0 range 3 .. 3;
      SM1   at 0 range 4 .. 4;
      SE    at 0 range 5 .. 5;
      SRW10 at 0 range 6 .. 6;
      SRE   at 0 range 7 .. 7;
   end record;

   MCUCR_ADDRESS : constant := 16#55#;

   MCUCR : aliased MCUCR_Type
      with Address              => System'To_Address (MCUCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 12. AVR Memories
   ----------------------------------------------------------------------------

   -- 12.7.1. EEARL – The EEPROM Address Register Low

   EEARL_ADDRESS : constant := 16#3E#;

   EEARL : aliased Unsigned_8
      with Address              => System'To_Address (EEARL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.7.2. EEARH – The EEPROM Address Register High

   EEARH_ADDRESS : constant := 16#3F#;

   EEARH : aliased Unsigned_8
      with Address              => System'To_Address (EEARH_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.7.3. EEDR – The EEPROM Data Register

   EEDR_ADDRESS : constant := 16#3D#;

   EEDR : aliased Unsigned_8
      with Address              => System'To_Address (EEDR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.7.4. EECR – The EEPROM Control Register

   type EECR_Type is record
      EERE     : Boolean := False; -- EEPROM Read Enable
      EEWE     : Boolean := False; -- EEPROM Write Enable
      EEMWE    : Boolean := False; -- EEPROM Master Write Enable
      EERIE    : Boolean := False; -- EEPROM Ready Interrupt Enable
      Reserved : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for EECR_Type use record
      EERE     at 0 range 0 .. 0;
      EEWE     at 0 range 1 .. 1;
      EEMWE    at 0 range 2 .. 2;
      EERIE    at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 7;
   end record;

   EECR_ADDRESS : constant := 16#3C#;

   EECR : aliased EECR_Type
      with Address              => System'To_Address (EECR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.7.6. XMCRA – External Memory Control Register A

   type XMCRA_Type is record
      Reserved1 : Bits_1 := 0;
      SRW11     : Bits_1 := SRW_NONE.SRWn1;          -- Wait-state Select Bits for Upper Sector
      SRW00     : Bits_1 := SRW_NONE.SRWn0;          -- Wait-state Select Bits for Lower Sector [n = 1:0]
      SRW01     : Bits_1 := SRW_NONE.SRWn1;          -- ''
      SRL       : Bits_3 := SRL_Lxxxxxxxx_U1100FFFF; -- Wait-state Sector Limit [n = 2:0]
      Reserved2 : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for XMCRA_Type use record
      Reserved1 at 0 range 0 .. 0;
      SRW11     at 0 range 1 .. 1;
      SRW00     at 0 range 2 .. 2;
      SRW01     at 0 range 3 .. 3;
      SRL       at 0 range 4 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   XMCRA_ADDRESS : constant := 16#6D#;

   XMCRA : aliased XMCRA_Type
      with Address              => System'To_Address (XMCRA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.7.7. XMCRB – External Memory Control Register B

   type XMCRB_Type is record
      XMM      : Bits_3  := XMM_NONE; -- External Memory High Mask [n = 2:0]
      Reserved : Bits_4  := 0;
      XMBK     : Boolean := False;    -- External Memory Bus-keeper Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for XMCRB_Type use record
      XMM      at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 6;
      XMBK     at 0 range 7 .. 7;
   end record;

   XMCRB_ADDRESS : constant := 16#6C#;

   XMCRB : aliased XMCRB_Type
      with Address              => System'To_Address (XMCRB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 13. System Clock and Clock Options
   ----------------------------------------------------------------------------

   -- 13.10.1.XDIV – XTAL Divide Control Register

   type XDIV_Type is record
      XDIV   : Bits_7  := 0;     -- XTAL Divide Select Bits [n = 6:0]
      XDIVEN : Boolean := False; -- XTAL Divide Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for XDIV_Type use record
      XDIV   at 0 range 0 .. 6;
      XDIVEN at 0 range 7 .. 7;
   end record;

   XDIV_ADDRESS : constant := 16#5C#;

   XDIV : aliased XDIV_Type
      with Address              => System'To_Address (XDIV_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.10.2. OSCCAL – Oscillator Calibration Register

   OSCCAL_ADDRESS : constant := 16#51#;

   OSCCAL : aliased Unsigned_8
      with Address              => System'To_Address (OSCCAL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 15. System Control and Reset
   ----------------------------------------------------------------------------

   -- 15.6.1. MCUCSR – MCU Control and Status Register

   type MCUCSR_Type is record
      PORF     : Boolean := True; -- Power-on Reset Flag
      EXTRF    : Boolean := True; -- External Reset Flag
      BORF     : Boolean := True; -- Brown-out Reset Flag
      WDRF     : Boolean := True; -- Watchdog Reset Flag
      JTRF     : Boolean := True; -- JTAG Reset Flag
      Reserved : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCUCSR_Type use record
      PORF     at 0 range 0 .. 0;
      EXTRF    at 0 range 1 .. 1;
      BORF     at 0 range 2 .. 2;
      WDRF     at 0 range 3 .. 3;
      JTRF     at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   MCUCSR_ADDRESS : constant := 16#54#;

   MCUCSR : aliased MCUCSR_Type
      with Address              => System'To_Address (MCUCSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.6.2. WDTCR – Watchdog Timer Control Register

   WDT_16K   : constant := 2#000#;
   WDT_32K   : constant := 2#001#;
   WDT_64K   : constant := 2#010#;
   WDT_128K  : constant := 2#011#;
   WDT_256K  : constant := 2#100#;
   WDT_512K  : constant := 2#101#;
   WDT_1024K : constant := 2#110#;
   WDT_2048K : constant := 2#111#;

   type WDTCR_Type is record
      WDP012   : Bits_3  := WDT_16K; -- Watchdog Timer Prescaler bit 0 .. 2
      WDE      : Boolean := False;   -- Watchdog Enable
      WDCE     : Boolean := False;   -- Watchdog Change Enable
      Reserved : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WDTCR_Type use record
      WDP012   at 0 range 0 .. 2;
      WDE      at 0 range 3 .. 3;
      WDCE     at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   WDTCR_ADDRESS : constant := 16#41#;

   WDTCR : aliased WDTCR_Type
      with Address              => System'To_Address (WDTCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 18. I/O Ports
   ----------------------------------------------------------------------------

   -- 18.4.2. PORTA – Port A Data Register

   PORTA_ADDRESS : constant := 16#3B#;

   PORTA : aliased Bitmap_8
      with Address              => System'To_Address (PORTA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.3. DDRA – Port A Data Direction Register

   DDRA_ADDRESS : constant := 16#3A#;

   DDRA : aliased Bitmap_8
      with Address              => System'To_Address (DDRA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.4. PINA – Port A Input Pins Address

   PINA_ADDRESS : constant := 16#39#;

   PINA : aliased Bitmap_8
      with Address              => System'To_Address (PINA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.5. PORTB – The Port B Data Register

   PORTB_ADDRESS : constant := 16#38#;

   PORTB : aliased Bitmap_8
      with Address              => System'To_Address (PORTB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.6. DDRB – The Port B Data Direction Register

   DDRB_ADDRESS : constant := 16#37#;

   DDRB : aliased Bitmap_8
      with Address              => System'To_Address (DDRB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.7. PINB – The Port B Input Pins Address

   PINB_ADDRESS : constant := 16#36#;

   PINB : aliased Bitmap_8
      with Address              => System'To_Address (PINB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.8. PORTC – The Port C Data Register

   PORTC_ADDRESS : constant := 16#35#;

   PORTC : aliased Bitmap_8
      with Address              => System'To_Address (PORTC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.9. DDRC – The Port C Data Direction Register

   DDRC_ADDRESS : constant := 16#34#;

   DDRC : aliased Bitmap_8
      with Address              => System'To_Address (DDRC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.10. PINC – The Port C Input Pins Address

   PINC_ADDRESS : constant := 16#33#;

   PINC : aliased Bitmap_8
      with Address              => System'To_Address (PINC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.11. PORTD – The Port D Data Register

   PORTD_ADDRESS : constant := 16#32#;

   PORTD : aliased Bitmap_8
      with Address              => System'To_Address (PORTD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.12. DDRD – The Port D Data Direction Register

   DDRD_ADDRESS : constant := 16#31#;

   DDRD : aliased Bitmap_8
      with Address              => System'To_Address (DDRD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.13. PIND – The Port D Input Pins Address

   PIND_ADDRESS : constant := 16#30#;

   PIND : aliased Bitmap_8
      with Address              => System'To_Address (PIND_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

pragma Style_Checks (On);

end ATmega128A;
