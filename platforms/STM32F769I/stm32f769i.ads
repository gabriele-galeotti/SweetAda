-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ stm32f769i.ads                                                                                            --
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

package STM32F769I
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
   -- RM0410 Rev 4
   -- STM32F76xxx and STM32F77xxx advanced Arm®-based 32-bit MCUs
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 3 Embedded Flash memory (FLASH)
   ----------------------------------------------------------------------------

   -- 3.7.1 Flash access control register (FLASH_ACR)

   type FLASH_ACR_Type is record
      LATENCY   : Bits_4  := 0;     -- Latency
      Reserved1 : Bits_4  := 0;
      PRFTEN    : Boolean := False; -- Prefetch enable
      ARTEN     : Boolean := False; -- ART Accelerator Enable
      Reserved2 : Bits_1  := 0;
      ARTRST    : Boolean := False; -- ART Accelerator reset
      Reserved3 : Bits_20 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FLASH_ACR_Type use record
      LATENCY   at 0 range  0 ..  3;
      Reserved1 at 0 range  4 ..  7;
      PRFTEN    at 0 range  8 ..  8;
      ARTEN     at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 10;
      ARTRST    at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 31;
   end record;

   FLASH_ACR_ADDRESS : constant := 16#4002_3C00#;

   FLASH_ACR : aliased FLASH_ACR_Type
      with Address              => System'To_Address (FLASH_ACR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 3.7.2 Flash key register (FLASH_KEYR)

   FKEYR_KEY1 : constant := 16#4567_0123#;
   FKEYR_KEY2 : constant := 16#CDEF_89AB#;

   type FLASH_KEYR_Type is record
      FKEYR : Unsigned_32; -- FPEC key
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FLASH_KEYR_Type use record
      FKEYR at 0 range 0 .. 31;
   end record;

   FLASH_KEYR_ADDRESS : constant := 16#4002_3C04#;

   FLASH_KEYR : aliased FLASH_KEYR_Type
      with Address              => System'To_Address (FLASH_KEYR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 3.7.3 Flash option key register (FLASH_OPTKEYR)

   OPTKEYR_OPTKEY1 : constant := 16#0819_2A3B#;
   OPTKEYR_OPTKEY2 : constant := 16#4C5D_6E7F#;

   type FLASH_OPTKEYR_Type is record
      OPTKEYR : Unsigned_32; -- Option byte key
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FLASH_OPTKEYR_Type use record
      OPTKEYR at 0 range 0 .. 31;
   end record;

   FLASH_OPTKEYR_ADDRESS : constant := 16#4002_3C08#;

   FLASH_OPTKEYR : aliased FLASH_OPTKEYR_Type
      with Address              => System'To_Address (FLASH_OPTKEYR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 3.7.4 Flash status register (FLASH_SR)

   type FLASH_SR_Type is record
      EOP       : Boolean := False; -- End of operation
      OPERR     : Boolean := False; -- Operation error
      Reserved1 : Bits_2  := 0;
      WRPERR    : Boolean := False; -- Write protection error
      PGAERR    : Boolean := False; -- Programming alignment error
      PGPERR    : Boolean := False; -- Programming parallelism error
      ERSERR    : Boolean := False; -- Erase Sequence Error
      Reserved2 : Bits_8  := 0;
      BSY       : Boolean := False; -- Busy
      Reserved3 : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FLASH_SR_Type use record
      EOP       at 0 range  0 ..  0;
      OPERR     at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  3;
      WRPERR    at 0 range  4 ..  4;
      PGAERR    at 0 range  5 ..  5;
      PGPERR    at 0 range  6 ..  6;
      ERSERR    at 0 range  7 ..  7;
      Reserved2 at 0 range  8 .. 15;
      BSY       at 0 range 16 .. 16;
      Reserved3 at 0 range 17 .. 31;
   end record;

   FLASH_SR_ADDRESS : constant := 16#4002_3C0C#;

   FLASH_SR : aliased FLASH_SR_Type
      with Address              => System'To_Address (FLASH_SR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 3.7.5 Flash control register (FLASH_CR)

   PSIZE_x8  : constant := 2#00#; -- program x8
   PSIZE_x16 : constant := 2#01#; -- program x16
   PSIZE_x32 : constant := 2#10#; -- program x32
   PSIZE_x64 : constant := 2#11#; -- program x64

   type FLASH_CR_Type is record
      PG        : Boolean := False;    -- Programming
      SER       : Boolean := False;    -- Sector Erase
      MER_MER1  : Boolean := False;    -- Mass Erase/Bank 1 Mass Erase
      SNB       : Bits_5  := 0;        -- Sector number
      PSIZE     : Bits_2  := PSIZE_x8; -- Program size
      Reserved1 : Bits_5  := 0;
      MER2      : Boolean := False;    -- Bank 2 Mass Erase
      STRT      : Boolean := False;    -- Start
      Reserved2 : Bits_7  := 0;
      EOPIE     : Boolean := False;    -- End of operation interrupt enable
      ERRIE     : Boolean := False;    -- Error interrupt enable
      Reserved3 : Bits_5  := 0;
      LOCK      : Boolean := True;     -- Lock
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FLASH_CR_Type use record
      PG        at 0 range  0 ..  0;
      SER       at 0 range  1 ..  1;
      MER_MER1  at 0 range  2 ..  2;
      SNB       at 0 range  3 ..  7;
      PSIZE     at 0 range  8 ..  9;
      Reserved1 at 0 range 10 .. 14;
      MER2      at 0 range 15 .. 15;
      STRT      at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 23;
      EOPIE     at 0 range 24 .. 24;
      ERRIE     at 0 range 25 .. 25;
      Reserved3 at 0 range 26 .. 30;
      LOCK      at 0 range 31 .. 31;
   end record;

   FLASH_CR_ADDRESS : constant := 16#4002_3C10#;

   FLASH_CR : aliased FLASH_CR_Type
      with Address              => System'To_Address (FLASH_CR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 3.7.6 Flash option control register (FLASH_OPTCR)

   BOR_LEV_3   : constant := 2#00#; -- BOR Level 3 (VBOR3), brownout threshold level 3
   BOR_LEV_2   : constant := 2#01#; -- BOR Level 2 (VBOR2), brownout threshold level 2
   BOR_LEV_1   : constant := 2#10#; -- BOR Level 1 (VBOR1), brownout threshold level 1
   BOR_LEV_off : constant := 2#11#; -- BOR off, POR/PDR reset threshold level is applied

   RDP_LEV_0 : constant := 16#AA#; -- Level 0, read protection not active
   RDP_LEV_2 : constant := 16#CC#; -- Level 2, chip read protection active

   type FLASH_OPTCR_Type is record
      OPTLOCK    : Boolean   := True;             -- Option lock
      OPTSTRT    : Boolean   := False;            -- Option start
      BOR_LEV    : Bits_2    := BOR_LEV_3;        -- BOR reset Level
      WWDG_SW    : Boolean   := True;
      IWDG_SW    : Boolean   := True;
      nRST_STOP  : Boolean   := True;
      nRST_STDBY : Boolean   := True;
      RDP        : Bits_8    := RDP_LEV_0;        -- Read protect
      nWRP       : Bitmap_12 := [others => True]; -- Not write protect
      nDBOOT     : Boolean   := True;             -- Dual Boot mode
      nDBANK     : Boolean   := True;             -- Not dual bank mode
      IWDG_STDBY : Boolean   := True;             -- Independent watchdog counter freeze in standby mode
      IWDG_STOP  : Boolean   := True;             -- Independent watchdog counter freeze in Stop mode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FLASH_OPTCR_Type use record
      OPTLOCK    at 0 range  0 ..  0;
      OPTSTRT    at 0 range  1 ..  1;
      BOR_LEV    at 0 range  2 ..  3;
      WWDG_SW    at 0 range  4 ..  4;
      IWDG_SW    at 0 range  5 ..  5;
      nRST_STOP  at 0 range  6 ..  6;
      nRST_STDBY at 0 range  7 ..  7;
      RDP        at 0 range  8 .. 15;
      nWRP       at 0 range 16 .. 27;
      nDBOOT     at 0 range 28 .. 28;
      nDBANK     at 0 range 29 .. 29;
      IWDG_STDBY at 0 range 30 .. 30;
      IWDG_STOP  at 0 range 31 .. 31;
   end record;

   FLASH_OPTCR_ADDRESS : constant := 16#4002_3C14#;

   FLASH_OPTCR : aliased FLASH_OPTCR_Type
      with Address              => System'To_Address (FLASH_OPTCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 3.7.7 Flash option control register (FLASH_OPTCR1)

   BOOT_ADD_ITCMRAM        : constant := 16#0000#; -- Boot from ITCM RAM (0x0000 0000)
   BOOT_ADD_SysMBootLoader : constant := 16#0040#; -- Boot from System memory bootloader (0x0010 0000)
   BOOT_ADD_ITCMIntFlash   : constant := 16#0080#; -- Boot from Flash on ITCM interface (0x0020 0000)
   BOOT_ADD_AXIMInt        : constant := 16#2000#; -- Boot from Flash on AXIM interface (0x0800 0000)
   BOOT_ADD_DTCMRAM        : constant := 16#8000#; -- Boot from DTCM RAM (0x2000 0000)
   BOOT_ADD_SRAM1          : constant := 16#8004#; -- Boot from SRAM1 (0x2002 0000)
   BOOT_ADD_SRAM2          : constant := 16#8013#; -- Boot from SRAM2 (0x2004 C000)

   type FLASH_OPTCR1_Type is record
      BOOT_ADD0 : Unsigned_16 := BOOT_ADD_ITCMIntFlash;   -- Boot base address when Boot pin =0
      BOOT_ADD1 : Unsigned_16 := BOOT_ADD_SysMBootLoader; -- Boot base address when Boot pin =1
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FLASH_OPTCR1_Type use record
      BOOT_ADD0 at 0 range  0 .. 15;
      BOOT_ADD1 at 0 range 16 .. 31;
   end record;

   FLASH_OPTCR1_ADDRESS : constant := 16#4002_3C18#;

   FLASH_OPTCR1 : aliased FLASH_OPTCR1_Type
      with Address              => System'To_Address (FLASH_OPTCR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 4 Power controller (PWR)
   ----------------------------------------------------------------------------

   -- 4.4.1 PWR power control register (PWR_CR1)

   PLS_2V0 : constant := 2#000#; -- 2.0 V
   PLS_2V1 : constant := 2#001#; -- 2.1 V
   PLS_2V3 : constant := 2#010#; -- 2.3 V
   PLS_2V5 : constant := 2#011#; -- 2.5 V
   PLS_2V6 : constant := 2#100#; -- 2.6 V
   PLS_2V7 : constant := 2#101#; -- 2.7 V
   PLS_2V8 : constant := 2#110#; -- 2.8 V
   PLS_2V9 : constant := 2#111#; -- 2.9 V

   VOS_RSVD   : constant := 2#00#; -- Reserved (Scale 3 mode selected)
   VOS_SCALE3 : constant := 2#01#; -- Scale 3 mode
   VOS_SCALE2 : constant := 2#10#; -- Scale 2 mode
   VOS_SCALE1 : constant := 2#11#; -- Scale 1 mode (reset value)

   UDEN_DISABLE : constant := 2#00#; -- Under-drive disable
   UDEN_RSVD1   : constant := 2#01#; -- Reserved
   UDEN_RSVD2   : constant := 2#10#; -- Reserved
   UDEN_ENABLE  : constant := 2#11#; -- Under-drive enable

   type PWR_CR1_Type is record
      LPDS      : Boolean := False;        -- Low-power deepsleep
      PDDS      : Boolean := False;        -- Power-down deepsleep
      Reserved1 : Bits_1  := 0;
      CSBF      : Boolean := False;        -- Clear standby flag
      PVDE      : Boolean := False;        -- Power voltage detector enable
      PLS       : Bits_3  := PLS_2V0;      -- PVD level selection
      DBP       : Boolean := False;        -- Disable backup domain write protection
      FPDS      : Boolean := False;        -- Flash power-down in Stop mode
      LPUDS     : Boolean := False;        -- Low-power regulator in deepsleep under-drive mode
      MRUDS     : Boolean := False;        -- Main regulator in deepsleep under-drive mode
      Reserved2 : Bits_1  := 0;
      ADCDC1    : Bits_1  := 0;            -- Refer to AN4073 for details on how to use this bit.
      VOS       : Bits_2  := VOS_SCALE1;   -- Regulator voltage scaling output selection
      ODEN      : Boolean := False;        -- Over-drive enable
      ODSWEN    : Boolean := False;        -- Over-drive switching enabled.
      UDEN      : Bits_2  := UDEN_DISABLE; -- Under-drive enable in stop mode
      Reserved3 : Bits_12 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PWR_CR1_Type use record
      LPDS      at 0 range  0 ..  0;
      PDDS      at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  2;
      CSBF      at 0 range  3 ..  3;
      PVDE      at 0 range  4 ..  4;
      PLS       at 0 range  5 ..  7;
      DBP       at 0 range  8 ..  8;
      FPDS      at 0 range  9 ..  9;
      LPUDS     at 0 range 10 .. 10;
      MRUDS     at 0 range 11 .. 11;
      Reserved2 at 0 range 12 .. 12;
      ADCDC1    at 0 range 13 .. 13;
      VOS       at 0 range 14 .. 15;
      ODEN      at 0 range 16 .. 16;
      ODSWEN    at 0 range 17 .. 17;
      UDEN      at 0 range 18 .. 19;
      Reserved3 at 0 range 20 .. 31;
   end record;

   PWR_CR1_ADDRESS : constant := 16#4000_7000#;

   PWR_CR1 : aliased PWR_CR1_Type
      with Address              => System'To_Address (PWR_CR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 4.4.2 PWR power control/status register (PWR_CSR1)

   PVDO_HIGHER : constant := 0; -- VDD is higher than the PVD threshold selected with the PLS[2:0] bits.
   PVDO_LOWER  : constant := 1; -- VDD is lower than the PVD threshold selected with the PLS[2:0] bits.

   UDRDY_DISABLED : constant := 2#00#; -- Under-drive is disabled
   UDRDY_RSVD1    : constant := 2#01#; -- Reserved
   UDRDY_RSVD2    : constant := 2#10#; -- Reserved
   UDRDY_STOP     : constant := 2#11#; -- Under-drive mode is activated in Stop mode.

   type PWR_CSR1_Type is record
      WUIF      : Boolean := False;          -- Wakeup internal flag
      SBF       : Boolean := False;          -- Standby flag
      PVDO      : Bits_1  := PVDO_HIGHER;    -- This bit is set and cleared by hardware. It is valid only if PVD is enabled by the PVDE bit.
      BRR       : Boolean := False;          -- Backup regulator ready
      Reserved1 : Bits_5  := 0;
      BRE       : Boolean := False;          -- Backup regulator enable
      Reserved2 : Bits_4  := 0;
      VOSRDY    : Boolean := False;          -- Regulator voltage scaling output selection ready bit
      Reserved3 : Bits_1  := 0;
      ODRDY     : Boolean := False;          -- Over-drive mode ready
      ODSWRDY   : Boolean := False;          -- Over-drive mode switching ready
      UDRDY     : Bits_2  := UDRDY_DISABLED; -- Under-drive ready flag
      Reserved4 : Bits_12 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PWR_CSR1_Type use record
      WUIF      at 0 range  0 ..  0;
      SBF       at 0 range  1 ..  1;
      PVDO      at 0 range  2 ..  2;
      BRR       at 0 range  3 ..  3;
      Reserved1 at 0 range  4 ..  8;
      BRE       at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 13;
      VOSRDY    at 0 range 14 .. 14;
      Reserved3 at 0 range 15 .. 15;
      ODRDY     at 0 range 16 .. 16;
      ODSWRDY   at 0 range 17 .. 17;
      UDRDY     at 0 range 18 .. 19;
      Reserved4 at 0 range 20 .. 31;
   end record;

   PWR_CSR1_ADDRESS : constant := 16#4000_7004#;

   PWR_CSR1 : aliased PWR_CSR1_Type
      with Address              => System'To_Address (PWR_CSR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 4.4.3 PWR power control/status register 2 (PWR_CR2)

   WUPP_RISING  : constant := 0; -- Detection on rising edge
   WUPP_FALLING : constant := 1; -- Detection on falling edge

   type PWR_CR2_Type is record
      CWUPF1    : Boolean := False;       -- Clear Wakeup Pin flag for PA0
      CWUPF2    : Boolean := False;       -- Clear Wakeup Pin flag for PA2
      CWUPF3    : Boolean := False;       -- Clear Wakeup Pin flag for PC1
      CWUPF4    : Boolean := False;       -- Clear Wakeup Pin flag for PC13
      CWUPF5    : Boolean := False;       -- Clear Wakeup Pin flag for PI8
      CWUPF6    : Boolean := False;       -- Clear Wakeup Pin flag for PI11
      Reserved1 : Bits_2  := 0;
      WUPP1     : Bits_1  := WUPP_RISING; -- Wakeup pin polarity bit for PA0
      WUPP2     : Bits_1  := WUPP_RISING; -- Wakeup pin polarity bit for PA2
      WUPP3     : Bits_1  := WUPP_RISING; -- Wakeup pin polarity bit for PC1
      WUPP4     : Bits_1  := WUPP_RISING; -- Wakeup pin polarity bit for PC13
      WUPP5     : Bits_1  := WUPP_RISING; -- Wakeup pin polarity bit for PI8
      WUPP6     : Bits_1  := WUPP_RISING; -- Wakeup pin polarity bit for PI11
      Reserved2 : Bits_18 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PWR_CR2_Type use record
      CWUPF1    at 0 range  0 ..  0;
      CWUPF2    at 0 range  1 ..  1;
      CWUPF3    at 0 range  2 ..  2;
      CWUPF4    at 0 range  3 ..  3;
      CWUPF5    at 0 range  4 ..  4;
      CWUPF6    at 0 range  5 ..  5;
      Reserved1 at 0 range  6 ..  7;
      WUPP1     at 0 range  8 ..  8;
      WUPP2     at 0 range  9 ..  9;
      WUPP3     at 0 range 10 .. 10;
      WUPP4     at 0 range 11 .. 11;
      WUPP5     at 0 range 12 .. 12;
      WUPP6     at 0 range 13 .. 13;
      Reserved2 at 0 range 14 .. 31;
   end record;

   PWR_CR2_ADDRESS : constant := 16#4000_7008#;

   PWR_CR2 : aliased PWR_CR2_Type
      with Address              => System'To_Address (PWR_CR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 4.4.4 PWR power control register 2 (PWR_CSR2)

   type PWR_CSR2_Type is record
      WUPF1     : Boolean := False; -- Wakeup Pin flag for PA0
      WUPF2     : Boolean := False; -- Wakeup Pin flag for PA2
      WUPF3     : Boolean := False; -- Wakeup Pin flag for PC1
      WUPF4     : Boolean := False; -- Wakeup Pin flag for PC13
      WUPF5     : Boolean := False; -- Wakeup Pin flag for PI8
      WUPF6     : Boolean := False; -- Wakeup Pin flag for PI11
      Reserved1 : Bits_2  := 0;
      EWUP1     : Boolean := False; -- Enable Wakeup pin for PA0
      EWUP2     : Boolean := False; -- Enable Wakeup pin for PA2
      EWUP3     : Boolean := False; -- Enable Wakeup pin for PC1
      EWUP4     : Boolean := False; -- Enable Wakeup pin for PC13
      EWUP5     : Boolean := False; -- Enable Wakeup pin for PI8
      EWUP6     : Boolean := False; -- Enable Wakeup pin for PI11
      Reserved2 : Bits_18 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PWR_CSR2_Type use record
      WUPF1     at 0 range  0 ..  0;
      WUPF2     at 0 range  1 ..  1;
      WUPF3     at 0 range  2 ..  2;
      WUPF4     at 0 range  3 ..  3;
      WUPF5     at 0 range  4 ..  4;
      WUPF6     at 0 range  5 ..  5;
      Reserved1 at 0 range  6 ..  7;
      EWUP1     at 0 range  8 ..  8;
      EWUP2     at 0 range  9 ..  9;
      EWUP3     at 0 range 10 .. 10;
      EWUP4     at 0 range 11 .. 11;
      EWUP5     at 0 range 12 .. 12;
      EWUP6     at 0 range 13 .. 13;
      Reserved2 at 0 range 14 .. 31;
   end record;

   PWR_CSR2_ADDRESS : constant := 16#4000_700C#;

   PWR_CSR2 : aliased PWR_CSR2_Type
      with Address              => System'To_Address (PWR_CSR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 5 Reset and clock control (RCC)
   ----------------------------------------------------------------------------

   -- 5.3.1 RCC clock control register (RCC_CR)

   type RCC_CR_Type is record
      HSION     : Boolean := True;   -- Internal high-speed clock enable
      HSIRDY    : Boolean := True;   -- Internal high-speed clock ready flag
      Reserved1 : Bits_1  := 0;
      HSITRIM   : Bits_5  := 16#10#; -- Internal high-speed clock trimming
      HSICAL    : Bits_8  := 0;      -- Internal high-speed clock calibration
      HSEON     : Boolean := False;  -- HSE clock enable
      HSERDY    : Boolean := False;  -- HSE clock ready flag
      HSEBYP    : Boolean := False;  -- HSE clock bypass
      CSSON     : Boolean := False;  -- Clock security system enable
      Reserved2 : Bits_4  := 0;
      PLLON     : Boolean := False;  -- Main PLL (PLL) enable
      PLLRDY    : Boolean := False;  -- Main PLL (PLL) clock ready flag
      PLLI2SON  : Boolean := False;  -- PLLI2S enable
      PLLI2SRDY : Boolean := False;  -- PLLI2S clock ready flag
      PLLSAION  : Boolean := False;  -- PLLSAI enable
      PLLSAIRDY : Boolean := False;  -- PLLSAI clock ready flag
      Reserved3 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_CR_Type use record
      HSION     at 0 range  0 ..  0;
      HSIRDY    at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  2;
      HSITRIM   at 0 range  3 ..  7;
      HSICAL    at 0 range  8 .. 15;
      HSEON     at 0 range 16 .. 16;
      HSERDY    at 0 range 17 .. 17;
      HSEBYP    at 0 range 18 .. 18;
      CSSON     at 0 range 19 .. 19;
      Reserved2 at 0 range 20 .. 23;
      PLLON     at 0 range 24 .. 24;
      PLLRDY    at 0 range 25 .. 25;
      PLLI2SON  at 0 range 26 .. 26;
      PLLI2SRDY at 0 range 27 .. 27;
      PLLSAION  at 0 range 28 .. 28;
      PLLSAIRDY at 0 range 29 .. 29;
      Reserved3 at 0 range 30 .. 31;
   end record;

   RCC_CR_ADDRESS : constant := 16#4002_3800#;

   RCC_CR : aliased RCC_CR_Type
      with Address              => System'To_Address (RCC_CR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.2 RCC PLL configuration register (RCC_PLLCFGR)

   PLLP_DIV2 : constant := 2#00#; -- PLLP = 2
   PLLP_DIV4 : constant := 2#01#; -- PLLP = 4
   PLLP_DIV6 : constant := 2#10#; -- PLLP = 6
   PLLP_DIV8 : constant := 2#11#; -- PLLP = 8

   PLLSRC_HSI : constant := 0; -- HSI clock selected as PLL and PLLI2S clock entry
   PLLSRC_HSE : constant := 1; -- HSE oscillator clock selected as PLL and PLLI2S clock entry

   type RCC_PLLCFGR_Type is record
      PLLM      : Bits_6 range 2 .. 63   := 16;         -- Division factor for the main PLLs (PLL, PLLI2S and PLLSAI) input clock
      PLLN      : Bits_9 range 50 .. 432 := 192;        -- Main PLL (PLL) multiplication factor for VCO
      Reserved1 : Bits_1                 := 0;
      PLLP      : Bits_2                 := PLLP_DIV2;  -- Main PLL (PLL) division factor for main system clock
      Reserved2 : Bits_4                 := 0;
      PLLSRC    : Bits_1                 := PLLSRC_HSI; -- Main PLL(PLL) and audio PLL (PLLI2S) entry clock source
      Reserved3 : Bits_1                 := 0;
      PLLQ      : Bits_4 range 2 .. 15   := 4;          -- Main PLL (PLL) division factor for USB OTG FS, SDMMC1/2 and [RNG] clocks
      PLLR      : Bits_3 range 2 .. 7    := 2;          -- PLL division factor for DSI clock
      Reserved4 : Bits_1                 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_PLLCFGR_Type use record
      PLLM      at 0 range  0 ..  5;
      PLLN      at 0 range  6 .. 14;
      Reserved1 at 0 range 15 .. 15;
      PLLP      at 0 range 16 .. 17;
      Reserved2 at 0 range 18 .. 21;
      PLLSRC    at 0 range 22 .. 22;
      Reserved3 at 0 range 23 .. 23;
      PLLQ      at 0 range 24 .. 27;
      PLLR      at 0 range 28 .. 30;
      Reserved4 at 0 range 31 .. 31;
   end record;

   RCC_PLLCFGR_ADDRESS : constant := 16#4002_3804#;

   RCC_PLLCFGR : aliased RCC_PLLCFGR_Type
      with Address              => System'To_Address (RCC_PLLCFGR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.3 RCC clock configuration register (RCC_CFGR)

   SW_HSI  : constant := 2#00#; -- HSI oscillator selected as system clock
   SW_HSE  : constant := 2#01#; -- HSE oscillator selected as system clock
   SW_PLL  : constant := 2#10#; -- PLL selected as system clock
   SW_RSVD : constant := 2#11#;

   SWS_HSI  : constant := 2#00#; -- HSI oscillator used as the system clock
   SWS_HSE  : constant := 2#01#; -- HSE oscillator used as the system clock
   SWS_PLL  : constant := 2#10#; -- PLL used as the system clock
   SWS_RSVD : constant := 2#11#; -- not applicable

   HPRE_NODIV  : constant := 2#0000#; -- system clock not divided
   HPRE_DIV2   : constant := 2#1000#; -- system clock divided by 2
   HPRE_DIV4   : constant := 2#1001#; -- system clock divided by 4
   HPRE_DIV8   : constant := 2#1010#; -- system clock divided by 8
   HPRE_DIV16  : constant := 2#1011#; -- system clock divided by 16
   HPRE_DIV64  : constant := 2#1100#; -- system clock divided by 64
   HPRE_DIV128 : constant := 2#1101#; -- system clock divided by 128
   HPRE_DIV256 : constant := 2#1110#; -- system clock divided by 256
   HPRE_DIV512 : constant := 2#1111#; -- system clock divided by 512

   PPRE_NODIV : constant := 2#000#; -- AHB clock not divided
   PPRE_DIV2  : constant := 2#100#; -- AHB clock divided by 2
   PPRE_DIV4  : constant := 2#101#; -- AHB clock divided by 4
   PPRE_DIV8  : constant := 2#110#; -- AHB clock divided by 8
   PPRE_DIV16 : constant := 2#111#; -- AHB clock divided by 16

   RTCPRE_NOCLOCK  : constant := 2#00000#; -- no clock
   RTCPRE_NOCLOCK1 : constant := 2#00001#; -- no clock
   RTCPRE_HSEDIV2  : constant := 2#00010#; -- HSE/2
   RTCPRE_HSEDIV3  : constant := 2#00011#; -- HSE/3
   RTCPRE_HSEDIV4  : constant := 2#00100#; -- HSE/4
   RTCPRE_HSEDIV5  : constant := 2#00101#; -- ...
   RTCPRE_HSEDIV6  : constant := 2#00110#;
   RTCPRE_HSEDIV7  : constant := 2#00111#;
   RTCPRE_HSEDIV8  : constant := 2#01000#;
   RTCPRE_HSEDIV9  : constant := 2#01001#;
   RTCPRE_HSEDIV10 : constant := 2#01010#;
   RTCPRE_HSEDIV11 : constant := 2#01011#;
   RTCPRE_HSEDIV12 : constant := 2#01100#;
   RTCPRE_HSEDIV13 : constant := 2#01101#;
   RTCPRE_HSEDIV14 : constant := 2#01110#;
   RTCPRE_HSEDIV15 : constant := 2#01111#;
   RTCPRE_HSEDIV16 : constant := 2#10000#;
   RTCPRE_HSEDIV17 : constant := 2#10001#;
   RTCPRE_HSEDIV18 : constant := 2#10010#;
   RTCPRE_HSEDIV19 : constant := 2#10011#;
   RTCPRE_HSEDIV20 : constant := 2#10100#;
   RTCPRE_HSEDIV21 : constant := 2#10101#;
   RTCPRE_HSEDIV22 : constant := 2#10110#;
   RTCPRE_HSEDIV23 : constant := 2#10111#;
   RTCPRE_HSEDIV24 : constant := 2#11000#;
   RTCPRE_HSEDIV25 : constant := 2#11001#;
   RTCPRE_HSEDIV26 : constant := 2#11010#;
   RTCPRE_HSEDIV27 : constant := 2#11011#;
   RTCPRE_HSEDIV28 : constant := 2#11100#;
   RTCPRE_HSEDIV29 : constant := 2#11101#;
   RTCPRE_HSEDIV30 : constant := 2#11110#; -- HSE/30
   RTCPRE_HSEDIV31 : constant := 2#11111#; -- HSE/31

   MCO1_HSI : constant := 2#00#; -- HSI clock selected
   MCO1_LSE : constant := 2#01#; -- LSE oscillator selected
   MCO1_HSE : constant := 2#10#; -- HSE oscillator clock selected
   MCO1_PLL : constant := 2#11#; -- PLL clock selected

   I2SSCR_PLLI2S : constant := 0; -- PLLI2S clock used as I2S clock source
   I2SSCR_EXT    : constant := 1; -- External clock mapped on the I2S_CKIN pin used as I2S clock source

   MCOPRE_NODIV : constant := 2#000#; -- no division
   MCOPRE_DIV2  : constant := 2#100#; -- division by 2
   MCOPRE_DIV3  : constant := 2#101#; -- division by 3
   MCOPRE_DIV4  : constant := 2#110#; -- division by 4
   MCOPRE_DIV5  : constant := 2#111#; -- division by 5

   MCO2_SYSCLK : constant := 2#00#; -- System clock (SYSCLK) selected
   MCO2_PLLI2S : constant := 2#01#; -- PLLI2S clock selected
   MCO2_HSE    : constant := 2#10#; -- HSE oscillator clock selected
   MCO2_PLL    : constant := 2#11#; -- PLL clock selected

   type RCC_CFGR_Type is record
      SW        : Bits_2 := SW_HSI;         -- System clock switch
      SWS       : Bits_2 := SWS_HSI;        -- System clock switch status
      HPRE      : Bits_4 := HPRE_NODIV;     -- AHB prescaler
      Reserved1 : Bits_2 := 0;
      PPRE1     : Bits_3 := PPRE_NODIV;     -- APB Low-speed prescaler (APB1)
      PPRE2     : Bits_3 := PPRE_NODIV;     -- APB high-speed prescaler (APB2)
      RTCPRE    : Bits_5 := RTCPRE_NOCLOCK; -- HSE division factor for RTC clock
      MCO1      : Bits_2 := MCO1_HSI;       -- Microcontroller clock output 1
      I2SSCR    : Bits_1 := I2SSCR_PLLI2S;  -- I2S clock selection
      MCO1PRE   : Bits_3 := MCOPRE_NODIV;   -- MCO1 prescaler
      MCO2PRE   : Bits_3 := MCOPRE_NODIV;   -- MCO2 prescaler
      MCO2      : Bits_2 := MCO2_SYSCLK;    -- Microcontroller clock output 2
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_CFGR_Type use record
      SW        at 0 range  0 ..  1;
      SWS       at 0 range  2 ..  3;
      HPRE      at 0 range  4 ..  7;
      Reserved1 at 0 range  8 ..  9;
      PPRE1     at 0 range 10 .. 12;
      PPRE2     at 0 range 13 .. 15;
      RTCPRE    at 0 range 16 .. 20;
      MCO1      at 0 range 21 .. 22;
      I2SSCR    at 0 range 23 .. 23;
      MCO1PRE   at 0 range 24 .. 26;
      MCO2PRE   at 0 range 27 .. 29;
      MCO2      at 0 range 30 .. 31;
   end record;

   RCC_CFGR_ADDRESS : constant := 16#4002_3808#;

   RCC_CFGR : aliased RCC_CFGR_Type
      with Address              => System'To_Address (RCC_CFGR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.4 RCC clock interrupt register (RCC_CIR)

   type RCC_CIR_Type is record
      LSIRDYF     : Boolean := False; -- LSI ready interrupt flag
      LSERDYF     : Boolean := False; -- LSE ready interrupt flag
      HSIRDYF     : Boolean := False; -- HSI ready interrupt flag
      HSERDYF     : Boolean := False; -- HSE ready interrupt flag
      PLLRDYF     : Boolean := False; -- Main PLL (PLL) ready interrupt flag
      PLLI2SRDYF  : Boolean := False; -- PLLI2S ready interrupt flag
      PLLSAIRDYF  : Boolean := False; -- PLLSAI Ready Interrupt flag
      CSSF        : Boolean := False; -- Clock security system interrupt flag
      LSIRDYIE    : Boolean := False; -- LSI ready interrupt enable
      LSERDYIE    : Boolean := False; -- LSE ready interrupt enable
      HSIRDYIE    : Boolean := False; -- HSI ready interrupt enable
      HSERDYIE    : Boolean := False; -- HSE ready interrupt enable
      PLLRDYIE    : Boolean := False; -- Main PLL (PLL) ready interrupt enable
      PLLI2SRDYIE : Boolean := False; -- PLLI2S ready interrupt enable
      PLLSAIRDYIE : Boolean := False; -- PLLSAI Ready Interrupt Enable
      Reserved1   : Bits_1  := 0;
      LSIRDYC     : Boolean := False; -- LSI ready interrupt clear
      LSERDYC     : Boolean := False; -- LSE ready interrupt clear
      HSIRDYC     : Boolean := False; -- HSI ready interrupt clear
      HSERDYC     : Boolean := False; -- HSE ready interrupt clear
      PLLRDYC     : Boolean := False; -- Main PLL(PLL) ready interrupt clear
      PLLI2SRDYC  : Boolean := False; -- PLLI2S ready interrupt clear
      PLLSAIRDYC  : Boolean := False; -- PLLSAI Ready Interrupt Clear
      CSSC        : Boolean := False; -- Clock security system interrupt clear
      Reserved2   : Bits_8  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_CIR_Type use record
      LSIRDYF     at 0 range  0 ..  0;
      LSERDYF     at 0 range  1 ..  1;
      HSIRDYF     at 0 range  2 ..  2;
      HSERDYF     at 0 range  3 ..  3;
      PLLRDYF     at 0 range  4 ..  4;
      PLLI2SRDYF  at 0 range  5 ..  5;
      PLLSAIRDYF  at 0 range  6 ..  6;
      CSSF        at 0 range  7 ..  7;
      LSIRDYIE    at 0 range  8 ..  8;
      LSERDYIE    at 0 range  9 ..  9;
      HSIRDYIE    at 0 range 10 .. 10;
      HSERDYIE    at 0 range 11 .. 11;
      PLLRDYIE    at 0 range 12 .. 12;
      PLLI2SRDYIE at 0 range 13 .. 13;
      PLLSAIRDYIE at 0 range 14 .. 14;
      Reserved1   at 0 range 15 .. 15;
      LSIRDYC     at 0 range 16 .. 16;
      LSERDYC     at 0 range 17 .. 17;
      HSIRDYC     at 0 range 18 .. 18;
      HSERDYC     at 0 range 19 .. 19;
      PLLRDYC     at 0 range 20 .. 20;
      PLLI2SRDYC  at 0 range 21 .. 21;
      PLLSAIRDYC  at 0 range 22 .. 22;
      CSSC        at 0 range 23 .. 23;
      Reserved2   at 0 range 24 .. 31;
   end record;

   RCC_CIR_ADDRESS : constant := 16#4002_380C#;

   RCC_CIR : aliased RCC_CIR_Type
      with Address              => System'To_Address (RCC_CIR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.5 RCC AHB1 peripheral reset register (RCC_AHB1RSTR)

   type RCC_AHB1RSTR_Type is record
      GPIOARST  : Boolean := False; -- IO port A reset
      GPIOBRST  : Boolean := False; -- IO port B reset
      GPIOCRST  : Boolean := False; -- IO port C reset
      GPIODRST  : Boolean := False; -- IO port D reset
      GPIOERST  : Boolean := False; -- IO port E reset
      GPIOFRST  : Boolean := False; -- IO port F reset
      GPIOGRST  : Boolean := False; -- IO port G reset
      GPIOHRST  : Boolean := False; -- IO port H reset
      GPIOIRST  : Boolean := False; -- IO port I reset
      GPIOJRST  : Boolean := False; -- IO port J reset
      GPIOKRST  : Boolean := False; -- IO port K reset
      Reserved1 : Bits_1  := 0;
      CRCRST    : Boolean := False; -- CRC reset
      Reserved2 : Bits_8  := 0;
      DMA1RST   : Boolean := False; -- DMA2 reset
      DMA2RST   : Boolean := False; -- DMA2 reset
      DMA2DRST  : Boolean := False; -- DMA2D reset
      Reserved3 : Bits_1  := 0;
      ETHMACRST : Boolean := False; -- Ethernet MAC reset
      Reserved4 : Bits_3  := 0;
      OTGHSRST  : Boolean := False; -- USB OTG HS module reset
      Reserved5 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_AHB1RSTR_Type use record
      GPIOARST  at 0 range  0 ..  0;
      GPIOBRST  at 0 range  1 ..  1;
      GPIOCRST  at 0 range  2 ..  2;
      GPIODRST  at 0 range  3 ..  3;
      GPIOERST  at 0 range  4 ..  4;
      GPIOFRST  at 0 range  5 ..  5;
      GPIOGRST  at 0 range  6 ..  6;
      GPIOHRST  at 0 range  7 ..  7;
      GPIOIRST  at 0 range  8 ..  8;
      GPIOJRST  at 0 range  9 ..  9;
      GPIOKRST  at 0 range 10 .. 10;
      Reserved1 at 0 range 11 .. 11;
      CRCRST    at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 20;
      DMA1RST   at 0 range 21 .. 21;
      DMA2RST   at 0 range 22 .. 22;
      DMA2DRST  at 0 range 23 .. 23;
      Reserved3 at 0 range 24 .. 24;
      ETHMACRST at 0 range 25 .. 25;
      Reserved4 at 0 range 26 .. 28;
      OTGHSRST  at 0 range 29 .. 29;
      Reserved5 at 0 range 30 .. 31;
   end record;

   RCC_AHB1RSTR_ADDRESS : constant := 16#4002_3810#;

   RCC_AHB1RSTR : aliased RCC_AHB1RSTR_Type
      with Address              => System'To_Address (RCC_AHB1RSTR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.6 RCC AHB2 peripheral reset register (RCC_AHB2RSTR)

   type RCC_AHB2RSTR_Type is record
      DCMIRST   : Boolean := False; -- Camera interface reset
      JPEGRST   : Boolean := False; -- JPEG module reset
      Reserved1 : Bits_2  := 0;
      CRYPRST   : Boolean := False; -- Cryptographic module reset
      HASHRST   : Boolean := False; -- Hash module reset
      RNGRST    : Boolean := False; -- Random number generator module reset
      OTGFSRST  : Boolean := False; -- USB OTG FS module reset
      Reserved2 : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_AHB2RSTR_Type use record
      DCMIRST   at 0 range 0 ..  0;
      JPEGRST   at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  3;
      CRYPRST   at 0 range 4 ..  4;
      HASHRST   at 0 range 5 ..  5;
      RNGRST    at 0 range 6 ..  6;
      OTGFSRST  at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   RCC_AHB2RSTR_ADDRESS : constant := 16#4002_3814#;

   RCC_AHB2RSTR : aliased RCC_AHB2RSTR_Type
      with Address              => System'To_Address (RCC_AHB2RSTR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.7 RCC AHB3 peripheral reset register (RCC_AHB3RSTR)

   type RCC_AHB3RSTR_Type is record
      FMCRST   : Boolean := False; -- Flexible memory controller module reset
      QSPIRST  : Boolean := False; -- Quad SPI memory controller reset
      Reserved : Bits_30 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_AHB3RSTR_Type use record
      FMCRST   at 0 range 0 ..  0;
      QSPIRST  at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   RCC_AHB3RSTR_ADDRESS : constant := 16#4002_3818#;

   RCC_AHB3RSTR : aliased RCC_AHB3RSTR_Type
      with Address              => System'To_Address (RCC_AHB3RSTR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.8 RCC APB1 peripheral reset register (RCC_APB1RSTR)

   type RCC_APB1RSTR_Type is record
      TIM2RST    : Boolean := False; -- TIM2 reset
      TIM3RST    : Boolean := False; -- TIM3 reset
      TIM4RST    : Boolean := False; -- TIM4 reset
      TIM5RST    : Boolean := False; -- TIM5 reset
      TIM6RST    : Boolean := False; -- TIM6 reset
      TIM7RST    : Boolean := False; -- TIM7 reset
      TIM12RST   : Boolean := False; -- TIM12 reset
      TIM13RST   : Boolean := False; -- TIM13 reset
      TIM14RST   : Boolean := False; -- TIM14 reset
      LPTMI1RST  : Boolean := False; -- Low-power timer 1 reset
      Reserved1  : Bits_1  := 0;
      WWDGRST    : Boolean := False; -- Window watchdog reset
      Reserved2  : Bits_1  := 0;
      CAN3RST    : Boolean := False; -- CAN 3 reset
      SPI2RST    : Boolean := False; -- SPI2 reset
      SPI3RST    : Boolean := False; -- SPI3 reset
      SPDIFRXRST : Boolean := False; -- SPDIFRX reset
      USART2RST  : Boolean := False; -- USART2 reset
      USART3RST  : Boolean := False; -- USART3 reset
      UART4RST   : Boolean := False; -- UART4 reset
      UART5RST   : Boolean := False; -- UART5 reset
      I2C1RST    : Boolean := False; -- I2C1 reset
      I2C2RST    : Boolean := False; -- I2C2 reset
      I2C3RST    : Boolean := False; -- I2C3 reset
      I2C4RST    : Boolean := False; -- I2C4 reset
      CAN1RST    : Boolean := False; -- CAN 1 reset
      CAN2RST    : Boolean := False; -- CAN 2 reset
      CECRST     : Boolean := False; -- HDMI-CEC reset
      PWRRST     : Boolean := False; -- Power interface reset
      DACRST     : Boolean := False; -- DAC interface reset
      UART7RST   : Boolean := False; -- UART7 reset
      UART8RST   : Boolean := False; -- UART8 reset
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_APB1RSTR_Type use record
      TIM2RST    at 0 range  0  .. 0;
      TIM3RST    at 0 range  1  .. 1;
      TIM4RST    at 0 range  2  .. 2;
      TIM5RST    at 0 range  3  .. 3;
      TIM6RST    at 0 range  4  .. 4;
      TIM7RST    at 0 range  5  .. 5;
      TIM12RST   at 0 range  6  .. 6;
      TIM13RST   at 0 range  7  .. 7;
      TIM14RST   at 0 range  8  .. 8;
      LPTMI1RST  at 0 range  9  .. 9;
      Reserved1  at 0 range 10 .. 10;
      WWDGRST    at 0 range 11 .. 11;
      Reserved2  at 0 range 12 .. 12;
      CAN3RST    at 0 range 13 .. 13;
      SPI2RST    at 0 range 14 .. 14;
      SPI3RST    at 0 range 15 .. 15;
      SPDIFRXRST at 0 range 16 .. 16;
      USART2RST  at 0 range 17 .. 17;
      USART3RST  at 0 range 18 .. 18;
      UART4RST   at 0 range 19 .. 19;
      UART5RST   at 0 range 20 .. 20;
      I2C1RST    at 0 range 21 .. 21;
      I2C2RST    at 0 range 22 .. 22;
      I2C3RST    at 0 range 23 .. 23;
      I2C4RST    at 0 range 24 .. 24;
      CAN1RST    at 0 range 25 .. 25;
      CAN2RST    at 0 range 26 .. 26;
      CECRST     at 0 range 27 .. 27;
      PWRRST     at 0 range 28 .. 28;
      DACRST     at 0 range 29 .. 29;
      UART7RST   at 0 range 30 .. 30;
      UART8RST   at 0 range 31 .. 31;
   end record;

   RCC_APB1RSTR_ADDRESS : constant := 16#4002_3820#;

   RCC_APB1RSTR : aliased RCC_APB1RSTR_Type
      with Address              => System'To_Address (RCC_APB1RSTR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.9 RCC APB2 peripheral reset register (RCC_APB2RSTR)

   type RCC_APB2RSTR_Type is record
      TIM1RST   : Boolean := False; -- TIM1 reset
      TIM8RST   : Boolean := False; -- TIM8 reset
      Reserved1 : Bits_2  := 0;
      USART1RST : Boolean := False; -- USART1 reset
      USART6RST : Boolean := False; -- USART6 reset
      Reserved2 : Bits_1  := 0;
      SDMMC2RST : Boolean := False; -- SDMMC2 module reset
      ADC1RST   : Boolean := False; -- ADC interface reset (common to all ADCs)
      Reserved3 : Bits_2  := 0;
      SDMMC1RST : Boolean := False; -- SDMMC1 reset
      SPI1RST   : Boolean := False; -- SPI1 reset
      SPI4RST   : Boolean := False; -- SPI4 reset
      SYSCFGRST : Boolean := False; -- System configuration controller reset
      Reserved4 : Bits_1  := 0;
      TIM9RST   : Boolean := False; -- TIM9 reset
      TIM10RST  : Boolean := False; -- TIM10 reset
      TIM11RST  : Boolean := False; -- TIM11 reset
      Reserved5 : Bits_1  := 0;
      SPI5RST   : Boolean := False; -- SPI5 reset
      SPI6RST   : Boolean := False; -- SPI6 reset
      SAI1RST   : Boolean := False; -- SAI1 reset
      SAI2RST   : Boolean := False; -- SAI2 reset
      Reserved6 : Bits_2  := 0;
      LTDCRST   : Boolean := False; -- LTDC reset
      DSIRST    : Boolean := False; -- DSIHOST module reset
      Reserved7 : Bits_1  := 0;
      DFSDM1RST : Boolean := False; -- DFSDM1 module reset
      MDIORST   : Boolean := False; -- MDIO module reset
      Reserved8 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_APB2RSTR_Type use record
      TIM1RST   at 0 range  0 ..  0;
      TIM8RST   at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  3;
      USART1RST at 0 range  4 ..  4;
      USART6RST at 0 range  5 ..  5;
      Reserved2 at 0 range  6 ..  6;
      SDMMC2RST at 0 range  7 ..  7;
      ADC1RST   at 0 range  8 ..  8;
      Reserved3 at 0 range  9 .. 10;
      SDMMC1RST at 0 range 11 .. 11;
      SPI1RST   at 0 range 12 .. 12;
      SPI4RST   at 0 range 13 .. 13;
      SYSCFGRST at 0 range 14 .. 14;
      Reserved4 at 0 range 15 .. 15;
      TIM9RST   at 0 range 16 .. 16;
      TIM10RST  at 0 range 17 .. 17;
      TIM11RST  at 0 range 18 .. 18;
      Reserved5 at 0 range 19 .. 19;
      SPI5RST   at 0 range 20 .. 20;
      SPI6RST   at 0 range 21 .. 21;
      SAI1RST   at 0 range 22 .. 22;
      SAI2RST   at 0 range 23 .. 23;
      Reserved6 at 0 range 24 .. 25;
      LTDCRST   at 0 range 26 .. 26;
      DSIRST    at 0 range 27 .. 27;
      Reserved7 at 0 range 28 .. 28;
      DFSDM1RST at 0 range 29 .. 29;
      MDIORST   at 0 range 30 .. 30;
      Reserved8 at 0 range 31 .. 31;
   end record;

   RCC_APB2RSTR_ADDRESS : constant := 16#4002_3824#;

   RCC_APB2RSTR : aliased RCC_APB2RSTR_Type
      with Address              => System'To_Address (RCC_APB2RSTR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.10 RCC AHB1 peripheral clock register (RCC_AHB1ENR)

   type RCC_AHB1ENR_Type is record
      GPIOAEN     : Boolean := False; -- IO port A clock enable
      GPIOBEN     : Boolean := False; -- IO port B clock enable
      GPIOCEN     : Boolean := False; -- IO port C clock enable
      GPIODEN     : Boolean := False; -- IO port D clock enable
      GPIOEEN     : Boolean := False; -- IO port E clock enable
      GPIOFEN     : Boolean := False; -- IO port F clock enable
      GPIOGEN     : Boolean := False; -- IO port G clock enable
      GPIOHEN     : Boolean := False; -- IO port H clock enable
      GPIOIEN     : Boolean := False; -- IO port I clock enable
      GPIOJEN     : Boolean := False; -- IO port J clock enable
      GPIOKEN     : Boolean := False; -- IO port K clock enable
      Reserved1   : Bits_1  := 0;
      CRCEN       : Boolean := False; -- CRC clock enable
      Reserved2   : Bits_5  := 0;
      BKPSRAMEN   : Boolean := False; -- Backup SRAM interface clock enable
      Reserved3   : Bits_1  := 0;
      DTCMRAMEN   : Boolean := True;  -- DTCM data RAM clock enable
      DMA1EN      : Boolean := False; -- DMA1 clock enable
      DMA2EN      : Boolean := False; -- DMA2 clock enable
      DMA2DEN     : Boolean := False; -- DMA2D clock enable
      Reserved4   : Bits_1  := 0;
      ETHMACEN    : Boolean := False; -- Ethernet MAC clock enable
      ETHMACTXEN  : Boolean := False; -- Ethernet Transmission clock enable
      ETHMACRXEN  : Boolean := False; -- Ethernet Reception clock enable
      ETHMACPTPEN : Boolean := False; -- Ethernet PTP clock enable
      OTGHSEN     : Boolean := False; -- USB OTG HS clock enable
      OTGHSULPIEN : Boolean := False; -- USB OTG HSULPI clock enable
      Reserved5   : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_AHB1ENR_Type use record
      GPIOAEN     at 0 range  0 ..  0;
      GPIOBEN     at 0 range  1 ..  1;
      GPIOCEN     at 0 range  2 ..  2;
      GPIODEN     at 0 range  3 ..  3;
      GPIOEEN     at 0 range  4 ..  4;
      GPIOFEN     at 0 range  5 ..  5;
      GPIOGEN     at 0 range  6 ..  6;
      GPIOHEN     at 0 range  7 ..  7;
      GPIOIEN     at 0 range  8 ..  8;
      GPIOJEN     at 0 range  9 ..  9;
      GPIOKEN     at 0 range 10 .. 10;
      Reserved1   at 0 range 11 .. 11;
      CRCEN       at 0 range 12 .. 12;
      Reserved2   at 0 range 13 .. 17;
      BKPSRAMEN   at 0 range 18 .. 18;
      Reserved3   at 0 range 19 .. 19;
      DTCMRAMEN   at 0 range 20 .. 20;
      DMA1EN      at 0 range 21 .. 21;
      DMA2EN      at 0 range 22 .. 22;
      DMA2DEN     at 0 range 23 .. 23;
      Reserved4   at 0 range 24 .. 24;
      ETHMACEN    at 0 range 25 .. 25;
      ETHMACTXEN  at 0 range 26 .. 26;
      ETHMACRXEN  at 0 range 27 .. 27;
      ETHMACPTPEN at 0 range 28 .. 28;
      OTGHSEN     at 0 range 29 .. 29;
      OTGHSULPIEN at 0 range 30 .. 30;
      Reserved5   at 0 range 31 .. 31;
   end record;

   RCC_AHB1ENR_ADDRESS : constant := 16#4002_3830#;

   RCC_AHB1ENR : aliased RCC_AHB1ENR_Type
      with Address              => System'To_Address (RCC_AHB1ENR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.11 RCC AHB2 peripheral clock enable register (RCC_AHB2ENR)

   type RCC_AHB2ENR_Type is record
      DCMIEN    : Boolean := False; -- Camera interface enable
      JPEGEN    : Boolean := False; -- JPEG module clock enable
      Reserved1 : Bits_2  := 0;
      CRYPEN    : Boolean := False; -- Cryptographic modules clock enable
      HASHEN    : Boolean := False; -- Hash modules clock enable
      RNGEN     : Boolean := False; -- Random number generator clock enable
      OTGFSEN   : Boolean := False; -- USB OTG FS clock enable
      Reserved2 : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_AHB2ENR_Type use record
      DCMIEN    at 0 range 0 ..  0;
      JPEGEN    at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  3;
      CRYPEN    at 0 range 4 ..  4;
      HASHEN    at 0 range 5 ..  5;
      RNGEN     at 0 range 6 ..  6;
      OTGFSEN   at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   RCC_AHB2ENR_ADDRESS : constant := 16#4002_3834#;

   RCC_AHB2ENR : aliased RCC_AHB2ENR_Type
      with Address              => System'To_Address (RCC_AHB2ENR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.12 RCC AHB3 peripheral clock enable register (RCC_AHB3ENR)

   type RCC_AHB3ENR_Type is record
      FMCEN    : Boolean := False; -- Flexible memory controller clock enable
      QSPIEN   : Boolean := False; -- Quad SPI memory controller clock enable
      Reserved : Bits_30 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_AHB3ENR_Type use record
      FMCEN    at 0 range 0 ..  0;
      QSPIEN   at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   RCC_AHB3ENR_ADDRESS : constant := 16#4002_3838#;

   RCC_AHB3ENR : aliased RCC_AHB3ENR_Type
      with Address              => System'To_Address (RCC_AHB3ENR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.13 RCC APB1 peripheral clock enable register (RCC_APB1ENR)

   type RCC_APB1ENR_Type is record
      TIM2EN    : Boolean := False; -- TIM2 clock enable
      TIM3EN    : Boolean := False; -- TIM3 clock enable
      TIM4EN    : Boolean := False; -- TIM4 clock enable
      TIM5EN    : Boolean := False; -- TIM5 clock enable
      TIM6EN    : Boolean := False; -- TIM6 clock enable
      TIM7EN    : Boolean := False; -- TIM7 clock enable
      TIM12EN   : Boolean := False; -- TIM12 clock enable
      TIM13EN   : Boolean := False; -- TIM13 clock enable
      TIM14EN   : Boolean := False; -- TIM14 clock enable
      LPTMI1EN  : Boolean := False; -- Low-power timer 1 clock enable
      RTCAPBEN  : Boolean := True;  -- RTC register interface clock enable
      WWDGEN    : Boolean := False; -- Window watchdog clock enable
      Reserved  : Bits_1  := 0;
      CAN3EN    : Boolean := False; -- CAN 3 clock enable
      SPI2EN    : Boolean := False; -- SPI2 clock enable
      SPI3EN    : Boolean := False; -- SPI3 clock enable
      SPDIFRXEN : Boolean := False; -- SPDIFRX clock enable
      USART2EN  : Boolean := False; -- USART2 clock enable
      USART3EN  : Boolean := False; -- USART3 clock enable
      UART4EN   : Boolean := False; -- UART4 clock enable
      UART5EN   : Boolean := False; -- UART5 clock enable
      I2C1EN    : Boolean := False; -- I2C1 clock enable
      I2C2EN    : Boolean := False; -- I2C2 clock enable
      I2C3EN    : Boolean := False; -- I2C3 clock enable
      I2C4EN    : Boolean := False; -- I2C4 clock enable
      CAN1EN    : Boolean := False; -- CAN 1 clock enable
      CAN2EN    : Boolean := False; -- CAN 2 clock enable
      CECEN     : Boolean := False; -- HDMI-CEC clock enable
      PWREN     : Boolean := False; -- Power interface clock enable
      DACEN     : Boolean := False; -- DAC interface clock enable
      UART7EN   : Boolean := False; -- UART7 clock enable
      UART8EN   : Boolean := False; -- UART8 clock enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_APB1ENR_Type use record
      TIM2EN    at 0 range  0  .. 0;
      TIM3EN    at 0 range  1  .. 1;
      TIM4EN    at 0 range  2  .. 2;
      TIM5EN    at 0 range  3  .. 3;
      TIM6EN    at 0 range  4  .. 4;
      TIM7EN    at 0 range  5  .. 5;
      TIM12EN   at 0 range  6  .. 6;
      TIM13EN   at 0 range  7  .. 7;
      TIM14EN   at 0 range  8  .. 8;
      LPTMI1EN  at 0 range  9  .. 9;
      RTCAPBEN  at 0 range 10 .. 10;
      WWDGEN    at 0 range 11 .. 11;
      Reserved  at 0 range 12 .. 12;
      CAN3EN    at 0 range 13 .. 13;
      SPI2EN    at 0 range 14 .. 14;
      SPI3EN    at 0 range 15 .. 15;
      SPDIFRXEN at 0 range 16 .. 16;
      USART2EN  at 0 range 17 .. 17;
      USART3EN  at 0 range 18 .. 18;
      UART4EN   at 0 range 19 .. 19;
      UART5EN   at 0 range 20 .. 20;
      I2C1EN    at 0 range 21 .. 21;
      I2C2EN    at 0 range 22 .. 22;
      I2C3EN    at 0 range 23 .. 23;
      I2C4EN    at 0 range 24 .. 24;
      CAN1EN    at 0 range 25 .. 25;
      CAN2EN    at 0 range 26 .. 26;
      CECEN     at 0 range 27 .. 27;
      PWREN     at 0 range 28 .. 28;
      DACEN     at 0 range 29 .. 29;
      UART7EN   at 0 range 30 .. 30;
      UART8EN   at 0 range 31 .. 31;
   end record;

   RCC_APB1ENR_ADDRESS : constant := 16#4002_3840#;

   RCC_APB1ENR : aliased RCC_APB1ENR_Type
      with Address              => System'To_Address (RCC_APB1ENR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.14 RCC APB2 peripheral clock enable register (RCC_APB2ENR)

   type RCC_APB2ENR_Type is record
      TIM1EN    : Boolean := False; -- TIM1 clock enable
      TIM8EN    : Boolean := False; -- TIM8 clock enable
      Reserved1 : Bits_2  := 0;
      USART1EN  : Boolean := False; -- USART1 clock enable
      USART6EN  : Boolean := False; -- USART6 clock enable
      Reserved2 : Bits_1  := 0;
      SDMMC2EN  : Boolean := False; -- SDMMC2 clock enable
      ADC1EN    : Boolean := False; -- ADC1 clock enable
      ADC2EN    : Boolean := False; -- ADC2 clock enable
      ADC3EN    : Boolean := False; -- ADC3 clock enable
      SDMMC1EN  : Boolean := False; -- SDMMC1 clock enable
      SPI1EN    : Boolean := False; -- SPI1 clock enable
      SPI4EN    : Boolean := False; -- SPI4 clock enable
      SYSCFGEN  : Boolean := False; -- System configuration controller clock enable
      Reserved3 : Bits_1  := 0;
      TIM9EN    : Boolean := False; -- TIM9 clock enable
      TIM10EN   : Boolean := False; -- TIM10 clock enable
      TIM11EN   : Boolean := False; -- TIM11 clock enable
      Reserved4 : Bits_1  := 0;
      SPI5EN    : Boolean := False; -- SPI5 clock enable
      SPI6EN    : Boolean := False; -- SPI6 clock enable
      SAI1EN    : Boolean := False; -- SAI1 clock enable
      SAI2EN    : Boolean := False; -- SAI2 clock enable
      Reserved5 : Bits_2  := 0;
      LTDCEN    : Boolean := False; -- LTDC clock enable
      DSIEN     : Boolean := False; -- DSIHOST clock enable
      Reserved6 : Bits_1  := 0;
      DFSDM1EN  : Boolean := False; -- DFSDM1 clock enable
      MDIOEN    : Boolean := False; -- MDIO clock enable
      Reserved7 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_APB2ENR_Type use record
      TIM1EN    at 0 range  0 ..  0;
      TIM8EN    at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  3;
      USART1EN  at 0 range  4 ..  4;
      USART6EN  at 0 range  5 ..  5;
      Reserved2 at 0 range  6 ..  6;
      SDMMC2EN  at 0 range  7 ..  7;
      ADC1EN    at 0 range  8 ..  8;
      ADC2EN    at 0 range  9 ..  9;
      ADC3EN    at 0 range 10 .. 10;
      SDMMC1EN  at 0 range 11 .. 11;
      SPI1EN    at 0 range 12 .. 12;
      SPI4EN    at 0 range 13 .. 13;
      SYSCFGEN  at 0 range 14 .. 14;
      Reserved3 at 0 range 15 .. 15;
      TIM9EN    at 0 range 16 .. 16;
      TIM10EN   at 0 range 17 .. 17;
      TIM11EN   at 0 range 18 .. 18;
      Reserved4 at 0 range 19 .. 19;
      SPI5EN    at 0 range 20 .. 20;
      SPI6EN    at 0 range 21 .. 21;
      SAI1EN    at 0 range 22 .. 22;
      SAI2EN    at 0 range 23 .. 23;
      Reserved5 at 0 range 24 .. 25;
      LTDCEN    at 0 range 26 .. 26;
      DSIEN     at 0 range 27 .. 27;
      Reserved6 at 0 range 28 .. 28;
      DFSDM1EN  at 0 range 29 .. 29;
      MDIOEN    at 0 range 30 .. 30;
      Reserved7 at 0 range 31 .. 31;
   end record;

   RCC_APB2ENR_ADDRESS : constant := 16#4002_3844#;

   RCC_APB2ENR : aliased RCC_APB2ENR_Type
      with Address              => System'To_Address (RCC_APB2ENR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.15 RCC AHB1 peripheral clock enable in low-power mode register (RCC_AHB1LPENR)

   type RCC_AHB1LPENR_Type is record
      GPIOALPEN     : Boolean := True; -- IO port A clock enable during sleep mode
      GPIOBLPEN     : Boolean := True; -- IO port B clock enable during Sleep mode
      GPIOCLPEN     : Boolean := True; -- IO port C clock enable during Sleep mode
      GPIODLPEN     : Boolean := True; -- IO port D clock enable during Sleep mode
      GPIOELPEN     : Boolean := True; -- IO port E clock enable during Sleep mode
      GPIOFLPEN     : Boolean := True; -- IO port F clock enable during Sleep mode
      GPIOGLPEN     : Boolean := True; -- IO port G clock enable during Sleep mode
      GPIOHLPEN     : Boolean := True; -- IO port H clock enable during Sleep mode
      GPIOILPEN     : Boolean := True; -- IO port I clock enable during Sleep mode
      GPIOJLPEN     : Boolean := True; -- IO port J clock enable during Sleep mode
      GPIOKLPEN     : Boolean := True; -- IO port K clock enable during Sleep mode
      Reserved1     : Bits_1  := 0;
      CRCLPEN       : Boolean := True; -- CRC clock enable during Sleep mode
      AXILPEN       : Boolean := True; -- AXI to AHB bridge clock enable during Sleep mode
      Reserved2     : Bits_1  := 0;
      FLITFLPEN     : Boolean := True; -- Flash interface clock enable during Sleep mode
      SRAM1LPEN     : Boolean := True; -- SRAM1 interface clock enable during Sleep mode
      SRAM2LPEN     : Boolean := True; -- SRAM2 interface clock enable during Sleep mode
      BKPSRAMLPEN   : Boolean := True; -- Backup SRAM interface clock enable during Sleep mode
      Reserved3     : Bits_1  := 0;
      DTCMLPEN      : Boolean := True; -- DTCM RAM interface clock enable during Sleep mode
      DMA1LPEN      : Boolean := True; -- DMA1 clock enable during Sleep mode
      DMA2LPEN      : Boolean := True; -- DMA2 clock enable during Sleep mode
      DMA2DLPEN     : Boolean := True; -- DMA2D clock enable during Sleep mode
      Reserved4     : Bits_1  := 0;
      ETHMACLPEN    : Boolean := True; -- Ethernet MAC clock enable during Sleep mode
      ETHMACTXLPEN  : Boolean := True; -- Ethernet transmission clock enable during Sleep mode
      ETHMACRXLPEN  : Boolean := True; -- Ethernet reception clock enable during Sleep mode
      ETHMACPTPLPEN : Boolean := True; -- Ethernet PTP clock enable during Sleep mode
      OTGHSLPEN     : Boolean := True; -- USB OTG HS clock enable during Sleep mode
      OTGHSULPILPEN : Boolean := True; -- USB OTG HS ULPI clock enable during Sleep mode
      Reserved5     : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_AHB1LPENR_Type use record
      GPIOALPEN     at 0 range  0 ..  0;
      GPIOBLPEN     at 0 range  1 ..  1;
      GPIOCLPEN     at 0 range  2 ..  2;
      GPIODLPEN     at 0 range  3 ..  3;
      GPIOELPEN     at 0 range  4 ..  4;
      GPIOFLPEN     at 0 range  5 ..  5;
      GPIOGLPEN     at 0 range  6 ..  6;
      GPIOHLPEN     at 0 range  7 ..  7;
      GPIOILPEN     at 0 range  8 ..  8;
      GPIOJLPEN     at 0 range  9 ..  9;
      GPIOKLPEN     at 0 range 10 .. 10;
      Reserved1     at 0 range 11 .. 11;
      CRCLPEN       at 0 range 12 .. 12;
      AXILPEN       at 0 range 13 .. 13;
      Reserved2     at 0 range 14 .. 14;
      FLITFLPEN     at 0 range 15 .. 15;
      SRAM1LPEN     at 0 range 16 .. 16;
      SRAM2LPEN     at 0 range 17 .. 17;
      BKPSRAMLPEN   at 0 range 18 .. 18;
      Reserved3     at 0 range 19 .. 19;
      DTCMLPEN      at 0 range 20 .. 20;
      DMA1LPEN      at 0 range 21 .. 21;
      DMA2LPEN      at 0 range 22 .. 22;
      DMA2DLPEN     at 0 range 23 .. 23;
      Reserved4     at 0 range 24 .. 24;
      ETHMACLPEN    at 0 range 25 .. 25;
      ETHMACTXLPEN  at 0 range 26 .. 26;
      ETHMACRXLPEN  at 0 range 27 .. 27;
      ETHMACPTPLPEN at 0 range 28 .. 28;
      OTGHSLPEN     at 0 range 29 .. 29;
      OTGHSULPILPEN at 0 range 30 .. 30;
      Reserved5     at 0 range 31 .. 31;
   end record;

   RCC_AHB1LPENR_ADDRESS : constant := 16#4002_3850#;

   RCC_AHB1LPENR : aliased RCC_AHB1LPENR_Type
      with Address              => System'To_Address (RCC_AHB1LPENR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.16 RCC AHB2 peripheral clock enable in low-power mode register (RCC_AHB2LPENR)

   type RCC_AHB2LPENR_Type is record
      DCMILPEN  : Boolean := True; -- Camera interface enable during Sleep mode
      JPEGLPEN  : Boolean := True; -- JPEG module enabled during Sleep mode
      Reserved1 : Bits_2  := 0;
      CRYPLPEN  : Boolean := True; -- Cryptography modules clock enable during Sleep mode
      HASHLPEN  : Boolean := True; -- Hash modules clock enable during Sleep mode
      RNGLPEN   : Boolean := True; -- Random number generator clock enable during Sleep mode
      OTGFSLPEN : Boolean := True; -- USB OTG FS clock enable during Sleep mode
      Reserved2 : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_AHB2LPENR_Type use record
      DCMILPEN  at 0 range 0 ..  0;
      JPEGLPEN  at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  3;
      CRYPLPEN  at 0 range 4 ..  4;
      HASHLPEN  at 0 range 5 ..  5;
      RNGLPEN   at 0 range 6 ..  6;
      OTGFSLPEN at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   RCC_AHB2LPENR_ADDRESS : constant := 16#4002_3854#;

   RCC_AHB2LPENR : aliased RCC_AHB2LPENR_Type
      with Address              => System'To_Address (RCC_AHB2LPENR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.17 RCC AHB3 peripheral clock enable in low-power mode register (RCC_AHB3LPENR)

   type RCC_AHB3LPENR_Type is record
      FMCLPEN  : Boolean := True; -- Flexible memory controller module clock enable during Sleep mode
      QSPILPEN : Boolean := True; -- QUADSPI memory controller clock enable during Sleep mode
      Reserved : Bits_30 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_AHB3LPENR_Type use record
      FMCLPEN  at 0 range 0 ..  0;
      QSPILPEN at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   RCC_AHB3LPENR_ADDRESS : constant := 16#4002_3858#;

   RCC_AHB3LPENR : aliased RCC_AHB3LPENR_Type
      with Address              => System'To_Address (RCC_AHB3LPENR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.18 RCC APB1 peripheral clock enable in low-power mode register (RCC_APB1LPENR)

   type RCC_APB1LPENR_Type is record
      TIM2LPEN    : Boolean := True; -- TIM2 clock enable during Sleep mode
      TIM3LPEN    : Boolean := True; -- TIM3 clock enable during Sleep mode
      TIM4LPEN    : Boolean := True; -- TIM4 clock enable during Sleep mode
      TIM5LPEN    : Boolean := True; -- TIM5 clock enable during Sleep mode
      TIM6LPEN    : Boolean := True; -- TIM6 clock enable during Sleep mode
      TIM7LPEN    : Boolean := True; -- TIM7 clock enable during Sleep mode
      TIM12LPEN   : Boolean := True; -- TIM12 clock enable during Sleep mode
      TIM13LPEN   : Boolean := True; -- TIM13 clock enable during Sleep mode
      TIM14LPEN   : Boolean := True; -- TIM14 clock enable during Sleep mode
      LPTIM1LPEN  : Boolean := True; -- low-power timer 1 clock enable during Sleep mode
      RTCAPBLPEN  : Boolean := True; -- RTC register interface clock enable during Sleep mode
      WWDGLPEN    : Boolean := True; -- Window watchdog clock enable during Sleep mode
      Reserved    : Bits_1  := 0;
      CAN3LPEN    : Boolean := True; -- CAN 3 clock enable during Sleep mode
      SPI2LPEN    : Boolean := True; -- SPI2 clock enable during Sleep mode
      SPI3LPEN    : Boolean := True; -- SPI3 clock enable during Sleep mode
      SPDIFRXLPEN : Boolean := True; -- SPDIFRX clock enable during Sleep mode
      USART2LPEN  : Boolean := True; -- USART2 clock enable during Sleep mode
      USART3LPEN  : Boolean := True; -- USART3 clock enable during Sleep mode
      UART4LPEN   : Boolean := True; -- UART4 clock enable during Sleep mode
      UART5LPEN   : Boolean := True; -- UART5 clock enable during Sleep mode
      I2C1LPEN    : Boolean := True; -- I2C1 clock enable during Sleep mode
      I2C2LPEN    : Boolean := True; -- I2C2 clock enable during Sleep mode
      I2C3LPEN    : Boolean := True; -- I2C3 clock enable during Sleep mode
      I2C4LPEN    : Boolean := True; -- I2C4 clock enable during Sleep mode
      CAN1LPEN    : Boolean := True; -- CAN 1 clock enable during Sleep mode
      CAN2LPEN    : Boolean := True; -- CAN 2 clock enable during Sleep mode
      CECLPEN     : Boolean := True; -- HDMI-CEC clock enable during Sleep mode
      PWRLPEN     : Boolean := True; -- Power interface clock enable during Sleep mode
      DACLPEN     : Boolean := True; -- DAC interface clock enable during Sleep mode
      UART7LPEN   : Boolean := True; -- UART7 clock enable during Sleep mode
      UART8LPEN   : Boolean := True; -- UART8 clock enable during Sleep mode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_APB1LPENR_Type use record
      TIM2LPEN    at 0 range  0 ..  0;
      TIM3LPEN    at 0 range  1 ..  1;
      TIM4LPEN    at 0 range  2 ..  2;
      TIM5LPEN    at 0 range  3 ..  3;
      TIM6LPEN    at 0 range  4 ..  4;
      TIM7LPEN    at 0 range  5 ..  5;
      TIM12LPEN   at 0 range  6 ..  6;
      TIM13LPEN   at 0 range  7 ..  7;
      TIM14LPEN   at 0 range  8 ..  8;
      LPTIM1LPEN  at 0 range  9 ..  9;
      RTCAPBLPEN  at 0 range 10 .. 10;
      WWDGLPEN    at 0 range 11 .. 11;
      Reserved    at 0 range 12 .. 12;
      CAN3LPEN    at 0 range 13 .. 13;
      SPI2LPEN    at 0 range 14 .. 14;
      SPI3LPEN    at 0 range 15 .. 15;
      SPDIFRXLPEN at 0 range 16 .. 16;
      USART2LPEN  at 0 range 17 .. 17;
      USART3LPEN  at 0 range 18 .. 18;
      UART4LPEN   at 0 range 19 .. 19;
      UART5LPEN   at 0 range 20 .. 20;
      I2C1LPEN    at 0 range 21 .. 21;
      I2C2LPEN    at 0 range 22 .. 22;
      I2C3LPEN    at 0 range 23 .. 23;
      I2C4LPEN    at 0 range 24 .. 24;
      CAN1LPEN    at 0 range 25 .. 25;
      CAN2LPEN    at 0 range 26 .. 26;
      CECLPEN     at 0 range 27 .. 27;
      PWRLPEN     at 0 range 28 .. 28;
      DACLPEN     at 0 range 29 .. 29;
      UART7LPEN   at 0 range 30 .. 30;
      UART8LPEN   at 0 range 31 .. 31;
   end record;

   RCC_APB1LPENR_ADDRESS : constant := 16#4002_3860#;

   RCC_APB1LPENR : aliased RCC_APB1LPENR_Type
      with Address              => System'To_Address (RCC_APB1LPENR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.19 RCC APB2 peripheral clock enabled in low-power mode register (RCC_APB2LPENR)

   type RCC_APB2LPENR_Type is record
      TIM1LPEN   : Boolean := True;  -- TIM1 clock enable during Sleep mode
      TIM8LPEN   : Boolean := True;  -- TIM8 clock enable during Sleep mode
      Reserved1  : Bits_2  := 0;
      USART1LPEN : Boolean := True;  -- USART1 clock enable during Sleep mode
      USART6LPEN : Boolean := True;  -- USART6 clock enable during Sleep mode
      Reserved2  : Bits_1  := 0;
      SDMMC2LPEN : Boolean := True;  -- SDMMC2 clock enable during Sleep mode
      ADC1LPEN   : Boolean := True;  -- ADC1 clock enable during Sleep mode
      ADC2LPEN   : Boolean := True;  -- ADC2 clock enable during Sleep mode
      ADC3LPEN   : Boolean := True;  -- ADC 3 clock enable during Sleep mode
      SDMMC1LPEN : Boolean := True;  -- SDMMC1 clock enable during Sleep mode
      SPI1LPEN   : Boolean := True;  -- SPI1 clock enable during Sleep mode
      SPI4LPEN   : Boolean := True;  -- SPI4 clock enable during Sleep mode
      SYSCFGLPEN : Boolean := True;  -- System configuration controller clock enable during Sleep mode
      Reserved3  : Bits_1  := 0;
      TIM9LPEN   : Boolean := True;  -- TIM9 clock enable during sleep mode
      TIM10LPEN  : Boolean := True;  -- TIM10 clock enable during Sleep mode
      TIM11LPEN  : Boolean := True;  -- TIM11 clock enable during Sleep mode
      Reserved4  : Bits_1  := 0;
      SPI5LPEN   : Boolean := True;  -- SPI5 clock enable during Sleep mode
      SPI6LPEN   : Boolean := True;  -- SPI6 clock enable during Sleep mode
      SAI1LPEN   : Boolean := True;  -- SAI1 clock enable during Sleep mode
      SAI2LPEN   : Boolean := True;  -- SAI2 clock enable during Sleep mode
      Reserved5  : Bits_2  := 2#10#;
      LTDCLPEN   : Boolean := True;  -- LTDC clock enable during Sleep mode
      DSILPEN    : Boolean := False; -- DSIHOST clock enable during Sleep mode
      Reserved6  : Bits_1  := 0;
      DFSDM1LPEN : Boolean := False; -- DFSDM1 clock enable during Sleep mode
      MDIOLPEN   : Boolean := False; -- MDIO clock enable during Sleep mode
      Reserved7  : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_APB2LPENR_Type use record
      TIM1LPEN   at 0 range  0 ..  0;
      TIM8LPEN   at 0 range  1 ..  1;
      Reserved1  at 0 range  2 ..  3;
      USART1LPEN at 0 range  4 ..  4;
      USART6LPEN at 0 range  5 ..  5;
      Reserved2  at 0 range  6 ..  6;
      SDMMC2LPEN at 0 range  7 ..  7;
      ADC1LPEN   at 0 range  8 ..  8;
      ADC2LPEN   at 0 range  9 ..  9;
      ADC3LPEN   at 0 range 10 .. 10;
      SDMMC1LPEN at 0 range 11 .. 11;
      SPI1LPEN   at 0 range 12 .. 12;
      SPI4LPEN   at 0 range 13 .. 13;
      SYSCFGLPEN at 0 range 14 .. 14;
      Reserved3  at 0 range 15 .. 15;
      TIM9LPEN   at 0 range 16 .. 16;
      TIM10LPEN  at 0 range 17 .. 17;
      TIM11LPEN  at 0 range 18 .. 18;
      Reserved4  at 0 range 19 .. 19;
      SPI5LPEN   at 0 range 20 .. 20;
      SPI6LPEN   at 0 range 21 .. 21;
      SAI1LPEN   at 0 range 22 .. 22;
      SAI2LPEN   at 0 range 23 .. 23;
      Reserved5  at 0 range 24 .. 25;
      LTDCLPEN   at 0 range 26 .. 26;
      DSILPEN    at 0 range 27 .. 27;
      Reserved6  at 0 range 28 .. 28;
      DFSDM1LPEN at 0 range 29 .. 29;
      MDIOLPEN   at 0 range 30 .. 30;
      Reserved7  at 0 range 31 .. 31;
   end record;

   RCC_APB2LPENR_ADDRESS : constant := 16#4002_3864#;

   RCC_APB2LPENR : aliased RCC_APB2LPENR_Type
      with Address              => System'To_Address (RCC_APB2LPENR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.20 RCC backup domain control register (RCC_BDCR)

   LSEDRV_LOW     : constant := 2#00#; -- Low driving capability
   LSEDRV_MEDHIGH : constant := 2#01#; -- Medium high driving capability
   LSEDRV_MEDLOW  : constant := 2#10#; -- Medium low driving capability
   LSEDRV_HIGH    : constant := 2#11#; -- High driving capability

   RTCSEL_NONE : constant := 2#00#; -- No clock
   RTCSEL_LSE  : constant := 2#01#; -- LSE oscillator clock used as the RTC clock
   RTCSEL_LSI  : constant := 2#10#; -- LSI oscillator clock used as the RTC clock
   RTCSEL_HSE  : constant := 2#11#; -- HSE oscillator clock divided by a programmable prescaler ...

   type RCC_BDCR_Type is record
      LSEON      : Boolean := False;       -- External low-speed oscillator enable
      LSERDY     : Boolean := False;       -- External low-speed oscillator ready
      LSEBYP     : Boolean := False;       -- External low-speed oscillator bypass
      LSEDRV     : Bits_2  := LSEDRV_LOW ; -- LSE oscillator drive capability
      Reserved1  : Bits_3  := 0;
      RTCSEL     : Bits_2  := RTCSEL_NONE; -- RTC clock source selection
      Reserved2  : Bits_5  := 0;
      RTCEN      : Boolean := False;       -- RTC clock enable
      BDRST      : Boolean := False;       -- Backup domain software reset
      Reserved3  : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_BDCR_Type use record
      LSEON      at 0 range  0 ..  0;
      LSERDY     at 0 range  1 ..  1;
      LSEBYP     at 0 range  2 ..  2;
      LSEDRV     at 0 range  3 ..  4;
      Reserved1  at 0 range  5 ..  7;
      RTCSEL     at 0 range  8 ..  9;
      Reserved2  at 0 range 10 .. 14;
      RTCEN      at 0 range 15 .. 15;
      BDRST      at 0 range 16 .. 16;
      Reserved3  at 0 range 17 .. 31;
   end record;

   RCC_BDCR_ADDRESS : constant := 16#4002_3870#;

   RCC_BDCR : aliased RCC_BDCR_Type
      with Address              => System'To_Address (RCC_BDCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.21 RCC clock control & status register (RCC_CSR)

   type RCC_CSR_Type is record
      LSION    : Boolean := False; -- Internal low-speed oscillator enable
      LSIRDY   : Boolean := False; -- Internal low-speed oscillator ready
      Reserved : Bits_22 := 0;
      RMVF     : Boolean := False; -- Remove reset flag
      BORRSTF  : Boolean := True;  -- BOR reset flag
      PINRSTF  : Boolean := True;  -- PIN reset flag
      PORRSTF  : Boolean := True;  -- POR/PDR reset flag
      SFTRSTF  : Boolean := False; -- Software reset flag
      IWDGRSTF : Boolean := False; -- Independent watchdog reset flag
      WWDGRSTF : Boolean := False; -- Window watchdog reset flag
      LPWRRSTF : Boolean := False; -- Low-power reset flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_CSR_Type use record
      LSION    at 0 range  0 ..  0;
      LSIRDY   at 0 range  1 ..  1;
      Reserved at 0 range  2 .. 23;
      RMVF     at 0 range 24 .. 24;
      BORRSTF  at 0 range 25 .. 25;
      PINRSTF  at 0 range 26 .. 26;
      PORRSTF  at 0 range 27 .. 27;
      SFTRSTF  at 0 range 28 .. 28;
      IWDGRSTF at 0 range 29 .. 29;
      WWDGRSTF at 0 range 30 .. 30;
      LPWRRSTF at 0 range 31 .. 31;
   end record;

   RCC_CSR_ADDRESS : constant := 16#4002_3874#;

   RCC_CSR : aliased RCC_CSR_Type
      with Address              => System'To_Address (RCC_CSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.22 RCC spread spectrum clock generation register (RCC_SSCGR)

   SPREADSEL_CENTER : constant := 0; -- Center spread
   SPREADSEL_DOWN   : constant := 1; -- Down spread

   type RCC_SSCGR_Type is record
      MODPER    : Bits_13 := 0;                -- Modulation period
      INCSTEP   : Bits_15 := 0;                -- Incrementation step
      Reserved  : Bits_2  := 0;
      SPREADSEL : Bits_1  := SPREADSEL_CENTER; -- Spread Select
      SSCGEN    : Boolean := False;            -- Spread spectrum modulation enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_SSCGR_Type use record
      MODPER    at 0 range  0 .. 12;
      INCSTEP   at 0 range 13 .. 27;
      Reserved  at 0 range 28 .. 29;
      SPREADSEL at 0 range 30 .. 30;
      SSCGEN    at 0 range 31 .. 31;
   end record;

   RCC_SSCGR_ADDRESS : constant := 16#4002_3880#;

   RCC_SSCGR : aliased RCC_SSCGR_Type
      with Address              => System'To_Address (RCC_SSCGR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.23 RCC PLLI2S configuration register (RCC_PLLI2SCFGR)

   PLLI2SP_DIV2 : constant := 2#00#;
   PLLI2SP_DIV4 : constant := 2#01#;
   PLLI2SP_DIV6 : constant := 2#10#;
   PLLI2SP_DIV8 : constant := 2#11#;

   PLLI2SQ_DIV2  : constant := 2;
   PLLI2SQ_DIV3  : constant := 3;
   PLLI2SQ_DIV4  : constant := 4;
   PLLI2SQ_DIV5  : constant := 5;
   PLLI2SQ_DIV6  : constant := 6;
   PLLI2SQ_DIV7  : constant := 7;
   PLLI2SQ_DIV8  : constant := 8;
   PLLI2SQ_DIV9  : constant := 9;
   PLLI2SQ_DIV10 : constant := 10;
   PLLI2SQ_DIV11 : constant := 11;
   PLLI2SQ_DIV12 : constant := 12;
   PLLI2SQ_DIV13 : constant := 13;
   PLLI2SQ_DIV14 : constant := 14;
   PLLI2SQ_DIV15 : constant := 15;

   PLLI2SR_DIV2 : constant := 2;
   PLLI2SR_DIV3 : constant := 3;
   PLLI2SR_DIV4 : constant := 4;
   PLLI2SR_DIV5 : constant := 5;
   PLLI2SR_DIV6 : constant := 6;
   PLLI2SR_DIV7 : constant := 7;

   type RCC_PLLI2SCFGR_Type is record
      Reserved1 : Bits_6                 := 0;
      PLLI2SN   : Bits_9 range 50 .. 432 := 192;          -- PLLI2S multiplication factor for VCO
      Reserved2 : Bits_1                 := 0;
      PLLI2SP   : Bits_2                 := PLLI2SP_DIV2; -- PLLI2S division factor for SPDIFRX clock
      Reserved3 : Bits_6                 := 0;
      PLLI2SQ   : Bits_4 range 2 .. 15   := PLLI2SQ_DIV4; -- PLLI2S division factor for SAIs clock
      PLLI2SR   : Bits_3 range 2 .. 7    := PLLI2SR_DIV2; -- PLLI2S division factor for I2S clocks
      Reserved4 : Bits_1                 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_PLLI2SCFGR_Type use record
      Reserved1 at 0 range  0 ..  5;
      PLLI2SN   at 0 range  6 .. 14;
      Reserved2 at 0 range 15 .. 15;
      PLLI2SP   at 0 range 16 .. 17;
      Reserved3 at 0 range 18 .. 23;
      PLLI2SQ   at 0 range 24 .. 27;
      PLLI2SR   at 0 range 28 .. 30;
      Reserved4 at 0 range 31 .. 31;
   end record;

   RCC_PLLI2SCFGR_ADDRESS : constant := 16#4002_3884#;

   RCC_PLLI2SCFGR : aliased RCC_PLLI2SCFGR_Type
      with Address              => System'To_Address (RCC_PLLI2SCFGR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.24 RCC PLLSAI configuration register (RCC_PLLSAICFGR)

   PLLSAIP_DIV2 : constant := 2#00#;
   PLLSAIP_DIV4 : constant := 2#01#;
   PLLSAIP_DIV6 : constant := 2#10#;
   PLLSAIP_DIV8 : constant := 2#11#;

   PLLSAIQ_DIV2  : constant := 2;
   PLLSAIQ_DIV3  : constant := 3;
   PLLSAIQ_DIV4  : constant := 4;
   PLLSAIQ_DIV5  : constant := 5;
   PLLSAIQ_DIV6  : constant := 6;
   PLLSAIQ_DIV7  : constant := 7;
   PLLSAIQ_DIV8  : constant := 8;
   PLLSAIQ_DIV9  : constant := 9;
   PLLSAIQ_DIV10 : constant := 10;
   PLLSAIQ_DIV11 : constant := 11;
   PLLSAIQ_DIV12 : constant := 12;
   PLLSAIQ_DIV13 : constant := 13;
   PLLSAIQ_DIV14 : constant := 14;
   PLLSAIQ_DIV15 : constant := 15;

   PLLSAIR_DIV2 : constant := 2;
   PLLSAIR_DIV3 : constant := 3;
   PLLSAIR_DIV4 : constant := 4;
   PLLSAIR_DIV5 : constant := 5;
   PLLSAIR_DIV6 : constant := 6;
   PLLSAIR_DIV7 : constant := 7;

   type RCC_PLLSAICFGR_Type is record
      Reserved1 : Bits_6                 := 0;
      PLLSAIN   : Bits_9 range 50 .. 432 := 192;          -- PLLSAI multiplication factor for VCO
      Reserved2 : Bits_1                 := 0;
      PLLSAIP   : Bits_2                 := PLLSAIP_DIV2; -- PLLSAI division factor for 48MHz clock
      Reserved3 : Bits_6                 := 0;
      PLLSAIQ   : Bits_4 range 2 .. 15   := PLLSAIQ_DIV4; -- PLLSAI division factor for SAI clock
      PLLSAIR   : Bits_3 range 2 .. 7    := PLLSAIR_DIV2; -- PLLSAI division factor for LCD clock
      Reserved4 : Bits_1                 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_PLLSAICFGR_Type use record
      Reserved1 at 0 range  0 ..  5;
      PLLSAIN   at 0 range  6 .. 14;
      Reserved2 at 0 range 15 .. 15;
      PLLSAIP   at 0 range 16 .. 17;
      Reserved3 at 0 range 18 .. 23;
      PLLSAIQ   at 0 range 24 .. 27;
      PLLSAIR   at 0 range 28 .. 30;
      Reserved4 at 0 range 31 .. 31;
   end record;

   RCC_PLLSAICFGR_ADDRESS : constant := 16#4002_3888#;

   RCC_PLLSAICFGR : aliased RCC_PLLSAICFGR_Type
      with Address              => System'To_Address (RCC_PLLSAICFGR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.25 RCC dedicated clocks configuration register (RCC_DCKCFGR1)

   PLLI2SDIVQ_DIV1  : constant := 0;  -- PLLI2SDIVQ = /1
   PLLI2SDIVQ_DIV2  : constant := 1;  -- PLLI2SDIVQ = /2
   PLLI2SDIVQ_DIV3  : constant := 2;  -- PLLI2SDIVQ = /3
   PLLI2SDIVQ_DIV4  : constant := 3;  -- PLLI2SDIVQ = /4
   PLLI2SDIVQ_DIV5  : constant := 4;  -- PLLI2SDIVQ = /5
   PLLI2SDIVQ_DIV6  : constant := 5;  -- ..
   PLLI2SDIVQ_DIV7  : constant := 6;
   PLLI2SDIVQ_DIV8  : constant := 7;
   PLLI2SDIVQ_DIV9  : constant := 8;
   PLLI2SDIVQ_DIV10 : constant := 9;
   PLLI2SDIVQ_DIV11 : constant := 10;
   PLLI2SDIVQ_DIV12 : constant := 11;
   PLLI2SDIVQ_DIV13 : constant := 12;
   PLLI2SDIVQ_DIV14 : constant := 13;
   PLLI2SDIVQ_DIV15 : constant := 14;
   PLLI2SDIVQ_DIV16 : constant := 15;
   PLLI2SDIVQ_DIV17 : constant := 16;
   PLLI2SDIVQ_DIV18 : constant := 17;
   PLLI2SDIVQ_DIV19 : constant := 18;
   PLLI2SDIVQ_DIV20 : constant := 19;
   PLLI2SDIVQ_DIV21 : constant := 20;
   PLLI2SDIVQ_DIV22 : constant := 21;
   PLLI2SDIVQ_DIV23 : constant := 22;
   PLLI2SDIVQ_DIV24 : constant := 23;
   PLLI2SDIVQ_DIV25 : constant := 24;
   PLLI2SDIVQ_DIV26 : constant := 25;
   PLLI2SDIVQ_DIV27 : constant := 26;
   PLLI2SDIVQ_DIV28 : constant := 27;
   PLLI2SDIVQ_DIV29 : constant := 28;
   PLLI2SDIVQ_DIV30 : constant := 29;
   PLLI2SDIVQ_DIV31 : constant := 30;
   PLLI2SDIVQ_DIV32 : constant := 31; -- PLLI2SDIVQ = /32

   PLLSAIDIVQ_DIV1  : constant := 0;  -- PLLSAIDIVQ = /1
   PLLSAIDIVQ_DIV2  : constant := 1;  -- PLLSAIDIVQ = /2
   PLLSAIDIVQ_DIV3  : constant := 2;  -- PLLSAIDIVQ = /3
   PLLSAIDIVQ_DIV4  : constant := 3;  -- PLLSAIDIVQ = /4
   PLLSAIDIVQ_DIV5  : constant := 4;  -- PLLSAIDIVQ = /5
   PLLSAIDIVQ_DIV6  : constant := 5;  -- ..
   PLLSAIDIVQ_DIV7  : constant := 6;
   PLLSAIDIVQ_DIV8  : constant := 7;
   PLLSAIDIVQ_DIV9  : constant := 8;
   PLLSAIDIVQ_DIV10 : constant := 9;
   PLLSAIDIVQ_DIV11 : constant := 10;
   PLLSAIDIVQ_DIV12 : constant := 11;
   PLLSAIDIVQ_DIV13 : constant := 12;
   PLLSAIDIVQ_DIV14 : constant := 13;
   PLLSAIDIVQ_DIV15 : constant := 14;
   PLLSAIDIVQ_DIV16 : constant := 15;
   PLLSAIDIVQ_DIV17 : constant := 16;
   PLLSAIDIVQ_DIV18 : constant := 17;
   PLLSAIDIVQ_DIV19 : constant := 18;
   PLLSAIDIVQ_DIV20 : constant := 19;
   PLLSAIDIVQ_DIV21 : constant := 20;
   PLLSAIDIVQ_DIV22 : constant := 21;
   PLLSAIDIVQ_DIV23 : constant := 22;
   PLLSAIDIVQ_DIV24 : constant := 23;
   PLLSAIDIVQ_DIV25 : constant := 24;
   PLLSAIDIVQ_DIV26 : constant := 25;
   PLLSAIDIVQ_DIV27 : constant := 26;
   PLLSAIDIVQ_DIV28 : constant := 27;
   PLLSAIDIVQ_DIV29 : constant := 28;
   PLLSAIDIVQ_DIV30 : constant := 29;
   PLLSAIDIVQ_DIV31 : constant := 30;
   PLLSAIDIVQ_DIV32 : constant := 31; -- PLLSAIDIVQ = /32

   PLLSAIDIVR_DIV2  : constant := 2#00#; -- PLLSAIDIVR = /2
   PLLSAIDIVR_DIV4  : constant := 2#01#; -- PLLSAIDIVR = /4
   PLLSAIDIVR_DIV8  : constant := 2#10#; -- PLLSAIDIVR = /8
   PLLSAIDIVR_DIV16 : constant := 2#11#; -- PLLSAIDIVR = /16

   SAIxSEL_SAI    : constant := 2#00#; -- SAIx clock frequency = f(PLLSAI_Q) / PLLSAIDIVQ
   SAIxSEL_I2S    : constant := 2#01#; -- SAIx clock frequency = f(PLLI2S_Q) / PLLI2SDIVQ
   SAIxSEL_ALT    : constant := 2#10#; -- SAIx clock frequency = Alternate function input frequency
   SAIxSEL_HSIHSE : constant := 2#11#; -- SAIx clock frequency = HSI or HSE

   TIMPRE_2xPCLKx : constant := 0; -- If the APB prescaler ... 1, TIMxCLK = PCLKx. Otherwise ... TIMxCLK = 2xPCLKx.
   TIMPRE_4xPCLKx : constant := 1; -- If the APB prescaler ... 1, 2 or 4, TIMxCLK = HCLK. Otherwise ... TIMxCLK = 4xPCLKx.

   DFSDM1SEL_APB2   : constant := 0; -- APB2 clock (PCLK2) selected as DFSDM1 Kernel clock source
   DFSDM1SEL_SYSCLK : constant := 1; -- System clock (SYSCLK) clock selected as DFSDM1 Kernel clock source

   ADFSDM1SEL_SAI1 : constant := 0; -- SAI1 clock selected as DFSDM1 Audio clock source
   ADFSDM1SEL_SAI2 : constant := 1; -- SAI2 clock selected as DFSDM1 Audio clock source

   type RCC_DCKCFGR1_Type is record
      PLLI2SDIVQ : Bits_5 := PLLI2SDIVQ_DIV1; -- PLLI2S division factor for SAI1 clock
      Reserved1  : Bits_3 := 0;
      PLLSAIDIVQ : Bits_5 := PLLSAIDIVQ_DIV1; -- PLLSAI division factor for SAI1 clock
      Reserved2  : Bits_3 := 0;
      PLLSAIDIVR : Bits_2 := PLLSAIDIVR_DIV2; -- division factor for LCD_CLK
      Reserved3  : Bits_2 := 0;
      SAI1SEL    : Bits_2 := SAIxSEL_SAI;     -- SAI1 clock source selection
      SAI2SEL    : Bits_2 := SAIxSEL_SAI;     -- SAI2 clock source selection:
      TIMPRE     : Bits_1 := TIMPRE_2xPCLKx;  -- Timers clocks prescalers selection
      DFSDM1SEL  : Bits_1 := DFSDM1SEL_APB2;  -- DFSDM1 clock source selection:
      ADFSDM1SEL : Bits_1 := ADFSDM1SEL_SAI1; -- DFSDM1 AUDIO clock source selection:
      Reserved4  : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_DCKCFGR1_Type use record
      PLLI2SDIVQ at 0 range  0 ..  4;
      Reserved1  at 0 range  5 ..  7;
      PLLSAIDIVQ at 0 range  8 .. 12;
      Reserved2  at 0 range 13 .. 15;
      PLLSAIDIVR at 0 range 16 .. 17;
      Reserved3  at 0 range 18 .. 19;
      SAI1SEL    at 0 range 20 .. 21;
      SAI2SEL    at 0 range 22 .. 23;
      TIMPRE     at 0 range 24 .. 24;
      DFSDM1SEL  at 0 range 25 .. 25;
      ADFSDM1SEL at 0 range 26 .. 26;
      Reserved4  at 0 range 27 .. 31;
   end record;

   RCC_DCKCFGR1_ADDRESS : constant := 16#4002_388C#;

   RCC_DCKCFGR1 : aliased RCC_DCKCFGR1_Type
      with Address              => System'To_Address (RCC_DCKCFGR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.26 RCC dedicated clocks configuration register (RCC_DCKCFGR2)

   USART1SEL_APB2 : constant := 2#00#; -- APB2 clock (PCLK2) is selected as USART 1 clock
   USART1SEL_SYS  : constant := 2#01#; -- System clock is selected as USART 1 clock
   USART1SEL_HSI  : constant := 2#10#; -- HSI clock is selected as USART 1 clock
   USART1SEL_LSE  : constant := 2#11#; -- LSE clock is selected as USART 1 clock

   USART2SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as USART 2 clock
   USART2SEL_SYS  : constant := 2#01#; -- System clock is selected as USART 2 clock
   USART2SEL_HSI  : constant := 2#10#; -- HSI clock is selected as USART 2 clock
   USART2SEL_LSE  : constant := 2#11#; -- LSE clock is selected as USART 2 clock

   USART3SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as USART 3 clock
   USART3SEL_SYS  : constant := 2#01#; -- System clock is selected as USART 3 clock
   USART3SEL_HSI  : constant := 2#10#; -- HSI clock is selected as USART 3 clock
   USART3SEL_LSE  : constant := 2#11#; -- LSE clock is selected as USART 3 clock

   UART4SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as UART 4 clock
   UART4SEL_SYS  : constant := 2#01#; -- System clock is selected as UART 4 clock
   UART4SEL_HSI  : constant := 2#10#; -- HSI clock is selected as UART 4 clock
   UART4SEL_LSE  : constant := 2#11#; -- LSE clock is selected as UART 4 clock

   UART5SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as UART 5 clock
   UART5SEL_SYS  : constant := 2#01#; -- System clock is selected as UART 5 clock
   UART5SEL_HSI  : constant := 2#10#; -- HSI clock is selected as UART 5 clock
   UART5SEL_LSE  : constant := 2#11#; -- LSE clock is selected as UART 5 clock

   USART6SEL_APB2 : constant := 2#00#; -- APB2 clock (PCLK2) is selected as USART 6 clock
   USART6SEL_SYS  : constant := 2#01#; -- System clock is selected as USART 6 clock
   USART6SEL_HSI  : constant := 2#10#; -- HSI clock is selected as USART 6 clock
   USART6SEL_LSE  : constant := 2#11#; -- LSE clock is selected as USART 6 clock

   UART7SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as UART 7 clock
   UART7SEL_SYS  : constant := 2#01#; -- System clock is selected as UART 7 clock
   UART7SEL_HSI  : constant := 2#10#; -- HSI clock is selected as UART 7 clock
   UART7SEL_LSE  : constant := 2#11#; -- LSE clock is selected as UART 7 clock

   UART8SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as UART 8 clock
   UART8SEL_SYS  : constant := 2#01#; -- System clock is selected as UART 8 clock
   UART8SEL_HSI  : constant := 2#10#; -- HSI clock is selected as UART 8 clock
   UART8SEL_LSE  : constant := 2#11#; -- LSE clock is selected as UART 8 clock

   I2CxSEL_APB1 : constant := 2#00#; -- APB clock (PCLK1) is selected as I2Cx clock
   I2CxSEL_SYS  : constant := 2#01#; -- System clock is selected as I2Cx clock
   I2CxSEL_HSI  : constant := 2#10#; -- HSI clock is selected as I2Cx clock

   LPTIM1SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) selected as LPTILM1 clock
   LPTIM1SEL_LSI  : constant := 2#01#; -- LSI clock is selected as LPTILM1 clock
   LPTIM1SEL_HSI  : constant := 2#10#; -- HSI clock is selected as LPTILM1 clock
   LPTIM1SEL_LSE  : constant := 2#11#; -- LSE clock is selected as LPTILM1 clock

   CECSEL_LSE : constant := 0; -- LSE clock is selected as HDMI-CEC clock
   CECSEL_HSI : constant := 1; -- HSI divided by 488 clock is selected as HDMI-CEC clock

   CK48MSEL_PLL    : constant := 0; -- 48MHz clock from PLL is selected
   CK48MSEL_PLLSAI : constant := 1; -- 48MHz clock from PLLSAI is selected.

   SDMMCxSEL_48M : constant := 0; -- 48 MHz clock is selected as SDMMC1 clock
   SDMMCxSEL_SYS : constant := 1; -- System clock is selected as SDMMC1 clock

   DSISEL_DSIPHY : constant := 0; -- DSI-PHY used as DSI byte lane clock source (usual case)
   DSISEL_PLLR   : constant := 1; -- PLLR used as DSI byte lane clock source, used in case DSI PLL and DSI-PHY are off ...

   type RCC_DCKCFGR2_Type is record
      USART1SEL : Bits_2 := USART1SEL_APB2; -- USART 1 clock source selection
      USART2SEL : Bits_2 := USART2SEL_APB1; -- USART 2 clock source selection
      USART3SEL : Bits_2 := USART3SEL_APB1; -- USART 3 clock source selection
      UART4SEL  : Bits_2 := UART4SEL_APB1;  -- UART 4 clock source selection
      UART5SEL  : Bits_2 := UART5SEL_APB1;  -- UART 5 clock source selection
      USART6SEL : Bits_2 := USART6SEL_APB2; -- USART 6 clock source selection
      UART7SEL  : Bits_2 := UART7SEL_APB1;  -- UART 7 clock source selection
      UART8SEL  : Bits_2 := UART8SEL_APB1;  -- UART 8 clock source selection
      I2C1SEL   : Bits_2 := I2CxSEL_APB1;   -- I2C1 clock source selection
      I2C2SEL   : Bits_2 := I2CxSEL_APB1;   -- I2C2 clock source selection
      I2C3SEL   : Bits_2 := I2CxSEL_APB1;   -- I2C3 clock source selection
      I2C4SEL   : Bits_2 := I2CxSEL_APB1;   -- I2C4 clock source selection
      LPTIM1SEL : Bits_2 := LPTIM1SEL_APB1; -- Low-power timer 1 clock source selection
      CECSEL    : Bits_1 := CECSEL_LSE;     -- HDMI-CEC clock source selection
      CK48MSEL  : Bits_1 := CK48MSEL_PLL;   -- 48MHz clock source selection
      SDMMC1SEL : Bits_1 := SDMMCxSEL_48M;  -- SDMMC1 clock source selection
      SDMMC2SEL : Bits_1 := SDMMCxSEL_48M;  -- SDMMC2 clock source selection
      DSISEL    : Bits_1 := DSISEL_DSIPHY;  -- DSI clock source selection
      Reserved  : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RCC_DCKCFGR2_Type use record
      USART1SEL at 0 range  0 ..  1;
      USART2SEL at 0 range  2 ..  3;
      USART3SEL at 0 range  4 ..  5;
      UART4SEL  at 0 range  6 ..  7;
      UART5SEL  at 0 range  8 ..  9;
      USART6SEL at 0 range 10 .. 11;
      UART7SEL  at 0 range 12 .. 13;
      UART8SEL  at 0 range 14 .. 15;
      I2C1SEL   at 0 range 16 .. 17;
      I2C2SEL   at 0 range 18 .. 19;
      I2C3SEL   at 0 range 20 .. 21;
      I2C4SEL   at 0 range 22 .. 23;
      LPTIM1SEL at 0 range 24 .. 25;
      CECSEL    at 0 range 26 .. 26;
      CK48MSEL  at 0 range 27 .. 27;
      SDMMC1SEL at 0 range 28 .. 28;
      SDMMC2SEL at 0 range 29 .. 29;
      DSISEL    at 0 range 30 .. 30;
      Reserved  at 0 range 31 .. 31;
   end record;

   RCC_DCKCFGR2_ADDRESS : constant := 16#4002_3890#;

   RCC_DCKCFGR2 : aliased RCC_DCKCFGR2_Type
      with Address              => System'To_Address (RCC_DCKCFGR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 6 General-purpose I/Os (GPIO)
   ----------------------------------------------------------------------------

   -- 6.4.1 GPIO port mode register (GPIOx_MODER) (x =A..K)

   GPIO_IN  : constant := 2#00#; -- Input mode (reset state)
   GPIO_OUT : constant := 2#01#; -- General purpose output mode
   GPIO_ALT : constant := 2#10#; -- Alternate function mode
   GPIO_ANL : constant := 2#11#; -- Analog mode

   type GPIOx_MODER_Type is array (0 .. 15) of Bits_2
      with Size => 32,
           Pack => True;

   -- 6.4.2 GPIO port output type register (GPIOx_OTYPER) (x = A..K)

   GPIO_PP : constant := 0; -- Output push-pull (reset state)
   GPIO_OD : constant := 1; -- Output open-drain

