-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ kl46z.ads                                                                                                 --
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
with System.Storage_Elements;
with Interfaces;
with Bits;

package KL46Z
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
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   -- 4.6.2 Peripheral bridge (AIPS-lite) memory map

   SIM_BASEADDRESS       : constant := 16#4004_7000#;
   -- SIM_BASEADDRESS       : constant := 16#4004_8000#;
   PORTx_MUX_BASEADDRESS : constant := 16#4004_9000#;
   GPIO_BASEADDRESS      : constant := 16#400F_F000#;

   -- 12.2.9 System Clock Gating Control Register 5

   type SIM_SCGC5_Type is record
      LPTMR     : Boolean;         -- Low Power Timer Access Control
      Reserved1 : Bits_1 := 1;
      Reserved2 : Bits_3 := 0;
      TSI       : Boolean;         -- TSI Access Control
      Reserved3 : Bits_1 := 0;
      Reserved4 : Bits_2 := 2#11#;
      PORTA     : Boolean;         -- PORTA Clock Gate Control
      PORTB     : Boolean;         -- PORTB Clock Gate Control
      PORTC     : Boolean;         -- PORTC Clock Gate Control
      PORTD     : Boolean;         -- PORTD Clock Gate Control
      PORTE     : Boolean;         -- PORTE Clock Gate Control
      Reserved5 : Bits_5 := 0;
      SLCD      : Boolean;         -- Segment LCD Clock Gate Control
      Reserved6 : Bits_12 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC5_Type use record
      LPTMR     at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  1;
      Reserved2 at 0 range  2 ..  4;
      TSI       at 0 range  5 ..  5;
      Reserved3 at 0 range  6 ..  6;
      Reserved4 at 0 range  7 ..  8;
      PORTA     at 0 range  9 ..  9;
      PORTB     at 0 range 10 .. 10;
      PORTC     at 0 range 11 .. 11;
      PORTD     at 0 range 12 .. 12;
      PORTE     at 0 range 13 .. 13;
      Reserved5 at 0 range 14 .. 18;
      SLCD      at 0 range 19 .. 19;
      Reserved6 at 0 range 20 .. 31;
   end record;

   SIM_SCGC5_ADDRESS : constant := SIM_BASEADDRESS + 16#1038#;

   SIM_SCGC5 : aliased SIM_SCGC5_Type
      with Address    => To_Address (SIM_SCGC5_ADDRESS),
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

   type PORTx_PCRn_Type is record
      PS        : Boolean;     -- Pull Select
      PE        : Boolean;     -- Pull Enable
      SRE       : Boolean;     -- Slew Rate Enable
      Reserved1 : Bits_1 := 0;
      PFE       : Boolean;     -- Passive Filter Enable
      Reserved2 : Bits_1 := 0;
      DSE       : Boolean;     -- Drive Strength Enable
      Reserved3 : Bits_1 := 0;
      MUX       : Bits_3;      -- Pin Mux Control
      Reserved4 : Bits_5 := 0;
      IRQC      : Bits_4;      -- Interrupt Configuration
      Reserved5 : Bits_4 := 0;
      ISF       : Boolean;     -- Interrupt Status Flag
      Reserved6 : Bits_7 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PORTx_PCRn_Type use record
      PS        at 0 range  0 ..  0;
      PE        at 0 range  1 ..  1;
      SRE       at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  3;
      PFE       at 0 range  4 ..  4;
      Reserved2 at 0 range  5 ..  5;
      DSE       at 0 range  6 ..  6;
      Reserved3 at 0 range  7 ..  7;
      MUX       at 0 range  8 .. 10;
      Reserved4 at 0 range 11 .. 15;
      IRQC      at 0 range 16 .. 19;
      Reserved5 at 0 range 20 .. 23;
      ISF       at 0 range 24 .. 24;
      Reserved6 at 0 range 25 .. 31;
   end record;

   PORTA_PCR_BASEADRESS : constant := PORTx_MUX_BASEADDRESS + 16#0000#;

   PORTA_PCR : aliased array (0 .. 31) of PORTx_PCRn_Type
      with Address    => To_Address (PORTA_PCR_BASEADRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   PORTB_PCR_BASEADRESS : constant := PORTx_MUX_BASEADDRESS + 16#1000#;

   PORTB_PCR : aliased array (0 .. 31) of PORTx_PCRn_Type
      with Address    => To_Address (PORTB_PCR_BASEADRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   PORTC_PCR_BASEADRESS : constant := PORTx_MUX_BASEADDRESS + 16#2000#;

   PORTC_PCR : aliased array (0 .. 31) of PORTx_PCRn_Type
      with Address    => To_Address (PORTC_PCR_BASEADRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   PORTD_PCR_BASEADRESS : constant := PORTx_MUX_BASEADDRESS + 16#3000#;

   PORTD_PCR : aliased array (0 .. 31) of PORTx_PCRn_Type
      with Address    => To_Address (PORTD_PCR_BASEADRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   PORTE_PCR_BASEADRESS : constant := PORTx_MUX_BASEADDRESS + 16#4000#;

   PORTE_PCR : aliased array (0 .. 31) of PORTx_PCRn_Type
      with Address    => To_Address (PORTE_PCR_BASEADRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 42.2.1 Port Data Output Register

   type GPIOx_PDOR_Type is new Bitmap_32;

   -- 42.2.2 Port Set Output Register

   type GPIOx_PSOR_Type is new Bitmap_32;

   -- 42.2.3 Port Clear Output Register

   type GPIOx_PCOR_Type is new Bitmap_32;

   -- 42.2.4 Port Toggle Output Register

   type GPIOx_PTOR_Type is new Bitmap_32;

   -- 42.2.5 Port Data Input Register

   type GPIOx_PDIR_Type is new Bitmap_32;

   -- 42.2.6 Port Data Direction Register

   type GPIOx_PDDR_Type is new Bitmap_32;

   -- Port A

   GPIOA_PDOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#00#;
   GPIOA_PSOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#04#;
   GPIOA_PCOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#08#;
   GPIOA_PTOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#0C#;
   GPIOA_PDIR_ADDRESS : constant := GPIO_BASEADDRESS + 16#10#;
   GPIOA_PDDR_ADDRESS : constant := GPIO_BASEADDRESS + 16#14#;

   GPIOA_PDOR : aliased GPIOx_PDOR_Type
      with Address    => To_Address (GPIOD_PDOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOA_PSOR : aliased GPIOx_PSOR_Type
      with Address    => To_Address (GPIOA_PSOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOA_PCOR : aliased GPIOx_PCOR_Type
      with Address    => To_Address (GPIOA_PCOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOA_PTOR : aliased GPIOx_PTOR_Type
      with Address    => To_Address (GPIOA_PTOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOA_PDIR : aliased GPIOx_PDIR_Type
      with Address    => To_Address (GPIOA_PDIR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOA_PDDR : aliased GPIOx_PDDR_Type
      with Address    => To_Address (GPIOA_PDDR_ADDRESS),
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

   GPIOB_PDOR : aliased GPIOx_PDOR_Type
      with Address    => To_Address (GPIOD_PDOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB_PSOR : aliased GPIOx_PSOR_Type
      with Address    => To_Address (GPIOB_PSOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB_PCOR : aliased GPIOx_PCOR_Type
      with Address    => To_Address (GPIOB_PCOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB_PTOR : aliased GPIOx_PTOR_Type
      with Address    => To_Address (GPIOB_PTOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB_PDIR : aliased GPIOx_PDIR_Type
      with Address    => To_Address (GPIOB_PDIR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB_PDDR : aliased GPIOx_PDDR_Type
      with Address    => To_Address (GPIOB_PDDR_ADDRESS),
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

   GPIOC_PDOR : aliased GPIOx_PDOR_Type
      with Address    => To_Address (GPIOC_PDOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC_PSOR : aliased GPIOx_PSOR_Type
      with Address    => To_Address (GPIOC_PSOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC_PCOR : aliased GPIOx_PCOR_Type
      with Address    => To_Address (GPIOC_PCOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC_PTOR : aliased GPIOx_PTOR_Type
      with Address    => To_Address (GPIOC_PTOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC_PDIR : aliased GPIOx_PDIR_Type
      with Address    => To_Address (GPIOC_PDIR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC_PDDR : aliased GPIOx_PDDR_Type
      with Address    => To_Address (GPIOC_PDDR_ADDRESS),
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

   GPIOD_PDOR : aliased GPIOx_PDOR_Type
      with Address    => To_Address (GPIOD_PDOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD_PSOR : aliased GPIOx_PSOR_Type
      with Address    => To_Address (GPIOD_PSOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD_PCOR : aliased GPIOx_PCOR_Type
      with Address    => To_Address (GPIOD_PCOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD_PTOR : aliased GPIOx_PTOR_Type
      with Address    => To_Address (GPIOD_PTOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD_PDIR : aliased GPIOx_PDIR_Type
      with Address    => To_Address (GPIOD_PDIR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD_PDDR : aliased GPIOx_PDDR_Type
      with Address    => To_Address (GPIOD_PDDR_ADDRESS),
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

   GPIOE_PDOR : aliased GPIOx_PDOR_Type
      with Address    => To_Address (GPIOE_PDOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE_PSOR : aliased GPIOx_PSOR_Type
      with Address    => To_Address (GPIOE_PSOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE_PCOR : aliased GPIOx_PCOR_Type
      with Address    => To_Address (GPIOE_PCOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE_PTOR : aliased GPIOx_PTOR_Type
      with Address    => To_Address (GPIOE_PTOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE_PDIR : aliased GPIOx_PDIR_Type
      with Address    => To_Address (GPIOE_PDIR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE_PDDR : aliased GPIOx_PDDR_Type
      with Address    => To_Address (GPIOE_PDDR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end KL46Z;
