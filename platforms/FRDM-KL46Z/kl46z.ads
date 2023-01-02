-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ kl46z.ads                                                                                                 --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package KL46Z is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;

   -- 4.6.2 Peripheral bridge (AIPS-lite) memory map

   SIM_BASEADDRESS       : constant := 16#4004_7000#;
   -- SIM_BASEADDRESS       : constant := 16#4004_8000#;
   PORTx_MUX_BASEADDRESS : constant := 16#4004_9000#;
   GPIO_BASEADDRESS      : constant := 16#400F_F000#;

   -- 12.2.9 System Clock Gating Control Register 5

   type SIM_SCGC5_Type is
   record
      LPTMR     : Boolean;      -- Low Power Timer Access Control
      Reserved1 : Boolean;      -- reserved, always 1
      Reserved2 : Bits.Bits_3;  -- reserved, always 000
      TSI       : Boolean;      -- TSI Access Control
      Reserved3 : Boolean;      -- reserved, always 0
      Reserved4 : Bits.Bits_2;  -- reserved, always 11
      PORTA     : Boolean;      -- PORTA Clock Gate Control
      PORTB     : Boolean;      -- PORTB Clock Gate Control
      PORTC     : Boolean;      -- PORTC Clock Gate Control
      PORTD     : Boolean;      -- PORTD Clock Gate Control
      PORTE     : Boolean;      -- PORTE Clock Gate Control
      Reserved5 : Bits.Bits_5;  -- reserved, always 00000
      SLCD      : Boolean;      -- Segment LCD Clock Gate Control
      Reserved6 : Bits.Bits_12; -- reserved, always 000000000000
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SIM_SCGC5_Type use
   record
      LPTMR     at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 1;
      Reserved2 at 0 range 2 .. 4;
      TSI       at 0 range 5 .. 5;
      Reserved3 at 0 range 6 .. 6;
      Reserved4 at 0 range 7 .. 8;
      PORTA     at 0 range 9 .. 9;
      PORTB     at 0 range 10 .. 10;
      PORTC     at 0 range 11 .. 11;
      PORTD     at 0 range 12 .. 12;
      PORTE     at 0 range 13 .. 13;
      Reserved5 at 0 range 14 .. 18;
      SLCD      at 0 range 19 .. 19;
      Reserved6 at 0 range 20 .. 31;
   end record;

   SIM_SCGC5_ADDRESS : constant := SIM_BASEADDRESS + 16#1038#;

   SIM_SCGC5 : aliased SIM_SCGC5_Type with
      Address    => To_Address (SIM_SCGC5_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- Port x multiplexing control

   -- 11.5.1 Pin Control Register n
   -- base address + 0h offset + (4d x i), i = 0 .. 31

   MUX_Disabled  : constant := 2#000#;
   MUX_ALT1_GPIO : constant := 2#001#;
   MUX_ALT2      : constant := 2#010#;
   MUX_ALT3      : constant := 2#011#;
   MUX_ALT4      : constant := 2#100#;
   MUX_ALT5      : constant := 2#101#;
   MUX_ALT6      : constant := 2#110#;
   MUX_ALT7      : constant := 2#111#;

   IRQC_Disabled    : constant := 2#0000#;
   IRQC_DMA_Rising  : constant := 2#0001#;
   IRQC_DMA_Falling : constant := 2#0010#;
   IRQC_DMA_Either  : constant := 2#0011#;
   IRQC_IRQ_Zero    : constant := 2#1000#;
   IRQC_IRQ_Rising  : constant := 2#1001#;
   IRQC_IRQ_Falling : constant := 2#1010#;
   IRQC_IRQ_Either  : constant := 2#1011#;
   IRQC_IRQ_One     : constant := 2#1100#;

   type PORTx_PCRn_Type is
   record
      PS        : Boolean;     -- Pull Select
      PE        : Boolean;     -- Pull Enable
      SRE       : Boolean;     -- Slew Rate Enable
      Reserved1 : Boolean;
      PFE       : Boolean;     -- Passive Filter Enable
      Reserved2 : Boolean;
      DSE       : Boolean;     -- Drive Strength Enable
      Reserved3 : Boolean;
      MUX       : Bits.Bits_3; -- Pin Mux Control
      Reserved4 : Bits.Bits_5;
      IRQC      : Bits.Bits_4; -- Interrupt Configuration
      Reserved5 : Bits.Bits_4;
      ISF       : Boolean;     -- Interrupt Status Flag
      Reserved6 : Bits.Bits_7;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for PORTx_PCRn_Type use
   record
      PS        at 0 range 0 .. 0;
      PE        at 0 range 1 .. 1;
      SRE       at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 3;
      PFE       at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 5;
      DSE       at 0 range 6 .. 6;
      Reserved3 at 0 range 7 .. 7;
      MUX       at 0 range 8 .. 10;
      Reserved4 at 0 range 11 .. 15;
      IRQC      at 0 range 16 .. 19;
      Reserved5 at 0 range 20 .. 23;
      ISF       at 0 range 24 .. 24;
      Reserved6 at 0 range 25 .. 31;
   end record;

   PORTA_PCR_BASEADRESS : constant := PORTx_MUX_BASEADDRESS + 16#0000#;
   PORTB_PCR_BASEADRESS : constant := PORTx_MUX_BASEADDRESS + 16#1000#;
   PORTC_PCR_BASEADRESS : constant := PORTx_MUX_BASEADDRESS + 16#2000#;
   PORTD_PCR_BASEADRESS : constant := PORTx_MUX_BASEADDRESS + 16#3000#;
   PORTE_PCR_BASEADRESS : constant := PORTx_MUX_BASEADDRESS + 16#4000#;

pragma Style_Checks (Off);
   -- PORT A
   PORTA_PCR00 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 00), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR01 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 01), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR02 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 02), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR03 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 03), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR04 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 04), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR05 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 05), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR06 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 06), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR07 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 07), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR08 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 08), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR09 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 09), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR10 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 10), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR11 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 11), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR12 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 12), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR13 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 13), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR14 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 14), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR15 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 15), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR16 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 16), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR17 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 17), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR18 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 18), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR19 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 19), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR20 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 20), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR21 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 21), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR22 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 22), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR23 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 23), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR24 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 24), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR25 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 25), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR26 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 26), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR27 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 27), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR28 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 28), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR29 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 29), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR30 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 30), Volatile => True, Import => True, Convention => Ada;
   PORTA_PCR31 : aliased PORTx_PCRn_Type with Address => To_Address (PORTA_PCR_BASEADRESS + 4 * 31), Volatile => True, Import => True, Convention => Ada;
   -- PORT B
   PORTB_PCR00 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 00), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR01 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 01), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR02 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 02), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR03 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 03), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR04 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 04), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR05 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 05), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR06 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 06), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR07 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 07), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR08 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 08), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR09 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 09), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR10 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 10), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR11 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 11), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR12 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 12), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR13 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 13), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR14 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 14), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR15 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 15), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR16 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 16), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR17 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 17), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR18 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 18), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR19 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 19), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR20 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 20), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR21 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 21), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR22 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 22), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR23 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 23), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR24 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 24), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR25 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 25), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR26 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 26), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR27 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 27), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR28 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 28), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR29 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 29), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR30 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 30), Volatile => True, Import => True, Convention => Ada;
   PORTB_PCR31 : aliased PORTx_PCRn_Type with Address => To_Address (PORTB_PCR_BASEADRESS + 4 * 31), Volatile => True, Import => True, Convention => Ada;
   -- PORT C
   PORTC_PCR00 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 00), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR01 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 01), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR02 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 02), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR03 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 03), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR04 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 04), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR05 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 05), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR06 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 06), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR07 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 07), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR08 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 08), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR09 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 09), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR10 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 10), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR11 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 11), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR12 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 12), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR13 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 13), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR14 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 14), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR15 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 15), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR16 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 16), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR17 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 17), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR18 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 18), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR19 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 19), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR20 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 20), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR21 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 21), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR22 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 22), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR23 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 23), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR24 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 24), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR25 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 25), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR26 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 26), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR27 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 27), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR28 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 28), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR29 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 29), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR30 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 30), Volatile => True, Import => True, Convention => Ada;
   PORTC_PCR31 : aliased PORTx_PCRn_Type with Address => To_Address (PORTC_PCR_BASEADRESS + 4 * 31), Volatile => True, Import => True, Convention => Ada;
   -- PORT D
   PORTD_PCR00 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 00), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR01 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 01), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR02 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 02), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR03 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 03), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR04 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 04), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR05 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 05), Volatile => True, Import => True, Convention => Ada; -- LED1 (GREEN)
   PORTD_PCR06 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 06), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR07 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 07), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR08 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 08), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR09 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 09), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR10 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 10), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR11 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 11), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR12 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 12), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR13 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 13), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR14 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 14), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR15 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 15), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR16 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 16), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR17 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 17), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR18 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 18), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR19 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 19), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR20 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 20), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR21 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 21), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR22 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 22), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR23 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 23), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR24 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 24), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR25 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 25), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR26 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 26), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR27 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 27), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR28 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 28), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR29 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 29), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR30 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 30), Volatile => True, Import => True, Convention => Ada;
   PORTD_PCR31 : aliased PORTx_PCRn_Type with Address => To_Address (PORTD_PCR_BASEADRESS + 4 * 31), Volatile => True, Import => True, Convention => Ada;
   -- PORT E
   PORTE_PCR00 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 00), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR01 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 01), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR02 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 02), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR03 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 03), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR04 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 04), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR05 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 05), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR06 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 06), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR07 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 07), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR08 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 08), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR09 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 09), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR10 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 10), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR11 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 11), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR12 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 12), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR13 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 13), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR14 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 14), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR15 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 15), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR16 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 16), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR17 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 17), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR18 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 18), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR19 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 19), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR20 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 20), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR21 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 21), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR22 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 22), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR23 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 23), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR24 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 24), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR25 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 25), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR26 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 26), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR27 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 27), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR28 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 28), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR29 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 29), Volatile => True, Import => True, Convention => Ada; -- LED2 (RED)
   PORTE_PCR30 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 30), Volatile => True, Import => True, Convention => Ada;
   PORTE_PCR31 : aliased PORTx_PCRn_Type with Address => To_Address (PORTE_PCR_BASEADRESS + 4 * 31), Volatile => True, Import => True, Convention => Ada;