pragma Warnings (Off);
   type GPIOx_OTYPER_Type is array (0 .. 15) of Bits_1
      with Size => 32,
           Pack => True;
pragma Warnings (On);

   -- 6.4.3 GPIO port output speed register (GPIOx_OSPEEDR) (x = A..K)

   GPIO_LO : constant := 2#00#; -- Low speed
   GPIO_MS : constant := 2#01#; -- Medium speed
   GPIO_HI : constant := 2#10#; -- High speed
   GPIO_VH : constant := 2#11#; -- Very high speed

   type GPIOx_OSPEEDR_Type is array (0 .. 15) of Bits_2
      with Size => 32,
           Pack => True;

   -- 6.4.4 GPIO port pull-up/pull-down register (GPIOx_PUPDR)(x = A..K)

   GPIO_NOPUPD : constant := 2#00#; -- No pull-up, pull-down
   GPIO_PU     : constant := 2#01#; -- Pull-up
   GPIO_PD     : constant := 2#10#; -- Pull-down

   type GPIOx_PUPDR_Type is array (0 .. 15) of Bits_2
      with Size => 32,
           Pack => True;

   -- 6.4.5 GPIO port input data register (GPIOx_IDR) (x = A..K)

pragma Warnings (Off);
   type GPIOx_IDR_Type is array (0 .. 15) of Bits_1
      with Size => 32,
           Pack => True;
pragma Warnings (On);

   -- 6.4.6 GPIO port output data register (GPIOx_ODR) (x = A..K)

pragma Warnings (Off);
   type GPIOx_ODR_Type is array (0 .. 15) of Bits_1
      with Size => 32,
           Pack => True;
pragma Warnings (On);

   -- 6.4.7 GPIO port bit set/reset register (GPIOx_BSRR) (x = A..K)

   type BSRR_SET_Type is array (0 .. 15) of Boolean
      with Size => 16,
           Pack => True;
   type BSRR_RST_Type is array (0 .. 15) of Boolean
      with Size => 16,
           Pack => True;

   type GPIOx_BSRR_Type is record
      SET : BSRR_SET_Type;
      RST : BSRR_RST_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GPIOx_BSRR_Type use record
      SET at 0 range  0 .. 15;
      RST at 0 range 16 .. 31;
   end record;

   -- 6.4.8 GPIO port configuration lock register (GPIOx_LCKR) (x = A..K)

   type LCKy_Type is array (0 .. 15) of Boolean
      with Size => 16,
           Pack => True;

   type GPIOx_LCKR_Type is record
      LCK      : LCKy_Type;      -- Port x lock bit y (y= 0..15)
      LCKK     : Boolean;        -- Lock key
      Reserved : Bits_15   := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GPIOx_LCKR_Type use record
      LCK      at 0 range  0 .. 15;
      LCKK     at 0 range 16 .. 16;
      Reserved at 0 range 17 .. 31;
   end record;

   -- 6.4.9 GPIO alternate function low register (GPIOx_AFRL) (x = A..K)
   -- 6.4.10 GPIO alternate function high register (GPIOx_AFRH) (x = A..J)

   AF0  : constant := 2#0000#;
   AF1  : constant := 2#0001#;
   AF2  : constant := 2#0010#;
   AF3  : constant := 2#0011#;
   AF4  : constant := 2#0100#;
   AF5  : constant := 2#0101#;
   AF6  : constant := 2#0110#;
   AF7  : constant := 2#0111#;
   AF8  : constant := 2#1000#;
   AF9  : constant := 2#1001#;
   AF10 : constant := 2#1010#;
   AF11 : constant := 2#1011#;
   AF12 : constant := 2#1100#;
   AF13 : constant := 2#1101#;
   AF14 : constant := 2#1110#;
   AF15 : constant := 2#1111#;

   type AFRL_Type is array (0 .. 7) of Bits_4
      with Size => 32,
           Pack => True;

   type AFRH_Type is array (8 .. 15) of Bits_4
      with Size => 32,
           Pack => True;

   -- 6.4.11 GPIO register map

   type GPIO_PORT_Type is record
      MODER   : GPIOx_MODER_Type   := [others => GPIO_IN]
         with Volatile_Full_Access => True; -- mode register
      OTYPER  : GPIOx_OTYPER_Type  := [others => GPIO_PP]
         with Volatile_Full_Access => True; -- output type register
      OSPEEDR : GPIOx_OSPEEDR_Type := [others => GPIO_LO]
         with Volatile_Full_Access => True; -- output speed register
      PUPDR   : GPIOx_PUPDR_Type   := [others => GPIO_NOPUPD]
         with Volatile_Full_Access => True; -- pull-up/pull-down register
      IDR     : GPIOx_IDR_Type
         with Volatile_Full_Access => True; -- input data register
      ODR     : GPIOx_ODR_Type
         with Volatile_Full_Access => True; -- output data register
      BSRR    : GPIOx_BSRR_Type    := ([others => False], [others => False])
         with Volatile_Full_Access => True; -- bit set/reset register
      LCKR    : GPIOx_LCKR_Type    := (LCK => [others => False], LCKK => False, others => <>)
         with Volatile_Full_Access => True; -- configuration lock register
      AFRL    : AFRL_Type          := [others => AF0]
         with Volatile_Full_Access => True; -- alternate function low register
      AFRH    : AFRH_Type          := [others => AF0]
         with Volatile_Full_Access => True; -- alternate function high register
   end record
      with Size                    => 16#28# * 8,
           Suppress_Initialization => True;
   for GPIO_PORT_Type use record
      MODER   at 16#00# range 0 .. 31;
      OTYPER  at 16#04# range 0 .. 31;
      OSPEEDR at 16#08# range 0 .. 31;
      PUPDR   at 16#0C# range 0 .. 31;
      IDR     at 16#10# range 0 .. 31;
      ODR     at 16#14# range 0 .. 31;
      BSRR    at 16#18# range 0 .. 31;
      LCKR    at 16#1C# range 0 .. 31;
      AFRL    at 16#20# range 0 .. 31;
      AFRH    at 16#24# range 0 .. 31;
   end record;

   GPIOA_BASEADDRESS : constant := 16#4002_0000#;

   GPIOA : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIOA_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   GPIOB_BASEADDRESS : constant := 16#4002_0400#;

   GPIOB : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIOB_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   GPIOC_BASEADDRESS : constant := 16#4002_0800#;

   GPIOC : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIOC_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   GPIOD_BASEADDRESS : constant := 16#4002_0C00#;

   GPIOD : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIOD_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   GPIOE_BASEADDRESS : constant := 16#4002_1000#;

   GPIOE : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIOE_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   GPIOF_BASEADDRESS : constant := 16#4002_1400#;

   GPIOF : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIOF_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   GPIOG_BASEADDRESS : constant := 16#4002_1800#;

   GPIOG : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIOG_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   GPIOH_BASEADDRESS : constant := 16#4002_1C00#;

   GPIOH : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIOH_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   GPIOI_BASEADDRESS : constant := 16#4002_2000#;

   GPIOI : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIOI_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   GPIOJ_BASEADDRESS : constant := 16#4002_2400#;

   GPIOJ : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIOJ_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   GPIOK_BASEADDRESS : constant := 16#4002_2800#;

   GPIOK : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIOK_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 7 System configuration controller (SYSCFG)
   ----------------------------------------------------------------------------

   -- 7.2.1 SYSCFG memory remap register (SYSCFG_MEMRMP)

   MEM_BOOT_ADD0 : constant := 0; -- Boot memory base address is defined by BOOT_ADD0 option byte
   MEM_BOOT_ADD1 : constant := 1; -- Boot memory base address is defined by BOOT_ADD1 option byte

   SWP_FMC_NONE  : constant := 2#00#; -- No FMC memory mapping swapping
   SWP_FMC_SDRAM : constant := 2#01#; -- NOR/RAM and SDRAM memory mapping swapped

   type SYSCFG_MEMRMP_Type is record
      MEM_BOOT  : Bits_1  := MEM_BOOT_ADD0; -- Memory boot mapping
      Reserved1 : Bits_7  := 0;
      SWP_FB    : Boolean := False;         -- Flash Bank swap
      Reserved2 : Bits_1  := 0;
      SWP_FMC   : Bits_2  := SWP_FMC_NONE;  -- FMC memory mapping swap
      Reserved3 : Bits_20 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYSCFG_MEMRMP_Type use record
      MEM_BOOT  at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      SWP_FB    at 0 range  8 ..  8;
      Reserved2 at 0 range  9 ..  9;
      SWP_FMC   at 0 range 10 .. 11;
      Reserved3 at 0 range 12 .. 31;
   end record;

   SYSCFG_MEMRMP_ADDRESS : constant := 16#4001_3800#;

   SYSCFG_MEMRMP : aliased SYSCFG_MEMRMP_Type
      with Address              => System'To_Address (SYSCFG_MEMRMP_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.2.2 SYSCFG peripheral mode configuration register (SYSCFG_PMC)

   MII_RMII_SEL_MII  : constant := 0; -- MII interface is selected
   MII_RMII_SEL_RMII : constant := 1; -- RMII PHY interface is selected

   type SYSCFG_PMC_Type is record
      I2C1_FMP     : Boolean := False;            -- I2C1_FMP I2C1 Fast Mode + Enable
      I2C2_FMP     : Boolean := False;            -- I2C2_FMP I2C2 Fast Mode + Enable
      I2C3_FMP     : Boolean := False;            -- I2C3_FMP I2C3 Fast Mode + Enable
      I2C4_FMP     : Boolean := False;            -- I2C4_FMP I2C4 Fast Mode + Enable
      PB6_FMP      : Boolean := False;            -- PB6_FMP Fast Mode + Enable
      PB7_FMP      : Boolean := False;            -- PB7_FMP Fast Mode + Enable
      PB8_FMP      : Boolean := False;            -- PB8_FMP Fast Mode + Enable
      PB9_FMP      : Boolean := False;            -- Fast Mode + Enable
      Reserved1    : Bits_8  := 0;
      ADC1DC2      : Boolean := False;            -- ADC accuracy Option 2
      ADC2DC2      : Boolean := False;            -- ADC accuracy Option 2
      ADC3DC2      : Boolean := False;            -- ADC accuracy Option 2
      Reserved2    : Bits_4  := 0;
      MII_RMII_SEL : Bits_1  := MII_RMII_SEL_MII; -- Ethernet PHY interface selection
      Reserved3    : Bits_8  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYSCFG_PMC_Type use record
      I2C1_FMP     at 0 range  0 ..  0;
      I2C2_FMP     at 0 range  1 ..  1;
      I2C3_FMP     at 0 range  2 ..  2;
      I2C4_FMP     at 0 range  3 ..  3;
      PB6_FMP      at 0 range  4 ..  4;
      PB7_FMP      at 0 range  5 ..  5;
      PB8_FMP      at 0 range  6 ..  6;
      PB9_FMP      at 0 range  7 ..  7;
      Reserved1    at 0 range  8 .. 15;
      ADC1DC2      at 0 range 16 .. 16;
      ADC2DC2      at 0 range 17 .. 17;
      ADC3DC2      at 0 range 18 .. 18;
      Reserved2    at 0 range 19 .. 22;
      MII_RMII_SEL at 0 range 23 .. 23;
      Reserved3    at 0 range 24 .. 31;
   end record;

   SYSCFG_PMC_ADDRESS : constant := 16#4001_3804#;

   SYSCFG_PMC : aliased SYSCFG_MEMRMP_Type
      with Address              => System'To_Address (SYSCFG_PMC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- EXTI mapping

   EXTI_PA : constant := 2#0000#; -- PA[x] pin
   EXTI_PB : constant := 2#0001#; -- PB[x] pin
   EXTI_PC : constant := 2#0010#; -- PC[x] pin
   EXTI_PD : constant := 2#0011#; -- PD[x] pin
   EXTI_PE : constant := 2#0100#; -- PE[x] pin
   EXTI_PF : constant := 2#0101#; -- PF[x] pin
   EXTI_PG : constant := 2#0110#; -- PG[x] pin
   EXTI_PH : constant := 2#0111#; -- PH[x] pin
   EXTI_PI : constant := 2#1000#; -- PI[x] pin
   EXTI_PJ : constant := 2#1001#; -- PJ[x] pin
   EXTI_PK : constant := 2#1010#; -- PK[x] pin

   -- 7.2.3 SYSCFG external interrupt configuration register 1 (SYSCFG_EXTICR1)

   type SYSCFG_EXTICR1_Type is record
      EXTI0    : Bits_4  := EXTI_PA; -- EXTI 0 configuration
      EXTI1    : Bits_4  := EXTI_PA; -- EXTI 1 configuration
      EXTI2    : Bits_4  := EXTI_PA; -- EXTI 2 configuration
      EXTI3    : Bits_4  := EXTI_PA; -- EXTI 3 configuration
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYSCFG_EXTICR1_Type use record
      EXTI0    at 0 range  0 ..  3;
      EXTI1    at 0 range  4 ..  7;
      EXTI2    at 0 range  8 .. 11;
      EXTI3    at 0 range 12 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   SYSCFG_EXTICR1_ADDRESS : constant := 16#4001_3808#;

   SYSCFG_EXTICR1 : aliased SYSCFG_EXTICR1_Type
      with Address              => System'To_Address (SYSCFG_EXTICR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.2.4 SYSCFG external interrupt configuration register 2 (SYSCFG_EXTICR2)

   type SYSCFG_EXTICR2_Type is record
      EXTI4    : Bits_4  := EXTI_PA; -- EXTI 4 configuration
      EXTI5    : Bits_4  := EXTI_PA; -- EXTI 5 configuration
      EXTI6    : Bits_4  := EXTI_PA; -- EXTI 6 configuration
      EXTI7    : Bits_4  := EXTI_PA; -- EXTI 7 configuration
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYSCFG_EXTICR2_Type use record
      EXTI4    at 0 range  0 ..  3;
      EXTI5    at 0 range  4 ..  7;
      EXTI6    at 0 range  8 .. 11;
      EXTI7    at 0 range 12 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   SYSCFG_EXTICR2_ADDRESS : constant := 16#4001_380C#;

   SYSCFG_EXTICR2 : aliased SYSCFG_EXTICR2_Type
      with Address              => System'To_Address (SYSCFG_EXTICR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.2.5 SYSCFG external interrupt configuration register 3 (SYSCFG_EXTICR3)

   type SYSCFG_EXTICR3_Type is record
      EXTI8    : Bits_4  := EXTI_PA; -- EXTI 8 configuration
      EXTI9    : Bits_4  := EXTI_PA; -- EXTI 9 configuration
      EXTI10   : Bits_4  := EXTI_PA; -- EXTI 10 configuration
      EXTI11   : Bits_4  := EXTI_PA; -- EXTI 11 configuration
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYSCFG_EXTICR3_Type use record
      EXTI8    at 0 range  0 ..  3;
      EXTI9    at 0 range  4 ..  7;
      EXTI10   at 0 range  8 .. 11;
      EXTI11   at 0 range 12 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   SYSCFG_EXTICR3_ADDRESS : constant := 16#4001_3810#;

   SYSCFG_EXTICR3 : aliased SYSCFG_EXTICR3_Type
      with Address              => System'To_Address (SYSCFG_EXTICR3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.2.6 SYSCFG external interrupt configuration register 4 (SYSCFG_EXTICR4)

   type SYSCFG_EXTICR4_Type is record
      EXTI12   : Bits_4  := EXTI_PA; -- EXTI 12 configuration
      EXTI13   : Bits_4  := EXTI_PA; -- EXTI 13 configuration
      EXTI14   : Bits_4  := EXTI_PA; -- EXTI 14 configuration
      EXTI15   : Bits_4  := EXTI_PA; -- EXTI 15 configuration
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYSCFG_EXTICR4_Type use record
      EXTI12   at 0 range  0 ..  3;
      EXTI13   at 0 range  4 ..  7;
      EXTI14   at 0 range  8 .. 11;
      EXTI15   at 0 range 12 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   SYSCFG_EXTICR4_ADDRESS : constant := 16#4001_3814#;

   SYSCFG_EXTICR4 : aliased SYSCFG_EXTICR4_Type
      with Address              => System'To_Address (SYSCFG_EXTICR4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.2.7 Class B register (SYSCFG_CBR)

   type SYSCFG_CBR_Type is record
      CLL       : Boolean := False; -- Core Lockup Lock
      Reserved1 : Bits_1  := 0;
      PVDL      : Boolean := False; -- PVD Lock
      Reserved2 : Bits_29 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYSCFG_CBR_Type use record
      CLL       at 0 range 0 ..  0;
      Reserved1 at 0 range 1 ..  1;
      PVDL      at 0 range 2 ..  2;
      Reserved2 at 0 range 3 .. 31;
   end record;

   SYSCFG_CBR_ADDRESS : constant := 16#4001_381C#;

   SYSCFG_CBR : aliased SYSCFG_CBR_Type
      with Address              => System'To_Address (SYSCFG_CBR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.2.8 Compensation cell control register (SYSCFG_CMPCR)

   type SYSCFG_CMPCR_Type is record
      CMP_PD    : Boolean := False; -- Compensation cell power-down
      Reserved1 : Bits_7  := 0;
      READY     : Boolean := False; -- Compensation cell ready flag
      Reserved2 : Bits_23 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYSCFG_CMPCR_Type use record
      CMP_PD    at 0 range 0 ..  0;
      Reserved1 at 0 range 1 ..  7;
      READY     at 0 range 8 ..  8;
      Reserved2 at 0 range 9 .. 31;
   end record;

   SYSCFG_CMPCR_ADDRESS : constant := 16#4001_3820#;

   SYSCFG_CMPCR : aliased SYSCFG_CMPCR_Type
      with Address              => System'To_Address (SYSCFG_CMPCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 8 Direct memory access controller (DMA)
   ----------------------------------------------------------------------------

   -- 8.5.1 DMA low interrupt status register (DMA_LISR)

   type DMA_LISR_Type is record
      FEIF0     : Boolean := False; -- stream 0 FIFO error interrupt flag
      Reserved1 : Bits_1  := 0;
      DMEIF0    : Boolean := False; -- stream 0 direct mode error interrupt flag
      TEIF0     : Boolean := False; -- stream 0 transfer error interrupt flag
      HTIF0     : Boolean := False; -- stream 0 half transfer interrupt flag
      TCIF0     : Boolean := False; -- stream 0 transfer complete interrupt flag
      FEIF1     : Boolean := False; -- stream 1 FIFO error interrupt flag
      Reserved2 : Bits_1  := 0;
      DMEIF1    : Boolean := False; -- stream 1 direct mode error interrupt flag
      TEIF1     : Boolean := False; -- stream 1 transfer error interrupt flag
      HTIF1     : Boolean := False; -- stream 1 half transfer interrupt flag
      TCIF1     : Boolean := False; -- stream 1 transfer complete interrupt flag
      Reserved3 : Bits_4  := 0;
      FEIF2     : Boolean := False; -- stream 2 FIFO error interrupt flag
      Reserved4 : Bits_1  := 0;
      DMEIF2    : Boolean := False; -- stream 2 direct mode error interrupt flag
      TEIF2     : Boolean := False; -- stream 2 transfer error interrupt flag
      HTIF2     : Boolean := False; -- stream 2 half transfer interrupt flag
      TCIF2     : Boolean := False; -- stream 2 transfer complete interrupt flag
      FEIF3     : Boolean := False; -- stream 3 FIFO error interrupt flag
      Reserved5 : Bits_1  := 0;
      DMEIF3    : Boolean := False; -- stream 3 direct mode error interrupt flag
      TEIF3     : Boolean := False; -- stream 3 transfer error interrupt flag
      HTIF3     : Boolean := False; -- stream 3 half transfer interrupt flag
      TCIF3     : Boolean := False; -- stream 3 transfer complete interrupt flag
      Reserved6 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_LISR_Type use record
      FEIF0     at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  1;
      DMEIF0    at 0 range  2 ..  2;
      TEIF0     at 0 range  3 ..  3;
      HTIF0     at 0 range  4 ..  4;
      TCIF0     at 0 range  5 ..  5;
      FEIF1     at 0 range  6 ..  6;
      Reserved2 at 0 range  7 ..  7;
      DMEIF1    at 0 range  8 ..  8;
      TEIF1     at 0 range  9 ..  9;
      HTIF1     at 0 range 10 .. 10;
      TCIF1     at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 15;
      FEIF2     at 0 range 16 .. 16;
      Reserved4 at 0 range 17 .. 17;
      DMEIF2    at 0 range 18 .. 18;
      TEIF2     at 0 range 19 .. 19;
      HTIF2     at 0 range 20 .. 20;
      TCIF2     at 0 range 21 .. 21;
      FEIF3     at 0 range 22 .. 22;
      Reserved5 at 0 range 23 .. 23;
      DMEIF3    at 0 range 24 .. 24;
      TEIF3     at 0 range 25 .. 25;
      HTIF3     at 0 range 26 .. 26;
      TCIF3     at 0 range 27 .. 27;
      Reserved6 at 0 range 28 .. 31;
   end record;

   -- 8.5.2 DMA high interrupt status register (DMA_HISR)

   type DMA_HISR_Type is record
      FEIF4     : Boolean := False; -- stream 4 FIFO error interrupt flag
      Reserved1 : Bits_1  := 0;
      DMEIF4    : Boolean := False; -- stream 4 direct mode error interrupt flag
      TEIF4     : Boolean := False; -- stream 4 transfer error interrupt flag
      HTIF4     : Boolean := False; -- stream 4 half transfer interrupt flag
      TCIF4     : Boolean := False; -- stream 4 transfer complete interrupt flag
      FEIF5     : Boolean := False; -- stream 5 FIFO error interrupt flag
      Reserved2 : Bits_1  := 0;
      DMEIF5    : Boolean := False; -- stream 5 direct mode error interrupt flag
      TEIF5     : Boolean := False; -- stream 5 transfer error interrupt flag
      HTIF5     : Boolean := False; -- stream 5 half transfer interrupt flag
      TCIF5     : Boolean := False; -- stream 5 transfer complete interrupt flag
      Reserved3 : Bits_4  := 0;
      FEIF6     : Boolean := False; -- stream 6 FIFO error interrupt flag
      Reserved4 : Bits_1  := 0;
      DMEIF6    : Boolean := False; -- stream 6 direct mode error interrupt flag
      TEIF6     : Boolean := False; -- stream 6 transfer error interrupt flag
      HTIF6     : Boolean := False; -- stream 6 half transfer interrupt flag
      TCIF6     : Boolean := False; -- stream 6 transfer complete interrupt flag
      FEIF7     : Boolean := False; -- stream 7 FIFO error interrupt flag
      Reserved5 : Bits_1  := 0;
      DMEIF7    : Boolean := False; -- stream 7 direct mode error interrupt flag
      TEIF7     : Boolean := False; -- stream 7 transfer error interrupt flag
      HTIF7     : Boolean := False; -- stream 7 half transfer interrupt flag
      TCIF7     : Boolean := False; -- stream 7 transfer complete interrupt flag
      Reserved6 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_HISR_Type use record
      FEIF4     at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  1;
      DMEIF4    at 0 range  2 ..  2;
      TEIF4     at 0 range  3 ..  3;
      HTIF4     at 0 range  4 ..  4;
      TCIF4     at 0 range  5 ..  5;
      FEIF5     at 0 range  6 ..  6;
      Reserved2 at 0 range  7 ..  7;
      DMEIF5    at 0 range  8 ..  8;
      TEIF5     at 0 range  9 ..  9;
      HTIF5     at 0 range 10 .. 10;
      TCIF5     at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 15;
      FEIF6     at 0 range 16 .. 16;
      Reserved4 at 0 range 17 .. 17;
      DMEIF6    at 0 range 18 .. 18;
      TEIF6     at 0 range 19 .. 19;
      HTIF6     at 0 range 20 .. 20;
      TCIF6     at 0 range 21 .. 21;
      FEIF7     at 0 range 22 .. 22;
      Reserved5 at 0 range 23 .. 23;
      DMEIF7    at 0 range 24 .. 24;
      TEIF7     at 0 range 25 .. 25;
      HTIF7     at 0 range 26 .. 26;
      TCIF7     at 0 range 27 .. 27;
      Reserved6 at 0 range 28 .. 31;
   end record;

   -- 8.5.3 DMA low interrupt flag clear register (DMA_LIFCR)

   type DMA_LIFCR_Type is record
      CFEIF0    : Boolean := False; -- stream 0 clear FIFO error interrupt flag
      Reserved1 : Bits_1  := 0;
      CDMEIF0   : Boolean := False; -- stream 0 clear direct mode error interrupt flag
      CTEIF0    : Boolean := False; -- stream 0 clear transfer error interrupt flag
      CHTIF0    : Boolean := False; -- stream 0 clear half transfer interrupt flag
      CTCIF0    : Boolean := False; -- stream 0 clear transfer complete interrupt flag
      CFEIF1    : Boolean := False; -- stream 1 clear FIFO error interrupt flag
      Reserved2 : Bits_1  := 0;
      CDMEIF1   : Boolean := False; -- stream 1 clear direct mode error interrupt flag
      CTEIF1    : Boolean := False; -- stream 1 clear transfer error interrupt flag
      CHTIF1    : Boolean := False; -- stream 1 clear half transfer interrupt flag
      CTCIF1    : Boolean := False; -- stream 1 clear transfer complete interrupt flag
      Reserved3 : Bits_4  := 0;
      CFEIF2    : Boolean := False; -- stream 2 clear FIFO error interrupt flag
      Reserved4 : Bits_1  := 0;
      CDMEIF2   : Boolean := False; -- stream 2 clear direct mode error interrupt flag
      CTEIF2    : Boolean := False; -- stream 2 clear transfer error interrupt flag
      CHTIF2    : Boolean := False; -- stream 2 clear half transfer interrupt flag
      CTCIF2    : Boolean := False; -- stream 2 clear transfer complete interrupt flag
      CFEIF3    : Boolean := False; -- stream 3 clear FIFO error interrupt flag
      Reserved5 : Bits_1  := 0;
      CDMEIF3   : Boolean := False; -- stream 3 clear direct mode error interrupt flag
      CTEIF3    : Boolean := False; -- stream 3 clear transfer error interrupt flag
      CHTIF3    : Boolean := False; -- stream 3 clear half transfer interrupt flag
      CTCIF3    : Boolean := False; -- stream 3 clear transfer complete interrupt flag
      Reserved6 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_LIFCR_Type use record
      CFEIF0    at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  1;
      CDMEIF0   at 0 range  2 ..  2;
      CTEIF0    at 0 range  3 ..  3;
      CHTIF0    at 0 range  4 ..  4;
      CTCIF0    at 0 range  5 ..  5;
      CFEIF1    at 0 range  6 ..  6;
      Reserved2 at 0 range  7 ..  7;
      CDMEIF1   at 0 range  8 ..  8;
      CTEIF1    at 0 range  9 ..  9;
      CHTIF1    at 0 range 10 .. 10;
      CTCIF1    at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 15;
      CFEIF2    at 0 range 16 .. 16;
      Reserved4 at 0 range 17 .. 17;
      CDMEIF2   at 0 range 18 .. 18;
      CTEIF2    at 0 range 19 .. 19;
      CHTIF2    at 0 range 20 .. 20;
      CTCIF2    at 0 range 21 .. 21;
      CFEIF3    at 0 range 22 .. 22;
      Reserved5 at 0 range 23 .. 23;
      CDMEIF3   at 0 range 24 .. 24;
      CTEIF3    at 0 range 25 .. 25;
      CHTIF3    at 0 range 26 .. 26;
      CTCIF3    at 0 range 27 .. 27;
      Reserved6 at 0 range 28 .. 31;
   end record;

   -- 8.5.4 DMA high interrupt flag clear register (DMA_HIFCR)

   type DMA_HIFCR_Type is record
      CFEIF4    : Boolean := False; -- stream 4 clear FIFO error interrupt flag
      Reserved1 : Bits_1  := 0;
      CDMEIF4   : Boolean := False; -- stream 4 clear direct mode error interrupt flag
      CTEIF4    : Boolean := False; -- stream 4 clear transfer error interrupt flag
      CHTIF4    : Boolean := False; -- stream 4 clear half transfer interrupt flag
      CTCIF4    : Boolean := False; -- stream 4 clear transfer complete interrupt flag
      CFEIF5    : Boolean := False; -- stream 5 clear FIFO error interrupt flag
      Reserved2 : Bits_1  := 0;
      CDMEIF5   : Boolean := False; -- stream 5 clear direct mode error interrupt flag
      CTEIF5    : Boolean := False; -- stream 5 clear transfer error interrupt flag
      CHTIF5    : Boolean := False; -- stream 5 clear half transfer interrupt flag
      CTCIF5    : Boolean := False; -- stream 5 clear transfer complete interrupt flag
      Reserved3 : Bits_4  := 0;
      CFEIF6    : Boolean := False; -- stream 6 clear FIFO error interrupt flag
      Reserved4 : Bits_1  := 0;
      CDMEIF6   : Boolean := False; -- stream 6 clear direct mode error interrupt flag
      CTEIF6    : Boolean := False; -- stream 6 clear transfer error interrupt flag
      CHTIF6    : Boolean := False; -- stream 6 clear half transfer interrupt flag
      CTCIF6    : Boolean := False; -- stream 6 clear transfer complete interrupt flag
      CFEIF7    : Boolean := False; -- stream 7 clear FIFO error interrupt flag
      Reserved5 : Bits_1  := 0;
      CDMEIF7   : Boolean := False; -- stream 7 clear direct mode error interrupt flag
      CTEIF7    : Boolean := False; -- stream 7 clear transfer error interrupt flag
      CHTIF7    : Boolean := False; -- stream 7 clear half transfer interrupt flag
      CTCIF7    : Boolean := False; -- stream 7 clear transfer complete interrupt flag
      Reserved6 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_HIFCR_Type use record
      CFEIF4    at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  1;
      CDMEIF4   at 0 range  2 ..  2;
      CTEIF4    at 0 range  3 ..  3;
      CHTIF4    at 0 range  4 ..  4;
      CTCIF4    at 0 range  5 ..  5;
      CFEIF5    at 0 range  6 ..  6;
      Reserved2 at 0 range  7 ..  7;
      CDMEIF5   at 0 range  8 ..  8;
      CTEIF5    at 0 range  9 ..  9;
      CHTIF5    at 0 range 10 .. 10;
      CTCIF5    at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 15;
      CFEIF6    at 0 range 16 .. 16;
      Reserved4 at 0 range 17 .. 17;
      CDMEIF6   at 0 range 18 .. 18;
      CTEIF6    at 0 range 19 .. 19;
      CHTIF6    at 0 range 20 .. 20;
      CTCIF6    at 0 range 21 .. 21;
      CFEIF7    at 0 range 22 .. 22;
      Reserved5 at 0 range 23 .. 23;
      CDMEIF7   at 0 range 24 .. 24;
      CTEIF7    at 0 range 25 .. 25;
      CHTIF7    at 0 range 26 .. 26;
      CTCIF7    at 0 range 27 .. 27;
      Reserved6 at 0 range 28 .. 31;
   end record;

   -- 8.5.5 DMA stream x configuration register (DMA_SxCR)

   PFCTRL_DMA        : constant := 0; -- DMA is the flow controller
   PFCTRL_PERIPHERAL : constant := 1; -- The peripheral is the flow controller

   DIR_P2M  : constant := 2#00#; -- peripheral-to-memory
   DIR_M2P  : constant := 2#01#; -- memory-to-peripheral
   DIR_M2M  : constant := 2#10#; -- memory-to-memory
   DIR_RSVD : constant := 2#11#; -- reserved

   PINC_FIXED : constant := 0; -- peripheral address pointer is fixed
   PINC_INCR  : constant := 1; -- peripheral address pointer is incremented after each data transfer (increment is done according to PSIZE)

   MINC_FIXED : constant := 0; -- memory address pointer is fixed
   MINC_INCR  : constant := 1; -- memory address pointer is incremented after each data transfer (increment is done according to MSIZE)

   PSIZE_8    : constant := 2#00#; -- byte (8-bit)
   PSIZE_16   : constant := 2#01#; -- half-word (16-bit)
   PSIZE_32   : constant := 2#10#; -- word (32-bit)
   PSIZE_RSVD : constant := 2#11#; -- reserved

   MSIZE_8    : constant := 2#00#; -- byte (8-bit)
   MSIZE_16   : constant := 2#01#; -- half-word (16-bit)
   MSIZE_32   : constant := 2#10#; -- word (32-bit)
   MSIZE_RSVD : constant := 2#11#; -- reserved

   PINCOS_PSIZE : constant := 0; -- The offset size for the peripheral address calculation is linked to the PSIZE
   PINCOS_4     : constant := 1; -- The offset size for the peripheral address calculation is fixed to 4 (32-bit alignment).

   PL_LO  : constant := 2#00#; -- low
   PL_MED : constant := 2#01#; -- medium
   PL_HI  : constant := 2#10#; -- high
   PL_VHI : constant := 2#11#; -- very high

   DBM_NOBUFSWITCH : constant := 0; -- no buffer switching at the end of transfer
   DBM_SWITCHONEND : constant := 1; -- memory target switched at the end of the DMA transfer

   CT_Memory0 : constant := 0; -- current target memory is Memory 0 (addressed by the DMA_SxM0AR pointer)
   CT_Memory1 : constant := 1; -- current target memory is Memory 1 (addressed by the DMA_SxM1AR pointer)

   PBURST_SINGLE : constant := 2#00#; -- single transfer
   PBURST_INCR4  : constant := 2#01#; -- INCR4 (incremental burst of 4 beats)
   PBURST_INCR8  : constant := 2#10#; -- INCR8 (incremental burst of 8 beats)
   PBURST_INCR16 : constant := 2#11#; -- INCR16 (incremental burst of 16 beats)

   MBURST_SINGLE : constant := 2#00#; -- single transfer
   MBURST_INCR4  : constant := 2#01#; -- INCR4 (incremental burst of 4 beats)
   MBURST_INCR8  : constant := 2#10#; -- INCR8 (incremental burst of 8 beats)
   MBURST_INCR16 : constant := 2#11#; -- INCR16 (incremental burst of 16 beats)

   CHSEL_0  : constant := 2#0000#; -- channel 0 selected
   CHSEL_1  : constant := 2#0001#; -- channel 1 selected
   CHSEL_2  : constant := 2#0010#; -- channel 2 selected
   CHSEL_3  : constant := 2#0011#; -- channel 3 selected
   CHSEL_4  : constant := 2#0100#; -- channel 4 selected
   CHSEL_5  : constant := 2#0101#; -- channel 5 selected
   CHSEL_6  : constant := 2#0110#; -- channel 6 selected
   CHSEL_7  : constant := 2#0111#; -- channel 7 selected
   CHSEL_8  : constant := 2#1000#; -- channel 8 selected
   CHSEL_9  : constant := 2#1001#; -- channel 9 selected
   CHSEL_10 : constant := 2#1010#; -- channel 10 selected
   CHSEL_11 : constant := 2#1011#; -- channel 11 selected
   CHSEL_12 : constant := 2#1100#; -- channel 12 selected
   CHSEL_13 : constant := 2#1101#; -- channel 13 selected
   CHSEL_14 : constant := 2#1110#; -- channel 14 selected
   CHSEL_15 : constant := 2#1111#; -- channel 15 selected

   type DMA_SxCR_Type is record
      EN        : Boolean := False;           -- stream enable / flag stream ready when read low
      DMEIE     : Boolean := False;           -- direct mode error interrupt enable
      TEIE      : Boolean := False;           -- transfer error interrupt enable
      HTIE      : Boolean := False;           -- half transfer interrupt enable
      TCIE      : Boolean := False;           -- transfer complete interrupt enable
      PFCTRL    : Bits_1  := PFCTRL_DMA;      -- peripheral flow controller
      DIR       : Bits_2  := DIR_P2M;         -- data transfer direction
      CIRC      : Boolean := False;           -- circular mode
      PINC      : Bits_1  := PINC_FIXED;      -- peripheral increment mode
      MINC      : Bits_1  := MINC_FIXED;      -- memory increment mode
      PSIZE     : Bits_2  := PSIZE_8;         -- peripheral data size
      MSIZE     : Bits_2  := MSIZE_8;         -- memory data size
      PINCOS    : Bits_1  := PINCOS_PSIZE;    -- peripheral increment offset size
      PL        : Bits_2  := PL_LO;           -- priority level
      DBM       : Bits_1  := DBM_NOBUFSWITCH; -- double-buffer mode
      CT        : Bits_1  := CT_Memory0;      -- current target (only in double-buffer mode)
      Reserved1 : Bits_1  := 0;
      PBURST    : Bits_2  := PBURST_SINGLE;   -- peripheral burst transfer configuration
      MBURST    : Bits_2  := MBURST_SINGLE;   -- memory burst transfer configuration
      CHSEL     : Bits_4  := CHSEL_0;         -- channel selection
      Reserved2 : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_SxCR_Type use record
      EN        at 0 range  0 ..  0;
      DMEIE     at 0 range  1 ..  1;
      TEIE      at 0 range  2 ..  2;
      HTIE      at 0 range  3 ..  3;
      TCIE      at 0 range  4 ..  4;
      PFCTRL    at 0 range  5 ..  5;
      DIR       at 0 range  6 ..  7;
      CIRC      at 0 range  8 ..  8;
      PINC      at 0 range  9 ..  9;
      MINC      at 0 range 10 .. 10;
      PSIZE     at 0 range 11 .. 12;
      MSIZE     at 0 range 13 .. 14;
      PINCOS    at 0 range 15 .. 15;
      PL        at 0 range 16 .. 17;
      DBM       at 0 range 18 .. 18;
      CT        at 0 range 19 .. 19;
      Reserved1 at 0 range 20 .. 20;
      PBURST    at 0 range 21 .. 22;
      MBURST    at 0 range 23 .. 24;
      CHSEL     at 0 range 25 .. 28;
      Reserved2 at 0 range 29 .. 31;
   end record;

   -- 8.5.6 DMA stream x number of data register (DMA_SxNDTR)

   type DMA_SxNDTR_Type is record
      NDT      : Unsigned_16 := 0; -- number of data items to transfer (0 up to 65535)
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_SxNDTR_Type use record
      NDT      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 8.5.7 DMA stream x peripheral address register (DMA_SxPAR)

   type DMA_SxPAR_Type is record
      PAR : Unsigned_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_SxPAR_Type use record
      PAR at 0 range 0 .. 31;
   end record;

   -- 8.5.8 DMA stream x memory 0 address register (DMA_SxM0AR)

   type DMA_SxM0AR_Type is record
      M0A : Unsigned_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_SxM0AR_Type use record
      M0A at 0 range 0 .. 31;
   end record;

   -- 8.5.9 DMA stream x memory 1 address register (DMA_SxM1AR)

   type DMA_SxM1AR_Type is record
      M1A : Unsigned_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_SxM1AR_Type use record
      M1A at 0 range 0 .. 31;
   end record;

   -- 8.5.10 DMA stream x FIFO control register (DMA_SxFCR)

   FTH_25PCT : constant := 2#00#; -- 1/4 full FIFO
   FTH_50PCT : constant := 2#01#; -- 1/2 full FIFO
   FTH_75PCT : constant := 2#10#; -- 3/4 full FIFO
   FTH_FULL  : constant := 2#11#; -- full FIFO

   FS_LT25PCT : constant := 2#000#; -- 0 < fifo_level < 1/4
   FS_LT50PCT : constant := 2#001#; -- 1/4 ≤ fifo_level < 1/2
   FS_LT75PCT : constant := 2#010#; -- 1/2 ≤ fifo_level < 3/4
   FS_LTFULL  : constant := 2#011#; -- 3/4 ≤ fifo_level < full
   FS_EMPTY   : constant := 2#100#; -- FIFO is empty
   FS_FULL    : constant := 2#101#; -- FIFO is full

   type DMA_SxFCR_Type is record
      FTH       : Bits_2  := FTH_50PCT; -- FIFO threshold selection
      DMDIS     : Boolean := False;     -- direct mode disable
      FS        : Bits_3  := FS_EMPTY;  -- FIFO status
      Reserved1 : Bits_1  := 0;
      FEIE      : Boolean := False;     -- FIFO error interrupt enable
      Reserved2 : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_SxFCR_Type use record
      FTH       at 0 range 0 ..  1;
      DMDIS     at 0 range 2 ..  2;
      FS        at 0 range 3 ..  5;
      Reserved1 at 0 range 6 ..  6;
      FEIE      at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   type DMA_Stream_Type is record
      CR   : DMA_SxCR_Type   with Volatile_Full_Access => True;
      NDTR : DMA_SxNDTR_Type with Volatile_Full_Access => True;
      PAR  : DMA_SxPAR_Type  with Volatile_Full_Access => True;
      M0AR : DMA_SxM0AR_Type with Volatile_Full_Access => True;
      M1AR : DMA_SxM1AR_Type with Volatile_Full_Access => True;
      FCR  : DMA_SxFCR_Type  with Volatile_Full_Access => True;
   end record
      with Size => 32 * 6;
   for DMA_Stream_Type use record
      CR   at 16#00# range 0 .. 31;
      NDTR at 16#04# range 0 .. 31;
      PAR  at 16#08# range 0 .. 31;
      M0AR at 16#0C# range 0 .. 31;
      M1AR at 16#10# range 0 .. 31;
      FCR  at 16#14# range 0 .. 31;
   end record;

   type DMA_Stream_Array_Type is array (0 ..7) of DMA_Stream_Type
      with Pack => True;

   -- 8.5 DMA registers

   type DMA_Type is record
      LISR   : DMA_LISR_Type         with Volatile_Full_Access => True;
      HISR   : DMA_HISR_Type         with Volatile_Full_Access => True;
      LIFCR  : DMA_HIFCR_Type        with Volatile_Full_Access => True;
      HIFCR  : DMA_HIFCR_Type        with Volatile_Full_Access => True;
      STREAM : DMA_Stream_Array_Type with Volatile => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32 * 4 + 32 * 6 * 8;
   for DMA_Type use record
      LISR   at 16#00# range 0 .. 31;
      HISR   at 16#04# range 0 .. 31;
      LIFCR  at 16#08# range 0 .. 31;
      HIFCR  at 16#0C# range 0 .. 31;
      STREAM at 16#10# range 0 .. 32 * 6 * 8 - 1;
   end record;

   DMA1_BASEADDRESS : constant := 16#4002_6000#;

   DMA1 : aliased DMA_Type
      with Address    => System'To_Address (DMA1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   DMA2_BASEADDRESS : constant := 16#4002_6400#;

   DMA2 : aliased DMA_Type
      with Address    => System'To_Address (DMA2_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 9 Chrom-ART AcceleratorTM controller (DMA2D)
   ----------------------------------------------------------------------------

   -- 9.5.1 DMA2D control register (DMA2D_CR)
   -- 9.5.2 DMA2D interrupt status register (DMA2D_ISR)
   -- 9.5.3 DMA2D interrupt flag clear register (DMA2D_IFCR)
   -- 9.5.4 DMA2D foreground memory address register (DMA2D_FGMAR)
   -- 9.5.5 DMA2D foreground offset register (DMA2D_FGOR)
   -- 9.5.6 DMA2D background memory address register (DMA2D_BGMAR)
   -- 9.5.7 DMA2D background offset register (DMA2D_BGOR)
   -- 9.5.8 DMA2D foreground PFC control register (DMA2D_FGPFCCR)
   -- 9.5.9 DMA2D foreground color register (DMA2D_FGCOLR)
   -- 9.5.10 DMA2D background PFC control register (DMA2D_BGPFCCR)
   -- 9.5.11 DMA2D background color register (DMA2D_BGCOLR)
   -- 9.5.12 DMA2D foreground CLUT memory address register (DMA2D_FGCMAR)
   -- 9.5.13 DMA2D background CLUT memory address register (DMA2D_BGCMAR)
   -- 9.5.14 DMA2D output PFC control register (DMA2D_OPFCCR)
   -- 9.5.15 DMA2D output color register (DMA2D_OCOLR)
   -- 9.5.16 DMA2D output color register [alternate] (DMA2D_OCOLR)
   -- 9.5.17 DMA2D output color register [alternate] (DMA2D_OCOLR)
   -- 9.5.18 DMA2D output color register [alternate] (DMA2D_OCOLR)
   -- 9.5.19 DMA2D output memory address register (DMA2D_OMAR)
   -- 9.5.20 DMA2D output offset register (DMA2D_OOR)
   -- 9.5.21 DMA2D number of line register (DMA2D_NLR)
   -- 9.5.22 DMA2D line watermark register (DMA2D_LWR)
   -- 9.5.23 DMA2D AHB master timer configuration register (DMA2D_AMTCR)
   -- 9.5.24 DMA2D foreground CLUT (DMA2D_FGCLUTx)
   -- 9.5.25 DMA2D background CLUT (DMA2D_BGCLUTx)

   ----------------------------------------------------------------------------
   -- 10 Nested vectored interrupt controller (NVIC)
   ----------------------------------------------------------------------------

   -- 10.1.2 Interrupt and exception vectors

   IRQ_WWDG               : constant :=   0; -- Window Watchdog interrupt
   IRQ_PVD                : constant :=   1; -- PVD through EXTI line detection interrupt
   IRQ_TAMP_STAMP         : constant :=   2; -- Tamper and TimeStamp interrupts through the EXTI line
   IRQ_RTC_WKUP           : constant :=   3; -- RTC Wakeup interrupt through the EXTI line
   IRQ_FLASH              : constant :=   4; -- Flash global interrupt
   IRQ_RCC                : constant :=   5; -- RCC global interrupt
   IRQ_EXTI0              : constant :=   6; -- EXTI Line0 interrupt
   IRQ_EXTI1              : constant :=   7; -- EXTI Line1 interrupt
   IRQ_EXTI2              : constant :=   8; -- EXTI Line2 interrupt
   IRQ_EXTI3              : constant :=   9; -- EXTI Line3 interrupt
   IRQ_EXTI4              : constant :=  10; -- EXTI Line4 interrupt
   IRQ_DMA1_Stream0       : constant :=  11; -- DMA1 Stream0 global interrupt
   IRQ_DMA1_Stream1       : constant :=  12; -- DMA1 Stream1 global interrupt
   IRQ_DMA1_Stream2       : constant :=  13; -- DMA1 Stream2 global interrupt
   IRQ_DMA1_Stream3       : constant :=  14; -- DMA1 Stream3 global interrupt
   IRQ_DMA1_Stream4       : constant :=  15; -- DMA1 Stream4 global interrupt
   IRQ_DMA1_Stream5       : constant :=  16; -- DMA1 Stream5 global interrupt
   IRQ_DMA1_Stream6       : constant :=  17; -- DMA1 Stream6 global interrupt
   IRQ_ADC                : constant :=  18; -- ADC1, ADC2 and ADC3 global interrupts
   IRQ_CAN1_TX            : constant :=  19; -- CAN1 TX interrupts
   IRQ_CAN1_RX0           : constant :=  20; -- CAN1 RX0 interrupts
   IRQ_CAN1_RX1           : constant :=  21; -- CAN1 RX1 interrupt
   IRQ_CAN1_SCE           : constant :=  22; -- CAN1 SCE interrupt
   IRQ_EXTI9_5            : constant :=  23; -- EXTI Line[9:5] interrupts
   IRQ_TIM1_BRK_TIM9      : constant :=  24; -- TIM1 Break interrupt and TIM9 global interrupt
   IRQ_TIM1_UP_TIM10      : constant :=  25; -- TIM1 Update interrupt and TIM10 global interrupt
   IRQ_TIM1_TRG_COM_TIM11 : constant :=  26; -- TIM1 Trigger and Commutation interrupts and TIM11 global interrupt
   IRQ_TIM1_CC            : constant :=  27; -- TIM1 Capture Compare interrupt
   IRQ_TIM2               : constant :=  28; -- TIM2 global interrupt
   IRQ_TIM3               : constant :=  29; -- TIM3 global interrupt
   IRQ_TIM4               : constant :=  30; -- TIM4 global interrupt
   IRQ_I2C1_EV            : constant :=  31; -- I2C1 event interrupt
   IRQ_I2C1_ER            : constant :=  32; -- I2C1 error interrupt
   IRQ_I2C2_EV            : constant :=  33; -- I2C2 event interrupt
   IRQ_I2C2_ER            : constant :=  34; -- I2C2 error interrupt
   IRQ_SPI1               : constant :=  35; -- SPI1 global interrupt
   IRQ_SPI2               : constant :=  36; -- SPI2 global interrupt
   IRQ_USART1             : constant :=  37; -- USART1 global interrupt
   IRQ_USART2             : constant :=  38; -- USART2 global interrupt
   IRQ_USART3             : constant :=  39; -- USART3 global interrupt
   IRQ_EXTI15_10          : constant :=  40; -- EXTI Line[15:10] interrupts
   IRQ_RTC_Alarm          : constant :=  41; -- RTC Alarms (A and B) through EXTI line interrupt
   IRQ_OTG_FS_WKUP        : constant :=  42; -- USB On-The-Go FS Wakeup through EXTI line interrupt
   IRQ_TIM8_BRK_TIM12     : constant :=  43; -- TIM8 Break interrupt and TIM12 global interrupt
   IRQ_TIM8_UP_TIM13      : constant :=  44; -- TIM8 Update interrupt and TIM13 global interrupt
   IRQ_TIM8_TRG_COM_TIM14 : constant :=  45; -- TIM8 Trigger and Commutation interrupts and TIM14 global interrupt
   IRQ_TIM8_CC            : constant :=  46; -- TIM8 Capture Compare interrupt
   IRQ_DMA1_Stream7       : constant :=  47; -- DMA1 Stream7 global interrupt
   IRQ_FMC                : constant :=  48; -- FMC global interrupt
   IRQ_SDMMC1             : constant :=  49; -- SDMMC1 global interrupt
   IRQ_TIM5               : constant :=  50; -- TIM5 global interrupt
   IRQ_SPI3               : constant :=  51; -- SPI3 global interrupt
   IRQ_UART4              : constant :=  52; -- UART4 global interrupt
   IRQ_UART5              : constant :=  53; -- UART5 global interrupt
   IRQ_TIM6_DAC           : constant :=  54; -- TIM6 global interrupt, DAC1 and DAC2 underrun error interrupts
   IRQ_TIM7               : constant :=  55; -- TIM7 global interrupt
   IRQ_DMA2_Stream0       : constant :=  56; -- DMA2 Stream0 global interrupt
   IRQ_DMA2_Stream1       : constant :=  57; -- DMA2 Stream1 global interrupt
   IRQ_DMA2_Stream2       : constant :=  58; -- DMA2 Stream2 global interrupt
   IRQ_DMA2_Stream3       : constant :=  59; -- DMA2 Stream3 global interrupt
   IRQ_DMA2_Stream4       : constant :=  60; -- DMA2 Stream4 global interrupt
   IRQ_ETH                : constant :=  61; -- Ethernet global interrupt
   IRQ_ETH_WKUP           : constant :=  62; -- Ethernet Wakeup through EXTI line interrupt
   IRQ_CAN2_TX            : constant :=  63; -- CAN2 TX interrupts
   IRQ_CAN2_RX0           : constant :=  64; -- CAN2 RX0 interrupts
   IRQ_CAN2_RX1           : constant :=  65; -- CAN2 RX1 interrupt
   IRQ_CAN2_SCE           : constant :=  66; -- CAN2 SCE interrupt
   IRQ_OTG_FS             : constant :=  67; -- USB On The Go FS global interrupt
   IRQ_DMA2_Stream5       : constant :=  68; -- DMA2 Stream5 global interrupt
   IRQ_DMA2_Stream6       : constant :=  69; -- DMA2 Stream6 global interrupt
   IRQ_DMA2_Stream7       : constant :=  70; -- DMA2 Stream7 global interrupt
   IRQ_USART6             : constant :=  71; -- USART6 global interrupt
   IRQ_I2C3_EV            : constant :=  72; -- I2C3 event interrupt
   IRQ_I2C3_ER            : constant :=  73; -- I2C3 error interrupt
   IRQ_OTG_HS_EP1_OUT     : constant :=  74; -- USB On The Go HS End Point 1 Out global interrupt
   IRQ_OTG_HS_EP1_IN      : constant :=  75; -- USB On The Go HS End Point 1 In global interrupt
   IRQ_OTG_HS_WKUP        : constant :=  76; -- USB On The Go HS Wakeup through EXTI interrupt
   IRQ_OTG_HS             : constant :=  77; -- USB On The Go HS global interrupt
   IRQ_DCMI               : constant :=  78; -- DCMI global interrupt
   IRQ_CRYP               : constant :=  79; -- CRYP crypto global interrupt
   IRQ_HASH_RNG           : constant :=  80; -- Hash and Rng global interrupt
   IRQ_FPU                : constant :=  81; -- FPU global interrupt
   IRQ_UART7              : constant :=  82; -- UART7 global interrupt
   IRQ_UART8              : constant :=  83; -- UART8 global interrupt
   IRQ_SPI4               : constant :=  84; -- SPI4 global interrupt
   IRQ_SPI5               : constant :=  85; -- SPI5 global interrupt
   IRQ_SPI6               : constant :=  86; -- SPI6 global interrupt
   IRQ_SAI7               : constant :=  87; -- SAI1 global interrupt
   IRQ_LCD_TFT            : constant :=  88; -- LCD-TFT global interrupt
   IRQ_LCD_TFT_E          : constant :=  89; -- LCD-TFT global Error interrupt
   IRQ_DMA2D              : constant :=  90; -- DMA2D global interrupt
   IRQ_SAI2               : constant :=  91; -- SAI2 global interrupt
   IRQ_QuadSPI            : constant :=  92; -- QuadSPI global interrupt
   IRQ_LP_Timer1          : constant :=  93; -- LP Timer1 global interrupt
   IRQ_HDMI_CEC           : constant :=  94; -- HDMI-CEC global interrupt
   IRQ_I2C4_EV            : constant :=  95; -- I2C4 event interrupt
   IRQ_I2C4_ER            : constant :=  96; -- I2C4 Error interrupt
   IRQ_SPDIFRX            : constant :=  97; -- SPDIFRX global interrupt
   IRQ_DSIHOST            : constant :=  98; -- DSI host global interrupt
   IRQ_DFSDM1_FLT0        : constant :=  99; -- DFSDM1 Filter 0 global interrupt
   IRQ_DFSDM1_FLT1        : constant := 100; -- DFSDM1 Filter 1 global interrupt
   IRQ_DFSDM1_FLT2        : constant := 101; -- DFSDM1 Filter 2 global interrupt
   IRQ_DFSDM1_FLT3        : constant := 102; -- DFSDM1 Filter 3 global interrupt
   IRQ_SDMMC2             : constant := 103; -- SDMMC2 global interrupt
   IRQ_CAN3_TX            : constant := 104; -- CAN3 TX interrupt
   IRQ_CAN3_RX0           : constant := 105; -- CAN3 RX0 interrupt
   IRQ_CAN3_RX1           : constant := 106; -- CAN3 RX1 interrupt
   IRQ_CAN3_SCE           : constant := 107; -- CAN3 SCE interrupt
   IRQ_JPEG               : constant := 108; -- JPEG global interrupt
   IRQ_MDIOS              : constant := 109; -- MDIO slave global interrupt

   ----------------------------------------------------------------------------
   -- 11 Extended interrupts and events controller (EXTI)
   ----------------------------------------------------------------------------

   type EXTI_Index_Type is range 0 .. 24;

   EXTI_LINE0            : constant EXTI_Index_Type := 0;  -- PA0 .. PK0
   EXTI_LINE1            : constant EXTI_Index_Type := 1;  -- PA1 .. PK1
   EXTI_LINE2            : constant EXTI_Index_Type := 2;  -- PA2 .. PK2
   EXTI_LINE3            : constant EXTI_Index_Type := 3;  -- PA3 .. PK3
   EXTI_LINE4            : constant EXTI_Index_Type := 4;  -- PA4 .. PK4
   EXTI_LINE5            : constant EXTI_Index_Type := 5;  -- PA5 .. PK5
   EXTI_LINE6            : constant EXTI_Index_Type := 6;  -- PA6 .. PK6
   EXTI_LINE7            : constant EXTI_Index_Type := 7;  -- PA7 .. PK7
   EXTI_LINE8            : constant EXTI_Index_Type := 8;  -- PA8 .. PJ8
   EXTI_LINE9            : constant EXTI_Index_Type := 9;  -- PA9 .. PJ9
   EXTI_LINE10           : constant EXTI_Index_Type := 10; -- PA10 .. PJ10
   EXTI_LINE11           : constant EXTI_Index_Type := 11; -- PA11 .. PJ11
   EXTI_LINE12           : constant EXTI_Index_Type := 12; -- PA12 .. PJ12
   EXTI_LINE13           : constant EXTI_Index_Type := 13; -- PA13 .. PJ13
   EXTI_LINE14           : constant EXTI_Index_Type := 14; -- PA14 .. PJ14
   EXTI_LINE15           : constant EXTI_Index_Type := 15; -- PA15 .. PJ15
   EXTI_PVD              : constant EXTI_Index_Type := 16; -- PVD output
   EXTI_RTC_ALARM        : constant EXTI_Index_Type := 17; -- RTC Alarm event
   EXTI_USB_OTGFS_WAKEUP : constant EXTI_Index_Type := 18; -- USB OTG FS Wakeup event
   EXTI_ETH_WAKEUP       : constant EXTI_Index_Type := 19; -- Ethernet Wakeup event
   EXTI_USB_OTGHS_WAKEUP : constant EXTI_Index_Type := 20; -- USB OTG HS (configured in FS) Wakeup event
   EXTI_RTC_TAMPER       : constant EXTI_Index_Type := 21; -- RTC Tamper and TimeStamp events
   EXTI_RTC_WAKEUP       : constant EXTI_Index_Type := 22; -- RTC Wakeup event
   EXTI_LPTIM1           : constant EXTI_Index_Type := 23; -- LPTIM1 asynchronous event
   EXTI_MDIO             : constant EXTI_Index_Type := 24; -- MDIO Slave asynchronous interrupt

   type EXTI_Bitmap_Type is array (EXTI_Index_Type) of Boolean
      with Component_Size => 1,
           Size           => 25;

   -- 11.9.1 Interrupt mask register (EXTI_IMR)

   type EXTI_IMR_Type is record
      MR       : EXTI_Bitmap_Type := [others => False]; -- Interrupt mask on line x
      Reserved : Bits_7           := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for EXTI_IMR_Type use record
      MR       at 0 range  0 .. 24;
      Reserved at 0 range 25 .. 31;
   end record;

   EXTI_IMR_ADDRESS : constant := 16#4001_3C00#;

   EXTI_IMR : aliased EXTI_IMR_Type
      with Address              => System'To_Address (EXTI_IMR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 11.9.2 Event mask register (EXTI_EMR)

   type EXTI_EMR_Type is record
      MR       : EXTI_Bitmap_Type := [others => False]; -- Event mask on line x
      Reserved : Bits_7           := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for EXTI_EMR_Type use record
      MR       at 0 range  0 .. 24;
      Reserved at 0 range 25 .. 31;
   end record;

   EXTI_EMR_ADDRESS : constant := 16#4001_3C04#;

   EXTI_EMR : aliased EXTI_EMR_Type
      with Address              => System'To_Address (EXTI_EMR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 11.9.3 Rising trigger selection register (EXTI_RTSR)

   type EXTI_RTSR_Type is record
      TR       : EXTI_Bitmap_Type := [others => False]; -- Rising trigger event configuration bit of line x
      Reserved : Bits_7           := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for EXTI_RTSR_Type use record
      TR       at 0 range  0 .. 24;
      Reserved at 0 range 25 .. 31;
   end record;

   EXTI_RTSR_ADDRESS : constant := 16#4001_3C08#;

   EXTI_RTSR : aliased EXTI_RTSR_Type
      with Address              => System'To_Address (EXTI_RTSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 11.9.4 Falling trigger selection register (EXTI_FTSR)

   type EXTI_FTSR_Type is record
      TR       : EXTI_Bitmap_Type := [others => False]; -- Falling trigger event configuration bit of line x
      Reserved : Bits_7           := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for EXTI_FTSR_Type use record
      TR       at 0 range  0 .. 24;
      Reserved at 0 range 25 .. 31;
   end record;

   EXTI_FTSR_ADDRESS : constant := 16#4001_3C0C#;

   EXTI_FTSR : aliased EXTI_FTSR_Type
      with Address              => System'To_Address (EXTI_FTSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 11.9.5 Software interrupt event register (EXTI_SWIER)

   type EXTI_SWIER_Type is record
      SWIER    : EXTI_Bitmap_Type := [others => False]; -- Software Interrupt on line x
      Reserved : Bits_7           := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for EXTI_SWIER_Type use record
      SWIER    at 0 range  0 .. 24;
      Reserved at 0 range 25 .. 31;
   end record;

   EXTI_SWIER_ADDRESS : constant := 16#4001_3C10#;

   EXTI_SWIER : aliased EXTI_SWIER_Type
      with Address              => System'To_Address (EXTI_SWIER_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 11.9.6 Pending register (EXTI_PR)

   type EXTI_PR_Type is record
      PR       : EXTI_Bitmap_Type := [others => False]; -- Pending bit
      Reserved : Bits_7           := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for EXTI_PR_Type use record
      PR       at 0 range  0 .. 24;
      Reserved at 0 range 25 .. 31;
   end record;

   EXTI_PR_ADDRESS : constant := 16#4001_3C14#;

   EXTI_PR : aliased EXTI_PR_Type
      with Address              => System'To_Address (EXTI_PR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 12 Cyclic redundancy check calculation unit (CRC)
   ----------------------------------------------------------------------------

   -- 12.4.1 CRC data register (CRC_DR)
   -- 12.4.2 CRC independent data register (CRC_IDR)
   -- 12.4.3 CRC control register (CRC_CR)
   -- 12.4.4 CRC initial value (CRC_INIT)
   -- 12.4.5 CRC polynomial (CRC_POL)

   ----------------------------------------------------------------------------
   -- 13 Flexible memory controller (FMC)
   ----------------------------------------------------------------------------

   -- 13.5.6 NOR/PSRAM controller registers

   -- SRAM/NOR-flash chip-select control register for bank x (FMC_BCRx) (x = 1 to 4)

   MTYP_SRAM  : constant := 2#00#; -- SRAM
   MTYP_PSRAM : constant := 2#01#; -- PSRAM (CRAM)
   MTYP_Flash : constant := 2#10#; -- NOR Flash/OneNAND Flash
   MTYP_RSVD  : constant := 2#11#; -- reserved

   MWID_8    : constant := 2#00#; -- 8 bits
   MWID_16   : constant := 2#01#; -- 16 bits
   MWID_32   : constant := 2#10#; -- 32 bits
   MWID_RSVD : constant := 2#11#; -- reserved

   WAITPOL_LOW  : constant := 0; -- NWAIT active low
   WAITPOL_HIGH : constant := 1; -- NWAIT active high.

   WAITCFG_CYCLE1 : constant := 0; -- NWAIT signal is active one data cycle before wait state
   WAITCFG_INWAIT : constant := 1; -- NWAIT signal is active during wait state (not used for PSRAM).

   CPSIZE_NONE  : constant := 2#000#; -- No burst split when crossing page boundary
   CPSIZE_128   : constant := 2#001#; -- 128 bytes
   CPSIZE_256   : constant := 2#010#; -- 256 bytes
   CPSIZE_512   : constant := 2#011#; -- 512 bytes
   CPSIZE_1024  : constant := 2#100#; -- 1024 bytes
   CPSIZE_RSVD1 : constant := 2#101#;
   CPSIZE_RSVD2 : constant := 2#110#;
   CPSIZE_RSVD3 : constant := 2#111#;

   type FMC_BCRx_Type is record
      MBKEN     : Boolean;                   -- Memory bank enable bit.
      MUXEN     : Boolean;                   -- Address/data multiplexing enable bit.
      MTYP      : Bits_2;                    -- Memory type.
      MWID      : Bits_2  := MWID_16;        -- Memory data bus width.
      FACCEN    : Boolean := True;           -- Flash access enable
      Reserved1 : Bits_1  := 1;
      BURSTEN   : Boolean := False;          -- Burst enable bit.
      WAITPOL   : Bits_1  := WAITPOL_LOW;    -- Wait signal polarity bit.
      Reserved2 : Bits_1  := 0;
      WAITCFG   : Bits_1  := WAITCFG_CYCLE1; -- Wait timing configuration.
      WREN      : Boolean := True;           -- Write enable bit.
      WAITEN    : Boolean := True;           -- Wait enable bit.
      EXTMOD    : Boolean := False;          -- Extended mode enable.
      ASYNCWAIT : Boolean := False;          -- Wait signal during asynchronous transfers
      CPSIZE    : Bits_3  := CPSIZE_NONE;    -- CRAM page size.
      CBURSTRW  : Boolean := False;          -- Write burst enable.
      CCLKEN    : Boolean := False;          -- Continuous Clock Enable.
      WFDIS     : Boolean := False;          -- Write FIFO Disable
      Reserved3 : Bits_10 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FMC_BCRx_Type use record
      MBKEN     at 0 range  0 ..  0;
      MUXEN     at 0 range  1 ..  1;
      MTYP      at 0 range  2 ..  3;
      MWID      at 0 range  4 ..  5;
      FACCEN    at 0 range  6 ..  6;
      Reserved1 at 0 range  7 ..  7;
      BURSTEN   at 0 range  8 ..  8;
      WAITPOL   at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 10;
      WAITCFG   at 0 range 11 .. 11;
      WREN      at 0 range 12 .. 12;
      WAITEN    at 0 range 13 .. 13;
      EXTMOD    at 0 range 14 .. 14;
      ASYNCWAIT at 0 range 15 .. 15;
      CPSIZE    at 0 range 16 .. 18;
      CBURSTRW  at 0 range 19 .. 19;
      CCLKEN    at 0 range 20 .. 20;
      WFDIS     at 0 range 21 .. 21;
      Reserved3 at 0 range 22 .. 31;
   end record;

   FMC_BCR1_ADDRESS : constant := 16#A000_0000#;

   FMC_BCR1 : aliased FMC_BCRx_Type
      with Address              => System'To_Address (FMC_BCR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FMC_BCR2_ADDRESS : constant := 16#A000_0008#;

   FMC_BCR2 : aliased FMC_BCRx_Type
      with Address              => System'To_Address (FMC_BCR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FMC_BCR3_ADDRESS : constant := 16#A000_0010#;

   FMC_BCR3 : aliased FMC_BCRx_Type
      with Address              => System'To_Address (FMC_BCR3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FMC_BCR4_ADDRESS : constant := 16#A000_0018#;

   FMC_BCR4 : aliased FMC_BCRx_Type
      with Address              => System'To_Address (FMC_BCR4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- SRAM/NOR-flash chip-select timing register for bank x (FMC_BTRx)

   ACCMOD_MODEA : constant := 2#00#; -- access mode A
   ACCMOD_MODEB : constant := 2#01#; -- access mode B
   ACCMOD_MODEC : constant := 2#10#; -- access mode C
   ACCMOD_MODED : constant := 2#11#; -- access mode D

   CLKDIV_RSVD   : constant := 2#0000#; -- Reserved
   CLKDIV_HCLK2  : constant := 2#0001#; -- FMC_CLK period = 2 × HCLK periods
   CLKDIV_HCLK3  : constant := 2#0010#; -- FMC_CLK period = 3 × HCLK periods
   CLKDIV_HCLK4  : constant := 2#0011#; -- FMC_CLK period = 4 × HCLK periods
   CLKDIV_HCLK5  : constant := 2#0100#; -- FMC_CLK period = 5 × HCLK periods
   CLKDIV_HCLK6  : constant := 2#0101#; -- FMC_CLK period = 6 × HCLK periods
   CLKDIV_HCLK7  : constant := 2#0110#; -- FMC_CLK period = 7 × HCLK periods
   CLKDIV_HCLK8  : constant := 2#0111#; -- FMC_CLK period = 8 × HCLK periods
   CLKDIV_HCLK9  : constant := 2#1000#; -- FMC_CLK period = 9 × HCLK periods
   CLKDIV_HCLK10 : constant := 2#1001#; -- FMC_CLK period = 10 × HCLK periods
   CLKDIV_HCLK11 : constant := 2#1010#; -- FMC_CLK period = 11 × HCLK periods
   CLKDIV_HCLK12 : constant := 2#1011#; -- FMC_CLK period = 12 × HCLK periods
   CLKDIV_HCLK13 : constant := 2#1100#; -- FMC_CLK period = 13 × HCLK periods
   CLKDIV_HCLK14 : constant := 2#1101#; -- FMC_CLK period = 14 × HCLK periods
   CLKDIV_HCLK15 : constant := 2#1110#; -- FMC_CLK period = 15 × HCLK periods
   CLKDIV_HCLK16 : constant := 2#1111#; -- FMC_CLK period = 16 × HCLK periods

   DATLAT_CLK2  : constant := 2#0000#; -- Data latency of 2 CLK clock cycles for first burst access
   DATLAT_CLK3  : constant := 2#0001#; -- Data latency of 3 CLK clock cycles for first burst access
   DATLAT_CLK4  : constant := 2#0010#; -- Data latency of 4 CLK clock cycles for first burst access
   DATLAT_CLK5  : constant := 2#0011#; -- Data latency of 5 CLK clock cycles for first burst access
   DATLAT_CLK6  : constant := 2#0100#; -- Data latency of 6 CLK clock cycles for first burst access
   DATLAT_CLK7  : constant := 2#0101#; -- Data latency of 7 CLK clock cycles for first burst access
   DATLAT_CLK8  : constant := 2#0110#; -- Data latency of 8 CLK clock cycles for first burst access
   DATLAT_CLK9  : constant := 2#0111#; -- Data latency of 9 CLK clock cycles for first burst access
   DATLAT_CLK10 : constant := 2#1000#; -- Data latency of 10 CLK clock cycles for first burst access
   DATLAT_CLK11 : constant := 2#1001#; -- Data latency of 11 CLK clock cycles for first burst access
   DATLAT_CLK12 : constant := 2#1010#; -- Data latency of 12 CLK clock cycles for first burst access
   DATLAT_CLK13 : constant := 2#1011#; -- Data latency of 13 CLK clock cycles for first burst access
   DATLAT_CLK14 : constant := 2#1100#; -- Data latency of 14 CLK clock cycles for first burst access
   DATLAT_CLK15 : constant := 2#1101#; -- Data latency of 15 CLK clock cycles for first burst access
   DATLAT_CLK16 : constant := 2#1110#; -- Data latency of 16 CLK clock cycles for first burst access
   DATLAT_CLK17 : constant := 2#1111#; -- Data latency of 17 CLK clock cycles for first burst access

   type FMC_BTRx_Type is record
      ADDSET   : Bits_4     := 15;            -- Address setup phase duration
      ADDHLD   : Bits_4     := 15;            -- Address-hold phase duration
      DATAST   : Unsigned_8 := 255;           -- Data-phase duration
      BUSTURN  : Bits_4     := 15;            -- Bus turnaround phase duration
      CLKDIV   : Bits_4     := CLKDIV_HCLK16; -- Clock divide ratio (for FMC_CLK signal)
      DATLAT   : Bits_4     := DATLAT_CLK17;  -- Data latency for synchronous memory
      ACCMOD   : Bits_2     := ACCMOD_MODEA;  -- Access mode
      Reserved : Bits_2     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FMC_BTRx_Type use record
      ADDSET   at 0 range  0 ..  3;
      ADDHLD   at 0 range  4 ..  7;
      DATAST   at 0 range  8 .. 15;
      BUSTURN  at 0 range 16 .. 19;
      CLKDIV   at 0 range 20 .. 23;
      DATLAT   at 0 range 24 .. 27;
      ACCMOD   at 0 range 28 .. 29;
      Reserved at 0 range 30 .. 31;
   end record;

   FMC_BTR1_ADDRESS : constant := 16#A000_0004#;

   FMC_BTR1 : aliased FMC_BTRx_Type
      with Address              => System'To_Address (FMC_BTR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FMC_BTR2_ADDRESS : constant := 16#A000_000C#;

   FMC_BTR2 : aliased FMC_BTRx_Type
      with Address              => System'To_Address (FMC_BTR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FMC_BTR3_ADDRESS : constant := 16#A000_0014#;

   FMC_BTR3 : aliased FMC_BTRx_Type
      with Address              => System'To_Address (FMC_BTR3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FMC_BTR4_ADDRESS : constant := 16#A000_001C#;

   FMC_BTR4 : aliased FMC_BTRx_Type
      with Address              => System'To_Address (FMC_BTR4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- SRAM/NOR-flash write timing registers x (FMC_BWTRx)

   -- ACCMOD_* already defined at FMC_BTRx

   type FMC_BWTRx_Type is record
      ADDSET    : Bits_4     := 15;           -- Address setup phase duration
      ADDHLD    : Bits_4     := 15;           -- Address-hold phase duration
      DATAST    : Unsigned_8 := 255;          -- Data-phase duration
      BUSTURN   : Bits_4     := 15;           -- Bus turnaround phase duration
      Reserved1 : Bits_8     := 16#FF#;
      ACCMOD    : Bits_2     := ACCMOD_MODEA; -- Access mode
      Reserved2 : Bits_2     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FMC_BWTRx_Type use record
      ADDSET    at 0 range  0 ..  3;
      ADDHLD    at 0 range  4 ..  7;
      DATAST    at 0 range  8 .. 15;
      BUSTURN   at 0 range 16 .. 19;
      Reserved1 at 0 range 20 .. 27;
      ACCMOD    at 0 range 28 .. 29;
      Reserved2 at 0 range 30 .. 31;
   end record;

   FMC_BWTR1_ADDRESS : constant := 16#A000_0104#;

   FMC_BWTR1 : aliased FMC_BWTRx_Type
      with Address              => System'To_Address (FMC_BWTR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FMC_BWTR2_ADDRESS : constant := 16#A000_010C#;

   FMC_BWTR2 : aliased FMC_BWTRx_Type
      with Address              => System'To_Address (FMC_BWTR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FMC_BWTR3_ADDRESS : constant := 16#A000_0114#;

   FMC_BWTR3 : aliased FMC_BWTRx_Type
      with Address              => System'To_Address (FMC_BWTR3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FMC_BWTR4_ADDRESS : constant := 16#A000_011C#;

   FMC_BWTR4 : aliased FMC_BWTRx_Type
      with Address              => System'To_Address (FMC_BWTR4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.6.7 NAND flash controller registers
   -- NAND flash control registers (FMC_PCR)
   -- FIFO status and interrupt register (FMC_SR)
   -- Common memory space timing register (FMC_PMEM)
   -- Attribute memory space timing register (FMC_PATT)
   -- ECC result registers (FMC_ECCR)

   -- 13.7.5 SDRAM controller registers
   -- SDRAM control register x (FMC_SDCRx)
   -- SDRAM timing register x (FMC_SDTRx)
   -- SDRAM Command Mode register (FMC_SDCMR)
   -- SDRAM refresh timer register (FMC_SDRTR)
   -- SDRAM status register (FMC_SDSR)

   ----------------------------------------------------------------------------
   -- 14 Quad-SPI interface (QUADSPI)
   ----------------------------------------------------------------------------

   -- 14.5.1 QUADSPI control register (QUADSPI_CR)

   SSHIFT_NONE      : constant := 0; -- No shift
   SSHIFT_HALFCYCLE : constant := 1; -- 1/2 cycle shift

   FSEL_FLASH1 : constant := 0; -- FLASH 1 selected
   FSEL_FLASH2 : constant := 1; -- FLASH 2 selected

   FTHRES_1  : constant := 0;  -- In indirect write mode (FMODE = 00): FTF is set if there are 1 or more free bytes available to be written to in the FIFO
                               -- In indirect read mode (FMODE = 01): FTF is set if there are 1 or more valid bytes that can be read from the FIFO
   FTHRES_2  : constant := 1;  -- In indirect write mode (FMODE = 00): FTF is set if there are 2 or more free bytes available to be written to in the FIFO
                               -- In indirect read mode (FMODE = 01): FTF is set if there are 2 or more valid bytes that can be read from the FIFO
   FTHRES_3  : constant := 2;
   FTHRES_4  : constant := 3;
   FTHRES_5  : constant := 4;
   FTHRES_6  : constant := 5;
   FTHRES_7  : constant := 6;
   FTHRES_8  : constant := 7;
   FTHRES_9  : constant := 8;
   FTHRES_10 : constant := 9;
   FTHRES_11 : constant := 10;
   FTHRES_12 : constant := 11;
   FTHRES_13 : constant := 12;
   FTHRES_14 : constant := 13;
   FTHRES_15 : constant := 14;
   FTHRES_16 : constant := 15;
   FTHRES_17 : constant := 16;
   FTHRES_18 : constant := 17;
   FTHRES_19 : constant := 18;
   FTHRES_20 : constant := 19;
   FTHRES_21 : constant := 20;
   FTHRES_22 : constant := 21;
   FTHRES_23 : constant := 22;
   FTHRES_24 : constant := 23;
   FTHRES_25 : constant := 24;
   FTHRES_26 : constant := 25;
   FTHRES_27 : constant := 26;
   FTHRES_28 : constant := 27;
   FTHRES_29 : constant := 28;
   FTHRES_30 : constant := 29;
   FTHRES_31 : constant := 30;
   FTHRES_32 : constant := 31; -- In indirect write mode (FMODE = 00): FTF is set if there are 32 free bytes available to be written to in the FIFO
                               -- In indirect read mode (FMODE = 01): FTF is set if there are 32 valid bytes that can be read from the FIFO

   APMS_ABORTDISABLE : constant := 0; -- Automatic polling mode is stopped only by abort or by disabling the QUADSPI.
   APMS_MATCH        : constant := 1; -- Automatic polling mode stops as soon as there is a match.

   PMM_AND : constant := 0; -- AND match mode.
   PMM_OR  : constant := 1; -- OR match mode.

   PRESCALER_FAHB        : constant := 0;   -- FCLK = FAHB, AHB clock used directly as QUADSPI CLK (prescaler bypassed)
   PRESCALER_FAHB_DIV2   : constant := 1;   -- FCLK = FAHB/2
   PRESCALER_FAHB_DIV3   : constant := 2;   -- FCLK = FAHB/3
   PRESCALER_FAHB_DIV256 : constant := 255; -- FCLK = FAHB/256

   type QUADSPI_CR_Type is record
      EN        : Boolean    := False;             -- Enable
      ABORTR    : Boolean    := False;             -- Abort request
      DMAEN     : Boolean    := False;             -- DMA enable
      TCEN      : Boolean    := False;             -- Timeout counter enable
      SSHIFT    : Bits_1     := SSHIFT_NONE;       -- Sample shift
      Reserved1 : Bits_1     := 0;
      DFM       : Boolean    := False;             -- Dual-flash mode
      FSEL      : Bits_1     := FSEL_FLASH1;       -- Flash memory selection
      FTHRES    : Bits_5     := FTHRES_1;          -- FIFO threshold level
      Reserved2 : Bits_3     := 0;
      TEIE      : Boolean    := False;             -- Transfer error interrupt enable
      TCIE      : Boolean    := False;             -- Transfer complete interrupt enable
      FTIE      : Boolean    := False;             -- FIFO threshold interrupt enable
      SMIE      : Boolean    := False;             -- Status match interrupt enable
      TOIE      : Boolean    := False;             -- TimeOut interrupt enable
      Reserved3 : Bits_1     := 0;
      APMS      : Bits_1     := APMS_ABORTDISABLE; -- Automatic poll mode stop
      PMM       : Bits_1     := PMM_AND;           -- Polling match mode
      PRESCALER : Unsigned_8 := PRESCALER_FAHB;    -- Clock prescaler
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_CR_Type use record
      EN        at 0 range  0 ..  0;
      ABORTR    at 0 range  1 ..  1;
      DMAEN     at 0 range  2 ..  2;
      TCEN      at 0 range  3 ..  3;
      SSHIFT    at 0 range  4 ..  4;
      Reserved1 at 0 range  5 ..  5;
      DFM       at 0 range  6 ..  6;
      FSEL      at 0 range  7 ..  7;
      FTHRES    at 0 range  8 .. 12;
      Reserved2 at 0 range 13 .. 15;
      TEIE      at 0 range 16 .. 16;
      TCIE      at 0 range 17 .. 17;
      FTIE      at 0 range 18 .. 18;
      SMIE      at 0 range 19 .. 19;
      TOIE      at 0 range 20 .. 20;
      Reserved3 at 0 range 21 .. 21;
      APMS      at 0 range 22 .. 22;
      PMM       at 0 range 23 .. 23;
      PRESCALER at 0 range 24 .. 31;
   end record;

   QUADSPI_CR_ADDRESS : constant := 16#A000_1000#;

   QUADSPI_CR : aliased QUADSPI_CR_Type
      with Address              => System'To_Address (QUADSPI_CR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.2 QUADSPI device configuration register (QUADSPI_DCR)

   CKMODE_MODE0 : constant := 0; -- CLK must stay low while NCS is high (chip select released).
   CKMODE_MODE3 : constant := 1; -- CLK must stay high while NCS is high (chip select released).

   CSHT_1 : constant := 0; -- NCS stays high for at least 1 cycle between flash memory commands
   CSHT_2 : constant := 1; -- NCS stays high for at least 2 cycles between flash memory commands
   CSHT_3 : constant := 2;
   CSHT_4 : constant := 3;
   CSHT_5 : constant := 4;
   CSHT_6 : constant := 5;
   CSHT_7 : constant := 6;
   CSHT_8 : constant := 7; -- NCS stays high for at least 8 cycles between flash memory commands

   FSIZE_2    : constant := 0;  -- Number of bytes in flash memory = 2^[FSIZE+1]
   FSIZE_4    : constant := 1;
   FSIZE_8    : constant := 2;
   FSIZE_16   : constant := 3;
   FSIZE_32   : constant := 4;
   FSIZE_64   : constant := 5;
   FSIZE_128  : constant := 6;
   FSIZE_256  : constant := 7;
   FSIZE_512  : constant := 8;
   FSIZE_1K   : constant := 9;
   FSIZE_2K   : constant := 10;
   FSIZE_4K   : constant := 11;
   FSIZE_8K   : constant := 12;
   FSIZE_16K  : constant := 13;
   FSIZE_32K  : constant := 14;
   FSIZE_64K  : constant := 15;
   FSIZE_128K : constant := 16;
   FSIZE_256K : constant := 17;
   FSIZE_512K : constant := 18;
   FSIZE_1M   : constant := 19;
   FSIZE_2M   : constant := 20;
   FSIZE_4M   : constant := 21;
   FSIZE_8M   : constant := 22;
   FSIZE_16M  : constant := 23;
   FSIZE_32M  : constant := 24;
   FSIZE_64M  : constant := 25;
   FSIZE_128M : constant := 26;
   FSIZE_256M : constant := 27;
   FSIZE_512M : constant := 28;
   FSIZE_1G   : constant := 29;
   FSIZE_2G   : constant := 30;
   FSIZE_4G   : constant := 31;

   type QUADSPI_DCR_Type is record
      CKMODE    : Bits_1  := CKMODE_MODE0; -- Mode 0/mode 3
      Reserved1 : Bits_7  := 0;
      CSHT      : Bits_3  := CSHT_1;       -- Chip select high time
      Reserved2 : Bits_5  := 0;
      FSIZE     : Bits_5  := FSIZE_2;      -- Flash memory size
      Reserved3 : Bits_11 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_DCR_Type use record
      CKMODE    at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      CSHT      at 0 range  8 .. 10;
      Reserved2 at 0 range 11 .. 15;
      FSIZE     at 0 range 16 .. 20;
      Reserved3 at 0 range 21 .. 31;
   end record;

   QUADSPI_DCR_ADDRESS : constant := 16#A000_1004#;

   QUADSPI_DCR : aliased QUADSPI_DCR_Type
      with Address              => System'To_Address (QUADSPI_DCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.3 QUADSPI status register (QUADSPI_SR)

   type QUADSPI_SR_Type is record
      TEF       : Boolean; -- Transfer error flag
      TCF       : Boolean; -- Transfer complete flag
      FTF       : Boolean; -- FIFO threshold flag
      SMF       : Boolean; -- Status match flag
      TOF       : Boolean; -- Timeout flag
      BUSY      : Boolean; -- Busy
      Reserved1 : Bits_2;
      FLEVEL    : Bits_6;  -- FIFO level
      Reserved2 : Bits_18;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_SR_Type use record
      TEF       at 0 range  0 ..  0;
      TCF       at 0 range  1 ..  1;
      FTF       at 0 range  2 ..  2;
      SMF       at 0 range  3 ..  3;
      TOF       at 0 range  4 ..  4;
      BUSY      at 0 range  5 ..  5;
      Reserved1 at 0 range  6 ..  7;
      FLEVEL    at 0 range  8 .. 13;
      Reserved2 at 0 range 14 .. 31;
   end record;

   QUADSPI_SR_ADDRESS : constant := 16#A000_1008#;

   QUADSPI_SR : aliased QUADSPI_SR_Type
      with Address              => System'To_Address (QUADSPI_SR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.4 QUADSPI flag clear register (QUADSPI_FCR)

   type QUADSPI_FCR_Type is record
      CTEF      : Boolean := False; -- Clear transfer error flag
      CTCF      : Boolean := False; -- Clear transfer complete flag
      Reserved1 : Bits_1  := 0;
      CSMF      : Boolean := False; -- Clear status match flag
      CTOF      : Boolean := False; -- Clear timeout flag
      Reserved2 : Bits_27 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_FCR_Type use record
      CTEF      at 0 range 0 ..  0;
      CTCF      at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  2;
      CSMF      at 0 range 3 ..  3;
      CTOF      at 0 range 4 ..  4;
      Reserved2 at 0 range 5 .. 31;
   end record;

   QUADSPI_FCR_ADDRESS : constant := 16#A000_100C#;

   QUADSPI_FCR : aliased QUADSPI_FCR_Type
      with Address              => System'To_Address (QUADSPI_FCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.5 QUADSPI data length register (QUADSPI_DLR)

   type QUADSPI_DLR_Type is record
      DL : Unsigned_32 := 0; -- Data length
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_DLR_Type use record
      DL at 0 range 0 .. 31;
   end record;

   QUADSPI_DLR_ADDRESS : constant := 16#A000_1010#;

   QUADSPI_DLR : aliased QUADSPI_DLR_Type
      with Address              => System'To_Address (QUADSPI_DLR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.6 QUADSPI communication configuration register (QUADSPI_CCR)

   IMODE_NONE   : constant := 2#00#; -- No instruction
   IMODE_LINES1 : constant := 2#01#; -- Instruction on a single line
   IMODE_LINES2 : constant := 2#10#; -- Instruction on two lines
   IMODE_LINES4 : constant := 2#11#; -- Instruction on four lines

   ADMODE_NONE   : constant := 2#00#; -- No address
   ADMODE_LINES1 : constant := 2#01#; -- Address on a single line
   ADMODE_LINES2 : constant := 2#10#; -- Address on two lines
   ADMODE_LINES4 : constant := 2#11#; -- Address on four lines

   ADSIZE_8  : constant := 2#00#; -- 8-bit address
   ADSIZE_16 : constant := 2#01#; -- 16-bit address
   ADSIZE_24 : constant := 2#10#; -- 24-bit address
   ADSIZE_32 : constant := 2#11#; -- 32-bit address

   ABMODE_NONE   : constant := 2#00#; -- No alternate bytes
   ABMODE_LINES1 : constant := 2#01#; -- Alternate bytes on a single line
   ABMODE_LINES2 : constant := 2#10#; -- Alternate bytes on two lines
   ABMODE_LINES4 : constant := 2#11#; -- Alternate bytes on four lines

   ABSIZE_8  : constant := 2#00#; -- 8-bit alternate byte
   ABSIZE_16 : constant := 2#01#; -- 16-bit alternate bytes
   ABSIZE_24 : constant := 2#10#; -- 24-bit alternate bytes
   ABSIZE_32 : constant := 2#11#; -- 32-bit alternate bytes

   DMODE_NONE   : constant := 2#00#; -- No data
   DMODE_LINES1 : constant := 2#01#; -- Data on a single line
   DMODE_LINES2 : constant := 2#10#; -- Data on two lines
   DMODE_LINES4 : constant := 2#11#; -- Data on four lines

   FMODE_INDWRITE : constant := 2#00#; -- Indirect-write mode
   FMODE_INDREAD  : constant := 2#01#; -- Indirect-read mode
   FMODE_AUTOPOLL : constant := 2#10#; -- Automatic status-polling mode
   FMODE_MEMMAP   : constant := 2#11#; -- Memory-mapped mode

   type QUADSPI_CCR_Type is record
      INSTRUCTION : Bits_8  := 0;              -- Instruction
      IMODE       : Bits_2  := IMODE_NONE;     -- Instruction mode
      ADMODE      : Bits_2  := ADMODE_NONE;    -- Address mode
      ADSIZE      : Bits_2  := ADSIZE_8;       -- Address size
      ABMODE      : Bits_2  := ABMODE_NONE;    -- Alternate byte mode
      ABSIZE      : Bits_2  := ABSIZE_8;       -- Alternate-byte size
      DCYC        : Bits_5  := 0;              -- Number of dummy cycles
      Reserved1   : Bits_1  := 0;
      DMODE       : Bits_2  := DMODE_NONE;     -- Data mode
      FMODE       : Bits_2  := FMODE_INDWRITE; -- Functional mode
      SIOO        : Boolean := False;          -- Send instruction only once mode
      Reserved2   : Bits_1  := 0;
      DHHC        : Boolean := False;          -- DDR hold
      DDRM        : Boolean := False;          -- Double data rate mode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_CCR_Type use record
      INSTRUCTION at 0 range  0 ..  7;
      IMODE       at 0 range  8 ..  9;
      ADMODE      at 0 range 10 .. 11;
      ADSIZE      at 0 range 12 .. 13;
      ABMODE      at 0 range 14 .. 15;
      ABSIZE      at 0 range 16 .. 17;
      DCYC        at 0 range 18 .. 22;
      Reserved1   at 0 range 23 .. 23;
      DMODE       at 0 range 24 .. 25;
      FMODE       at 0 range 26 .. 27;
      SIOO        at 0 range 28 .. 28;
      Reserved2   at 0 range 29 .. 29;
      DHHC        at 0 range 30 .. 30;
      DDRM        at 0 range 31 .. 31;
   end record;

   QUADSPI_CCR_ADDRESS : constant := 16#A000_1014#;

   QUADSPI_CCR : aliased QUADSPI_CCR_Type
      with Address              => System'To_Address (QUADSPI_CCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.7 QUADSPI address register (QUADSPI_AR)

   type QUADSPI_AR_Type is record
      ADDRESS : Unsigned_32 := 0; -- Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_AR_Type use record
      ADDRESS at 0 range 0 .. 31;
   end record;

   QUADSPI_AR_ADDRESS : constant := 16#A000_1018#;

   QUADSPI_AR : aliased QUADSPI_AR_Type
      with Address              => System'To_Address (QUADSPI_AR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.8 QUADSPI alternate-byte register (QUADSPI_ABR)

   type QUADSPI_ABR_Type is record
      ALTERNATE : Unsigned_32 := 0; -- Alternate bytes
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_ABR_Type use record
      ALTERNATE at 0 range 0 .. 31;
   end record;

   QUADSPI_ABR_ADDRESS : constant := 16#A000_101C#;

   QUADSPI_ABR : aliased QUADSPI_ABR_Type
      with Address              => System'To_Address (QUADSPI_ABR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.9 QUADSPI data register (QUADSPI_DR)

   type QUADSPI_DR_Type is record
      DATA : Unsigned_32; -- Data
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_DR_Type use record
      DATA at 0 range 0 .. 31;
   end record;

   QUADSPI_DR_ADDRESS : constant := 16#A000_1020#;

   QUADSPI_DR : aliased QUADSPI_DR_Type
      with Address              => System'To_Address (QUADSPI_DR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.10 QUADSPI polling status mask register (QUADSPI_PSMKR)

   type QUADSPI_PSMKR_Type is record
      MASK : Unsigned_32 := 0; -- Status mask
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_PSMKR_Type use record
      MASK at 0 range 0 .. 31;
   end record;

   QUADSPI_PSMKR_ADDRESS : constant := 16#A000_1024#;

   QUADSPI_PSMKR : aliased QUADSPI_PSMKR_Type
      with Address              => System'To_Address (QUADSPI_PSMKR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.11 QUADSPI polling status match register (QUADSPI_PSMAR)

   type QUADSPI_PSMAR_Type is record
      MATCH : Unsigned_32 := 0; -- Status match
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_PSMAR_Type use record
      MATCH at 0 range 0 .. 31;
   end record;

   QUADSPI_PSMAR_ADDRESS : constant := 16#A000_1028#;

   QUADSPI_PSMAR : aliased QUADSPI_PSMAR_Type
      with Address              => System'To_Address (QUADSPI_PSMAR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.12 QUADSPI polling interval register (QUADSPI_PIR)

   type QUADSPI_PIR_Type is record
      INTERVAL : Unsigned_16 := 0; -- Polling interval
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_PIR_Type use record
      INTERVAL at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   QUADSPI_PIR_ADDRESS : constant := 16#A000_102C#;

   QUADSPI_PIR : aliased QUADSPI_PIR_Type
      with Address              => System'To_Address (QUADSPI_PIR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.13 QUADSPI low-power timeout register (QUADSPI_LPTR)

   type QUADSPI_LPTR_Type is record
      TIMEOUT  : Unsigned_16 := 0; -- Timeout period
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for QUADSPI_LPTR_Type use record
      TIMEOUT  at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   QUADSPI_LPTR_ADDRESS : constant := 16#A000_1030#;

   QUADSPI_LPTR : aliased QUADSPI_LPTR_Type
      with Address              => System'To_Address (QUADSPI_LPTR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 15 Analog-to-digital converter (ADC)
   ----------------------------------------------------------------------------

   -- 15.13.1 ADC status register (ADC_SR)
   -- 15.13.2 ADC control register 1 (ADC_CR1)
   -- 15.13.3 ADC control register 2 (ADC_CR2)
   -- 15.13.4 ADC sample time register 1 (ADC_SMPR1)
   -- 15.13.5 ADC sample time register 2 (ADC_SMPR2)
   -- 15.13.6 ADC injected channel data offset register x (ADC_JOFRx) (x=1..4)
   -- 15.13.7 ADC watchdog higher threshold register (ADC_HTR)
   -- 15.13.8 ADC watchdog lower threshold register (ADC_LTR)
   -- 15.13.9 ADC regular sequence register 1 (ADC_SQR1)
   -- 15.13.10 ADC regular sequence register 2 (ADC_SQR2)
   -- 15.13.11 ADC regular sequence register 3 (ADC_SQR3)
   -- 15.13.12 ADC injected sequence register (ADC_JSQR)
   -- 15.13.13 ADC injected data register x (ADC_JDRx) (x= 1..4)
   -- 15.13.14 ADC regular data register (ADC_DR)
   -- 15.13.15 ADC Common status register (ADC_CSR)
   -- 15.13.16 ADC common control register (ADC_CCR)
   -- 15.13.17 ADC common regular data register for dual and triple modes (ADC_CDR)

   ----------------------------------------------------------------------------
   -- 16 Digital-to-analog converter (DAC)
   ----------------------------------------------------------------------------

   -- 16.5.1 DAC control register (DAC_CR)
   -- 16.5.2 DAC software trigger register (DAC_SWTRIGR)
   -- 16.5.3 DAC channel1 12-bit right-aligned data holding register (DAC_DHR12R1)
   -- 16.5.4 DAC channel1 12-bit left aligned data holding register (DAC_DHR12L1)
   -- 16.5.5 DAC channel1 8-bit right aligned data holding register (DAC_DHR8R1)
   -- 16.5.6 DAC channel2 12-bit right aligned data holding register (DAC_DHR12R2)
   -- 16.5.7 DAC channel2 12-bit left aligned data holding register (DAC_DHR12L2)
   -- 16.5.8 DAC channel2 8-bit right-aligned data holding register (DAC_DHR8R2)
   -- 16.5.9 Dual DAC 12-bit right-aligned data holding register (DAC_DHR12RD)
   -- 16.5.10 DUAL DAC 12-bit left aligned data holding register (DAC_DHR12LD)
   -- 16.5.11 DUAL DAC 8-bit right aligned data holding register (DAC_DHR8RD)
   -- 16.5.12 DAC channel1 data output register (DAC_DOR1)
   -- 16.5.13 DAC channel2 data output register (DAC_DOR2)
   -- 16.5.14 DAC status register (DAC_SR)

   ----------------------------------------------------------------------------
   -- 17 Digital filter for sigma delta modulators (DFSDM)
   ----------------------------------------------------------------------------

   -- 17.7 DFSDM channel y registers (y=0..7)
   -- 17.7.1 DFSDM channel y configuration register (DFSDM_CHyCFGR1)
   -- 17.7.2 DFSDM channel y configuration register (DFSDM_CHyCFGR2)
   -- 17.7.3 DFSDM channel y analog watchdog and short-circuit detector register (DFSDM_CHyAWSCDR)
   -- 17.7.4 DFSDM channel y watchdog filter data register (DFSDM_CHyWDATR)
   -- 17.7.5 DFSDM channel y data input register (DFSDM_CHyDATINR)
   -- 17.8 DFSDM filter x module registers (x=0..3)
   -- 17.8.1 DFSDM filter x control register 1 (DFSDM_FLTxCR1)
   -- 17.8.2 DFSDM filter x control register 2 (DFSDM_FLTxCR2)
   -- 17.8.3 DFSDM filter x interrupt and status register (DFSDM_FLTxISR)
   -- 17.8.4 DFSDM filter x interrupt flag clear register (DFSDM_FLTxICR)
   -- 17.8.5 DFSDM filter x injected channel group selection register (DFSDM_FLTxJCHGR)
   -- 17.8.6 DFSDM filter x control register (DFSDM_FLTxFCR)
   -- 17.8.7 DFSDM filter x data register for injected group (DFSDM_FLTxJDATAR)
   -- 17.8.8 DFSDM filter x data register for the regular channel (DFSDM_FLTxRDATAR)
   -- 17.8.9 DFSDM filter x analog watchdog high threshold register (DFSDM_FLTxAWHTR)
   -- 17.8.10 DFSDM filter x analog watchdog low threshold register (DFSDM_FLTxAWLTR)
   -- 17.8.11 DFSDM filter x analog watchdog status register (DFSDM_FLTxAWSR)
   -- 17.8.12 DFSDM filter x analog watchdog clear flag register (DFSDM_FLTxAWCFR)
   -- 17.8.13 DFSDM filter x extremes detector maximum register (DFSDM_FLTxEXMAX)
   -- 17.8.14 DFSDM filter x extremes detector minimum register (DFSDM_FLTxEXMIN)
   -- 17.8.15 DFSDM filter x conversion timer register (DFSDM_FLTxCNVTIMR)

   ----------------------------------------------------------------------------
   -- 18 Digital camera interface (DCMI)
   ----------------------------------------------------------------------------

   -- 18.5.1 DCMI control register (DCMI_CR)
   -- 18.5.2 DCMI status register (DCMI_SR)
   -- 18.5.3 DCMI raw interrupt status register (DCMI_RIS)
   -- 18.5.4 DCMI interrupt enable register (DCMI_IER)
   -- 18.5.5 DCMI masked interrupt status register (DCMI_MIS)
   -- 18.5.6 DCMI interrupt clear register (DCMI_ICR)
   -- 18.5.7 DCMI embedded synchronization code register (DCMI_ESCR)
   -- 18.5.8 DCMI embedded synchronization unmask register (DCMI_ESUR)
   -- 18.5.9 DCMI crop window start (DCMI_CWSTRT)
   -- 18.5.10 DCMI crop window size (DCMI_CWSIZE)
   -- 18.5.11 DCMI data register (DCMI_DR)

   ----------------------------------------------------------------------------
   -- 19 LCD-TFT display controller (LTDC)
   ----------------------------------------------------------------------------

   -- 19.7.1 LTDC synchronization size configuration register (LTDC_SSCR)
   -- 19.7.2 LTDC back porch configuration register (LTDC_BPCR)
   -- 19.7.3 LTDC active width configuration register (LTDC_AWCR)
   -- 19.7.4 LTDC total width configuration register (LTDC_TWCR)
   -- 19.7.5 LTDC global control register (LTDC_GCR)
   -- 19.7.6 LTDC shadow reload configuration register (LTDC_SRCR)
   -- 19.7.7 LTDC background color configuration register (LTDC_BCCR)
   -- 19.7.8 LTDC interrupt enable register (LTDC_IER)
   -- 19.7.9 LTDC interrupt status register (LTDC_ISR)
   -- 19.7.10 LTDC Interrupt clear register (LTDC_ICR)
   -- 19.7.11 LTDC line interrupt position configuration register (LTDC_LIPCR)
   -- 19.7.12 LTDC current position status register (LTDC_CPSR)
   -- 19.7.13 LTDC current display status register (LTDC_CDSR)
   -- 19.7.14 LTDC layer x control register (LTDC_LxCR)
   -- 19.7.15 LTDC layer x window horizontal position configuration register (LTDC_LxWHPCR)
   -- 19.7.16 LTDC layer x window vertical position configuration register (LTDC_LxWVPCR)
   -- 19.7.17 LTDC layer x color keying configuration register (LTDC_LxCKCR)
   -- 19.7.18 LTDC layer x pixel format configuration register (LTDC_LxPFCR)
   -- 19.7.19 LTDC layer x constant alpha configuration register (LTDC_LxCACR)
   -- 19.7.20 LTDC layer x default color configuration register (LTDC_LxDCCR)
   -- 19.7.21 LTDC layer x blending factors configuration register (LTDC_LxBFCR)
   -- 19.7.22 LTDC layer x color frame buffer address register (LTDC_LxCFBAR)
   -- 19.7.23 LTDC layer x color frame buffer length register (LTDC_LxCFBLR)
   -- 19.7.24 LTDC layer x color frame buffer line number register (LTDC_LxCFBLNR)
   -- 19.7.25 LTDC layer x CLUT write register (LTDC_LxCLUTWR)

   ----------------------------------------------------------------------------
   -- 20 DSI Host (DSI)
   ----------------------------------------------------------------------------

   -- 20.15.1 DSI Host version register (DSI_VR)
   -- 20.15.2 DSI Host control register (DSI_CR)
   -- 20.15.3 DSI Host clock control register (DSI_CCR)
   -- 20.15.4 DSI Host LTDC VCID register (DSI_LVCIDR)
   -- 20.15.5 DSI Host LTDC color coding register (DSI_LCOLCR)
   -- 20.15.6 DSI Host LTDC polarity configuration register (DSI_LPCR)
   -- 20.15.7 DSI Host low-power mode configuration register (DSI_LPMCR)
   -- 20.15.8 DSI Host protocol configuration register (DSI_PCR)
   -- 20.15.9 DSI Host generic VCID register (DSI_GVCIDR)
   -- 20.15.10 DSI Host mode configuration register (DSI_MCR)
   -- 20.15.11 DSI Host video mode configuration register (DSI_VMCR)
   -- 20.15.12 DSI Host video packet configuration register (DSI_VPCR)
   -- 20.15.13 DSI Host video chunks configuration register (DSI_VCCR)
   -- 20.15.14 DSI Host video null packet configuration register (DSI_VNPCR)
   -- 20.15.15 DSI Host video HSA configuration register (DSI_VHSACR)
   -- 20.15.16 DSI Host video HBP configuration register (DSI_VHBPCR)
   -- 20.15.17 DSI Host video line configuration register (DSI_VLCR)
   -- 20.15.18 DSI Host video VSA configuration register (DSI_VVSACR)
   -- 20.15.19 DSI Host video VBP configuration register (DSI_VVBPCR)
   -- 20.15.20 DSI Host video VFP configuration register (DSI_VVFPCR)
   -- 20.15.21 DSI Host video VA configuration register (DSI_VVACR)
   -- 20.15.22 DSI Host LTDC command configuration register (DSI_LCCR)
   -- 20.15.23 DSI Host command mode configuration register (DSI_CMCR)
   -- 20.15.24 DSI Host generic header configuration register (DSI_GHCR)
   -- 20.15.25 DSI Host generic payload data register (DSI_GPDR)
   -- 20.15.26 DSI Host generic packet status register (DSI_GPSR)
   -- 20.15.27 DSI Host timeout counter configuration register 0 (DSI_TCCR0)
   -- 20.15.28 DSI Host timeout counter configuration register 1 (DSI_TCCR1)
   -- 20.15.29 DSI Host timeout counter configuration register 2 (DSI_TCCR2)
   -- 20.15.30 DSI Host timeout counter configuration register 3 (DSI_TCCR3)
   -- 20.15.31 DSI Host timeout counter configuration register 4 (DSI_TCCR4)
   -- 20.15.32 DSI Host timeout counter configuration register 5 (DSI_TCCR5)
   -- 20.15.33 DSI Host clock lane configuration register (DSI_CLCR)
   -- 20.15.34 DSI Host clock lane timer configuration register (DSI_CLTCR)
   -- 20.15.35 DSI Host data lane timer configuration register (DSI_DLTCR)
   -- 20.15.36 DSI Host PHY control register (DSI_PCTLR)
   -- 20.15.37 DSI Host PHY configuration register (DSI_PCONFR)
   -- 20.15.38 DSI Host PHY ULPS control register (DSI_PUCR)
   -- 20.15.39 DSI Host PHY TX triggers configuration register (DSI_PTTCR)
   -- 20.15.40 DSI Host PHY status register (DSI_PSR)
   -- 20.15.41 DSI Host interrupt and status register 0 (DSI_ISR0)
   -- 20.15.42 DSI Host interrupt and status register 1 (DSI_ISR1)
   -- 20.15.43 DSI Host interrupt enable register 0 (DSI_IER0)
   -- 20.15.44 DSI Host interrupt enable register 1 (DSI_IER1)
   -- 20.15.45 DSI Host force interrupt register 0 (DSI_FIR0)
   -- 20.15.46 DSI Host force interrupt register 1 (DSI_FIR1)
   -- 20.15.47 DSI Host video shadow control register (DSI_VSCR)
   -- 20.15.48 DSI Host LTDC current VCID register (DSI_LCVCIDR)
   -- 20.15.49 DSI Host LTDC current color coding register (DSI_LCCCR)
   -- 20.15.50 DSI Host low-power mode current configuration register (DSI_LPMCCR)
   -- 20.15.51 DSI Host video mode current configuration register (DSI_VMCCR)
   -- 20.15.52 DSI Host video packet current configuration register (DSI_VPCCR)
   -- 20.15.53 DSI Host video chunks current configuration register (DSI_VCCCR)
   -- 20.15.54 DSI Host video null packet current configuration register (DSI_VNPCCR)
   -- 20.15.55 DSI Host video HSA current configuration register (DSI_VHSACCR)
   -- 20.15.56 DSI Host video HBP current configuration register (DSI_VHBPCCR)
   -- 20.15.57 DSI Host video line current configuration register (DSI_VLCCR)
   -- 20.15.58 DSI Host video VSA current configuration register (DSI_VVSACCR)
   -- 20.15.59 DSI Host video VBP current configuration register (DSI_VVBPCCR)
   -- 20.15.60 DSI Host video VFP current configuration register (DSI_VVFPCCR)
   -- 20.15.61 DSI Host video VA current configuration register (DSI_VVACCR)

   -- 20.16.1 DSI Wrapper configuration register (DSI_WCFGR)
   -- 20.16.2 DSI Wrapper control register (DSI_WCR)
   -- 20.16.3 DSI Wrapper interrupt enable register (DSI_WIER)
   -- 20.16.4 DSI Wrapper interrupt and status register (DSI_WISR)
   -- 20.16.5 DSI Wrapper interrupt flag clear register (DSI_WIFCR)
   -- 20.16.6 DSI Wrapper PHY configuration register 0 (DSI_WPCR0)
   -- 20.16.7 DSI Wrapper PHY configuration register 1 (DSI_WPCR1)
   -- 20.16.8 DSI Wrapper PHY configuration register 2 (DSI_WPCR2)
   -- 20.16.9 DSI Wrapper PHY configuration register 3 (DSI_WPCR3)
   -- 20.16.10 DSI Wrapper PHY configuration register 4 (DSI_WPCR4)
   -- 20.16.11 DSI Wrapper regulator and PLL control register (DSI_WRPCR)

   ----------------------------------------------------------------------------
   -- 21 JPEG codec (JPEG)
   ----------------------------------------------------------------------------

   -- 21.5.1 JPEG codec control register (JPEG_CONFR0)
   -- 21.5.2 JPEG codec configuration register 1 (JPEG_CONFR1)
   -- 21.5.3 JPEG codec configuration register 2 (JPEG_CONFR2)
   -- 21.5.4 JPEG codec configuration register 3 (JPEG_CONFR3)
   -- 21.5.5 JPEG codec configuration register x (JPEG_CONFRx)
   -- 21.5.6 JPEG control register (JPEG_CR)
   -- 21.5.7 JPEG status register (JPEG_SR)
   -- 21.5.8 JPEG clear flag register (JPEG_CFR)
   -- 21.5.9 JPEG data input register (JPEG_DIR)
   -- 21.5.10 JPEG data output register (JPEG_DOR)
   -- 21.5.11 JPEG quantization memory x (JPEG_QMEMx_y)
   -- 21.5.12 JPEG Huffman min (JPEG_HUFFMINx_y)
   -- 21.5.13 JPEG Huffman min x (JPEG_HUFFMINx_y)
   -- 21.5.14 JPEG Huffman base (JPEG_HUFFBASEx)
   -- 21.5.15 JPEG Huffman symbol (JPEG_HUFFSYMBx)
   -- 21.5.16 JPEG DHT memory (JPEG_DHTMEMx)
   -- 21.5.17 JPEG Huffman encoder ACx (JPEG_HUFFENC_ACx_y)
   -- 21.5.18 JPEG Huffman encoder DCx (JPEG_HUFFENC_DCx_y)

   ----------------------------------------------------------------------------
   -- 22 True random number generator (RNG)
   ----------------------------------------------------------------------------

   -- 22.7.1 RNG control register (RNG_CR)
   -- 22.7.2 RNG status register (RNG_SR)
   -- 22.7.3 RNG data register (RNG_DR)

   ----------------------------------------------------------------------------
   -- 23 Cryptographic processor (CRYP)
   ----------------------------------------------------------------------------

   -- 23.7.1 CRYP control register (CRYP_CR)
   -- 23.7.2 CRYP status register (CRYP_SR)
   -- 23.7.3 CRYP data input register (CRYP_DIN)
   -- 23.7.4 CRYP data output register (CRYP_DOUT)
   -- 23.7.5 CRYP DMA control register (CRYP_DMACR)
   -- 23.7.6 CRYP interrupt mask set/clear register (CRYP_IMSCR)
   -- 23.7.7 CRYP raw interrupt status register (CRYP_RISR)
   -- 23.7.8 CRYP masked interrupt status register (CRYP_MISR)
   -- 23.7.9 CRYP key register 0L (CRYP_K0LR)
   -- 23.7.10 CRYP key register 0R (CRYP_K0RR)
   -- 23.7.11 CRYP key register 1L (CRYP_K1LR)
   -- 23.7.12 CRYP key register 1R (CRYP_K1RR)
   -- 23.7.13 CRYP key register 2L (CRYP_K2LR)
   -- 23.7.14 CRYP key register 2R (CRYP_K2RR)
   -- 23.7.15 CRYP key register 3L (CRYP_K3LR)
   -- 23.7.16 CRYP key register 3R (CRYP_K3RR)
   -- 23.7.17 CRYP initialization vector register 0L (CRYP_IV0LR)
   -- 23.7.18 CRYP initialization vector register 0R (CRYP_IV0RR)
   -- 23.7.19 CRYP initialization vector register 1L (CRYP_IV1LR)
   -- 23.7.20 CRYP initialization vector register 1R (CRYP_IV1RR)

   ----------------------------------------------------------------------------
   -- 24 Hash processor (HASH)
   ----------------------------------------------------------------------------

   -- 24.6.1 HASH control register (HASH_CR)
   -- 24.6.2 HASH data input register (HASH_DIN)
   -- 24.6.3 HASH start register (HASH_STR)
   -- 24.6.4 HASH digest registers
   -- 24.6.5 HASH interrupt enable register (HASH_IMR)
   -- 24.6.6 HASH status register (HASH_SR)
   -- 24.6.7 HASH context swap registers

   ----------------------------------------------------------------------------
   -- 25 Advanced-control timers (TIM1/TIM8)
   ----------------------------------------------------------------------------

   -- 25.4.1 TIMx control register 1 (TIMx_CR1)(x = 1, 8)
   -- 25.4.2 TIMx control register 2 (TIMx_CR2)(x = 1, 8)
   -- 25.4.3 TIMx slave mode control register (TIMx_SMCR)(x = 1, 8)
   -- 25.4.4 TIMx DMA/interrupt enable register (TIMx_DIER)(x = 1, 8)
   -- 25.4.5 TIMx status register (TIMx_SR)(x = 1, 8)
   -- 25.4.6 TIMx event generation register (TIMx_EGR)(x = 1, 8)
   -- 25.4.7 TIMx capture/compare mode register 1 (TIMx_CCMR1)(x = 1, 8)
   -- 25.4.8 TIMx capture/compare mode register 1 [alternate] (TIMx_CCMR1)(x = 1, 8)
   -- 25.4.9 TIMx capture/compare mode register 2 (TIMx_CCMR2)(x = 1, 8)
   -- 25.4.10 TIMx capture/compare mode register 2 [alternate] (TIMx_CCMR2)(x = 1, 8)
   -- 25.4.11 TIMx capture/compare enable register (TIMx_CCER)(x = 1, 8)
   -- 25.4.12 TIMx counter (TIMx_CNT)(x = 1, 8)
   -- 25.4.13 TIMx prescaler (TIMx_PSC)(x = 1, 8)
   -- 25.4.14 TIMx auto-reload register (TIMx_ARR)(x = 1, 8)
   -- 25.4.15 TIMx repetition counter register (TIMx_RCR)(x = 1, 8)
   -- 25.4.16 TIMx capture/compare register 1 (TIMx_CCR1)(x = 1, 8)
   -- 25.4.17 TIMx capture/compare register 2 (TIMx_CCR2)(x = 1, 8)
   -- 25.4.18 TIMx capture/compare register 3 (TIMx_CCR3)(x = 1, 8)
   -- 25.4.19 TIMx capture/compare register 4 (TIMx_CCR4)(x = 1, 8)
   -- 25.4.20 TIMx break and dead-time register (TIMx_BDTR)(x = 1, 8)
   -- 25.4.21 TIMx DMA control register (TIMx_DCR)(x = 1, 8)
   -- 25.4.22 TIMx DMA address for full transfer (TIMx_DMAR)(x = 1, 8)
   -- 25.4.23 TIMx capture/compare mode register 3 (TIMx_CCMR3)(x = 1, 8)
   -- 25.4.24 TIMx capture/compare register 5 (TIMx_CCR5)(x = 1, 8)
   -- 25.4.25 TIMx capture/compare register 6 (TIMx_CCR6)(x = 1, 8)
   -- 25.4.26 TIMx alternate function option register 1 (TIMx_AF1)(x = 1, 8)
   -- 25.4.27 TIMx alternate function option register 2 (TIMx_AF2)(x = 1, 8)

   ----------------------------------------------------------------------------
   -- 26 General-purpose timers (TIM2/TIM3/TIM4/TIM5)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 27 General-purpose timers (TIM9/TIM10/TIM11/TIM12/TIM13/TIM14)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 28 Basic timers (TIM6/TIM7)
   ----------------------------------------------------------------------------

   -- 28.4.1 TIM6/TIM7 control register 1 (TIMx_CR1)

   URS_ANY          : constant := 0; -- Any of the following events generates ...
   URS_COUNTER_OFUF : constant := 1; -- Only counter overflow/underflow generates ..

   type TIMx_CR1_Type is record
      CEN       : Boolean := False;   -- Counter enable
      UDIS      : Boolean := False;   -- Update disable
      URS       : Bits_1  := URS_ANY; -- Update request source
      OPM       : Boolean := False;   -- One-pulse mode
      Reserved1 : Bits_3  := 0;
      ARPE      : Boolean := False;   -- Auto-reload preload enable
      Reserved2 : Bits_3  := 0;
      UIFREMAP  : Boolean := False;   -- UIF status bit remapping
      Reserved3 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for TIMx_CR1_Type use record
      CEN       at 0 range  0 ..  0;
      UDIS      at 0 range  1 ..  1;
      URS       at 0 range  2 ..  2;
      OPM       at 0 range  3 ..  3;
      Reserved1 at 0 range  4 ..  6;
      ARPE      at 0 range  7 ..  7;
      Reserved2 at 0 range  8 .. 10;
      UIFREMAP  at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 15;
   end record;

   -- 28.4.2 TIM6/TIM7 control register 2 (TIMx_CR2)

   MMS_RESET  : constant := 2#000#; -- the UG bit from the TIMx_EGR register is used as a trigger output (TRGO).
   MMS_ENABLE : constant := 2#001#; -- the Counter enable signal, CNT_EN, is used as a trigger output (TRGO).
   MMS_UPDATE : constant := 2#010#; -- The update event is selected as a trigger output (TRGO).

   type TIMx_CR2_Type is record
      Reserved1 : Bits_4 := 0;
      MMS       : Bits_3 := MMS_RESET; -- Master mode selection
      Reserved2 : Bits_9 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for TIMx_CR2_Type use record
      Reserved1 at 0 range 0 ..  3;
      MMS       at 0 range 4 ..  6;
      Reserved2 at 0 range 7 .. 15;
   end record;

   -- 28.4.3 TIM6/TIM7 DMA/Interrupt enable register (TIMx_DIER)

   type TIMx_DIER_Type is record
      UIE       : Boolean := False; -- Update interrupt enable
      Reserved1 : Bits_7  := 0;
      UDE       : Boolean := False; -- Update DMA request enable
      Reserved2 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for TIMx_DIER_Type use record
      UIE       at 0 range 0 ..  0;
      Reserved1 at 0 range 1 ..  7;
      UDE       at 0 range 8 ..  8;
      Reserved2 at 0 range 9 .. 15;
   end record;

   -- 28.4.4 TIM6/TIM7 status register (TIMx_SR)

   type TIMx_SR_Type is record
      UIF      : Boolean := False; -- Update interrupt flag
      Reserved : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for TIMx_SR_Type use record
      UIF      at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 15;
   end record;

   -- 28.4.5 TIM6/TIM7 event generation register (TIMx_EGR)

   type TIMx_EGR_Type is record
      UG       : Boolean := False; -- Update generation
      Reserved : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for TIMx_EGR_Type use record
      UG       at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 15;
   end record;

   -- 28.4.6 TIM6/TIM7 counter (TIMx_CNT)

   type TIMx_CNT_Type is record
      CNT      : Unsigned_16 := 0;     -- Counter value
      Reserved : Bits_15     := 0;
      UIFCPY   : Boolean     := False; -- UIF Copy
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TIMx_CNT_Type use record
      CNT      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 30;
      UIFCPY   at 0 range 31 .. 31;
   end record;

   -- 28.4 TIM6/TIM7 registers

   type Basic_Timers_Type is record
      CR1  : TIMx_CR1_Type  with Volatile_Full_Access => True;
      CR2  : TIMx_CR2_Type  with Volatile_Full_Access => True;
      DIER : TIMx_DIER_Type with Volatile_Full_Access => True;
      SR   : TIMx_SR_Type   with Volatile_Full_Access => True;
      EGR  : TIMx_EGR_Type  with Volatile_Full_Access => True;
      CNT  : TIMx_CNT_Type  with Volatile_Full_Access => True;
      PSC  : Unsigned_16    with Volatile_Full_Access => True;
      ARR  : Unsigned_16    with Volatile_Full_Access => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16#30# * 8;
   for Basic_Timers_Type use record
      CR1  at 16#00# range 0 .. 15;
      CR2  at 16#04# range 0 .. 15;
      DIER at 16#0C# range 0 .. 15;
      SR   at 16#10# range 0 .. 15;
      EGR  at 16#14# range 0 .. 15;
      CNT  at 16#24# range 0 .. 31;
      PSC  at 16#28# range 0 .. 15;
      ARR  at 16#2C# range 0 .. 15;
   end record;

   TIM6_BASEADDRESS : constant := 16#4000_1000#;

   TIM6 : aliased Basic_Timers_Type
      with Address    => System'To_Address (TIM6_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   TIM7_BASEADDRESS : constant := 16#4000_1400#;

   TIM7 : aliased Basic_Timers_Type
      with Address    => System'To_Address (TIM7_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 29 Low-power timer (LPTIM)
   ----------------------------------------------------------------------------

   -- 29.7.1 LPTIM interrupt and status register (LPTIM_ISR)
   -- 29.7.2 LPTIM interrupt clear register (LPTIM_ICR)
   -- 29.7.3 LPTIM interrupt enable register (LPTIM_IER)
   -- 29.7.4 LPTIM configuration register (LPTIM_CFGR)
   -- 29.7.5 LPTIM control register (LPTIM_CR)
   -- 29.7.6 LPTIM compare register (LPTIM_CMP)
   -- 29.7.7 LPTIM autoreload register (LPTIM_ARR)
   -- 29.7.8 LPTIM counter register (LPTIM_CNT)

   ----------------------------------------------------------------------------
   -- 30 Independent watchdog (IWDG)
   ----------------------------------------------------------------------------

   -- 30.4.1 IWDG key register (IWDG_KR)
   -- 30.4.2 IWDG prescaler register (IWDG_PR)
   -- 30.4.3 IWDG reload register (IWDG_RLR)
   -- 30.4.4 IWDG status register (IWDG_SR)
   -- 30.4.5 IWDG window register (IWDG_WINR)

   ----------------------------------------------------------------------------
   -- 31 System window watchdog (WWDG)
   ----------------------------------------------------------------------------

   -- 31.5.1 WWDG control register (WWDG_CR)
   -- 31.5.2 WWDG configuration register (WWDG_CFR)
   -- 31.5.3 WWDG status register (WWDG_SR)

   ----------------------------------------------------------------------------
   -- 32 Real-time clock (RTC)
   ----------------------------------------------------------------------------

   PM_AM : constant := 0; -- AM or 24-hour format
   PM_PM : constant := 1; -- PM

   MSK_MATCH    : constant := 0; -- ??? set if ??? match
   MSK_DONTCARE : constant := 1; -- ??? don’t care in ??? comparison

   WDSEL_DATE    : constant := 0; -- ??? represents the date units
   WDSEL_WEEKDAY : constant := 1; -- ??? represents the week day.

   -- 32.6.1 RTC time register (RTC_TR)

   type RTC_TR_Type is record
      SU        : Bits_4 := 0; -- Second units in BCD format
      ST        : Bits_3 := 0; -- Second tens in BCD format
      Reserved1 : Bits_1 := 0;
      MNU       : Bits_4 := 0; -- Minute units in BCD format
      MNT       : Bits_3 := 0; -- Minute tens in BCD format
      Reserved2 : Bits_1 := 0;
      HU        : Bits_4 := 0; -- Hour units in BCD format
      HT        : Bits_2 := 0; -- Hour tens in BCD format
      PM        : Bits_1 := 0; -- AM/PM notation
      Reserved3 : Bits_9 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_TR_Type use record
      SU        at 0 range  0 ..  3;
      ST        at 0 range  4 ..  6;
      Reserved1 at 0 range  7 ..  7;
      MNU       at 0 range  8 .. 11;
      MNT       at 0 range 12 .. 14;
      Reserved2 at 0 range 15 .. 15;
      HU        at 0 range 16 .. 19;
      HT        at 0 range 20 .. 21;
      PM        at 0 range 22 .. 22;
      Reserved3 at 0 range 23 .. 31;
   end record;

   -- 32.6.2 RTC date register (RTC_DR)

   type RTC_DR_Type is record
      DU        : Bits_4 := 2#0001#; -- Date units in BCD format
      DT        : Bits_2 := 0;       -- Date tens in BCD format
      Reserved1 : Bits_2 := 0;
      MU        : Bits_4 := 2#0001#; -- Month units in BCD format
      MT        : Bits_1 := 0;       -- Month tens in BCD format
      WDU       : Bits_3 := 2#001#;  -- Week day units
      YU        : Bits_4 := 0;       -- Year units in BCD format
      YT        : Bits_4 := 0;       -- Year tens in BCD format
      Reserved2 : Bits_8 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_DR_Type use record
      DU        at 0 range  0 ..  3;
      DT        at 0 range  4 ..  5;
      Reserved1 at 0 range  6 ..  7;
      MU        at 0 range  8 .. 11;
      MT        at 0 range 12 .. 12;
      WDU       at 0 range 13 .. 15;
      YU        at 0 range 16 .. 19;
      YT        at 0 range 20 .. 23;
      Reserved2 at 0 range 24 .. 31;
   end record;

   -- 32.6.3 RTC control register (RTC_CR)

   WUCKSEL_DIV16   : constant := 2#000#; -- RTC/16 clock is selected
   WUCKSEL_DIV8    : constant := 2#001#; -- RTC/8 clock is selected
   WUCKSEL_DIV4    : constant := 2#010#; -- RTC/4 clock is selected
   WUCKSEL_DIV2    : constant := 2#011#; -- RTC/2 clock is selected
   WUCKSEL_SPRE    : constant := 2#100#; -- ck_spre (usually 1 Hz) clock is selected
   WUCKSEL_SPRE216 : constant := 2#110#; -- ck_spre (usually 1 Hz) clock is selected and 216 is added to the WUT counter value

   TSEDGE_RISING  : constant := 0; -- RTC_TS input rising edge generates a time-stamp event
   TSEDGE_FALLING : constant := 1; -- RTC_TS input falling edge generates a time-stamp event

   FMT_24   : constant := 0; -- 24 hour/day format
   FMT_AMPM : constant := 1; -- AM/PM hour format

   COSEL_512 : constant := 0; -- Calibration output is 512 Hz (with default prescaler setting)
   COSEL_1   : constant := 1; -- Calibration output is 1 Hz (with default prescaler setting)

   POL_HI : constant := 0; -- The pin is high when ALRAF/ALRBF/WUTF is asserted (depending on OSEL[1:0])
   POL_LO : constant := 1; -- The pin is low when ALRAF/ALRBF/WUTF is asserted (depending on OSEL[1:0]).

   OSEL_DISABLE : constant := 2#00#; -- Output disabled
   OSEL_ALARMA  : constant := 2#01#; -- Alarm A output enabled
   OSEL_ALARMB  : constant := 2#10#; -- Alarm B output enabled
   OSEL_WAKEUP  : constant := 2#11#; -- Wakeup output enabled

   type RTC_CR_Type is record
      WUCKSEL   : Bits_3  := WUCKSEL_DIV16; -- Wakeup clock selection
      TSEDGE    : Bits_1  := TSEDGE_RISING; -- Time-stamp event active edge
      REFCKON   : Boolean := False;         -- RTC_REFIN reference clock detection enable (50 or 60 Hz)
      BYPSHAD   : Boolean := False;         -- Bypass the shadow registers
      FMT       : Bits_1  := FMT_24;        -- Hour format
      Reserved1 : Bits_1  := 0;
      ALRAE     : Boolean := False;         -- Alarm A enable
      ALRBE     : Boolean := False;         -- Alarm B enable
      WUTE      : Boolean := False;         -- Wakeup timer enable
      TSE       : Boolean := False;         -- timestamp enable
      ALRAIE    : Boolean := False;         -- Alarm A interrupt enable
      ALRBIE    : Boolean := False;         -- Alarm B interrupt enable
      WUTIE     : Boolean := False;         -- Wakeup timer interrupt enable
      TSIE      : Boolean := False;         -- Time-stamp interrupt enable
      ADD1H     : Boolean := False;         -- Add 1 hour (summer time change)
      SUB1H     : Boolean := False;         -- Subtract 1 hour (winter time change)
      BKP       : Boolean := False;         -- Backup
      COSEL     : Bits_1  := COSEL_512;     -- Calibration output selection
      POL       : Bits_1  := POL_HI;        -- Output polarity
      OSEL      : Bits_2  := OSEL_DISABLE;  -- Output selection
      COE       : Boolean := False;         -- Calibration output enable
      ITSE      : Boolean := False;         -- timestamp on internal event enable
      Reserved2 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_CR_Type use record
      WUCKSEL   at 0 range  0 ..  2;
      TSEDGE    at 0 range  3 ..  3;
      REFCKON   at 0 range  4 ..  4;
      BYPSHAD   at 0 range  5 ..  5;
      FMT       at 0 range  6 ..  6;
      Reserved1 at 0 range  7 ..  7;
      ALRAE     at 0 range  8 ..  8;
      ALRBE     at 0 range  9 ..  9;
      WUTE      at 0 range 10 .. 10;
      TSE       at 0 range 11 .. 11;
      ALRAIE    at 0 range 12 .. 12;
      ALRBIE    at 0 range 13 .. 13;
      WUTIE     at 0 range 14 .. 14;
      TSIE      at 0 range 15 .. 15;
      ADD1H     at 0 range 16 .. 16;
      SUB1H     at 0 range 17 .. 17;
      BKP       at 0 range 18 .. 18;
      COSEL     at 0 range 19 .. 19;
      POL       at 0 range 20 .. 20;
      OSEL      at 0 range 21 .. 22;
      COE       at 0 range 23 .. 23;
      ITSE      at 0 range 24 .. 24;
      Reserved2 at 0 range 25 .. 31;
   end record;

   -- 32.6.4 RTC initialization and status register (RTC_ISR)

   INIT_FREERUN  : constant := 0; -- Free running mode
   INIT_INITMODE : constant := 1; -- Initialization mode used to program time and date register (RTC_TR and RTC_DR), and ...

   type RTC_ISR_Type is record
      ALRAWF   : Boolean := True;         -- Alarm A write flag
      ALRBWF   : Boolean := True;         -- Alarm B write flag
      WUTWF    : Boolean := True;         -- Wakeup timer write flag
      SHPF     : Boolean := False;        -- Shift operation pending
      INITS    : Boolean := False;        -- Initialization status flag
      RSF      : Boolean := False;        -- Registers synchronization flag
      INITF    : Boolean := False;        -- Initialization flag
      INIT     : Bits_1  := INIT_FREERUN; -- Initialization mode
      ALRAF    : Boolean := False;        -- Alarm A flag
      ALRBF    : Boolean := False;        -- Alarm B flag
      WUTF     : Boolean := False;        -- Wakeup timer flag
      TSF      : Boolean := False;        -- Time-stamp flag
      TSOVF    : Boolean := False;        -- Time-stamp overflow flag
      TAMP1F   : Boolean := False;        -- RTC_TAMP1 detection flag
      TAMP2F   : Boolean := False;        -- RTC_TAMP2 detection flag
      TAMP3F   : Boolean := False;        -- RTC_TAMP3 detection flag
      RECALPF  : Boolean := False;        -- Recalibration pending Flag
      ITSF     : Boolean := False;        -- Internal tTime-stamp flag
      Reserved : Bits_14 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_ISR_Type use record
      ALRAWF   at 0 range  0 ..  0;
      ALRBWF   at 0 range  1 ..  1;
      WUTWF    at 0 range  2 ..  2;
      SHPF     at 0 range  3 ..  3;
      INITS    at 0 range  4 ..  4;
      RSF      at 0 range  5 ..  5;
      INITF    at 0 range  6 ..  6;
      INIT     at 0 range  7 ..  7;
      ALRAF    at 0 range  8 ..  8;
      ALRBF    at 0 range  9 ..  9;
      WUTF     at 0 range 10 .. 10;
      TSF      at 0 range 11 .. 11;
      TSOVF    at 0 range 12 .. 12;
      TAMP1F   at 0 range 13 .. 13;
      TAMP2F   at 0 range 14 .. 14;
      TAMP3F   at 0 range 15 .. 15;
      RECALPF  at 0 range 16 .. 16;
      ITSF     at 0 range 17 .. 17;
      Reserved at 0 range 18 .. 31;
   end record;

   -- 32.6.5 RTC prescaler register (RTC_PRER)

   type RTC_PRER_Type is record
      PREDIV_S  : Bits_15 := 16#FF#; -- Synchronous prescaler factor
      Reserved1 : Bits_1  := 0;
      PREDIV_A  : Bits_7  := 16#7F#; -- Asynchronous prescaler factor
      Reserved2 : Bits_9  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_PRER_Type use record
      PREDIV_S  at 0 range  0 .. 14;
      Reserved1 at 0 range 15 .. 15;
      PREDIV_A  at 0 range 16 .. 22;
      Reserved2 at 0 range 23 .. 31;
   end record;

   -- 32.6.6 RTC wakeup timer register (RTC_WUTR)

   type RTC_WUTR_Type is record
      WUT      : Bits_16 := 16#FFFF#; -- Wakeup auto-reload value bits
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_WUTR_Type use record
      WUT      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 32.6.7 RTC alarm A register (RTC_ALRMAR)
   -- 32.6.8 RTC alarm B register (RTC_ALRMBR)

   type RTC_ALRMxR_Type is record
      SU    : Bits_4 := 0; -- Second units in BCD format.
      ST    : Bits_3 := 0; -- Second tens in BCD format.
      MSK1  : Bits_1 := 0; -- Alarm x seconds mask
      MNU   : Bits_4 := 0; -- Minute units in BCD format.
      MNT   : Bits_3 := 0; -- Minute tens in BCD format.
      MSK2  : Bits_1 := 0; -- Alarm x minutes mask
      HU    : Bits_4 := 0; -- Hour units in BCD format.
      HT    : Bits_2 := 0; -- Hour tens in BCD format.
      PM    : Bits_1 := 0; -- AM/PM notation
      MSK3  : Bits_1 := 0; -- Alarm x hours mask
      DU    : Bits_4 := 0; -- Date units or day in BCD format.
      DT    : Bits_2 := 0; -- Date tens in BCD format.
      WDSEL : Bits_1 := 0; -- Week day selection
      MSK4  : Bits_1 := 0; -- Alarm x date mask
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_ALRMxR_Type use record
      SU    at 0 range  0 ..  3;
      ST    at 0 range  4 ..  6;
      MSK1  at 0 range  7 ..  7;
      MNU   at 0 range  8 .. 11;
      MNT   at 0 range 12 .. 14;
      MSK2  at 0 range 15 .. 15;
      HU    at 0 range 16 .. 19;
      HT    at 0 range 20 .. 21;
      PM    at 0 range 22 .. 22;
      MSK3  at 0 range 23 .. 23;
      DU    at 0 range 24 .. 27;
      DT    at 0 range 28 .. 29;
      WDSEL at 0 range 30 .. 30;
      MSK4  at 0 range 31 .. 31;
   end record;

   -- 32.6.9 RTC write protection register (RTC_WPR)

   KEY_KEY1 : constant := 16#CA#;
   KEY_KEY2 : constant := 16#53#;

   type RTC_WPR_Type is record
      KEY      : Unsigned_8;      -- Write protection key
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_WPR_Type use record
      KEY      at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 32.6.10 RTC sub second register (RTC_SSR)

   type RTC_SSR_Type is record
      SS       : Unsigned_16; -- Sub second value
      Reserved : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_SSR_Type use record
      SS       at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 32.6.11 RTC shift control register (RTC_SHIFTR)

   type RTC_SHIFTR_Type is record
      SUBFS    : Bits_15 := 0;     -- Subtract a fraction of a second
      Reserved : Bits_16 := 0;
      ADD1S    : Boolean := False; -- Add one second
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_SHIFTR_Type use record
      SUBFS    at 0 range  0 .. 14;
      Reserved at 0 range 15 .. 30;
      ADD1S    at 0 range 31 .. 31;
   end record;

   -- 32.6.12 RTC timestamp time register (RTC_TSTR)

   type RTC_TSTR_Type is record
      SU        : Bits_4; -- Second units in BCD format.
      ST        : Bits_3; -- Second tens in BCD format.
      Reserved1 : Bits_1;
      MNU       : Bits_4; -- Minute units in BCD format.
      MNT       : Bits_3; -- Minute tens in BCD format.
      Reserved2 : Bits_1;
      HU        : Bits_4; -- Hour units in BCD format.
      HT        : Bits_2; -- Hour tens in BCD format.
      PM        : Bits_1; -- AM/PM notation
      Reserved3 : Bits_9;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_TSTR_Type use record
      SU        at 0 range  0 ..  3;
      ST        at 0 range  4 ..  6;
      Reserved1 at 0 range  7 ..  7;
      MNU       at 0 range  8 .. 11;
      MNT       at 0 range 12 .. 14;
      Reserved2 at 0 range 15 .. 15;
      HU        at 0 range 16 .. 19;
      HT        at 0 range 20 .. 21;
      PM        at 0 range 22 .. 22;
      Reserved3 at 0 range 23 .. 31;
   end record;

   -- 32.6.13 RTC timestamp date register (RTC_TSDR)

   type RTC_TSDR_Type is record
      DU        : Bits_4; -- Date units in BCD format
      DT        : Bits_2; -- Date tens in BCD format
      Reserved1 : Bits_2;
      MU        : Bits_4; -- Month units in BCD format
      MT        : Bits_1; -- Month tens in BCD format
      WDU       : Bits_3; -- Week day units
      YU        : Bits_4; -- Year units in BCD format
      YT        : Bits_4; -- Year tens in BCD format
      Reserved2 : Bits_8;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_TSDR_Type use record
      DU        at 0 range  0 ..  3;
      DT        at 0 range  4 ..  5;
      Reserved1 at 0 range  6 ..  7;
      MU        at 0 range  8 .. 11;
      MT        at 0 range 12 .. 12;
      WDU       at 0 range 13 .. 15;
      YU        at 0 range 16 .. 19;
      YT        at 0 range 20 .. 23;
      Reserved2 at 0 range 24 .. 31;
   end record;

   -- 32.6.14 RTC time-stamp sub second register (RTC_TSSSR)

   type RTC_TSSSR_Type is record
      SS       : Unsigned_16; -- Sub second value
      Reserved : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_TSSSR_Type use record
      SS       at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 32.6.15 RTC calibration register (RTC_CALR)

   type RTC_CALR_Type is record
      CALM      : Bits_9  := 0;     -- Calibration minus
      Reserved1 : Bits_4  := 0;
      CALW16    : Boolean := False; -- Use a 16-second calibration cycle period
      CALW8     : Boolean := False; -- Use an 8-second calibration cycle period
      CALP      : Boolean := False; -- Increase frequency of RTC by 488.5 ppm
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_CALR_Type use record
      CALM      at 0 range  0 ..  8;
      Reserved1 at 0 range  9 .. 12;
      CALW16    at 0 range 13 .. 13;
      CALW8     at 0 range 14 .. 14;
      CALP      at 0 range 15 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   -- 32.6.16 RTC tamper configuration register (RTC_TAMPCR)

   TAMPxTRG_LO      : constant := 0; -- RTC_TAMPx input staying low triggers a tamper detection event.
   TAMPxTRG_HI      : constant := 1; -- RTC_TAMPx input staying high triggers a tamper detection event.
   TAMPxTRG_RISING  : constant := 0; -- RTC_TAMPx input rising edge triggers a tamper detection event.
   TAMPxTRG_FALLING : constant := 1; -- RTC_TAMPx input falling edge triggers a tamper detection event.

   TAMPFREQ_DIV32k : constant := 16#0#; -- RTCCLK / 32768 (1 Hz when RTCCLK = 32768 Hz)
   TAMPFREQ_DIV16k : constant := 16#1#; -- RTCCLK / 16384 (2 Hz when RTCCLK = 32768 Hz)
   TAMPFREQ_DIV8k  : constant := 16#2#; -- RTCCLK / 8192 (4 Hz when RTCCLK = 32768 Hz)
   TAMPFREQ_DIV4k  : constant := 16#3#; -- RTCCLK / 4096 (8 Hz when RTCCLK = 32768 Hz)
   TAMPFREQ_DIV2k  : constant := 16#4#; -- RTCCLK / 2048 (16 Hz when RTCCLK = 32768 Hz)
   TAMPFREQ_DIV1k  : constant := 16#5#; -- RTCCLK / 1024 (32 Hz when RTCCLK = 32768 Hz)
   TAMPFREQ_DIV512 : constant := 16#6#; -- RTCCLK / 512 (64 Hz when RTCCLK = 32768 Hz)
   TAMPFREQ_DIV256 : constant := 16#7#; -- RTCCLK / 256 (128 Hz when RTCCLK = 32768 Hz)

   TAMPFLT_EDGE : constant := 16#0#; -- Tamper event is activated on edge of RTC_TAMPx input transitions ...
   TAMPFLT_SMP2 : constant := 16#1#; -- Tamper event is activated after 2 consecutive samples at the active level.
   TAMPFLT_SMP4 : constant := 16#2#; -- Tamper event is activated after 4 consecutive samples at the active level.
   TAMPFLT_SMP8 : constant := 16#3#; -- Tamper event is activated after 8 consecutive samples at the active level.

   TAMPPRCH_CYC1 : constant := 16#0#; -- 1 RTCCLK cycle
   TAMPPRCH_CYC2 : constant := 16#1#; -- 2 RTCCLK cycles
   TAMPPRCH_CYC4 : constant := 16#2#; -- 4 RTCCLK cycles
   TAMPPRCH_CYC8 : constant := 16#3#; -- 8 RTCCLK cycles

   type RTC_TAMPCR_Type is record
      TAMP1E       : Boolean := False;           -- RTC_TAMP1 input detection enable
      TAMP1TRG     : Bits_1  := TAMPxTRG_LO;     -- Active level for RTC_TAMP1 input
      TAMPIE       : Boolean := False;           -- Tamper interrupt enable
      TAMP2E       : Boolean := False;           -- RTC_TAMP2 input detection enable
      TAMP2TRG     : Bits_1  := TAMPxTRG_LO;     -- Active level for RTC_TAMP2 input
      TAMP3E       : Boolean := False;           -- RTC_TAMP3 detection enable
      TAMP3TRG     : Bits_1  := TAMPxTRG_LO;     -- Active level for RTC_TAMP3 input
      TAMPTS       : Boolean := False;           -- Activate timestamp on tamper detection event
      TAMPFREQ     : Bits_3  := TAMPFREQ_DIV32k; -- Tamper sampling frequency
      TAMPFLT      : Bits_2  := TAMPFLT_EDGE;    -- RTC_TAMPx filter count
      TAMPPRCH     : Bits_2  := TAMPPRCH_CYC1;   -- RTC_TAMPx precharge duration
      TAMPPUDIS    : Boolean := False;           -- RTC_TAMPx pull-up disable
      TAMP1IE      : Boolean := False;           -- Tamper 1 interrupt enable
      TAMP1NOERASE : Boolean := False;           -- Tamper 1 no erase
      TAMP1MF      : Boolean := False;           -- Tamper 1 mask flag
      TAMP2IE      : Boolean := False;           -- Tamper 2 interrupt enable
      TAMP2NOERASE : Boolean := False;           -- Tamper 2 no erase
      TAMP2MF      : Boolean := False;           -- Tamper 2 mask flag
      TAMP3IE      : Boolean := False;           -- Tamper 3 interrupt enable
      TAMP3NOERASE : Boolean := False;           -- Tamper 3 no erase
      TAMP3MF      : Boolean := False;           -- Tamper 3 mask flag
      Reserved     : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_TAMPCR_Type use record
      TAMP1E       at 0 range  0 ..  0;
      TAMP1TRG     at 0 range  1 ..  1;
      TAMPIE       at 0 range  2 ..  2;
      TAMP2E       at 0 range  3 ..  3;
      TAMP2TRG     at 0 range  4 ..  4;
      TAMP3E       at 0 range  5 ..  5;
      TAMP3TRG     at 0 range  6 ..  6;
      TAMPTS       at 0 range  7 ..  7;
      TAMPFREQ     at 0 range  8 .. 10;
      TAMPFLT      at 0 range 11 .. 12;
      TAMPPRCH     at 0 range 13 .. 14;
      TAMPPUDIS    at 0 range 15 .. 15;
      TAMP1IE      at 0 range 16 .. 16;
      TAMP1NOERASE at 0 range 17 .. 17;
      TAMP1MF      at 0 range 18 .. 18;
      TAMP2IE      at 0 range 19 .. 19;
      TAMP2NOERASE at 0 range 20 .. 20;
      TAMP2MF      at 0 range 21 .. 21;
      TAMP3IE      at 0 range 22 .. 22;
      TAMP3NOERASE at 0 range 23 .. 23;
      TAMP3MF      at 0 range 24 .. 24;
      Reserved     at 0 range 25 .. 31;
   end record;

   -- 32.6.17 RTC alarm A sub second register (RTC_ALRMASSR)
   -- 32.6.18 RTC alarm B sub second register (RTC_ALRMBSSR)

   type RTC_ALRMxSSR_Type is record
      SS        : Bits_15 := 0; -- Sub seconds value
      Reserved1 : Bits_9  := 0;
      MASKSS    : Bits_4  := 0; -- Mask the most-significant bits starting at this bit
      Reserved2 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_ALRMxSSR_Type use record
      SS        at 0 range  0 .. 14;
      Reserved1 at 0 range 15 .. 23;
      MASKSS    at 0 range 24 .. 27;
      Reserved2 at 0 range 28 .. 31;
   end record;

   -- 32.6.19 RTC option register (RTC_OR)

   TSINSEL_PC13   : constant := 2#00#; -- TIMESTAMP is mapped on PC13
   TSINSEL_PI8    : constant := 2#01#; -- TIMESTAMP is mapped on PI8
   TSINSEL_PC1    : constant := 2#10#; -- TIMESTAMP is mapped on PC1
   TSINSEL_PC1ALT : constant := 2#11#; -- TIMESTAMP is mapped on PC1

   RTC_ALARM_TYPE_OD : constant := 0; -- RTC_ALARM, when mapped on PC13, is open-drain output
   RTC_ALARM_TYPE_PP : constant := 1; -- RTC_ALARM, when mapped on PC13, is push-pull output

   type RTC_OR_Type is record
      Reserved1      : Bits_1  := 0;
      TSINSEL        : Bits_2  := TSINSEL_PC13;      -- TIMESTAMP mapping
      RTC_ALARM_TYPE : Bits_1  := RTC_ALARM_TYPE_OD; -- RTC_ALARM on PC13 output type
      Reserved2      : Bits_28 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_OR_Type use record
      Reserved1      at 0 range 0 ..  0;
      TSINSEL        at 0 range 1 ..  2;
      RTC_ALARM_TYPE at 0 range 3 ..  3;
      Reserved2      at 0 range 4 .. 31;
   end record;

   -- 32.6.20 RTC backup registers (RTC_BKPxR)

   type RTC_BKPxR_Type is array (0 .. 31) of Unsigned_32
      with Pack                => True,
           Volatile_Components => True;

   -- 32.6 RTC registers

   RTC_TR_ADDRESS : constant := 16#4000_2800#;

   RTC_TR : aliased RTC_TR_Type
      with Address              => System'To_Address (RTC_TR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_DR_ADDRESS : constant := 16#4000_2804#;

   RTC_DR : aliased RTC_DR_Type
      with Address              => System'To_Address (RTC_DR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_CR_ADDRESS : constant := 16#4000_2808#;

   RTC_CR : aliased RTC_CR_Type
      with Address              => System'To_Address (RTC_CR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_ISR_ADDRESS : constant := 16#4000_280C#;

   RTC_ISR : aliased RTC_ISR_Type
      with Address              => System'To_Address (RTC_ISR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_PRER_ADDRESS : constant := 16#4000_2810#;

   RTC_PRER : aliased RTC_PRER_Type
      with Address              => System'To_Address (RTC_PRER_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_WUTR_ADDRESS : constant := 16#4000_2814#;

   RTC_WUTR : aliased RTC_WUTR_Type
      with Address              => System'To_Address (RTC_WUTR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_ALRMAR_ADDRESS : constant := 16#4000_281C#;

   RTC_ALRMAR : aliased RTC_ALRMxR_Type
      with Address              => System'To_Address (RTC_ALRMAR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_ALRMBR_ADDRESS : constant := 16#4000_2820#;

   RTC_ALRMBR : aliased RTC_ALRMxR_Type
      with Address              => System'To_Address (RTC_ALRMBR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_WPR_ADDRESS : constant := 16#4000_2824#;

   RTC_WPR : aliased RTC_WPR_Type
      with Address              => System'To_Address (RTC_WPR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_SSR_ADDRESS : constant := 16#4000_2828#;

   RTC_SSR : aliased RTC_SSR_Type
      with Address              => System'To_Address (RTC_SSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_SHIFTR_ADDRESS : constant := 16#4000_282C#;

   RTC_SHIFTR : aliased RTC_SHIFTR_Type
      with Address              => System'To_Address (RTC_SHIFTR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_TSTR_ADDRESS : constant := 16#4000_2830#;

   RTC_TSTR : aliased RTC_TSTR_Type
      with Address              => System'To_Address (RTC_TSTR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_TSDR_ADDRESS : constant := 16#4000_2834#;

   RTC_TSDR : aliased RTC_TSDR_Type
      with Address              => System'To_Address (RTC_TSDR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_TSSSR_ADDRESS : constant := 16#4000_2838#;

   RTC_TSSSR : aliased RTC_TSSSR_Type
      with Address              => System'To_Address (RTC_TSSSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_CALR_ADDRESS : constant := 16#4000_283C#;

   RTC_CALR : aliased RTC_CALR_Type
      with Address              => System'To_Address (RTC_CALR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_TAMPCR_ADDRESS : constant := 16#4000_2840#;

   RTC_TAMPCR : aliased RTC_TAMPCR_Type
      with Address              => System'To_Address (RTC_TAMPCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_ALRMASSR_ADDRESS : constant := 16#4000_2844#;

   RTC_ALRMASSR : aliased RTC_ALRMxSSR_Type
      with Address              => System'To_Address (RTC_ALRMASSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_ALRMBSSR_ADDRESS : constant := 16#4000_2848#;

   RTC_ALRMBSSR : aliased RTC_ALRMxSSR_Type
      with Address              => System'To_Address (RTC_ALRMBSSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_OR_ADDRESS : constant := 16#4000_284C#;

   RTC_OR : aliased RTC_OR_Type
      with Address              => System'To_Address (RTC_OR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTC_BKPR_ADDRESS : constant := 16#4000_2850#;

   RTC_BKPR : RTC_BKPxR_Type
      with Address    => System'To_Address (RTC_BKPR_ADDRESS),
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 33 Inter-integrated circuit (I2C) interface
   ----------------------------------------------------------------------------

   -- 33.7.1 I2C control register 1 (I2C_CR1)

   DNF_DISABLED : constant := 2#0000#; -- Digital filter disabled
   DNF_1        : constant := 2#0001#; -- Digital filter enabled and filtering capability up to 1 tI2CCLK
   DNF_2        : constant := 2#0010#; -- Digital filter enabled and filtering capability up to 2 tI2CCLK
   DNF_3        : constant := 2#0011#; -- Digital filter enabled and filtering capability up to 3 tI2CCLK
   DNF_4        : constant := 2#0100#; -- Digital filter enabled and filtering capability up to 4 tI2CCLK
   DNF_5        : constant := 2#0101#; -- Digital filter enabled and filtering capability up to 5 tI2CCLK
   DNF_6        : constant := 2#0110#; -- Digital filter enabled and filtering capability up to 6 tI2CCLK
   DNF_7        : constant := 2#0111#; -- Digital filter enabled and filtering capability up to 7 tI2CCLK
   DNF_8        : constant := 2#1000#; -- Digital filter enabled and filtering capability up to 8 tI2CCLK
   DNF_9        : constant := 2#1001#; -- Digital filter enabled and filtering capability up to 9 tI2CCLK
   DNF_10       : constant := 2#1010#; -- Digital filter enabled and filtering capability up to 10 tI2CCLK
   DNF_11       : constant := 2#1011#; -- Digital filter enabled and filtering capability up to 11 tI2CCLK
   DNF_12       : constant := 2#1100#; -- Digital filter enabled and filtering capability up to 12 tI2CCLK
   DNF_13       : constant := 2#1101#; -- Digital filter enabled and filtering capability up to 13 tI2CCLK
   DNF_14       : constant := 2#1110#; -- Digital filter enabled and filtering capability up to 14 tI2CCLK
   DNF_15       : constant := 2#1111#; -- digital filter enabled and filtering capability up to15 tI2CCLK

   type I2C_CR1_Type is record
      PE        : Boolean := False;        -- Peripheral enable
      TXIE      : Boolean := False;        -- TX Interrupt enable
      RXIE      : Boolean := False;        -- RX Interrupt enable
      ADDRIE    : Boolean := False;        -- Address match Interrupt enable (slave only)
      NACKIE    : Boolean := False;        -- Not acknowledge received Interrupt enable
      STOPIE    : Boolean := False;        -- STOP detection Interrupt enable
      TCIE      : Boolean := False;        -- Transfer Complete interrupt enable
      ERRIE     : Boolean := False;        -- Error interrupts enable
      DNF       : Bits_4  := DNF_DISABLED; -- Digital noise filter
      ANFOFF    : Boolean := False;        -- Analog noise filter OFF
      Reserved1 : Bits_1  := 0;
      TXDMAEN   : Boolean := False;        -- DMA transmission requests enable
      RXDMAEN   : Boolean := False;        -- DMA reception requests enable
      SBC       : Boolean := False;        -- Slave byte control
      NOSTRETCH : Boolean := False;        -- Clock stretching disable
      Reserved2 : Bits_1  := 0;
      GCEN      : Boolean := False;        -- General call enable
      SMBHEN    : Boolean := False;        -- SMBus Host address enable
      SMBDEN    : Boolean := False;        -- SMBus Device Default address enable
      ALERTEN   : Boolean := False;        -- SMBus alert enable
      PECEN     : Boolean := False;        -- PEC enable
      Reserved3 : Bits_8  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for I2C_CR1_Type use record
      PE        at 0 range  0 ..  0;
      TXIE      at 0 range  1 ..  1;
      RXIE      at 0 range  2 ..  2;
      ADDRIE    at 0 range  3 ..  3;
      NACKIE    at 0 range  4 ..  4;
      STOPIE    at 0 range  5 ..  5;
      TCIE      at 0 range  6 ..  6;
      ERRIE     at 0 range  7 ..  7;
      DNF       at 0 range  8 .. 11;
      ANFOFF    at 0 range 12 .. 12;
      Reserved1 at 0 range 13 .. 13;
      TXDMAEN   at 0 range 14 .. 14;
      RXDMAEN   at 0 range 15 .. 15;
      SBC       at 0 range 16 .. 16;
      NOSTRETCH at 0 range 17 .. 17;
      Reserved2 at 0 range 18 .. 18;
      GCEN      at 0 range 19 .. 19;
      SMBHEN    at 0 range 20 .. 20;
      SMBDEN    at 0 range 21 .. 21;
      ALERTEN   at 0 range 22 .. 22;
      PECEN     at 0 range 23 .. 23;
      Reserved3 at 0 range 24 .. 31;
   end record;

   -- 33.7.2 I2C control register 2 (I2C_CR2)

   RD_WRN_WRITE : constant := 0; -- Master requests a write transfer.
   RD_WRN_READ  : constant := 1; -- Master requests a read transfer.

   HEAD10R_COMPLETE : constant := 0; -- The master sends the complete 10 bit slave address read sequence: Start + 2 bytes 10bit address in write direction + Restart + 1st 7 bits of the 10 bit address in read direction.
   HEAD10R_BIT7READ : constant := 1; -- The master only sends the 1st 7 bits of the 10 bit address, followed by Read direction.

   type I2C_CR2_Type is record
      SADD     : Bits_10    := 0;                -- Slave address bit(s)
      RD_WRN   : Bits_1     := RD_WRN_WRITE;     -- Transfer direction (master mode)
      ADD10    : Boolean    := False;            -- 10-bit addressing mode (master mode)
      HEAD10R  : Bits_1     := HEAD10R_COMPLETE; -- 10-bit address header only read direction (master receiver mode)
      START    : Boolean    := False;            -- Start generation
      STOP     : Boolean    := False;            -- Stop generation (master mode)
      NACK     : Boolean    := False;            -- NACK generation (slave mode)
      NBYTES   : Unsigned_8 := 0;                -- Number of bytes
      RELOAD   : Boolean    := False;            -- NBYTES reload mode
      AUTOEND  : Boolean    := False;            -- Automatic end mode (master mode)
      PECBYTE  : Boolean    := False;            -- Packet error checking byte
      Reserved : Bits_5     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for I2C_CR2_Type use record
      SADD     at 0 range  0 ..  9;
      RD_WRN   at 0 range 10 .. 10;
      ADD10    at 0 range 11 .. 11;
      HEAD10R  at 0 range 12 .. 12;
      START    at 0 range 13 .. 13;
      STOP     at 0 range 14 .. 14;
      NACK     at 0 range 15 .. 15;
      NBYTES   at 0 range 16 .. 23;
      RELOAD   at 0 range 24 .. 24;
      AUTOEND  at 0 range 25 .. 25;
      PECBYTE  at 0 range 26 .. 26;
      Reserved at 0 range 27 .. 31;
   end record;

   -- 33.7.3 I2C own address 1 register (I2C_OAR1)

   OA1MODE_7  : constant := 0; -- Own address 1 is a 7-bit address.
   OA1MODE_10 : constant := 1; -- Own address 1 is a 10-bit address.

   type I2C_OAR1_Type is record
      OA1       : Bits_10 := 0;         -- Own Address 1
      OA1MODE   : Bits_1  := OA1MODE_7; -- Own Address 1 10-bit mode
      Reserved1 : Bits_4  := 0;
      OA1EN     : Boolean := False;     -- Own Address 1 enable
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for I2C_OAR1_Type use record
      OA1       at 0 range  0 ..  9;
      OA1MODE   at 0 range 10 .. 10;
      Reserved1 at 0 range 11 .. 14;
      OA1EN     at 0 range 15 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   -- 33.7.4 I2C own address 2 register (I2C_OAR2)

   OA2MSK_NONE : constant := 2#000#; -- No mask
   OA2MSK_11   : constant := 2#001#; -- OA2[1] is masked and don’t care. Only OA2[7:2] are compared.
   OA2MSK_21   : constant := 2#010#; -- OA2[2:1] are masked and don’t care. Only OA2[7:3] are compared.
   OA2MSK_31   : constant := 2#011#; -- OA2[3:1] are masked and don’t care. Only OA2[7:4] are compared.
   OA2MSK_41   : constant := 2#100#; -- OA2[4:1] are masked and don’t care. Only OA2[7:5] are compared.
   OA2MSK_51   : constant := 2#101#; -- OA2[5:1] are masked and don’t care. Only OA2[7:6] are compared.
   OA2MSK_61   : constant := 2#110#; -- OA2[6:1] are masked and don’t care. Only OA2[7] is compared.
   OA2MSK_ALL  : constant := 2#111#; -- OA2[7:1] are masked and don’t care. No comparison is done, and all (except reserved) 7-bit received addresses are acknowledged.

   type I2C_OAR2_Type is record
      Reserved1 : Bits_1  := 0;
      OA2       : Bits_7  := 0;           -- Interface address
      OA2MSK    : Bits_3  := OA2MSK_NONE; -- Own Address 2 masks
      Reserved2 : Bits_4  := 0;
      OA2EN     : Boolean := False;       -- Own Address 2 enable
      Reserved3 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for I2C_OAR2_Type use record
      Reserved1 at 0 range  0 ..  0;
      OA2       at 0 range  1 ..  7;
      OA2MSK    at 0 range  8 .. 10;
      Reserved2 at 0 range 11 .. 14;
      OA2EN     at 0 range 15 .. 15;
      Reserved3 at 0 range 16 .. 31;
   end record;

   -- 33.7.5 I2C timing register (I2C_TIMINGR)

   type I2C_TIMINGR_Type is record
      SCLL     : Bits_8 := 0; -- SCL low period (master mode)
      SCLH     : Bits_8 := 0; -- SCL high period (master mode)
      SDADEL   : Bits_4 := 0; -- Data hold time
      SCLDEL   : Bits_4 := 0; -- Data setup time
      Reserved : Bits_4 := 0;
      PRESC    : Bits_4 := 0; -- Timing prescaler
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for I2C_TIMINGR_Type use record
      SCLL     at 0 range  0 ..  7;
      SCLH     at 0 range  8 .. 15;
      SDADEL   at 0 range 16 .. 19;
      SCLDEL   at 0 range 20 .. 23;
      Reserved at 0 range 24 .. 27;
      PRESC    at 0 range 28 .. 31;
   end record;

   -- 33.7.6 I2C timeout register (I2C_TIMEOUTR)

   TIDLE_TOUTASCLLOW     : constant := 0; -- TIMEOUTA is used to detect SCL low timeout
   TIDLE_TOUTASCLSDAHIGH : constant := 1; -- TIMEOUTA is used to detect both SCL and SDA high timeout (bus idle condition)

   type I2C_TIMEOUTR_Type is record
      TIMEOUTA  : Bits_12 := 0;                 -- Bus Timeout A
      TIDLE     : Bits_1  := TIDLE_TOUTASCLLOW; -- Idle clock timeout detection
      Reserved1 : Bits_2  := 0;
      TIMOUTEN  : Boolean := False;             -- Clock timeout enable
      TIMEOUTB  : Bits_12 := 0;                 -- Bus timeout B
      Reserved2 : Bits_3  := 0;
      TEXTEN    : Boolean := False;             -- Extended clock timeout enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for I2C_TIMEOUTR_Type use record
      TIMEOUTA  at 0 range  0 .. 11;
      TIDLE     at 0 range 12 .. 12;
      Reserved1 at 0 range 13 .. 14;
      TIMOUTEN  at 0 range 15 .. 15;
      TIMEOUTB  at 0 range 16 .. 27;
      Reserved2 at 0 range 28 .. 30;
      TEXTEN    at 0 range 31 .. 31;
   end record;

   -- 33.7.7 I2C interrupt and status register (I2C_ISR)

   DIR_WRITE : constant := 0; -- Write transfer, slave enters receiver mode.
   DIR_READ  : constant := 1; -- Read transfer, slave enters transmitter mode.

   type I2C_ISR_Type is record
      TXE       : Boolean := False;     -- Transmit data register empty (transmitters)
      TXIS      : Boolean := False;     -- Transmit interrupt status (transmitters)
      RXNE      : Boolean := False;     -- Receive data register not empty (receivers)
      ADDR      : Boolean := False;     -- Address matched (slave mode)
      NACKF     : Boolean := False;     -- Not Acknowledge received flag
      STOPF     : Boolean := False;     -- Stop detection flag
      TC        : Boolean := False;     -- Transfer Complete (master mode)
      TCR       : Boolean := False;     -- Transfer Complete Reload
      BERR      : Boolean := False;     -- Bus error
      ARLO      : Boolean := False;     -- Arbitration lost
      OVR       : Boolean := False;     -- Overrun/Underrun (slave mode)
      PECERR    : Boolean := False;     -- PEC Error in reception
      TIMEOUT   : Boolean := False;     -- Timeout or tLOW detection flag
      ALERT     : Boolean := False;     -- SMBus alert
      Reserved1 : Bits_1  := 0;
      BUSY      : Boolean := False;     -- Bus busy
      DIR       : Bits_1  := DIR_WRITE; -- Transfer direction (Slave mode)
      ADDCODE   : Bits_7  := 0;         -- Address match code (Slave mode)
      Reserved2 : Bits_8  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for I2C_ISR_Type use record
      TXE       at 0 range  0 ..  0;
      TXIS      at 0 range  1 ..  1;
      RXNE      at 0 range  2 ..  2;
      ADDR      at 0 range  3 ..  3;
      NACKF     at 0 range  4 ..  4;
      STOPF     at 0 range  5 ..  5;
      TC        at 0 range  6 ..  6;
      TCR       at 0 range  7 ..  7;
      BERR      at 0 range  8 ..  8;
      ARLO      at 0 range  9 ..  9;
      OVR       at 0 range 10 .. 10;
      PECERR    at 0 range 11 .. 11;
      TIMEOUT   at 0 range 12 .. 12;
      ALERT     at 0 range 13 .. 13;
      Reserved1 at 0 range 14 .. 14;
      BUSY      at 0 range 15 .. 15;
      DIR       at 0 range 16 .. 16;
      ADDCODE   at 0 range 17 .. 23;
      Reserved2 at 0 range 24 .. 31;
   end record;

   -- 33.7.8 I2C interrupt clear register (I2C_ICR)

   type I2C_ICR_Type is record
      Reserved1 : Bits_3  := 0;
      ADDRCF    : Boolean := False; -- Address matched flag clear
      NACKCF    : Boolean := False; -- Not Acknowledge flag clear
      STOPCF    : Boolean := False; -- Stop detection flag clear
      Reserved2 : Bits_2  := 0;
      BERRCF    : Boolean := False; -- Bus error flag clear
      ARLOCF    : Boolean := False; -- Arbitration Lost flag clear
      OVRCF     : Boolean := False; -- Overrun/Underrun flag clear
      PECCF     : Boolean := False; -- PEC Error flag clear
      TIMOUTCF  : Boolean := False; -- Timeout detection flag clear
      ALERTCF   : Boolean := False; -- Alert flag clear
      Reserved3 : Bits_18 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for I2C_ICR_Type use record
      Reserved1 at 0 range  0 ..  2;
      ADDRCF    at 0 range  3 ..  3;
      NACKCF    at 0 range  4 ..  4;
      STOPCF    at 0 range  5 ..  5;
      Reserved2 at 0 range  6 ..  7;
      BERRCF    at 0 range  8 ..  8;
      ARLOCF    at 0 range  9 ..  9;
      OVRCF     at 0 range 10 .. 10;
      PECCF     at 0 range 11 .. 11;
      TIMOUTCF  at 0 range 12 .. 12;
      ALERTCF   at 0 range 13 .. 13;
      Reserved3 at 0 range 14 .. 31;
   end record;

   -- 33.7.9 I2C PEC register (I2C_PECR)

   type I2C_PECR_Type is record
      PEC      : Unsigned_8; -- Packet error checking register
      Reserved : Bits_24;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for I2C_PECR_Type use record
      PEC      at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 33.7.10 I2C receive data register (I2C_RXDR)

   type I2C_RXDR_Type is record
      RXDATA   : Unsigned_8; -- 8-bit receive data
      Reserved : Bits_24;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for I2C_RXDR_Type use record
      RXDATA   at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 33.7.11 I2C transmit data register (I2C_TXDR)

   type I2C_TXDR_Type is record
      TXDATA   : Unsigned_8;      -- 8-bit transmit data RXDATA
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for I2C_TXDR_Type use record
      TXDATA   at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 33.7 I2C registers

   type I2C_Type is record
      CR1      : I2C_CR1_Type      with Volatile_Full_Access => True;
      CR2      : I2C_CR2_Type      with Volatile_Full_Access => True;
      OAR1     : I2C_OAR1_Type     with Volatile_Full_Access => True;
      OAR2     : I2C_OAR2_Type     with Volatile_Full_Access => True;
      TIMINGR  : I2C_TIMINGR_Type  with Volatile_Full_Access => True;
      TIMEOUTR : I2C_TIMEOUTR_Type with Volatile_Full_Access => True;
      ISR      : I2C_ISR_Type      with Volatile_Full_Access => True;
      ICR      : I2C_ICR_Type      with Volatile_Full_Access => True;
      PECR     : I2C_PECR_Type     with Volatile_Full_Access => True;
      RXDR     : I2C_RXDR_Type     with Volatile_Full_Access => True;
      TXDR     : I2C_TXDR_Type     with Volatile_Full_Access => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 11 * 32;
   for I2C_Type use record
      CR1      at 16#00# range 0 .. 31;
      CR2      at 16#04# range 0 .. 31;
      OAR1     at 16#08# range 0 .. 31;
      OAR2     at 16#0C# range 0 .. 31;
      TIMINGR  at 16#10# range 0 .. 31;
      TIMEOUTR at 16#14# range 0 .. 31;
      ISR      at 16#18# range 0 .. 31;
      ICR      at 16#1C# range 0 .. 31;
      PECR     at 16#20# range 0 .. 31;
      RXDR     at 16#24# range 0 .. 31;
      TXDR     at 16#28# range 0 .. 31;
   end record;

   I2C1_ADDRESS : constant := 16#4000_5400#;

   I2C1 : aliased I2C_Type
      with Address    => System'To_Address (I2C1_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   I2C2_ADDRESS : constant := 16#4000_5800#;

   I2C2 : aliased I2C_Type
      with Address    => System'To_Address (I2C2_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   I2C3_ADDRESS : constant := 16#4000_5C00#;

   I2C3 : aliased I2C_Type
      with Address    => System'To_Address (I2C3_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   I2C4_ADDRESS : constant := 16#4000_6000#;

   I2C4 : aliased I2C_Type
      with Address    => System'To_Address (I2C4_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 34 Universal synchronous asynchronous receiver transmitter (USART)
   ----------------------------------------------------------------------------

   -- 34.8.1 Control register 1 (USART_CR1)

   PS_EVEN : constant := 0; -- Even parity
   PS_ODD  : constant := 1; -- Odd parity

   WAKE_IDLE : constant := 0; -- Idle line
   WAKE_ADDR : constant := 1; -- Address mark

   type M_WORD_LENGTH_Type is record
      M0 : Bits_1;
      M1 : Bits_1;
   end record;

   M_8N1 : constant M_WORD_LENGTH_Type := (0, 0); -- 1 Start bit, 8 data bits, n stop bits
   M_9N1 : constant M_WORD_LENGTH_Type := (1, 0); -- 1 Start bit, 9 data bits, n stop bits
   M_7N1 : constant M_WORD_LENGTH_Type := (0, 1); -- 1 Start bit, 7 data bits, n stop bits

   OVER8_16 : constant := 0; -- Oversampling by 16
   OVER8_8  : constant := 1; -- Oversampling by 8

   type USART_CR1_Type is record
      UE       : Boolean := False;     -- USART enable
      UESM     : Boolean := False;     -- USART enable in Stop mode
      RE       : Boolean := False;     -- Receiver enable
      TE       : Boolean := False;     -- Transmitter enable
      IDLEIE   : Boolean := False;     -- IDLE interrupt enable
      RXNEIE   : Boolean := False;     -- RXNE interrupt enable
      TCIE     : Boolean := False;     -- Transmission complete interrupt enable
      TXEIE    : Boolean := False;     -- interrupt enable
      PEIE     : Boolean := False;     -- PE interrupt enable
      PS       : Bits_1  := PS_EVEN;   -- Parity selection
      PCE      : Boolean := False;     -- Parity control enable
      WAKE     : Bits_1  := WAKE_IDLE; -- Receiver wakeup method
      M0       : Bits_1  := M_8N1.M0;  -- Word length
      MME      : Boolean := False;     -- Mute mode enable
      CMIE     : Boolean := False;     -- Character match interrupt enable
      OVER8    : Bits_1  := OVER8_16;  -- Oversampling mode
      DEDT     : Bits_5  := 0;         -- Driver Enable de-assertion time
      DEAT     : Bits_5  := 0;         -- Driver Enable assertion time
      RTOIE    : Boolean := False;     -- Receiver timeout interrupt enable
      EOBIE    : Boolean := False;     -- End of Block interrupt enable
      M1       : Bits_1  := M_8N1.M1;  -- Word length
      Reserved : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_CR1_Type use record
      UE       at 0 range  0 ..  0;
      UESM     at 0 range  1 ..  1;
      RE       at 0 range  2 ..  2;
      TE       at 0 range  3 ..  3;
      IDLEIE   at 0 range  4 ..  4;
      RXNEIE   at 0 range  5 ..  5;
      TCIE     at 0 range  6 ..  6;
      TXEIE    at 0 range  7 ..  7;
      PEIE     at 0 range  8 ..  8;
      PS       at 0 range  9 ..  9;
      PCE      at 0 range 10 .. 10;
      WAKE     at 0 range 11 .. 11;
      M0       at 0 range 12 .. 12;
      MME      at 0 range 13 .. 13;
      CMIE     at 0 range 14 .. 14;
      OVER8    at 0 range 15 .. 15;
      DEDT     at 0 range 16 .. 20;
      DEAT     at 0 range 21 .. 25;
      RTOIE    at 0 range 26 .. 26;
      EOBIE    at 0 range 27 .. 27;
      M1       at 0 range 28 .. 28;
      Reserved at 0 range 29 .. 31;
   end record;

   -- 34.8.2 Control register 2 (USART_CR2)

   ADDM7_4 : constant := 0; -- 4-bit address detection
   ADDM7_7 : constant := 1; -- 7-bit address detection (in 8-bit data mode)

   LBDL_10 : constant := 0; -- 10-bit break detection
   LBDL_11 : constant := 1; -- 11-bit break detection

   CPHA_1ST : constant := 0; -- The first clock transition is the first data capture edge
   CPHA_2ND : constant := 1; -- The second clock transition is the first data capture edge

   CPOL_LOW  : constant := 0; -- Steady low value on CK pin outside transmission window
   CPOL_HIGH : constant := 1; -- Steady high value on CK pin outside transmission window

   STOP_1  : constant := 2#00#; -- 1 stop bit
   STOP_05 : constant := 2#01#; -- 0.5 stop bit
   STOP_2  : constant := 2#10#; -- 2 stop bits
   STOP_15 : constant := 2#11#; -- 1.5 stop bits

   ABRMOD_START   : constant := 2#00#; --  Measurement of the start bit is used to detect the baud rate.
   ABRMOD_FALLING : constant := 2#01#; --  Falling edge to falling edge measurement.
   ABRMOD_7F      : constant := 2#10#; --  0x7F frame detection.
   ABRMOD_55      : constant := 2#11#; --  0x55 frame detection

   type USART_CR2_Type is record
      Reserved1 : Bits_4  := 0;
      ADDM7     : Bits_1  := ADDM7_4;      -- 7-bit Address Detection/4-bit Address Detection
      LBDL      : Bits_1  := LBDL_10;      -- LIN break detection length
      LBDIE     : Boolean := False;        -- LIN break detection interrupt enable
      Reserved2 : Bits_1  := 0;
      LBCL      : Boolean := False;        -- Last bit clock pulse
      CPHA      : Bits_1  := CPHA_1ST;     -- Clock phase
      CPOL      : Bits_1  := CPOL_LOW;     -- Clock polarity
      CLKEN     : Boolean := False;        -- Clock enable
      STOP      : Bits_2  := STOP_1;       -- STOP bits
      LINEN     : Boolean := False;        -- LIN mode enable
      SWAP      : Boolean := False;        -- Swap TX/RX pins
      RXINV     : Boolean := False;        -- RX pin active level inversion
      TXINV     : Boolean := False;        -- TX pin active level inversion
      DATAINV   : Boolean := False;        -- Binary data inversion
      MSBFIRST  : Boolean := False;        -- Most significant bit first
      ABREN     : Boolean := False;        -- Auto baud rate enable
      ABRMOD    : Bits_2  := ABRMOD_START; -- Auto baud rate mode
      RTOEN     : Boolean := False;        -- Receiver timeout enable
      ADD30     : Bits_4  := 0;            -- Address of the USART node
      ADD74     : Bits_4  := 0;            -- Address of the USART node
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_CR2_Type use record
      Reserved1 at 0 range  0 ..  3;
      ADDM7     at 0 range  4 ..  4;
      LBDL      at 0 range  5 ..  5;
      LBDIE     at 0 range  6 ..  6;
      Reserved2 at 0 range  7 ..  7;
      LBCL      at 0 range  8 ..  8;
      CPHA      at 0 range  9 ..  9;
      CPOL      at 0 range 10 .. 10;
      CLKEN     at 0 range 11 .. 11;
      STOP      at 0 range 12 .. 13;
      LINEN     at 0 range 14 .. 14;
      SWAP      at 0 range 15 .. 15;
      RXINV     at 0 range 16 .. 16;
      TXINV     at 0 range 17 .. 17;
      DATAINV   at 0 range 18 .. 18;
      MSBFIRST  at 0 range 19 .. 19;
      ABREN     at 0 range 20 .. 20;
      ABRMOD    at 0 range 21 .. 22;
      RTOEN     at 0 range 23 .. 23;
      ADD30     at 0 range 24 .. 27;
      ADD74     at 0 range 28 .. 31;
   end record;

   -- 34.8.3 Control register 3 (USART_CR3)

   DEP_HIGH : constant := 0; -- DE signal is active high.
   DEP_LOW  : constant := 1; -- DE signal is active low.

   SCARCNT_RETXDIS : constant := 0; -- No automatic retransmission in transmit mode.

   WUS_ADDRMATCH : constant := 2#00#; -- WUF active on address match
   WUS_STARTBIT  : constant := 2#10#; -- WuF active on Start bit detection
   WUS_RXNE      : constant := 2#11#; -- WUF active on RXNE.

   type USART_CR3_Type is record
      EIE       : Boolean := False;           -- Error interrupt enable
      IREN      : Boolean := False;           -- IrDA mode enable
      IRLP      : Boolean := False;           -- IrDA low-power
      HDSEL     : Boolean := False;           -- Half-duplex selection
      NACK      : Boolean := False;           -- Smartcard NACK enable
      SCEN      : Boolean := False;           -- Smartcard mode enable
      DMAR      : Boolean := False;           -- DMA enable receiver
      DMAT      : Boolean := False;           -- DMA enable transmitter
      RTSE      : Boolean := False;           -- RTS enable
      CTSE      : Boolean := False;           -- CTS enable
      CTSIE     : Boolean := False;           -- CTS interrupt enable
      ONEBIT    : Boolean := False;           -- One sample bit method enable
      OVRDIS    : Boolean := False;           -- Overrun Disable
      DDRE      : Boolean := False;           -- DMA Disable on Reception Error
      DEM       : Boolean := False;           -- Driver enable mode
      DEP       : Bits_1  := DEP_HIGH;        -- Driver enable polarity selection
      Reserved1 : Bits_1  := 0;
      SCARCNT   : Bits_3  := SCARCNT_RETXDIS; -- Smartcard auto-retry count
      WUS       : Bits_2  := WUS_ADDRMATCH;   -- Wakeup from Stop mode interrupt flag selection
      WUFIE     : Boolean := False;           -- Wakeup from Stop mode interrupt enable
      UCESM     : Boolean := False;           -- USART Clock Enable in Stop mode.
      TCBGTIE   : Boolean := False;           -- Transmission complete before guard time interrupt enable
      Reserved2 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_CR3_Type use record
      EIE       at 0 range  0 ..  0;
      IREN      at 0 range  1 ..  1;
      IRLP      at 0 range  2 ..  2;
      HDSEL     at 0 range  3 ..  3;
      NACK      at 0 range  4 ..  4;
      SCEN      at 0 range  5 ..  5;
      DMAR      at 0 range  6 ..  6;
      DMAT      at 0 range  7 ..  7;
      RTSE      at 0 range  8 ..  8;
      CTSE      at 0 range  9 ..  9;
      CTSIE     at 0 range 10 .. 10;
      ONEBIT    at 0 range 11 .. 11;
      OVRDIS    at 0 range 12 .. 12;
      DDRE      at 0 range 13 .. 13;
      DEM       at 0 range 14 .. 14;
      DEP       at 0 range 15 .. 15;
      Reserved1 at 0 range 16 .. 16;
      SCARCNT   at 0 range 17 .. 19;
      WUS       at 0 range 20 .. 21;
      WUFIE     at 0 range 22 .. 22;
      UCESM     at 0 range 23 .. 23;
      TCBGTIE   at 0 range 24 .. 24;
      Reserved2 at 0 range 25 .. 31;
   end record;

   -- 34.8.4 Baud rate register (USART_BRR)

   type USART_BRR_Type is record
      BRR      : Unsigned_16 := 0; -- BRR value
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_BRR_Type use record
      BRR      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 34.8.5 Guard time and prescaler register (USART_GTPR)

   type USART_GTPR_Type is record
      PSC      : Unsigned_8 := 0; -- Prescaler value
      GT       : Unsigned_8 := 0; -- Guard time value
      Reserved : Bits_16    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_GTPR_Type use record
      PSC      at 0 range  0 ..  7;
      GT       at 0 range  8 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 34.8.6 Receiver timeout register (USART_RTOR)

   type USART_RTOR_Type is record
      RTO  : Bits_24 := 0; -- Receiver timeout value
      BLEN : Bits_8  := 0; -- Block Length
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_RTOR_Type use record
      RTO  at 0 range  0 .. 23;
      BLEN at 0 range 24 .. 31;
   end record;

   -- 34.8.7 Request register (USART_RQR)

   type USART_RQR_Type is record
      ABRRQ    : Boolean := False; -- Auto baud rate request
      SBKRQ    : Boolean := False; -- Send break request
      MMRQ     : Boolean := False; -- Mute mode request
      RXFRQ    : Boolean := False; -- Receive data flush request
      TXFRQ    : Boolean := False; -- Transmit data flush request
      Reserved : Bits_27 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_RQR_Type use record
      ABRRQ    at 0 range 0 ..  0;
      SBKRQ    at 0 range 1 ..  1;
      MMRQ     at 0 range 2 ..  2;
      RXFRQ    at 0 range 3 ..  3;
      TXFRQ    at 0 range 4 ..  4;
      Reserved at 0 range 5 .. 31;
   end record;

   -- 34.8.8 Interrupt and status register (USART_ISR)

   type USART_ISR_Type is record
      PE        : Boolean; -- Parity Error
      FE        : Boolean; -- Framing Error
      NF        : Boolean; -- START bit Noise detection flag
      ORE       : Boolean; -- Overrun error
      IDLE      : Boolean; -- Idle line detected
      RXNE      : Boolean; -- Read data register not empty
      TC        : Boolean; -- Transmission complete
      TXE       : Boolean; -- Transmit data register empty
      LBDF      : Boolean; -- LIN break detection flag
      CTSIF     : Boolean; -- CTS interrupt flag
      CTS       : Boolean; -- CTS flag
      RTOF      : Boolean; -- Receiver timeout
      EOBF      : Boolean; -- End of block flag
      Reserved1 : Bits_1;
      ABRE      : Boolean; -- Auto baud rate error
      ABRF      : Boolean; -- Auto baud rate flag
      BUSY      : Boolean; -- Busy flag
      CMF       : Boolean; -- Character match flag
      SBKF      : Boolean; -- Send break flag
      RWU       : Boolean; -- Receiver wakeup from Mute mode
      WUF       : Boolean; -- Wakeup from Stop mode flag
      TEACK     : Boolean; -- Transmit enable acknowledge flag
      REACK     : Boolean; -- Receive enable acknowledge flag
      Reserved2 : Bits_2;
      TCBGT     : Boolean; -- Transmission complete before guard time completion.
      Reserved3 : Bits_6;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_ISR_Type use record
      PE        at 0 range  0 ..  0;
      FE        at 0 range  1 ..  1;
      NF        at 0 range  2 ..  2;
      ORE       at 0 range  3 ..  3;
      IDLE      at 0 range  4 ..  4;
      RXNE      at 0 range  5 ..  5;
      TC        at 0 range  6 ..  6;
      TXE       at 0 range  7 ..  7;
      LBDF      at 0 range  8 ..  8;
      CTSIF     at 0 range  9 ..  9;
      CTS       at 0 range 10 .. 10;
      RTOF      at 0 range 11 .. 11;
      EOBF      at 0 range 12 .. 12;
      Reserved1 at 0 range 13 .. 13;
      ABRE      at 0 range 14 .. 14;
      ABRF      at 0 range 15 .. 15;
      BUSY      at 0 range 16 .. 16;
      CMF       at 0 range 17 .. 17;
      SBKF      at 0 range 18 .. 18;
      RWU       at 0 range 19 .. 19;
      WUF       at 0 range 20 .. 20;
      TEACK     at 0 range 21 .. 21;
      REACK     at 0 range 22 .. 22;
      Reserved2 at 0 range 23 .. 24;
      TCBGT     at 0 range 25 .. 25;
      Reserved3 at 0 range 26 .. 31;
   end record;

   -- 34.8.9 Interrupt flag clear register (USART_ICR)

   type USART_ICR_Type is record
      PECF      : Boolean := False; -- Parity error clear flag
      FECF      : Boolean := False; -- Framing error clear flag
      NCF       : Boolean := False; -- Noise detected clear flag
      ORECF     : Boolean := False; -- Overrun error clear flag
      IDLECF    : Boolean := False; -- Idle line detected clear flag
      Reserved1 : Bits_1  := 0;
      TCCF      : Boolean := False; -- Transmission complete clear flag
      TCBGTCF   : Boolean := False; -- Transmission completed before guard time clear flag
      LBDCF     : Boolean := False; -- LIN break detection clear flag
      CTSCF     : Boolean := False; -- CTS clear flag
      Reserved2 : Bits_1  := 0;
      RTOCF     : Boolean := False; -- Receiver timeout clear flag
      EOBCF     : Boolean := False; -- End of block clear flag
      Reserved3 : Bits_4  := 0;
      CMCF      : Boolean := False; -- Character match clear flag
      Reserved4 : Bits_2  := 0;
      WUCF      : Boolean := False; -- Wakeup from Stop mode clear flag
      Reserved5 : Bits_11 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_ICR_Type use record
      PECF      at 0 range  0 ..  0;
      FECF      at 0 range  1 ..  1;
      NCF       at 0 range  2 ..  2;
      ORECF     at 0 range  3 ..  3;
      IDLECF    at 0 range  4 ..  4;
      Reserved1 at 0 range  5 ..  5;
      TCCF      at 0 range  6 ..  6;
      TCBGTCF   at 0 range  7 ..  7;
      LBDCF     at 0 range  8 ..  8;
      CTSCF     at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 10;
      RTOCF     at 0 range 11 .. 11;
      EOBCF     at 0 range 12 .. 12;
      Reserved3 at 0 range 13 .. 16;
      CMCF      at 0 range 17 .. 17;
      Reserved4 at 0 range 18 .. 19;
      WUCF      at 0 range 20 .. 20;
      Reserved5 at 0 range 21 .. 31;
   end record;

   -- 34.8.10 Receive data register (USART_RDR)
   -- 34.8.11 Transmit data register (USART_TDR)

   type USART_DR_Type is record
      DR       : Unsigned_8;
      DR8      : Bits_1     := 0;
      Reserved : Bits_23    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_DR_Type use record
      DR       at 0 range 0 ..  7;
      DR8      at 0 range 8 ..  8;
      Reserved at 0 range 9 .. 31;
   end record;

   -- 34.8 USART registers

   type USART_Type is record
      CR1  : USART_CR1_Type  with Volatile_Full_Access => True;
      CR2  : USART_CR2_Type  with Volatile_Full_Access => True;
      CR3  : USART_CR3_Type  with Volatile_Full_Access => True;
      BRR  : USART_BRR_Type  with Volatile_Full_Access => True;
      GTPR : USART_GTPR_Type with Volatile_Full_Access => True;
      RTOR : USART_RTOR_Type with Volatile_Full_Access => True;
      RQR  : USART_RQR_Type  with Volatile_Full_Access => True;
      ISR  : USART_ISR_Type  with Volatile_Full_Access => True;
      ICR  : USART_ICR_Type  with Volatile_Full_Access => True;
      RDR  : USART_DR_Type;
      TDR  : USART_DR_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 11 * 32;
   for USART_Type use record
      CR1  at 16#00# range 0 .. 31;
      CR2  at 16#04# range 0 .. 31;
      CR3  at 16#08# range 0 .. 31;
      BRR  at 16#0C# range 0 .. 31;
      GTPR at 16#10# range 0 .. 31;
      RTOR at 16#14# range 0 .. 31;
      RQR  at 16#18# range 0 .. 31;
      ISR  at 16#1C# range 0 .. 31;
      ICR  at 16#20# range 0 .. 31;
      RDR  at 16#24# range 0 .. 31;
      TDR  at 16#28# range 0 .. 31;
   end record;

   USART1_BASEADDRESS : constant := 16#4001_1000#;

   USART1 : aliased USART_Type
      with Address    => System'To_Address (USART1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   USART2_BASEADDRESS : constant := 16#4000_4400#;

   USART2 : aliased USART_Type
      with Address    => System'To_Address (USART2_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   USART3_BASEADDRESS : constant := 16#4000_4800#;

   USART3 : aliased USART_Type
      with Address    => System'To_Address (USART3_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   UART4_BASEADDRESS : constant := 16#4000_4C00#;

   UART4 : aliased USART_Type
      with Address    => System'To_Address (UART4_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   UART5_BASEADDRESS : constant := 16#4000_5000#;

   UART5 : aliased USART_Type
      with Address    => System'To_Address (UART5_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   USART6_BASEADDRESS : constant := 16#4001_1400#;

   USART6 : aliased USART_Type
      with Address    => System'To_Address (USART6_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   UART7_BASEADDRESS : constant := 16#4000_7800#;

   UART7 : aliased USART_Type
      with Address    => System'To_Address (UART7_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   UART8_BASEADDRESS : constant := 16#4000_7C00#;

   UART8 : aliased USART_Type
      with Address    => System'To_Address (UART8_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 35 Serial peripheral interface / integrated interchip sound (SPI/I2S)
   ----------------------------------------------------------------------------

   -- 35.9.1 SPI control register 1 (SPIx_CR1)
   -- 35.9.2 SPI control register 2 (SPIx_CR2)
   -- 35.9.3 SPI status register (SPIx_SR)
   -- 35.9.4 SPI data register (SPIx_DR)
   -- 35.9.5 SPI CRC polynomial register (SPIx_CRCPR)
   -- 35.9.6 SPI Rx CRC register (SPIx_RXCRCR)
   -- 35.9.7 SPI Tx CRC register (SPIx_TXCRCR)
   -- 35.9.8 SPIx_I2S configuration register (SPIx_I2SCFGR)
   -- 35.9.9 SPIx_I2S prescaler register (SPIx_I2SPR)

   ----------------------------------------------------------------------------
   -- 36 Serial audio interface (SAI)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 37 SPDIF receiver interface (SPDIFRX)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 38 Management data input/output (MDIOS)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 39 SD/SDIO/MMC card host interface (SDMMC)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 40 Controller area network (bxCAN)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 41 USB on-the-go full-speed/high-speed (OTG_FS/OTG_HS)
   ----------------------------------------------------------------------------

   -- 41.15.1 OTG control and status register (OTG_GOTGCTL)
   -- 41.15.2 OTG interrupt register (OTG_GOTGINT)
   -- 41.15.3 OTG AHB configuration register (OTG_GAHBCFG)
   -- 41.15.4 OTG USB configuration register (OTG_GUSBCFG)
   -- 41.15.5 OTG reset register (OTG_GRSTCTL)
   -- 41.15.6 OTG core interrupt register (OTG_GINTSTS)
   -- 41.15.7 OTG interrupt mask register (OTG_GINTMSK)
   -- 41.15.8 OTG receive status debug read register (OTG_GRXSTSR)
   -- 41.15.9 OTG receive status debug read [alternate] (OTG_GRXSTSR)
   -- 41.15.10 OTG status read and pop registers (OTG_GRXSTSP)
   -- 41.15.11 OTG status read and pop registers [alternate] (OTG_GRXSTSP)
   -- 41.15.12 OTG receive FIFO size register (OTG_GRXFSIZ)
   -- 41.15.13 OTG host non-periodic transmit FIFO size register (OTG_HNPTXFSIZ)/Endpoint 0 Transmit FIFO size (OTG_DIEPTXF0)
   -- 41.15.14 OTG non-periodic transmit FIFO/queue status register (OTG_HNPTXSTS)
   -- 41.15.15 OTG general core configuration register (OTG_GCCFG)
   -- 41.15.16 OTG core ID register (OTG_CID)
   -- 41.15.17 OTG core LPM configuration register (OTG_GLPMCFG)
   -- 41.15.18 OTG host periodic transmit FIFO size register (OTG_HPTXFSIZ)
   -- 41.15.19 OTG device IN endpoint transmit FIFO x size register (OTG_DIEPTXFx)
   -- 41.15.20 Host-mode registers
   -- 41.15.21 OTG host configuration register (OTG_HCFG)
   -- 41.15.22 OTG host frame interval register (OTG_HFIR)
   -- 41.15.23 OTG host frame number/frame time remaining register (OTG_HFNUM)
   -- 41.15.24 OTG_Host periodic transmit FIFO/queue status register (OTG_HPTXSTS)
   -- 41.15.25 OTG host all channels interrupt register (OTG_HAINT)
   -- 41.15.26 OTG host all channels interrupt mask register (OTG_HAINTMSK)
   -- 41.15.27 OTG host port control and status register (OTG_HPRT)
   -- 41.15.28 OTG host channel x characteristics register (OTG_HCCHARx)
   -- 41.15.29 OTG host channel x split control register (OTG_HCSPLTx)
   -- 41.15.30 OTG host channel x interrupt register (OTG_HCINTx)
   -- 41.15.31 OTG host channel x interrupt mask register (OTG_HCINTMSKx)
   -- 41.15.32 OTG host channel x transfer size register (OTG_HCTSIZx)
   -- 41.15.33 OTG host channel x DMA address register (OTG_HCDMAx)
   -- 41.15.34 Device-mode registers
   -- 41.15.35 OTG device configuration register (OTG_DCFG)
   -- 41.15.36 OTG device control register (OTG_DCTL)
   -- 41.15.37 OTG device status register (OTG_DSTS)
   -- 41.15.38 OTG device IN endpoint common interrupt mask register (OTG_DIEPMSK)
   -- 41.15.39 OTG device OUT endpoint common interrupt mask register (OTG_DOEPMSK)
   -- 41.15.40 OTG device all endpoints interrupt register (OTG_DAINT)
   -- 41.15.41 OTG all endpoints interrupt mask register (OTG_DAINTMSK)
   -- 41.15.42 OTG device VBUS discharge time register (OTG_DVBUSDIS)
   -- 41.15.43 OTG device VBUS pulsing time register (OTG_DVBUSPULSE)
   -- 41.15.44 OTG device threshold control register (OTG_DTHRCTL)
   -- 41.15.45 OTG device IN endpoint FIFO empty interrupt mask register (OTG_DIEPEMPMSK)
   -- 41.15.46 OTG device each endpoint interrupt register (OTG_DEACHINT)
   -- 41.15.47 OTG device each endpoint interrupt mask register (OTG_DEACHINTMSK)
   -- 41.15.48 OTG device each IN endpoint-1 interrupt mask register (OTG_HS_DIEPEACHMSK1)
   -- 41.15.49 OTG device each OUT endpoint-1 interrupt mask register (OTG_HS_DOEPEACHMSK1)
   -- 41.15.50 OTG device control IN endpoint 0 control register (OTG_DIEPCTL0)
   -- 41.15.51 OTG device IN endpoint x control register (OTG_DIEPCTLx)
   -- 41.15.52 OTG device IN endpoint x interrupt register (OTG_DIEPINTx)
   -- 41.15.53 OTG device IN endpoint 0 transfer size register (OTG_DIEPTSIZ0)
   -- 41.15.54 OTG device IN endpoint x DMA address register (OTG_DIEPDMAx)
   -- 41.15.55 OTG device IN endpoint transmit FIFO status register (OTG_DTXFSTSx)
   -- 41.15.56 OTG device IN endpoint x transfer size register (OTG_DIEPTSIZx)
   -- 41.15.57 OTG device control OUT endpoint 0 control register (OTG_DOEPCTL0)
   -- 41.15.58 OTG device OUT endpoint x interrupt register (OTG_DOEPINTx)
   -- 41.15.59 OTG device OUT endpoint 0 transfer size register (OTG_DOEPTSIZ0)
   -- 41.15.60 OTG device OUT endpoint x DMA address register (OTG_DOEPDMAx)
   -- 41.15.61 OTG device OUT endpoint x control register (OTG_DOEPCTLx)
   -- 41.15.62 OTG device OUT endpoint x transfer size register (OTG_DOEPTSIZx)
   -- 41.15.63 OTG power and clock gating control register (OTG_PCGCCTL)

   ----------------------------------------------------------------------------
   -- 42 Ethernet (ETH): media access control (MAC) with DMA controller
   ----------------------------------------------------------------------------

   -- 42.8.1 MAC register description
   -- Ethernet MAC configuration register (ETH_MACCR)
   -- Ethernet MAC frame filter register (ETH_MACFFR)
   -- Ethernet MAC hash table high register (ETH_MACHTHR)
   -- Ethernet MAC hash table low register (ETH_MACHTLR)
   -- Ethernet MAC MII address register (ETH_MACMIIAR)
   -- Ethernet MAC MII data register (ETH_MACMIIDR)
   -- Ethernet MAC flow control register (ETH_MACFCR)
   -- Ethernet MAC VLAN tag register (ETH_MACVLANTR)
   -- Ethernet MAC remote wakeup frame filter register (ETH_MACRWUFFR)
   -- Ethernet MAC PMT control and status register (ETH_MACPMTCSR)
   -- Ethernet MAC debug register (ETH_MACDBGR)
   -- Ethernet MAC interrupt status register (ETH_MACSR)
   -- Ethernet MAC interrupt mask register (ETH_MACIMR)
   -- Ethernet MAC address 0 high register (ETH_MACA0HR)
   -- Ethernet MAC address 0 low register (ETH_MACA0LR)
   -- Ethernet MAC address 1 high register (ETH_MACA1HR)
   -- Ethernet MAC address1 low register (ETH_MACA1LR)
   -- Ethernet MAC address 2 high register (ETH_MACA2HR)
   -- Ethernet MAC address 2 low register (ETH_MACA2LR)
   -- Ethernet MAC address 3 high register (ETH_MACA3HR)
   -- Ethernet MAC address 3 low register (ETH_MACA3LR)

   -- 42.8.2 MMC register description
   -- Ethernet MMC control register (ETH_MMCCR)
   -- Ethernet MMC receive interrupt register (ETH_MMCRIR)
   -- Ethernet MMC transmit interrupt register (ETH_MMCTIR)
   -- Ethernet MMC receive interrupt mask register (ETH_MMCRIMR)
   -- Ethernet MMC transmit interrupt mask register (ETH_MMCTIMR)
   -- Ethernet MMC transmitted good frames after a single collision counter register (ETH_MMCTGFSCCR)
   -- Ethernet MMC transmitted good frames after more than a single collision counter register (ETH_MMCTGFMSCCR)
   -- Ethernet MMC transmitted good frames counter register (ETH_MMCTGFCR)
   -- Ethernet MMC received frames with CRC error counter register (ETH_MMCRFCECR)
   -- Ethernet MMC received frames with alignment error counter register (ETH_MMCRFAECR)
   -- MMC received good unicast frames counter register (ETH_MMCRGUFCR)

   -- 42.8.3 IEEE 1588 time stamp registers
   -- Ethernet PTP time stamp control register (ETH_PTPTSCR)
   -- Ethernet PTP subsecond increment register (ETH_PTPSSIR)
   -- Ethernet PTP time stamp high register (ETH_PTPTSHR)
   -- Ethernet PTP time stamp low register (ETH_PTPTSLR)
   -- Ethernet PTP time stamp high update register (ETH_PTPTSHUR)
   -- Ethernet PTP time stamp low update register (ETH_PTPTSLUR)
   -- Ethernet PTP time stamp addend register (ETH_PTPTSAR)
   -- Ethernet PTP target time high register (ETH_PTPTTHR)
   -- Ethernet PTP target time low register (ETH_PTPTTLR)
   -- Ethernet PTP time stamp status register (ETH_PTPTSSR)
   -- Ethernet PTP PPS control register (ETH_PTPPPSCR)

   -- 42.8.4 DMA register description
   -- Ethernet DMA bus mode register (ETH_DMABMR)
   -- Ethernet DMA transmit poll demand register (ETH_DMATPDR)
   -- EHERNET DMA receive poll demand register (ETH_DMARPDR)
   -- Ethernet DMA receive descriptor list address register (ETH_DMARDLAR)
   -- Ethernet DMA transmit descriptor list address register (ETH_DMATDLAR)
   -- Ethernet DMA status register (ETH_DMASR)
   -- Ethernet DMA operation mode register (ETH_DMAOMR)
   -- Ethernet DMA interrupt enable register (ETH_DMAIER)
   -- Ethernet DMA missed frame and buffer overflow counter register (ETH_DMAMFBOCR)
   -- Ethernet DMA receive status watchdog timer register (ETH_DMARSWTR)
   -- Ethernet DMA current host transmit descriptor register (ETH_DMACHTDR)
   -- Ethernet DMA current host transmit buffer address register (ETH_DMACHTBAR)
   -- Ethernet DMA current host receive buffer address register (ETH_DMACHRBAR)

   ----------------------------------------------------------------------------
   -- 43 HDMI-CEC controller (CEC)
   ----------------------------------------------------------------------------

   -- 43.7.1 CEC control register (CEC_CR)
   -- 43.7.2 CEC configuration register (CEC_CFGR)
   -- 43.7.3 CEC Tx data register (CEC_TXDR)
   -- 43.7.4 CEC Rx data register (CEC_RXDR)
   -- 43.7.5 CEC interrupt and status register (CEC_ISR)
   -- 43.7.6 CEC interrupt enable register (CEC_IER)

pragma Style_Checks (On);

end STM32F769I;