pragma Style_Checks (On);

   -- 42.2.1 Port Data Output Register

   type GPIOx_PDOR_Type is
   record
      PDO00 : Boolean;
      PDO01 : Boolean;
      PDO02 : Boolean;
      PDO03 : Boolean;
      PDO04 : Boolean;
      PDO05 : Boolean;
      PDO06 : Boolean;
      PDO07 : Boolean;
      PDO08 : Boolean;
      PDO09 : Boolean;
      PDO10 : Boolean;
      PDO11 : Boolean;
      PDO12 : Boolean;
      PDO13 : Boolean;
      PDO14 : Boolean;
      PDO15 : Boolean;
      PDO16 : Boolean;
      PDO17 : Boolean;
      PDO18 : Boolean;
      PDO19 : Boolean;
      PDO20 : Boolean;
      PDO21 : Boolean;
      PDO22 : Boolean;
      PDO23 : Boolean;
      PDO24 : Boolean;
      PDO25 : Boolean;
      PDO26 : Boolean;
      PDO27 : Boolean;
      PDO28 : Boolean;
      PDO29 : Boolean;
      PDO30 : Boolean;
      PDO31 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPIOx_PDOR_Type use
   record
      PDO00 at 0 range 0 .. 0;
      PDO01 at 0 range 1 .. 1;
      PDO02 at 0 range 2 .. 2;
      PDO03 at 0 range 3 .. 3;
      PDO04 at 0 range 4 .. 4;
      PDO05 at 0 range 5 .. 5;
      PDO06 at 0 range 6 .. 6;
      PDO07 at 0 range 7 .. 7;
      PDO08 at 0 range 8 .. 8;
      PDO09 at 0 range 9 .. 9;
      PDO10 at 0 range 10 .. 10;
      PDO11 at 0 range 11 .. 11;
      PDO12 at 0 range 12 .. 12;
      PDO13 at 0 range 13 .. 13;
      PDO14 at 0 range 14 .. 14;
      PDO15 at 0 range 15 .. 15;
      PDO16 at 0 range 16 .. 16;
      PDO17 at 0 range 17 .. 17;
      PDO18 at 0 range 18 .. 18;
      PDO19 at 0 range 19 .. 19;
      PDO20 at 0 range 20 .. 20;
      PDO21 at 0 range 21 .. 21;
      PDO22 at 0 range 22 .. 22;
      PDO23 at 0 range 23 .. 23;
      PDO24 at 0 range 24 .. 24;
      PDO25 at 0 range 25 .. 25;
      PDO26 at 0 range 26 .. 26;
      PDO27 at 0 range 27 .. 27;
      PDO28 at 0 range 28 .. 28;
      PDO29 at 0 range 29 .. 29;
      PDO30 at 0 range 30 .. 30;
      PDO31 at 0 range 31 .. 31;
   end record;

   -- 42.2.2 Port Set Output Register

   type GPIOx_PSOR_Type is
   record
      PTSO00 : Boolean;
      PTSO01 : Boolean;
      PTSO02 : Boolean;
      PTSO03 : Boolean;
      PTSO04 : Boolean;
      PTSO05 : Boolean;
      PTSO06 : Boolean;
      PTSO07 : Boolean;
      PTSO08 : Boolean;
      PTSO09 : Boolean;
      PTSO10 : Boolean;
      PTSO11 : Boolean;
      PTSO12 : Boolean;
      PTSO13 : Boolean;
      PTSO14 : Boolean;
      PTSO15 : Boolean;
      PTSO16 : Boolean;
      PTSO17 : Boolean;
      PTSO18 : Boolean;
      PTSO19 : Boolean;
      PTSO20 : Boolean;
      PTSO21 : Boolean;
      PTSO22 : Boolean;
      PTSO23 : Boolean;
      PTSO24 : Boolean;
      PTSO25 : Boolean;
      PTSO26 : Boolean;
      PTSO27 : Boolean;
      PTSO28 : Boolean;
      PTSO29 : Boolean;
      PTSO30 : Boolean;
      PTSO31 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPIOx_PSOR_Type use
   record
      PTSO00 at 0 range 0 .. 0;
      PTSO01 at 0 range 1 .. 1;
      PTSO02 at 0 range 2 .. 2;
      PTSO03 at 0 range 3 .. 3;
      PTSO04 at 0 range 4 .. 4;
      PTSO05 at 0 range 5 .. 5;
      PTSO06 at 0 range 6 .. 6;
      PTSO07 at 0 range 7 .. 7;
      PTSO08 at 0 range 8 .. 8;
      PTSO09 at 0 range 9 .. 9;
      PTSO10 at 0 range 10 .. 10;
      PTSO11 at 0 range 11 .. 11;
      PTSO12 at 0 range 12 .. 12;
      PTSO13 at 0 range 13 .. 13;
      PTSO14 at 0 range 14 .. 14;
      PTSO15 at 0 range 15 .. 15;
      PTSO16 at 0 range 16 .. 16;
      PTSO17 at 0 range 17 .. 17;
      PTSO18 at 0 range 18 .. 18;
      PTSO19 at 0 range 19 .. 19;
      PTSO20 at 0 range 20 .. 20;
      PTSO21 at 0 range 21 .. 21;
      PTSO22 at 0 range 22 .. 22;
      PTSO23 at 0 range 23 .. 23;
      PTSO24 at 0 range 24 .. 24;
      PTSO25 at 0 range 25 .. 25;
      PTSO26 at 0 range 26 .. 26;
      PTSO27 at 0 range 27 .. 27;
      PTSO28 at 0 range 28 .. 28;
      PTSO29 at 0 range 29 .. 29;
      PTSO30 at 0 range 30 .. 30;
      PTSO31 at 0 range 31 .. 31;
   end record;

   -- 42.2.3 Port Clear Output Register

   type GPIOx_PCOR_Type is
   record
      PTCO00 : Boolean;
      PTCO01 : Boolean;
      PTCO02 : Boolean;
      PTCO03 : Boolean;
      PTCO04 : Boolean;
      PTCO05 : Boolean;
      PTCO06 : Boolean;
      PTCO07 : Boolean;
      PTCO08 : Boolean;
      PTCO09 : Boolean;
      PTCO10 : Boolean;
      PTCO11 : Boolean;
      PTCO12 : Boolean;
      PTCO13 : Boolean;
      PTCO14 : Boolean;
      PTCO15 : Boolean;
      PTCO16 : Boolean;
      PTCO17 : Boolean;
      PTCO18 : Boolean;
      PTCO19 : Boolean;
      PTCO20 : Boolean;
      PTCO21 : Boolean;
      PTCO22 : Boolean;
      PTCO23 : Boolean;
      PTCO24 : Boolean;
      PTCO25 : Boolean;
      PTCO26 : Boolean;
      PTCO27 : Boolean;
      PTCO28 : Boolean;
      PTCO29 : Boolean;
      PTCO30 : Boolean;
      PTCO31 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPIOx_PCOR_Type use
   record
      PTCO00 at 0 range 0 .. 0;
      PTCO01 at 0 range 1 .. 1;
      PTCO02 at 0 range 2 .. 2;
      PTCO03 at 0 range 3 .. 3;
      PTCO04 at 0 range 4 .. 4;
      PTCO05 at 0 range 5 .. 5;
      PTCO06 at 0 range 6 .. 6;
      PTCO07 at 0 range 7 .. 7;
      PTCO08 at 0 range 8 .. 8;
      PTCO09 at 0 range 9 .. 9;
      PTCO10 at 0 range 10 .. 10;
      PTCO11 at 0 range 11 .. 11;
      PTCO12 at 0 range 12 .. 12;
      PTCO13 at 0 range 13 .. 13;
      PTCO14 at 0 range 14 .. 14;
      PTCO15 at 0 range 15 .. 15;
      PTCO16 at 0 range 16 .. 16;
      PTCO17 at 0 range 17 .. 17;
      PTCO18 at 0 range 18 .. 18;
      PTCO19 at 0 range 19 .. 19;
      PTCO20 at 0 range 20 .. 20;
      PTCO21 at 0 range 21 .. 21;
      PTCO22 at 0 range 22 .. 22;
      PTCO23 at 0 range 23 .. 23;
      PTCO24 at 0 range 24 .. 24;
      PTCO25 at 0 range 25 .. 25;
      PTCO26 at 0 range 26 .. 26;
      PTCO27 at 0 range 27 .. 27;
      PTCO28 at 0 range 28 .. 28;
      PTCO29 at 0 range 29 .. 29;
      PTCO30 at 0 range 30 .. 30;
      PTCO31 at 0 range 31 .. 31;
   end record;

   -- 42.2.4 Port Toggle Output Register

   type GPIOx_PTOR_Type is
   record
      PTTO00 : Boolean;
      PTTO01 : Boolean;
      PTTO02 : Boolean;
      PTTO03 : Boolean;
      PTTO04 : Boolean;
      PTTO05 : Boolean;
      PTTO06 : Boolean;
      PTTO07 : Boolean;
      PTTO08 : Boolean;
      PTTO09 : Boolean;
      PTTO10 : Boolean;
      PTTO11 : Boolean;
      PTTO12 : Boolean;
      PTTO13 : Boolean;
      PTTO14 : Boolean;
      PTTO15 : Boolean;
      PTTO16 : Boolean;
      PTTO17 : Boolean;
      PTTO18 : Boolean;
      PTTO19 : Boolean;
      PTTO20 : Boolean;
      PTTO21 : Boolean;
      PTTO22 : Boolean;
      PTTO23 : Boolean;
      PTTO24 : Boolean;
      PTTO25 : Boolean;
      PTTO26 : Boolean;
      PTTO27 : Boolean;
      PTTO28 : Boolean;
      PTTO29 : Boolean;
      PTTO30 : Boolean;
      PTTO31 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPIOx_PTOR_Type use
   record
      PTTO00 at 0 range 0 .. 0;
      PTTO01 at 0 range 1 .. 1;
      PTTO02 at 0 range 2 .. 2;
      PTTO03 at 0 range 3 .. 3;
      PTTO04 at 0 range 4 .. 4;
      PTTO05 at 0 range 5 .. 5;
      PTTO06 at 0 range 6 .. 6;
      PTTO07 at 0 range 7 .. 7;
      PTTO08 at 0 range 8 .. 8;
      PTTO09 at 0 range 9 .. 9;
      PTTO10 at 0 range 10 .. 10;
      PTTO11 at 0 range 11 .. 11;
      PTTO12 at 0 range 12 .. 12;
      PTTO13 at 0 range 13 .. 13;
      PTTO14 at 0 range 14 .. 14;
      PTTO15 at 0 range 15 .. 15;
      PTTO16 at 0 range 16 .. 16;
      PTTO17 at 0 range 17 .. 17;
      PTTO18 at 0 range 18 .. 18;
      PTTO19 at 0 range 19 .. 19;
      PTTO20 at 0 range 20 .. 20;
      PTTO21 at 0 range 21 .. 21;
      PTTO22 at 0 range 22 .. 22;
      PTTO23 at 0 range 23 .. 23;
      PTTO24 at 0 range 24 .. 24;
      PTTO25 at 0 range 25 .. 25;
      PTTO26 at 0 range 26 .. 26;
      PTTO27 at 0 range 27 .. 27;
      PTTO28 at 0 range 28 .. 28;
      PTTO29 at 0 range 29 .. 29;
      PTTO30 at 0 range 30 .. 30;
      PTTO31 at 0 range 31 .. 31;
   end record;

   -- 42.2.5 Port Data Input Register

   type GPIOx_PDIR_Type is
   record
      PDI00 : Boolean;
      PDI01 : Boolean;
      PDI02 : Boolean;
      PDI03 : Boolean;
      PDI04 : Boolean;
      PDI05 : Boolean;
      PDI06 : Boolean;
      PDI07 : Boolean;
      PDI08 : Boolean;
      PDI09 : Boolean;
      PDI10 : Boolean;
      PDI11 : Boolean;
      PDI12 : Boolean;
      PDI13 : Boolean;
      PDI14 : Boolean;
      PDI15 : Boolean;
      PDI16 : Boolean;
      PDI17 : Boolean;
      PDI18 : Boolean;
      PDI19 : Boolean;
      PDI20 : Boolean;
      PDI21 : Boolean;
      PDI22 : Boolean;
      PDI23 : Boolean;
      PDI24 : Boolean;
      PDI25 : Boolean;
      PDI26 : Boolean;
      PDI27 : Boolean;
      PDI28 : Boolean;
      PDI29 : Boolean;
      PDI30 : Boolean;
      PDI31 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPIOx_PDIR_Type use
   record
      PDI00 at 0 range 0 .. 0;
      PDI01 at 0 range 1 .. 1;
      PDI02 at 0 range 2 .. 2;
      PDI03 at 0 range 3 .. 3;
      PDI04 at 0 range 4 .. 4;
      PDI05 at 0 range 5 .. 5;
      PDI06 at 0 range 6 .. 6;
      PDI07 at 0 range 7 .. 7;
      PDI08 at 0 range 8 .. 8;
      PDI09 at 0 range 9 .. 9;
      PDI10 at 0 range 10 .. 10;
      PDI11 at 0 range 11 .. 11;
      PDI12 at 0 range 12 .. 12;
      PDI13 at 0 range 13 .. 13;
      PDI14 at 0 range 14 .. 14;
      PDI15 at 0 range 15 .. 15;
      PDI16 at 0 range 16 .. 16;
      PDI17 at 0 range 17 .. 17;
      PDI18 at 0 range 18 .. 18;
      PDI19 at 0 range 19 .. 19;
      PDI20 at 0 range 20 .. 20;
      PDI21 at 0 range 21 .. 21;
      PDI22 at 0 range 22 .. 22;
      PDI23 at 0 range 23 .. 23;
      PDI24 at 0 range 24 .. 24;
      PDI25 at 0 range 25 .. 25;
      PDI26 at 0 range 26 .. 26;
      PDI27 at 0 range 27 .. 27;
      PDI28 at 0 range 28 .. 28;
      PDI29 at 0 range 29 .. 29;
      PDI30 at 0 range 30 .. 30;
      PDI31 at 0 range 31 .. 31;
   end record;

   -- 42.2.6 Port Data Direction Register

   type GPIOx_PDDR_Type is
   record
      PDD00 : Boolean;
      PDD01 : Boolean;
      PDD02 : Boolean;
      PDD03 : Boolean;
      PDD04 : Boolean;
      PDD05 : Boolean;
      PDD06 : Boolean;
      PDD07 : Boolean;
      PDD08 : Boolean;
      PDD09 : Boolean;
      PDD10 : Boolean;
      PDD11 : Boolean;
      PDD12 : Boolean;
      PDD13 : Boolean;
      PDD14 : Boolean;
      PDD15 : Boolean;
      PDD16 : Boolean;
      PDD17 : Boolean;
      PDD18 : Boolean;
      PDD19 : Boolean;
      PDD20 : Boolean;
      PDD21 : Boolean;
      PDD22 : Boolean;
      PDD23 : Boolean;
      PDD24 : Boolean;
      PDD25 : Boolean;
      PDD26 : Boolean;
      PDD27 : Boolean;
      PDD28 : Boolean;
      PDD29 : Boolean;
      PDD30 : Boolean;
      PDD31 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPIOx_PDDR_Type use
   record
      PDD00 at 0 range 0 .. 0;
      PDD01 at 0 range 1 .. 1;
      PDD02 at 0 range 2 .. 2;
      PDD03 at 0 range 3 .. 3;
      PDD04 at 0 range 4 .. 4;
      PDD05 at 0 range 5 .. 5;
      PDD06 at 0 range 6 .. 6;
      PDD07 at 0 range 7 .. 7;
      PDD08 at 0 range 8 .. 8;
      PDD09 at 0 range 9 .. 9;
      PDD10 at 0 range 10 .. 10;
      PDD11 at 0 range 11 .. 11;
      PDD12 at 0 range 12 .. 12;
      PDD13 at 0 range 13 .. 13;
      PDD14 at 0 range 14 .. 14;
      PDD15 at 0 range 15 .. 15;
      PDD16 at 0 range 16 .. 16;
      PDD17 at 0 range 17 .. 17;
      PDD18 at 0 range 18 .. 18;
      PDD19 at 0 range 19 .. 19;
      PDD20 at 0 range 20 .. 20;
      PDD21 at 0 range 21 .. 21;
      PDD22 at 0 range 22 .. 22;
      PDD23 at 0 range 23 .. 23;
      PDD24 at 0 range 24 .. 24;
      PDD25 at 0 range 25 .. 25;
      PDD26 at 0 range 26 .. 26;
      PDD27 at 0 range 27 .. 27;
      PDD28 at 0 range 28 .. 28;
      PDD29 at 0 range 29 .. 29;
      PDD30 at 0 range 30 .. 30;
      PDD31 at 0 range 31 .. 31;
   end record;

   -- Port A

   GPIOA_PDOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#00#;
   GPIOA_PSOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#04#;
   GPIOA_PCOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#08#;
   GPIOA_PTOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#0C#;
   GPIOA_PDIR_ADDRESS : constant := GPIO_BASEADDRESS + 16#10#;
   GPIOA_PDDR_ADDRESS : constant := GPIO_BASEADDRESS + 16#14#;

   GPIOA_PDOR : aliased GPIOx_PDOR_Type with
      Address    => To_Address (GPIOD_PDOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOA_PSOR : aliased GPIOx_PSOR_Type with
      Address    => To_Address (GPIOA_PSOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOA_PCOR : aliased GPIOx_PCOR_Type with
      Address    => To_Address (GPIOA_PCOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOA_PTOR : aliased GPIOx_PTOR_Type with
      Address    => To_Address (GPIOA_PTOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOA_PDIR : aliased GPIOx_PDIR_Type with
      Address    => To_Address (GPIOA_PDIR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOA_PDDR : aliased GPIOx_PDDR_Type with
      Address    => To_Address (GPIOA_PDDR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- Port B

   GPIOB_PDOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#40#;
   GPIOB_PSOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#44#;
   GPIOB_PCOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#48#;
   GPIOB_PTOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#4C#;
   GPIOB_PDIR_ADDRESS : constant := GPIO_BASEADDRESS + 16#50#;
   GPIOB_PDDR_ADDRESS : constant := GPIO_BASEADDRESS + 16#54#;

   GPIOB_PDOR : aliased GPIOx_PDOR_Type with
      Address    => To_Address (GPIOD_PDOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOB_PSOR : aliased GPIOx_PSOR_Type with
      Address    => To_Address (GPIOB_PSOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOB_PCOR : aliased GPIOx_PCOR_Type with
      Address    => To_Address (GPIOB_PCOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOB_PTOR : aliased GPIOx_PTOR_Type with
      Address    => To_Address (GPIOB_PTOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOB_PDIR : aliased GPIOx_PDIR_Type with
      Address    => To_Address (GPIOB_PDIR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOB_PDDR : aliased GPIOx_PDDR_Type with
      Address    => To_Address (GPIOB_PDDR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- Port C

   GPIOC_PDOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#80#;
   GPIOC_PSOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#84#;
   GPIOC_PCOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#88#;
   GPIOC_PTOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#8C#;
   GPIOC_PDIR_ADDRESS : constant := GPIO_BASEADDRESS + 16#90#;
   GPIOC_PDDR_ADDRESS : constant := GPIO_BASEADDRESS + 16#94#;

   GPIOC_PDOR : aliased GPIOx_PDOR_Type with
      Address    => To_Address (GPIOC_PDOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOC_PSOR : aliased GPIOx_PSOR_Type with
      Address    => To_Address (GPIOC_PSOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOC_PCOR : aliased GPIOx_PCOR_Type with
      Address    => To_Address (GPIOC_PCOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOC_PTOR : aliased GPIOx_PTOR_Type with
      Address    => To_Address (GPIOC_PTOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOC_PDIR : aliased GPIOx_PDIR_Type with
      Address    => To_Address (GPIOC_PDIR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOC_PDDR : aliased GPIOx_PDDR_Type with
      Address    => To_Address (GPIOC_PDDR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- Port D

   GPIOD_PDOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#C0#;
   GPIOD_PSOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#C4#;
   GPIOD_PCOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#C8#;
   GPIOD_PTOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#CC#;
   GPIOD_PDIR_ADDRESS : constant := GPIO_BASEADDRESS + 16#D0#;
   GPIOD_PDDR_ADDRESS : constant := GPIO_BASEADDRESS + 16#D4#;

   GPIOD_PDOR : aliased GPIOx_PDOR_Type with
      Address    => To_Address (GPIOD_PDOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOD_PSOR : aliased GPIOx_PSOR_Type with
      Address    => To_Address (GPIOD_PSOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOD_PCOR : aliased GPIOx_PCOR_Type with
      Address    => To_Address (GPIOD_PCOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOD_PTOR : aliased GPIOx_PTOR_Type with
      Address    => To_Address (GPIOD_PTOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOD_PDIR : aliased GPIOx_PDIR_Type with
      Address    => To_Address (GPIOD_PDIR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOD_PDDR : aliased GPIOx_PDDR_Type with
      Address    => To_Address (GPIOD_PDDR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- Port E

   GPIOE_PDOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#100#;
   GPIOE_PSOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#104#;
   GPIOE_PCOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#108#;
   GPIOE_PTOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#10C#;
   GPIOE_PDIR_ADDRESS : constant := GPIO_BASEADDRESS + 16#110#;
   GPIOE_PDDR_ADDRESS : constant := GPIO_BASEADDRESS + 16#114#;

   GPIOE_PDOR : aliased GPIOx_PDOR_Type with
      Address    => To_Address (GPIOE_PDOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOE_PSOR : aliased GPIOx_PSOR_Type with
      Address    => To_Address (GPIOE_PSOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOE_PCOR : aliased GPIOx_PCOR_Type with
      Address    => To_Address (GPIOE_PCOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOE_PTOR : aliased GPIOx_PTOR_Type with
      Address    => To_Address (GPIOE_PTOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOE_PDIR : aliased GPIOx_PDIR_Type with
      Address    => To_Address (GPIOE_PDIR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOE_PDDR : aliased GPIOx_PDDR_Type with
      Address    => To_Address (GPIOE_PDDR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end KL46Z;
