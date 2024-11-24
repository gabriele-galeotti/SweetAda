-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ msp432p401r.ads                                                                                           --
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
with Interfaces;
with Bits;

package MSP432P401R
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
   -- 3 Reset Controller (RSTCTL)
   ----------------------------------------------------------------------------

   -- 3.3.1 RSTCTL_RESET_REQ Register

   RSTCTL_RESET_REQ_RSTKEY : constant := 16#69#;

   type RSTCTL_RESET_REQ_Type is record
      SOFT_REQ  : Boolean;      -- If written with 1, generates a Hard Reset request to the Reset Controller
      HARD_REQ  : Boolean;      -- If written with 1, generates a Soft Reset request to the Reset Controller
      Reserved1 : Bits_6  := 0;
      RSTKEY    : Bits_8;       -- Must be written with 69h to enable writes to bits 1-0 (in the same write ...
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RSTCTL_RESET_REQ_Type use record
      SOFT_REQ  at 0 range  0 ..  0;
      HARD_REQ  at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  7;
      RSTKEY    at 0 range  8 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   -- common definitions for RSTCTL_[HARD|SOFT]RESET_[STAT|CLR|SET]
   -- 3.3.2 RSTCTL_HARDRESET_STAT Register
   -- 3.3.3 RSTCTL_HARDRESET_CLR Register
   -- 3.3.4 RSTCTL_HARDRESET_SET Register
   -- 3.3.5 RSTCTL_SOFTRESET_STAT Register
   -- 3.3.6 RSTCTL_SOFTRESET_CLR Register
   -- 3.3.7 RSTCTL_SOFTRESET_SET Register

   -- indexes into bitmaps
   SRC0  : constant := 0;
   SRC1  : constant := 1;
   SRC2  : constant := 2;
   SRC3  : constant := 3;
   SRC4  : constant := 4;
   SRC5  : constant := 5;
   SRC6  : constant := 6;
   SRC7  : constant := 7;
   SRC8  : constant := 8;
   SRC9  : constant := 9;
   SRC10 : constant := 10;
   SRC11 : constant := 11;
   SRC12 : constant := 12;
   SRC13 : constant := 13;
   SRC14 : constant := 14;
   SRC15 : constant := 15;

   type RSTCTL_RESET_Type is record
      SRC      : Bitmap_16 := [others => False];
      Reserved : Bits_16   := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RSTCTL_RESET_Type use record
      SRC      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 3.3.8 RSTCTL_PSSRESET_STAT Register

   type RSTCTL_PSSRESET_STAT_Type is record
      Reserved1 : Bits_1;
      SVSMH     : Boolean; -- Indicates if POR was caused by an SVSMH trip condition in the PSS (with SVSMH enabled and set as supervisor)
      BGREF     : Boolean; -- Indicates if POR was caused by a Band Gap Reference not okay condition in the PSS
      VCCDET    : Boolean; -- Indicates if POR was caused by a VCCDET trip condition in the PSS
      Reserved2 : Bits_28;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RSTCTL_PSSRESET_STAT_Type use record
      Reserved1 at 0 range 0 ..  0;
      SVSMH     at 0 range 1 ..  1;
      BGREF     at 0 range 2 ..  2;
      VCCDET    at 0 range 3 ..  3;
      Reserved2 at 0 range 4 .. 31;
   end record;

   -- 3.3.9 RSTCTL_PSSRESET_CLR Register

   type RSTCTL_PSSRESET_CLR_Type is record
      CLR      : Boolean; -- Write 1 clears all PSS Reset Flags in the RSTCTL_PSSRESET_STAT
      Reserved : Bits_31;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RSTCTL_PSSRESET_CLR_Type use record
      CLR      at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   -- Table 6-33. RSTCTL Registers

   RSTCTL_BASEADDRESS : constant := 16#E004_2000#;

   RSTCTL_RESET_REQ : aliased RSTCTL_RESET_REQ_Type
      with Address              => System'To_Address (RSTCTL_BASEADDRESS + 16#000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_HARDRESET_STAT : aliased RSTCTL_RESET_Type
      with Address              => System'To_Address (RSTCTL_BASEADDRESS + 16#004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_HARDRESET_CLR : aliased RSTCTL_RESET_Type
      with Address              => System'To_Address (RSTCTL_BASEADDRESS + 16#008#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_HARDRESET_SET : aliased RSTCTL_RESET_Type
      with Address              => System'To_Address (RSTCTL_BASEADDRESS + 16#00C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_SOFTRESET_STAT : aliased RSTCTL_RESET_Type
      with Address              => System'To_Address (RSTCTL_BASEADDRESS + 16#010#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_SOFTRESET_CLR : aliased RSTCTL_RESET_Type
      with Address              => System'To_Address (RSTCTL_BASEADDRESS + 16#014#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_SOFTRESET_SET : aliased RSTCTL_RESET_Type
      with Address              => System'To_Address (RSTCTL_BASEADDRESS + 16#018#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_PSSRESET_STAT : aliased RSTCTL_PSSRESET_STAT_Type
      with Address              => System'To_Address (RSTCTL_BASEADDRESS + 16#100#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_PSSRESET_CLR : aliased RSTCTL_PSSRESET_CLR_Type
      with Address              => System'To_Address (RSTCTL_BASEADDRESS + 16#104#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 4 System Controller (SYSCTL)
   ----------------------------------------------------------------------------

   -- 4.11.1 SYS_REBOOT_CTL Register

   SYS_REBOOT_CTL_WKEY : constant := 16#69#;

   type SYS_REBOOT_CTL_Type is record
      REBOOT    : Boolean;      -- Write 1 initiates a Reboot of the device
      Reserved1 : Bits_7  := 0;
      WKEY      : Bits_8;       -- Key to enable writes to bit 0.
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_REBOOT_CTL_Type use record
      REBOOT    at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      WKEY      at 0 range  8 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   -- 4.11.2 SYS_NMI_CTLSTAT Register

   type SYS_NMI_CTLSTAT_Type is record
      CS_SRC    : Boolean := False; -- Enables CS interrupt as a source of NMI
      PSS_SRC   : Boolean := False; -- Enables the PSS interrupt as a source of NMI
      PCM_SRC   : Boolean := False; -- Enables the PCM interrupt as a source of NMI
      PIN_SRC   : Boolean := False; -- configures the RSTn/NMI pin as a source of NMI
      Reserved1 : Bits_12 := 0;
      CS_FLG    : Boolean := False; -- indicates CS interrupt was the source of NMI
      PSS_FLG   : Boolean := False; -- indicates the PSS interrupt was the source of NMI
      PCM_FLG   : Boolean := False; -- indicates the PCM interrupt was the source of NMI
      PIN_FLG   : Boolean := False; -- Indicates the RSTn/NMI pin was the source of NMI
      Reserved2 : Bits_12 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_NMI_CTLSTAT_Type use record
      CS_SRC    at 0 range  0 ..  0;
      PSS_SRC   at 0 range  1 ..  1;
      PCM_SRC   at 0 range  2 ..  2;
      PIN_SRC   at 0 range  3 ..  3;
      Reserved1 at 0 range  4 .. 15;
      CS_FLG    at 0 range 16 .. 16;
      PSS_FLG   at 0 range 17 .. 17;
      PCM_FLG   at 0 range 18 .. 18;
      PIN_FLG   at 0 range 19 .. 19;
      Reserved2 at 0 range 20 .. 31;
   end record;

   -- 4.11.3 SYS_WDTRESET_CTL Register

   TIMEOUT_SOFT : constant := 0; -- WDT timeout event generates Soft reset
   TIMEOUT_HARD : constant := 1; -- WDT timeout event generates Hard reset

   VIOLATION_SOFT : constant := 0; -- WDT password violation event generates Soft reset
   VIOLATION_HARD : constant := 1; -- WDT password violation event generates Hard reset

   type SYS_WDTRESET_CTL_Type is record
      TIMEOUT   : Bits_1  := TIMEOUT_SOFT;   -- WDT timeout event
      VIOLATION : Bits_1  := VIOLATION_SOFT; -- WDT password violation
      Reserved  : Bits_30 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_WDTRESET_CTL_Type use record
      TIMEOUT   at 0 range 0 ..  0;
      VIOLATION at 0 range 1 ..  1;
      Reserved  at 0 range 2 .. 31;
   end record;

   -- 4.11.4 SYS_PERIHALT_CTL Register

   type SYS_PERIHALT_CTL_Type is record
      HALT_T16_0 : Boolean := False; -- freezes peripheral operation when CPU is halted
      HALT_T16_1 : Boolean := False; -- ''
      HALT_T16_2 : Boolean := False; -- ''
      HALT_T16_3 : Boolean := False; -- ''
      HALT_T32_0 : Boolean := False; -- ''
      HALT_eUA0  : Boolean := False; -- ''
      HALT_eUA1  : Boolean := False; -- ''
      HALT_eUA2  : Boolean := False; -- ''
      HALT_eUA3  : Boolean := False; -- ''
      HALT_eUB0  : Boolean := False; -- ''
      HALT_eUB1  : Boolean := False; -- ''
      HALT_eUB2  : Boolean := False; -- ''
      HALT_eUB3  : Boolean := False; -- ''
      HALT_ADC   : Boolean := False; -- ''
      HALT_WDT   : Boolean := False; -- ''
      HALT_DMA   : Boolean := False; -- ''
      Reserved   : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_PERIHALT_CTL_Type use record
      HALT_T16_0 at 0 range  0 ..  0;
      HALT_T16_1 at 0 range  1 ..  1;
      HALT_T16_2 at 0 range  2 ..  2;
      HALT_T16_3 at 0 range  3 ..  3;
      HALT_T32_0 at 0 range  4 ..  4;
      HALT_eUA0  at 0 range  5 ..  5;
      HALT_eUA1  at 0 range  6 ..  6;
      HALT_eUA2  at 0 range  7 ..  7;
      HALT_eUA3  at 0 range  8 ..  8;
      HALT_eUB0  at 0 range  9 ..  9;
      HALT_eUB1  at 0 range 10 .. 10;
      HALT_eUB2  at 0 range 11 .. 11;
      HALT_eUB3  at 0 range 12 .. 12;
      HALT_ADC   at 0 range 13 .. 13;
      HALT_WDT   at 0 range 14 .. 14;
      HALT_DMA   at 0 range 15 .. 15;
      Reserved   at 0 range 16 .. 31;
   end record;

   -- 4.11.5 SYS_SRAM_SIZE Register

   -- 4.11.6 SYS_SRAM_BANKEN Register

   type SYS_SRAM_BANKEN_Type is record
      BNK0_EN   : Boolean := True;  -- When 1, enables Bank0 of the SRAM
      BNK1_EN   : Boolean := True;  -- When set to 1, bank enable bits for all banks below this bank are set to 1 as well.
      BNK2_EN   : Boolean := True;  -- ''
      BNK3_EN   : Boolean := True;  -- ''
      BNK4_EN   : Boolean := True;  -- ''
      BNK5_EN   : Boolean := True;  -- ''
      BNK6_EN   : Boolean := True;  -- ''
      BNK7_EN   : Boolean := True;  -- ''
      Reserved1 : Bits_8  := 0;
      SRAM_RDY  : Boolean := False; -- SRAM is ready for accesses.
      Reserved2 : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_SRAM_BANKEN_Type use record
      BNK0_EN   at 0 range  0 ..  0;
      BNK1_EN   at 0 range  1 ..  1;
      BNK2_EN   at 0 range  2 ..  2;
      BNK3_EN   at 0 range  3 ..  3;
      BNK4_EN   at 0 range  4 ..  4;
      BNK5_EN   at 0 range  5 ..  5;
      BNK6_EN   at 0 range  6 ..  6;
      BNK7_EN   at 0 range  7 ..  7;
      Reserved1 at 0 range  8 .. 15;
      SRAM_RDY  at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 31;
   end record;

   -- 4.11.7 SYS_SRAM_BANKRET Register

   type SYS_SRAM_BANKRET_Type is record
      BNK0_RET  : Boolean := True;  -- Bank0 is always retained in LPM3, LPM4 and LPM3.5 modes of operation
      BNK1_RET  : Boolean := True;  -- 1b = Bank? of the SRAM is retained in LPM3 and LPM4
      BNK2_RET  : Boolean := True;  -- ''
      BNK3_RET  : Boolean := True;  -- ''
      BNK4_RET  : Boolean := True;  -- ''
      BNK5_RET  : Boolean := True;  -- ''
      BNK6_RET  : Boolean := True;  -- ''
      BNK7_RET  : Boolean := True;  -- ''
      Reserved1 : Bits_8  := 0;
      SRAM_RDY  : Boolean := False; -- 1b = SRAM is ready for accesses.
      Reserved2 : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_SRAM_BANKRET_Type use record
      BNK0_RET  at 0 range  0 ..  0;
      BNK1_RET  at 0 range  1 ..  1;
      BNK2_RET  at 0 range  2 ..  2;
      BNK3_RET  at 0 range  3 ..  3;
      BNK4_RET  at 0 range  4 ..  4;
      BNK5_RET  at 0 range  5 ..  5;
      BNK6_RET  at 0 range  6 ..  6;
      BNK7_RET  at 0 range  7 ..  7;
      Reserved1 at 0 range  8 .. 15;
      SRAM_RDY  at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 31;
   end record;

   -- 4.11.8 SYS_FLASH_SIZE Register

   -- 4.11.9 SYS_DIO_GLTFLT_CTL Register

   type SYS_DIO_GLTFLT_CTL_Type is record
      GLTCH_EN : Boolean := True; -- 1b = Enables glitch filter on the digital I/Os
      Reserved : Bits_31 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_DIO_GLTFLT_CTL_Type use record
      GLTCH_EN at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   -- 4.11.10 SYS_SECDATA_UNLOCK Register
   -- 4.11.11 SYS_MASTER_UNLOCK Register

   UNLKEY_KEY : constant := 16#695A#; -- Write to unlock

   type SYS_X_UNLOCK_Type is record
      UNLKEY   : Bits_16 := 0; -- Unlock Key
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_X_UNLOCK_Type use record
      UNLKEY   at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 4.11.12 SYS_BOOTOVER_REQ0 Register

   -- 4.11.13 SYS_BOOTOVER_REQ1 Register

   -- 4.11.14 SYS_BOOTOVER_ACK Register

   -- 4.11.15 SYS_RESET_REQ Register

   WKEY_KEY : constant := 16#69#;

   type SYS_RESET_REQ_Type is record
      POR       : Boolean := False; -- When written with 1, generates a POR pulse to the device Reset Controller
      REBOOT    : Boolean := False; -- When written with 1, generates a Reboot Reset pulse to the device Reset Controller
      Reserved1 : Bits_6  := 0;
      WKEY      : Bits_8  := 0;     -- Key to validate/enable write to bits '1-0'. Bits '1-0' are written only if WKEY is 69h in the same write cycle end record
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_RESET_REQ_Type use record
      POR       at 0 range  0 ..  0;
      REBOOT    at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  7;
      WKEY      at 0 range  8 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   -- 4.11.16 SYS_RESET_STATOVER Register

   type SYS_RESET_STATOVER_Type is record
      SOFT      : Boolean;          -- Indicates if SOFT Reset is asserted
      HARD      : Boolean;          -- Indicates if HARD Reset is asserted
      REBOOT    : Boolean;          -- Indicates if Reboot Reset is asserted
      Reserved1 : Bits_5  := 0;
      SOFT_OVER : Boolean := False; -- When 1, activates the override request for the SOFT Reset output of the Reset Controller.
      HARD_OVER : Boolean := False; -- When 1, activates the override request for the HARD Reset output of the Reset Controller.
      RBT_OVER  : Boolean := False; -- When 1, activates the override request for the Reboot Reset output of the Reset Controller
      Reserved2 : Bits_21 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_RESET_STATOVER_Type use record
      SOFT      at 0 range  0 ..  0;
      HARD      at 0 range  1 ..  1;
      REBOOT    at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  7;
      SOFT_OVER at 0 range  8 ..  8;
      HARD_OVER at 0 range  9 ..  9;
      RBT_OVER  at 0 range 10 .. 10;
      Reserved2 at 0 range 11 .. 31;
   end record;

   -- 4.11.17 SYS_SYSTEM_STAT Register

   type SYS_SYSTEM_STAT_Type is record
      Reserved1         : Bits_1;
      Reserved2         : Bits_1;
      Reserved3         : Bits_1;
      DBG_SEC_ACT       : Boolean; -- Indicates if the Debug Security is currently active
      JTAG_SWD_LOCK_ACT : Boolean; -- Indicates if JTAG and SWD Lock is active
      IP_PROT_ACT       : Boolean; -- Indicates if IP protection is active
      Reserved4         : Bits_26;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_SYSTEM_STAT_Type use record
      Reserved1         at 0 range 0 ..  0;
      Reserved2         at 0 range 1 ..  1;
      Reserved3         at 0 range 2 ..  2;
      DBG_SEC_ACT       at 0 range 3 ..  3;
      JTAG_SWD_LOCK_ACT at 0 range 4 ..  4;
      IP_PROT_ACT       at 0 range 5 ..  5;
      Reserved4         at 0 range 6 .. 31;
   end record;

   -- Table 6-34. SYSCTL Registers

   SYSCTL_BASEADDRESS : constant := 16#E004_3000#;

   SYS_REBOOT_CTL : aliased SYS_REBOOT_CTL_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_NMI_CTLSTAT : aliased SYS_NMI_CTLSTAT_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_WDTRESET_CTL : aliased SYS_WDTRESET_CTL_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0008#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_PERIHALT_CTL : aliased SYS_PERIHALT_CTL_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#000C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_SRAM_SIZE : aliased Unsigned_32
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0010#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_SRAM_BANKEN : aliased SYS_SRAM_BANKEN_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0014#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_SRAM_BANKRET : aliased SYS_SRAM_BANKRET_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0018#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_FLASH_SIZE : aliased Unsigned_32
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0020#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_DIO_GLTFLT_CTL : aliased SYS_DIO_GLTFLT_CTL_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0030#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_SECDATA_UNLOCK : aliased SYS_X_UNLOCK_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0040#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_MASTER_UNLOCK : aliased SYS_X_UNLOCK_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#1000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_BOOTOVER_REQ0 : aliased Unsigned_32
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#1004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_BOOTOVER_REQ1 : aliased Unsigned_32
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#1008#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_BOOTOVER_ACK : aliased Unsigned_32
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#100C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_RESET_REQ : aliased SYS_RESET_REQ_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#1010#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_RESET_STATOVER : aliased SYS_RESET_STATOVER_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#1014#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SYS_SYSTEM_STAT : aliased SYS_SYSTEM_STAT_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#1020#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 6 Clock System (CS)
   ----------------------------------------------------------------------------

   -- 6.3.1 CSKEY Register Clock System Key Register

   CSKEY_CSKEY : constant := 16#695A#;

   type CSKEY_Type is record
      CSKEY    : Unsigned_16;      -- Write CSKEY = xxxx_695Ah to unlock CS registers. All 16 LSBs need to be written together.
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSKEY_Type use record
      CSKEY    at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 6.3.2 CSCTL0 Register Clock System Control 0 Register

   DCORSEL_1M5      : constant := 2#000#; -- Nominal DCO Frequency (MHz): 1.5; Nominal DCO Frequency Range (MHz): 1 to 2
   DCORSEL_3M       : constant := 2#001#; -- Nominal DCO Frequency (MHz): 3; Nominal DCO Frequency Range (MHz): 2 to 4
   DCORSEL_6M       : constant := 2#010#; -- Nominal DCO Frequency (MHz): 6; Nominal DCO Frequency Range (MHz): 4 to 8
   DCORSEL_12M      : constant := 2#011#; -- Nominal DCO Frequency (MHz): 12; Nominal DCO Frequency Range (MHz): 8 to 16
   DCORSEL_24M      : constant := 2#100#; -- Nominal DCO Frequency (MHz): 24; Nominal DCO Frequency Range (MHz): 16 to 32
   DCORSEL_48M      : constant := 2#101#; -- Nominal DCO Frequency (MHz): 48; Nominal DCO Frequency Range (MHz): 32 to 64
   DCORSEL_RSVD1M5  : constant := 2#110#; -- Nominal DCO Frequency (MHz): Reserved--defaults to 1.5 when selected;
   DCORSEL_RSVD1OR2 : constant := 2#111#; -- Nominal DCO Frequency Range (MHz): Reserved--defaults to 1 to 2 when selected.

   type CSCTL0_Type is record
      DCOTUNE   : Bits_10;      -- DCO frequency tuning select.
      Reserved1 : Bits_3  := 0;
      Reserved2 : Bits_3  := 0;
      DCORSEL   : Bits_3;       -- DCO frequency range select.
      Reserved3 : Bits_3  := 0;
      DCORES    : Boolean;      -- Enables the DCO external resistor mode.
      DCOEN     : Boolean;      -- Enables the DCO oscillator regardless if used as a clock resource.
      Reserved4 : Bits_1  := 0;
      Reserved5 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCTL0_Type use record
      DCOTUNE   at 0 range  0 ..  9;
      Reserved1 at 0 range 10 .. 12;
      Reserved2 at 0 range 13 .. 15;
      DCORSEL   at 0 range 16 .. 18;
      Reserved3 at 0 range 19 .. 21;
      DCORES    at 0 range 22 .. 22;
      DCOEN     at 0 range 23 .. 23;
      Reserved4 at 0 range 24 .. 24;
      Reserved5 at 0 range 25 .. 31;
   end record;

   -- 6.3.3 CSCTL1 Register Clock System Control 1 Register

   SELM_LFXTCLK     : constant := 2#000#; -- LFXTCLK
   SELM_VLOCLK      : constant := 2#001#; -- VLOCLK
   SELM_REFOCLK     : constant := 2#010#; -- REFOCLK
   SELM_DCOCLK      : constant := 2#011#; -- DCOCLK
   SELM_MODOSC      : constant := 2#100#; -- MODOSC
   SELM_HFXTCLK     : constant := 2#101#; -- HFXTCLK
   SELM_RSVDDCOCLK1 : constant := 2#110#; -- Reserved for future use. Defaults to DCOCLK.
   SELM_RSVDDCOCLK2 : constant := 2#111#; -- Reserved for future use. Defaults to DCOCLK.

   SELS_LFXTCLK     : constant := 2#000#; -- LFXTCLK
   SELS_VLOCLK      : constant := 2#001#; -- VLOCLK
   SELS_REFOCLK     : constant := 2#010#; -- REFOCLK
   SELS_DCOCLK      : constant := 2#011#; -- DCOCLK
   SELS_MODOSC      : constant := 2#100#; -- MODOSC
   SELS_HFXTCLK     : constant := 2#101#; -- HFXTCLK
   SELS_RSVDDCOCLK1 : constant := 2#110#; -- Reserved for future use. Defaults to DCOCLK.
   SELS_RSVDDCOCLK2 : constant := 2#111#; -- Reserved for future use. Defaults to DCOCLK.

   SELA_LFXTCLK      : constant := 2#000#; -- LFXTCLK
   SELA_VLOCLK       : constant := 2#001#; -- VLOCLK
   SELA_REFOCLK      : constant := 2#010#; -- REFOCLK
   SELA_RSVDREFOCLK1 : constant := 2#011#; -- Reserved for future use. Defaults to REFOCLK.
   SELA_RSVDREFOCLK2 : constant := 2#100#; -- Reserved for future use. Defaults to REFOCLK.
   SELA_RSVDREFOCLK3 : constant := 2#101#; -- Reserved for future use. Defaults to REFOCLK.
   SELA_RSVDREFOCLK4 : constant := 2#110#; -- Reserved for future use. Defaults to REFOCLK.
   SELA_RSVDREFOCLK5 : constant := 2#111#; -- Reserved for future use. Defaults to REFOCLK.

   SELB_LFXTCLK : constant := 0; -- LFXTCLK
   SELB_REFOCLK : constant := 1; -- REFOCLK

   DIVM_DIV1   : constant := 2#000#; -- f(MCLK)/1
   DIVM_DIV2   : constant := 2#001#; -- f(MCLK)/2
   DIVM_DIV4   : constant := 2#010#; -- f(MCLK)/4
   DIVM_DIV8   : constant := 2#011#; -- f(MCLK)/8
   DIVM_DIV16  : constant := 2#100#; -- f(MCLK)/16
   DIVM_DIV32  : constant := 2#101#; -- f(MCLK)/32
   DIVM_DIV64  : constant := 2#110#; -- f(MCLK)/64
   DIVM_DIV128 : constant := 2#111#; -- f(MCLK)/128

   DIVHS_DIV1   : constant := 2#000#; -- f(HSMCLK)/1
   DIVHS_DIV2   : constant := 2#001#; -- f(HSMCLK)/2
   DIVHS_DIV4   : constant := 2#010#; -- f(HSMCLK)/4
   DIVHS_DIV8   : constant := 2#011#; -- f(HSMCLK)/8
   DIVHS_DIV16  : constant := 2#100#; -- f(HSMCLK)/16
   DIVHS_DIV32  : constant := 2#101#; -- f(HSMCLK)/32
   DIVHS_DIV64  : constant := 2#110#; -- f(HSMCLK)/64
   DIVHS_DIV128 : constant := 2#111#; -- f(HSMCLK)/128

   DIVA_DIV1   : constant := 2#000#; -- f(ACLK)/1
   DIVA_DIV2   : constant := 2#001#; -- f(ACLK)/2
   DIVA_DIV4   : constant := 2#010#; -- f(ACLK)/4
   DIVA_DIV8   : constant := 2#011#; -- f(ACLK)/8
   DIVA_DIV16  : constant := 2#100#; -- f(ACLK)/16
   DIVA_DIV32  : constant := 2#101#; -- f(ACLK)/32
   DIVA_DIV64  : constant := 2#110#; -- f(ACLK)/64
   DIVA_DIV128 : constant := 2#111#; -- f(ACLK)/128

   DIVS_DIV1   : constant := 2#000#; -- f(SCLK)/1
   DIVS_DIV2   : constant := 2#001#; -- f(SCLK)/2
   DIVS_DIV4   : constant := 2#010#; -- f(SCLK)/4
   DIVS_DIV8   : constant := 2#011#; -- f(SCLK)/8
   DIVS_DIV16  : constant := 2#100#; -- f(SCLK)/16
   DIVS_DIV32  : constant := 2#101#; -- f(SCLK)/32
   DIVS_DIV64  : constant := 2#110#; -- f(SCLK)/64
   DIVS_DIV128 : constant := 2#111#; -- f(SCLK)/128

   type CSCTL1_Type is record
      SELM      : Bits_3;      -- Selects the MCLK source.
      Reserved1 : Bits_1 := 0;
      SELS      : Bits_3;      -- Selects the SMCLK and HSMCLK source.
      Reserved2 : Bits_1 := 0;
      SELA      : Bits_3;      -- Selects the ACLK source.
      Reserved3 : Bits_1 := 0;
      SELB      : Bits_1;      -- Selects the BCLK source.
      Reserved4 : Bits_2 := 0;
      Reserved5 : Bits_1 := 0;
      DIVM      : Bits_3;      -- MCLK source divider.
      Reserved6 : Bits_1 := 0;
      DIVHS     : Bits_3;      -- HSMCLK source divider.
      Reserved7 : Bits_1 := 0;
      DIVA      : Bits_3;      -- ACLK source divider.
      Reserved8 : Bits_1 := 0;
      DIVS      : Bits_3;      -- SMCLK source divider.
      Reserved9 : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCTL1_Type use record
      SELM      at 0 range  0 ..  2;
      Reserved1 at 0 range  3 ..  3;
      SELS      at 0 range  4 ..  6;
      Reserved2 at 0 range  7 ..  7;
      SELA      at 0 range  8 .. 10;
      Reserved3 at 0 range 11 .. 11;
      SELB      at 0 range 12 .. 12;
      Reserved4 at 0 range 13 .. 14;
      Reserved5 at 0 range 15 .. 15;
      DIVM      at 0 range 16 .. 18;
      Reserved6 at 0 range 19 .. 19;
      DIVHS     at 0 range 20 .. 22;
      Reserved7 at 0 range 23 .. 23;
      DIVA      at 0 range 24 .. 26;
      Reserved8 at 0 range 27 .. 27;
      DIVS      at 0 range 28 .. 30;
      Reserved9 at 0 range 31 .. 31;
   end record;

   -- 6.3.4 CSCTL2 Register Clock System Control 2 Register

   LFXTDRIVE_0 : constant := 0; -- Lowest drive strength and current consumption LFXT oscillator.
   LFXTDRIVE_1 : constant := 1; -- Increased drive strength LFXT oscillator.
   LFXTDRIVE_2 : constant := 2; -- Increased drive strength LFXT oscillator.
   LFXTDRIVE_3 : constant := 3; -- Maximum drive strength and maximum current consumption LFXT oscillator.

   LFXTBYPASS_EXTAL : constant := 0; -- LFXT sourced by external crystal.
   LFXTBYPASS_SQRWV : constant := 1; -- LFXT sourced by external square wave.

   HFXTDRIVE_1_4  : constant := 0; -- To be used for HFXTFREQ setting 000b
   HFXTDRIVE_5_48 : constant := 1; -- To be used for HFXTFREQ settings 001b to 110b

   HFXTFREQ_1_4      : constant := 2#000#; -- 1 MHz to 4 MHz
   HFXTFREQ_5_8      : constant := 2#001#; -- >4 MHz to 8 MHz
   HFXTFREQ_9_16     : constant := 2#010#; -- >8 MHz to 16 MHz
   HFXTFREQ_17_24    : constant := 2#011#; -- >16 MHz to 24 MHz
   HFXTFREQ_25_32    : constant := 2#100#; -- >24 MHz to 32 MHz
   HFXTFREQ_33_40    : constant := 2#101#; -- >32 MHz to 40 MHz
   HFXTFREQ_41_48    : constant := 2#110#; -- >40 MHz to 48 MHz
   HFXTFREQ_RESERVED : constant := 2#111#; -- Reserved for future use.

   HFXTBYPASS_EXTAL : constant := 0; -- HFXT sourced by external crystal.
   HFXTBYPASS_SQRWV : constant := 1; -- HFXT sourced by external square wave.

   type CSCTL2_Type is record
      LFXTDRIVE  : Bits_2;       -- The LFXT oscillator current can be adjusted to its drive needs.
      Reserved1  : Bits_1  := 0;
      Reserved2  : Bits_4  := 0;
      Reserved3  : Bits_1  := 0;
      LFXT_EN    : Boolean;      -- Turns on the LFXT oscillator regardless if used as a clock resource.
      LFXTBYPASS : Bits_1;       -- LFXT bypass select.
      Reserved4  : Bits_6  := 0;
      HFXTDRIVE  : Bits_1;       -- HFXT oscillator drive selection.
      Reserved5  : Bits_2  := 0;
      Reserved6  : Bits_1  := 0;
      HFXTFREQ   : Bits_3;       -- HFXT frequency selection.
      Reserved7  : Bits_1  := 0;
      HFXT_EN    : Boolean;      -- Turns on the HFXT oscillator regardless if used as a clock resource.
      HFXTBYPASS : Bits_1;       -- HFXT bypass select.
      Reserved8  : Bits_6  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCTL2_Type use record
      LFXTDRIVE  at 0 range  0 ..  1;
      Reserved1  at 0 range  2 ..  2;
      Reserved2  at 0 range  3 ..  6;
      Reserved3  at 0 range  7 ..  7;
      LFXT_EN    at 0 range  8 ..  8;
      LFXTBYPASS at 0 range  9 ..  9;
      Reserved4  at 0 range 10 .. 15;
      HFXTDRIVE  at 0 range 16 .. 16;
      Reserved5  at 0 range 17 .. 18;
      Reserved6  at 0 range 19 .. 19;
      HFXTFREQ   at 0 range 20 .. 22;
      Reserved7  at 0 range 23 .. 23;
      HFXT_EN    at 0 range 24 .. 24;
      HFXTBYPASS at 0 range 25 .. 25;
      Reserved8  at 0 range 26 .. 31;
   end record;

   -- 6.3.5 CSCTL3 Register Clock System Control 3 Register

   FCNTLF_4k  : constant := 2#00#; -- 4096 cycles
   FCNTLF_8k  : constant := 2#01#; -- 8192 cycles
   FCNTLF_16k : constant := 2#10#; -- 16384 cycles
   FCNTLF_32k : constant := 2#11#; -- 32768 cycles

   FCNTHF_4k  : constant := 2#00#; -- 4096 cycles
   FCNTHF_8k  : constant := 2#01#; -- 8192 cycles
   FCNTHF_16k : constant := 2#10#; -- 16384 cycles
   FCNTHF_32k : constant := 2#11#; -- 32768 cycles

   type CSCTL3_Type is record
      FCNTLF    : Bits_2;       -- Start flag counter for LFXT.
      RFCNTLF   : Boolean;      -- Reset start fault counter for LFXT.
      FCNTLF_EN : Boolean;      -- Enable start fault counter for LFXT.
      FCNTHF    : Bits_2;       -- Start flag counter for HFXT.
      RFCNTHF   : Boolean;      -- Reset start fault counter for HFXT.
      FCNTHF_EN : Boolean;      -- Enable start fault counter for HFXT.
      Reserved  : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCTL3_Type use record
      FCNTLF    at 0 range 0 ..  1;
      RFCNTLF   at 0 range 2 ..  2;
      FCNTLF_EN at 0 range 3 ..  3;
      FCNTHF    at 0 range 4 ..  5;
      RFCNTHF   at 0 range 6 ..  6;
      FCNTHF_EN at 0 range 7 ..  7;
      Reserved  at 0 range 8 .. 31;
   end record;

   -- 6.3.6 CSCLKEN Register Clock System Clock Enable Register

   REFOFSEL_32k  : constant := 0; -- 32.768 kHz
   REFOFSEL_128k : constant := 1; -- 128 kHz

   type CSCLKEN_Type is record
      ACLK_EN   : Boolean;      -- ACLK system clock conditional request enable
      MCLK_EN   : Boolean;      -- MCLK system clock conditional request enable
      HSMCLK_EN : Boolean;      -- HSMCLK system clock conditional request enable
      SMCLK_EN  : Boolean;      -- SMCLK system clock conditional request enable
      Reserved1 : Bits_4  := 0;
      VLO_EN    : Boolean;      -- Turns on the VLO oscillator regardless if used as a clock resource.
      REFO_EN   : Boolean;      -- Turns on the REFO oscillator regardless if used as a clock resource.
      MODOSC_EN : Boolean;      -- Turns on the MODOSC oscillator regardless if used as a clock resource.
      Reserved2 : Bits_4  := 0;
      REFOFSEL  : Bits_1;       -- Selects REFO nominal frequency.
      Reserved3 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCLKEN_Type use record
      ACLK_EN   at 0 range  0 ..  0;
      MCLK_EN   at 0 range  1 ..  1;
      HSMCLK_EN at 0 range  2 ..  2;
      SMCLK_EN  at 0 range  3 ..  3;
      Reserved1 at 0 range  4 ..  7;
      VLO_EN    at 0 range  8 ..  8;
      REFO_EN   at 0 range  9 ..  9;
      MODOSC_EN at 0 range 10 .. 10;
      Reserved2 at 0 range 11 .. 14;
      REFOFSEL  at 0 range 15 .. 15;
      Reserved3 at 0 range 16 .. 31;
   end record;

   -- 6.3.7 CSSTAT Register Clock System Status Register

   type CSSTAT_Type is record
      DCO_ON       : Boolean; -- DCO status
      DCOBIAS_ON   : Boolean; -- DCO bias status
      HFXT_ON      : Boolean; -- HFXT status.
      Reserved1    : Bits_1;
      MODOSC_ON    : Boolean; -- MODOSC status
      VLO_ON       : Boolean; -- VLO status
      LFXT_ON      : Boolean; -- LFXT status.
      REFO_ON      : Boolean; -- REFO status
      Reserved2    : Bits_8;
      ACLK_ON      : Boolean; -- ACLK system clock status
      MCLK_ON      : Boolean; -- MCLK system clock status
      HSMCLK_ON    : Boolean; -- HSMCLK system clock status
      SMCLK_ON     : Boolean; -- SMCLK system clock status
      MODCLK_ON    : Boolean; -- MODCLK system clock status
      VLOCLK_ON    : Boolean; -- VLOCLK system clock status
      LFXTCLK_ON   : Boolean; -- LFXTCLK system clock status
      REFOCLK_ON   : Boolean; -- REFOCLK system clock status
      ACLK_READY   : Boolean; -- ACLK Ready status.
      MCLK_READY   : Boolean; -- MCLK Ready status.
      HSMCLK_READY : Boolean; -- HSMCLK Ready status.
      SMCLK_READY  : Boolean; -- SMCLK Ready status.
      BCLK_READY   : Boolean; -- BCLK Ready status.
      Reserved3    : Bits_3;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSSTAT_Type use record
      DCO_ON       at 0 range  0 ..  0;
      DCOBIAS_ON   at 0 range  1 ..  1;
      HFXT_ON      at 0 range  2 ..  2;
      Reserved1    at 0 range  3 ..  3;
      MODOSC_ON    at 0 range  4 ..  4;
      VLO_ON       at 0 range  5 ..  5;
      LFXT_ON      at 0 range  6 ..  6;
      REFO_ON      at 0 range  7 ..  7;
      Reserved2    at 0 range  8 .. 15;
      ACLK_ON      at 0 range 16 .. 16;
      MCLK_ON      at 0 range 17 .. 17;
      HSMCLK_ON    at 0 range 18 .. 18;
      SMCLK_ON     at 0 range 19 .. 19;
      MODCLK_ON    at 0 range 20 .. 20;
      VLOCLK_ON    at 0 range 21 .. 21;
      LFXTCLK_ON   at 0 range 22 .. 22;
      REFOCLK_ON   at 0 range 23 .. 23;
      ACLK_READY   at 0 range 24 .. 24;
      MCLK_READY   at 0 range 25 .. 25;
      HSMCLK_READY at 0 range 26 .. 26;
      SMCLK_READY  at 0 range 27 .. 27;
      BCLK_READY   at 0 range 28 .. 28;
      Reserved3    at 0 range 29 .. 31;
   end record;

   -- 6.3.8 CSIE Register Clock System Interrupt Enable Register

   type CSIE_Type is record
      LFXTIE     : Boolean;      -- LFXT oscillator fault flag interrupt enable.
      HFXTIE     : Boolean;      -- HFXT oscillator fault flag interrupt enable.
      Reserved1  : Bits_1  := 0;
      Reserved2  : Bits_1  := 0;
      Reserved3  : Bits_1  := 0;
      Reserved4  : Bits_1  := 0;
      DCOR_OPNIE : Boolean;      -- DCO external resistor open circuit fault flag interrupt enable.
      Reserved5  : Bits_1  := 0;
      FCNTLFIE   : Boolean;      -- Start fault counter interrupt enable LFXT.
      FCNTHFIE   : Boolean;      -- Start fault counter interrupt enable HFXT.
      Reserved6  : Bits_22 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSIE_Type use record
      LFXTIE     at 0 range  0 ..  0;
      HFXTIE     at 0 range  1 ..  1;
      Reserved1  at 0 range  2 ..  2;
      Reserved2  at 0 range  3 ..  3;
      Reserved3  at 0 range  4 ..  4;
      Reserved4  at 0 range  5 ..  5;
      DCOR_OPNIE at 0 range  6 ..  6;
      Reserved5  at 0 range  7 ..  7;
      FCNTLFIE   at 0 range  8 ..  8;
      FCNTHFIE   at 0 range  9 ..  9;
      Reserved6  at 0 range 10 .. 31;
   end record;

   -- 6.3.9 CSIFG Register Clock System Interrupt Flag Register

   type CSIFG_Type is record
      LFXTIFG     : Boolean; -- LFXT oscillator fault flag.
      HFXTIFG     : Boolean; -- HFXT oscillator fault flag.
      Reserved1   : Bits_1;
      Reserved2   : Bits_1;
      Reserved3   : Bits_1;
      DCOR_SHTIFG : Boolean; -- DCO external resistor short circuit fault flag.
      DCOR_OPNIFG : Boolean; -- DCO external resistor open circuit fault flag.
      Reserved4   : Bits_1;
      FCNTLFIFG   : Boolean; -- Start fault counter interrupt flag LFXT.
      FCNTHFIFG   : Boolean; -- Start fault counter interrupt flag HFXT.
      Reserved5   : Bits_22;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSIFG_Type use record
      LFXTIFG     at 0 range  0 ..  0;
      HFXTIFG     at 0 range  1 ..  1;
      Reserved1   at 0 range  2 ..  2;
      Reserved2   at 0 range  3 ..  3;
      Reserved3   at 0 range  4 ..  4;
      DCOR_SHTIFG at 0 range  5 ..  5;
      DCOR_OPNIFG at 0 range  6 ..  6;
      Reserved4   at 0 range  7 ..  7;
      FCNTLFIFG   at 0 range  8 ..  8;
      FCNTHFIFG   at 0 range  9 ..  9;
      Reserved5   at 0 range 10 .. 31;
   end record;

   -- 6.3.10 CSCLRIFG Register Clock System Clear Interrupt Flag Register

   type CSCLRIFG_Type is record
      CLR_LFXTIFG     : Boolean := False; -- Clear LFXT oscillator fault interrupt flag.
      CLR_HFXTIFG     : Boolean := False; -- Clear HFXT oscillator fault interrupt flag.
      Reserved1       : Bits_1  := 0;
      Reserved2       : Bits_1  := 0;
      Reserved3       : Bits_1  := 0;
      Reserved4       : Bits_1  := 0;
      CLR_DCOR_OPNIFG : Boolean := False; -- Clear DCO external resistor open circuit fault interrupt flag.
      Reserved5       : Bits_1  := 0;
      CLR_FCNTLFIFG   : Boolean := False; -- Start fault counter clear interrupt flag LFXT.
      CLR_FCNTHFIFG   : Boolean := False; -- Start fault counter clear interrupt flag HFXT.
      Reserved6       : Bits_22 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCLRIFG_Type use record
      CLR_LFXTIFG     at 0 range  0 ..  0;
      CLR_HFXTIFG     at 0 range  1 ..  1;
      Reserved1       at 0 range  2 ..  2;
      Reserved2       at 0 range  3 ..  3;
      Reserved3       at 0 range  4 ..  4;
      Reserved4       at 0 range  5 ..  5;
      CLR_DCOR_OPNIFG at 0 range  6 ..  6;
      Reserved5       at 0 range  7 ..  7;
      CLR_FCNTLFIFG   at 0 range  8 ..  8;
      CLR_FCNTHFIFG   at 0 range  9 ..  9;
      Reserved6       at 0 range 10 .. 31;
   end record;

   -- 6.3.11 CSSETIFG Register Clock System Clear Interrupt Flag Register

   type CSSETIFG_Type is record
      SET_LFXTIFG     : Boolean;      -- Set LFXT oscillator fault interrupt flag.
      SET_HFXTIFG     : Boolean;      -- Set HFXT oscillator fault interrupt flag.
      Reserved1       : Bits_1  := 0;
      Reserved2       : Bits_1  := 0;
      Reserved3       : Bits_1  := 0;
      Reserved4       : Bits_1  := 0;
      SET_DCOR_OPNIFG : Boolean;      -- Set DCO external resistor open circuit fault interrupt flag.
      Reserved5       : Bits_1  := 0;
      SET_FCNTLFIFG   : Boolean;      -- Start fault counter set interrupt flag LFXT.
      SET_FCNTHFIFG   : Boolean;      -- Start fault counter set interrupt flag HFXT.
      Reserved6       : Bits_22 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSSETIFG_Type use record
      SET_LFXTIFG     at 0 range  0 ..  0;
      SET_HFXTIFG     at 0 range  1 ..  1;
      Reserved1       at 0 range  2 ..  2;
      Reserved2       at 0 range  3 ..  3;
      Reserved3       at 0 range  4 ..  4;
      Reserved4       at 0 range  5 ..  5;
      SET_DCOR_OPNIFG at 0 range  6 ..  6;
      Reserved5       at 0 range  7 ..  7;
      SET_FCNTLFIFG   at 0 range  8 ..  8;
      SET_FCNTHFIFG   at 0 range  9 ..  9;
      Reserved6       at 0 range 10 .. 31;
   end record;

   -- 6.3.12 CSDCOERCAL0 Register DCO External Resistor Calibration 0 Register

   type CSDCOERCAL0_Type is record
      DCO_TCCAL       : Bits_2;       -- DCO Temperature compensation calibration.
      Reserved1       : Bits_14 := 0;
      DCO_FCAL_RSEL04 : Bits_10;      -- DCO frequency calibration for DCO frequency range (DCORSEL) 0 to 4.
      Reserved2       : Bits_6  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSDCOERCAL0_Type use record
      DCO_TCCAL       at 0 range  0 ..  1;
      Reserved1       at 0 range  2 .. 15;
      DCO_FCAL_RSEL04 at 0 range 16 .. 25;
      Reserved2       at 0 range 26 .. 31;
   end record;

   -- 6.3.13 CSDCOERCAL1 Register DCO External Resistor Calibration 1 Register

   type CSDCOERCAL1_Type is record
      DCO_FCAL_RSEL5 : Bits_10;      -- DCO frequency calibration for DCO frequency range (DCORSEL) 5.
      Reserved       : Bits_22 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSDCOERCAL1_Type use record
      DCO_FCAL_RSEL5 at 0 range  0 ..  9;
      Reserved       at 0 range 10 .. 31;
   end record;

   -- Table 6-28. CS Registers

   CS_BASEADDRESS : constant := 16#4001_0400#;

   CSKEY : aliased CSKEY_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCTL0 : aliased CSCTL0_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCTL1 : aliased CSCTL1_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#08#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCTL2 : aliased CSCTL2_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCTL3 : aliased CSCTL3_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#10#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCLKEN : aliased CSCLKEN_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#30#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSSTAT : aliased CSSTAT_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#34#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSIE : aliased CSIE_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#40#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSIFG : aliased CSIFG_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#48#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCLRIFG : aliased CSCLRIFG_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#50#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSSETIFG : aliased CSSETIFG_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#58#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSDCOERCAL0 : aliased CSDCOERCAL0_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#60#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSDCOERCAL1 : aliased CSDCOERCAL1_Type
      with Address              => System'To_Address (CS_BASEADDRESS + 16#64#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 7 Power Supply System (PSS)
   ----------------------------------------------------------------------------

   -- 7.3.1 PSSKEY Register PSS Key Register

   PSSKEY_KEY : constant := 16#A596#;

   type PSSKEY_Type is record
      PSSKEY   : Unsigned_16;      -- PSS key.
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PSSKEY_Type use record
      PSSKEY   at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 7.3.2 PSSCTL0 Register PSS Control 0 Register

   SVSMHS_SVSH : constant := 0; -- Configure as SVSH
   SVSMHS_SVMH : constant := 1; -- Configure as SVMH

   SVSMHTH_0 : constant := 2#000#; -- Table 5-22. PSS, SVSMH
   SVSMHTH_1 : constant := 2#001#; -- ''
   SVSMHTH_2 : constant := 2#010#; -- ''
   SVSMHTH_3 : constant := 2#011#; -- ''
   SVSMHTH_4 : constant := 2#100#; -- ''
   SVSMHTH_5 : constant := 2#101#; -- ''
   SVSMHTH_6 : constant := 2#110#; -- ''
   SVSMHTH_7 : constant := 2#111#; -- ''

   type PSSCTL0_Type is record
      SVSMHOFF     : Boolean;      -- SVSM high-side off
      SVSMHLP      : Boolean;      -- SVSM high-side low power normal performance mode
      SVSMHS       : Bits_1;       -- Supply supervisor or monitor selection for the high-side
      SVSMHTH      : Bits_3;       -- SVSM high-side reset voltage level.
      SVMHOE       : Boolean;      -- SVSM high-side output enable
      SVMHOUTPOLAL : Boolean;      -- SVMHOUT pin polarity active low.
      Reserved1    : Bits_2  := 0;
      DCDC_FORCE   : Boolean;      -- Force DC/DC regulator operation.
      Reserved2    : Bits_1  := 0;
      Reserved3    : Bits_2  := 2;
      Reserved4    : Bits_18 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PSSCTL0_Type use record
      SVSMHOFF     at 0 range  0 ..  0;
      SVSMHLP      at 0 range  1 ..  1;
      SVSMHS       at 0 range  2 ..  2;
      SVSMHTH      at 0 range  3 ..  5;
      SVMHOE       at 0 range  6 ..  6;
      SVMHOUTPOLAL at 0 range  7 ..  7;
      Reserved1    at 0 range  8 ..  9;
      DCDC_FORCE   at 0 range 10 .. 10;
      Reserved2    at 0 range 11 .. 11;
      Reserved3    at 0 range 12 .. 13;
      Reserved4    at 0 range 14 .. 31;
   end record;

   -- 7.3.3 PSSIE Register PSS Interrupt Enable Register

   type PSSIE_Type is record
      Reserved1 : Bits_1  := 0;
      SVSMHIE   : Boolean;      -- High-side SVSM interrupt enable, when set as a monitor (SVSMHS = 1).
      Reserved2 : Bits_30 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PSSIE_Type use record
      Reserved1 at 0 range 0 ..  0;
      SVSMHIE   at 0 range 1 ..  1;
      Reserved2 at 0 range 2 .. 31;
   end record;

   -- 7.3.4 PSSIFG Register PSS Interrupt Flag Register

   type PSSIFG_Type is record
      Reserved1 : Bits_1  := 0;
      SVSMHIFG  : Boolean;      -- High-side SVSM interrupt flag.
      Reserved2 : Bits_30 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PSSIFG_Type use record
      Reserved1 at 0 range 0 ..  0;
      SVSMHIFG  at 0 range 1 ..  1;
      Reserved2 at 0 range 2 .. 31;
   end record;

   -- 7.3.5 PSSCLRIFG Register PSS Clear Interrupt Flag Register

   type PSSCLRIFG_Type is record
      Reserved1   : Bits_1  := 0;
      CLRSVSMHIFG : Boolean;      -- SVSMH clear interrupt flag
      Reserved2   : Bits_30 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PSSCLRIFG_Type use record
      Reserved1   at 0 range 0 ..  0;
      CLRSVSMHIFG at 0 range 1 ..  1;
      Reserved2   at 0 range 2 .. 31;
   end record;

   -- Table 6-29. PSS Registers

   PSS_BASEADDRESS : constant := 16#4001_0800#;

   PSSKEY : aliased PSSKEY_Type
      with Address              => System'To_Address (PSS_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PSSCTL0 : aliased PSSCTL0_Type
      with Address              => System'To_Address (PSS_BASEADDRESS + 16#04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PSSIE : aliased PSSIE_Type
      with Address              => System'To_Address (PSS_BASEADDRESS + 16#34#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PSSIFG : aliased PSSIFG_Type
      with Address              => System'To_Address (PSS_BASEADDRESS + 16#38#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PSSCLRIFG : aliased PSSCLRIFG_Type
      with Address              => System'To_Address (PSS_BASEADDRESS + 16#3C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 8 Power Control Manager (PCM)
   ----------------------------------------------------------------------------

   PCMKEY_KEY : constant := 16#695A#;

   -- 8.26.1 PCMCTL0 Register PCM Control 0 Register

   AMR_AM_LDO_VCORE0  : constant := 16#0#; -- LDO based Active Mode at Core voltage setting 0.
   AMR_AM_LDO_VCORE1  : constant := 16#1#; -- LDO based Active Mode at Core voltage setting 1.
   AMR_RSVD1          : constant := 16#2#; -- Reserved
   AMR_RSVD2          : constant := 16#3#; -- Reserved
   AMR_AM_DCDC_VCORE0 : constant := 16#4#; -- DC-DC based Active Mode at Core voltage setting 0.
   AMR_AM_DCDC_VCORE1 : constant := 16#5#; -- DC-DC based Active Mode at Core voltage setting 1.
   AMR_RSVD3          : constant := 16#6#; -- Reserved
   AMR_RSVD4          : constant := 16#7#; -- Reserved
   AMR_AM_LF_VCORE0   : constant := 16#8#; -- Low-Frequency Active Mode at Core voltage setting 0.
   AMR_AM_LF_VCORE1   : constant := 16#9#; -- Low-Frequency Active Mode at Core voltage setting 1.
   AMR_RSVD5          : constant := 16#A#; -- Reserved
   AMR_RSVD6          : constant := 16#B#; -- Reserved
   AMR_RSVD7          : constant := 16#C#; -- Reserved
   AMR_RSVD8          : constant := 16#D#; -- Reserved
   AMR_RSVD9          : constant := 16#E#; -- Reserved
   AMR_RSVD10         : constant := 16#F#; -- Reserved

   LPMR_LPM3   : constant := 16#0#; -- LPM3. Core voltage setting is similar to the mode from which LPM3 is entered.
   LPMR_RSVD1  : constant := 16#1#; -- Reserved.
   LPMR_RSVD2  : constant := 16#2#; -- Reserved.
   LPMR_RSVD3  : constant := 16#3#; -- Reserved.
   LPMR_RSVD4  : constant := 16#4#; -- Reserved.
   LPMR_RSVD5  : constant := 16#5#; -- Reserved.
   LPMR_RSVD6  : constant := 16#6#; -- Reserved.
   LPMR_RSVD7  : constant := 16#7#; -- Reserved.
   LPMR_RSVD8  : constant := 16#8#; -- Reserved.
   LPMR_RSVD9  : constant := 16#9#; -- Reserved.
   LPMR_LPM35  : constant := 16#A#; -- LPM3.5. Core voltage setting 0.
   LPMR_RSVD10 : constant := 16#B#; -- Reserved.
   LPMR_LPM45  : constant := 16#C#; -- LPM4.5.
   LPMR_RSVD11 : constant := 16#D#; -- Reserved.
   LPMR_RSVD12 : constant := 16#E#; -- Reserved.
   LPMR_RSVD13 : constant := 16#F#; -- Reserved.

   CPM_AM_LDO_VCORE0    : constant := 16#00#; -- LDO based Active Mode at Core voltage setting 0.
   CPM_AM_LDO_VCORE1    : constant := 16#01#; -- LDO based Active Mode at Core voltage setting 1.
   CPM_AM_DCDC_VCORE0   : constant := 16#04#; -- DC-DC based Active Mode at Core voltage setting 0.
   CPM_AM_DCDC_VCORE1   : constant := 16#05#; -- DC-DC based Active Mode at Core voltage setting 1.
   CPM_AM_LF_VCORE0     : constant := 16#08#; -- Low-Frequency Active Mode at Core voltage setting 0.
   CPM_AM_LF_VCORE1     : constant := 16#09#; -- Low-Frequency Active Mode at Core voltage setting 1.
   CPM_LPM0_LDO_VCORE0  : constant := 16#10#; -- LDO based LPM0 at Core voltage setting 0.
   CPM_LPM0_LDO_VCORE1  : constant := 16#11#; -- LDO based LPM0 at Core voltage setting 1.
   CPM_LPM0_DCDC_VCORE0 : constant := 16#14#; -- DC-DC based LPM0 at Core voltage setting 0.
   CPM_LPM0_DCDC_VCORE1 : constant := 16#15#; -- DC-DC based LPM0 at Core voltage setting 1.
   CPM_LPM0_LF_VCORE0   : constant := 16#18#; -- Low-Frequency LPM0 at Core voltage setting 0.
   CPM_LPM0_LF_VCORE1   : constant := 16#19#; -- Low-Frequency LPM0 at Core voltage setting 1.
   CPM_LPM3             : constant := 16#20#; -- LPM3

   type PCMCTL0_Type is record
      AMR      : Bits_4;                    -- Active Mode Request.
      LPMR     : Bits_4;                    -- Low Power Mode Request.
      CPM      : Bits_6;                    -- Current Power Mode.
      Reserved : Bits_2      := 0;
      PCMKEY   : Unsigned_16 := PCMKEY_KEY; -- PCM key.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PCMCTL0_Type use record
      AMR      at 0 range  0 ..  3;
      LPMR     at 0 range  4 ..  7;
      CPM      at 0 range  8 .. 13;
      Reserved at 0 range 14 .. 15;
      PCMKEY   at 0 range 16 .. 31;
   end record;

   -- 8.26.2 PCMCTL1 Register PCM Control 1 Register

   type PCMCTL1_Type is record
      LOCKLPM5        : Boolean;          -- Lock LPM5.
      LOCKBKUP        : Boolean;          -- Lock Backup.
      FORCE_LPM_ENTRY : Boolean;          -- Bit selection for the application to determine whether the entry into LPM3/LPMx.5 ...
      Reserved1       : Bits_5      := 0;
      PMR_BUSY        : Boolean;          -- Power mode request busy flag.
      Reserved2       : Bits_7      := 0;
      PCMKEY          : Unsigned_16;      -- PCM key.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PCMCTL1_Type use record
      LOCKLPM5        at 0 range  0 ..  0;
      LOCKBKUP        at 0 range  1 ..  1;
      FORCE_LPM_ENTRY at 0 range  2 ..  2;
      Reserved1       at 0 range  3 ..  7;
      PMR_BUSY        at 0 range  8 ..  8;
      Reserved2       at 0 range  9 .. 15;
      PCMKEY          at 0 range 16 .. 31;
   end record;

   -- 8.26.3 PCMIE Register PCM Interrupt Enable Register

   type PCMIE_Type is record
      LPM_INVALID_TR_IE  : Boolean;      -- LPM invalid transition interrupt enable.
      LPM_INVALID_CLK_IE : Boolean;      -- LPM invalid clock interrupt enable.
      AM_INVALID_TR_IE   : Boolean;      -- Active mode invalid transition interrupt enable.
      Reserved1          : Bits_3  := 0;
      DCDC_ERROR_IE      : Boolean;      -- DC-DC error interrupt enable.
      Reserved2          : Bits_25 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PCMIE_Type use record
      LPM_INVALID_TR_IE  at 0 range 0 ..  0;
      LPM_INVALID_CLK_IE at 0 range 1 ..  1;
      AM_INVALID_TR_IE   at 0 range 2 ..  2;
      Reserved1          at 0 range 3 ..  5;
      DCDC_ERROR_IE      at 0 range 6 ..  6;
      Reserved2          at 0 range 7 .. 31;
   end record;

   -- 8.26.4 PCMIFG Register PCM Interrupt Flag Register

   type PCMIFG_Type is record
      LPM_INVALID_TR_IFG  : Boolean;      -- LPM invalid transition flag.
      LPM_INVALID_CLK_IFG : Boolean;      -- LPM invalid clock flag.
      AM_INVALID_TR_IFG   : Boolean;      -- Active mode invalid transition flag.
      Reserved1           : Bits_3  := 0;
      DCDC_ERROR_IFG      : Boolean;      -- DC-DC error flag.
      Reserved2           : Bits_25 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PCMIFG_Type use record
      LPM_INVALID_TR_IFG  at 0 range 0 ..  0;
      LPM_INVALID_CLK_IFG at 0 range 1 ..  1;
      AM_INVALID_TR_IFG   at 0 range 2 ..  2;
      Reserved1           at 0 range 3 ..  5;
      DCDC_ERROR_IFG      at 0 range 6 ..  6;
      Reserved2           at 0 range 7 .. 31;
   end record;

   -- 8.26.5 PCMCLRIFG Register PCM Clear Interrupt Flag Register

   type PCMCLRIFG_Type is record
      CLR_LPM_INVALID_TR_IFG  : Boolean := False;        -- Clear LPM invalid transition flag.
      CLR_LPM_INVALID_CLK_IFG : Boolean := False;        -- Clear LPM invalid clock flag.
      CLR_AM_INVALID_TR_IFG   : Boolean := False;        -- Clear active mode invalid transition flag.
      Reserved1               : Bits_3  := 2#11#;
      CLR_DCDC_ERROR_IFG      : Boolean := False;        -- Clear DC-DC error flag.
      Reserved2               : Bits_25 := 16#1FF_FFFF#;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PCMCLRIFG_Type use record
      CLR_LPM_INVALID_TR_IFG  at 0 range 0 ..  0;
      CLR_LPM_INVALID_CLK_IFG at 0 range 1 ..  1;
      CLR_AM_INVALID_TR_IFG   at 0 range 2 ..  2;
      Reserved1               at 0 range 3 ..  5;
      CLR_DCDC_ERROR_IFG      at 0 range 6 ..  6;
      Reserved2               at 0 range 7 .. 31;
   end record;

   -- Table 6-27. PCM Registers

   PCM_BASEADDRESS : constant := 16#4001_0000#;

   PCMCTL0 : aliased PCMCTL0_Type
      with Address              => System'To_Address (PCM_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PCMCTL1 : aliased PCMCTL1_Type
      with Address              => System'To_Address (PCM_BASEADDRESS + 16#04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PCMIE : aliased PCMIE_Type
      with Address              => System'To_Address (PCM_BASEADDRESS + 16#08#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PCMIFG : aliased PCMIFG_Type
      with Address              => System'To_Address (PCM_BASEADDRESS + 16#0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PCMCLRIFG : aliased PCMCLRIFG_Type
      with Address              => System'To_Address (PCM_BASEADDRESS + 16#10#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 12 Digital I/O
   ----------------------------------------------------------------------------

   type PORT16_Type is record
      PxIN   : Bitmap_16 with Volatile_Full_Access => True;
      PxOUT  : Bitmap_16 with Volatile_Full_Access => True;
      PxDIR  : Bitmap_16 with Volatile_Full_Access => True;
      PxREN  : Bitmap_16 with Volatile_Full_Access => True;
      PxDS   : Bitmap_16 with Volatile_Full_Access => True;
      PxSEL0 : Bitmap_16 with Volatile_Full_Access => True;
      PxSEL1 : Bitmap_16 with Volatile_Full_Access => True;
      PxSELC : Bitmap_16 with Volatile_Full_Access => True;
      PxIES  : Bitmap_16 with Volatile_Full_Access => True;
      PxIE   : Bitmap_16 with Volatile_Full_Access => True;
      PxIFG  : Bitmap_16 with Volatile_Full_Access => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16#1E# * 8;
   for PORT16_Type use record
      PxIN   at 16#00# range 0 .. 15;
      PxOUT  at 16#02# range 0 .. 15;
      PxDIR  at 16#04# range 0 .. 15;
      PxREN  at 16#06# range 0 .. 15;
      PxDS   at 16#08# range 0 .. 15;
      PxSEL0 at 16#0A# range 0 .. 15;
      PxSEL1 at 16#0C# range 0 .. 15;
      PxSELC at 16#16# range 0 .. 15;
      PxIES  at 16#18# range 0 .. 15;
      PxIE   at 16#1A# range 0 .. 15;
      PxIFG  at 16#1C# range 0 .. 15;
   end record;

   type PORTJ16_Type is record
      PxIN     : Bitmap_16 with Volatile_Full_Access => True;
      PxOUT    : Bitmap_16 with Volatile_Full_Access => True;
      PxDIR    : Bitmap_16 with Volatile_Full_Access => True;
      PxREN    : Bitmap_16 with Volatile_Full_Access => True;
      PxDS     : Bitmap_16 with Volatile_Full_Access => True;
      PxSEL0   : Bitmap_16 with Volatile_Full_Access => True;
      PxSEL1   : Bitmap_16 with Volatile_Full_Access => True;
      PxSELC   : Bitmap_16 with Volatile_Full_Access => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16#18# * 8;
   for PORTJ16_Type use record
      PxIN   at 16#00# range 0 .. 15;
      PxOUT  at 16#02# range 0 .. 15;
      PxDIR  at 16#04# range 0 .. 15;
      PxREN  at 16#06# range 0 .. 15;
      PxDS   at 16#08# range 0 .. 15;
      PxSEL0 at 16#0A# range 0 .. 15;
      PxSEL1 at 16#0C# range 0 .. 15;
      PxSELC at 16#16# range 0 .. 15;
   end record;

   type PORTL8_Type is record
      PxIN   : Bitmap_8    with Volatile_Full_Access => True;
      PxOUT  : Bitmap_8    with Volatile_Full_Access => True;
      PxDIR  : Bitmap_8    with Volatile_Full_Access => True;
      PxREN  : Bitmap_8    with Volatile_Full_Access => True;
      PxDS   : Bitmap_8    with Volatile_Full_Access => True;
      PxSEL0 : Bitmap_8    with Volatile_Full_Access => True;
      PxSEL1 : Bitmap_8    with Volatile_Full_Access => True;
      PxIV   : Unsigned_16 with Volatile_Full_Access => True;
      PxSELC : Bitmap_8    with Volatile_Full_Access => True;
      PxIES  : Bitmap_8    with Volatile_Full_Access => True;
      PxIE   : Bitmap_8    with Volatile_Full_Access => True;
      PxIFG  : Bitmap_8    with Volatile_Full_Access => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16#1E# * 8;
   for PORTL8_Type use record
      PxIN   at 16#00# range 0 ..  7;
      PxOUT  at 16#02# range 0 ..  7;
      PxDIR  at 16#04# range 0 ..  7;
      PxREN  at 16#06# range 0 ..  7;
      PxDS   at 16#08# range 0 ..  7;
      PxSEL0 at 16#0A# range 0 ..  7;
      PxSEL1 at 16#0C# range 0 ..  7;
      PxIV   at 16#0E# range 0 .. 15;
      PxSELC at 16#16# range 0 ..  7;
      PxIES  at 16#18# range 0 ..  7;
      PxIE   at 16#1A# range 0 ..  7;
      PxIFG  at 16#1C# range 0 ..  7;
   end record;

   type PORTH8_Type is record
      PxIN   : Bitmap_8    with Volatile_Full_Access => True;
      PxOUT  : Bitmap_8    with Volatile_Full_Access => True;
      PxDIR  : Bitmap_8    with Volatile_Full_Access => True;
      PxREN  : Bitmap_8    with Volatile_Full_Access => True;
      PxDS   : Bitmap_8    with Volatile_Full_Access => True;
      PxSEL0 : Bitmap_8    with Volatile_Full_Access => True;
      PxSEL1 : Bitmap_8    with Volatile_Full_Access => True;
      PxSELC : Bitmap_8    with Volatile_Full_Access => True;
      PxIES  : Bitmap_8    with Volatile_Full_Access => True;
      PxIE   : Bitmap_8    with Volatile_Full_Access => True;
      PxIFG  : Bitmap_8    with Volatile_Full_Access => True;
      PxIV   : Unsigned_16 with Volatile_Full_Access => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16#20# * 8;
   for PORTH8_Type use record
      PxIN   at 16#01# range 0 ..  7;
      PxOUT  at 16#03# range 0 ..  7;
      PxDIR  at 16#05# range 0 ..  7;
      PxREN  at 16#07# range 0 ..  7;
      PxDS   at 16#09# range 0 ..  7;
      PxSEL0 at 16#0B# range 0 ..  7;
      PxSEL1 at 16#0D# range 0 ..  7;
      PxSELC at 16#17# range 0 ..  7;
      PxIES  at 16#19# range 0 ..  7;
      PxIE   at 16#1B# range 0 ..  7;
      PxIFG  at 16#1D# range 0 ..  7;
      PxIV   at 16#1E# range 0 .. 15;
   end record;

   -- Table 6-21. Port Registers

   PORT_BASEADDRESS : constant := 16#4000_4C00#;

   P1  : aliased PORTL8_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#000#), Volatile => True, Import => True, Convention => Ada;
   P2  : aliased PORTH8_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#000#), Volatile => True, Import => True, Convention => Ada;
   PA  : aliased PORT16_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#000#), Volatile => True, Import => True, Convention => Ada;

   P3  : aliased PORTL8_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#020#), Volatile => True, Import => True, Convention => Ada;
   P4  : aliased PORTH8_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#020#), Volatile => True, Import => True, Convention => Ada;
   PB  : aliased PORT16_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#020#), Volatile => True, Import => True, Convention => Ada;

   P5  : aliased PORTL8_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#040#), Volatile => True, Import => True, Convention => Ada;
   P6  : aliased PORTH8_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#040#), Volatile => True, Import => True, Convention => Ada;
   PC  : aliased PORT16_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#040#), Volatile => True, Import => True, Convention => Ada;

   P7  : aliased PORTL8_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#060#), Volatile => True, Import => True, Convention => Ada;
   P8  : aliased PORTH8_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#060#), Volatile => True, Import => True, Convention => Ada;
   PD  : aliased PORT16_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#060#), Volatile => True, Import => True, Convention => Ada;

   P9  : aliased PORTL8_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#080#), Volatile => True, Import => True, Convention => Ada;
   P10 : aliased PORTH8_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#080#), Volatile => True, Import => True, Convention => Ada;
   PE  : aliased PORT16_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#080#), Volatile => True, Import => True, Convention => Ada;

   PJ  : aliased PORT16_Type with Address => System'To_Address (PORT_BASEADDRESS + 16#120#), Volatile => True, Import => True, Convention => Ada;

   ----------------------------------------------------------------------------
   -- 13 Port Mapping Controller (PMAP)
   ----------------------------------------------------------------------------

   -- 13.3.1 PMAPKEYID Register

   PMAPKEYx_KEY : constant := 16#2D52#;

   type PMAPKEYID_Type is record
      PMAPKEYx : Unsigned_16; -- Port mapping controller write access key.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PMAPKEYID_Type use record
      PMAPKEYx at 0 range 0 .. 15;
   end record;

   -- 13.3.2 PMAPCTL Register

   type PMAPCTL_Type is record
      PMAPLOCKED : Boolean := True;  -- Port mapping lock bit.
      PMAPRECFG  : Boolean := False; -- Port mapping reconfiguration control bit
      Reserved   : Bits_14 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PMAPCTL_Type use record
      PMAPLOCKED at 0 range 0 ..  0;
      PMAPRECFG  at 0 range 1 ..  1;
      Reserved   at 0 range 2 .. 15;
   end record;

   -- 13.3.3 P1MAP0 to P1MAP7 Register

   type PMAP8_Type is record
      PMAP : Bitmap_8;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PMAP8_Type use record
      PMAP at 0 range 0 .. 7;
   end record;

   -- 13.3.10 PxMAPyz Register

   type PMAP16_Type is record
      PMAP : Bitmap_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PMAP16_Type use record
      PMAP at 0 range 0 .. 15;
   end record;

   -- Table 6-22. PMAP Registers

   PMAP_BASEADDRESS : constant := 16#4000_5000#;

   PMAPKEYID : aliased PMAPKEYID_Type
      with Address              => System'To_Address (PMAP_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PMAPCTL : aliased PMAPCTL_Type
      with Address              => System'To_Address (PMAP_BASEADDRESS + 16#02#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   P2MAP0 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#10#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P2MAP1 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#11#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P2MAP2 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#12#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P2MAP3 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#13#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P2MAP4 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#14#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P2MAP5 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#15#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P2MAP6 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#16#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P2MAP7 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#17#), Volatile_Full_Access => True, Import => True, Convention => Ada;

   P2MAP01 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#10#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P2MAP23 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#12#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P2MAP45 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#14#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P2MAP67 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#16#), Volatile_Full_Access => True, Import => True, Convention => Ada;

   P3MAP0 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#18#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P3MAP1 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#19#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P3MAP2 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#1A#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P3MAP3 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#1B#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P3MAP4 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#1C#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P3MAP5 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#1D#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P3MAP6 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#1E#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P3MAP7 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#1F#), Volatile_Full_Access => True, Import => True, Convention => Ada;

   P3MAP01 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#18#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P3MAP23 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#1A#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P3MAP45 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#1C#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P3MAP67 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#1E#), Volatile_Full_Access => True, Import => True, Convention => Ada;

   P7MAP0 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#38#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P7MAP1 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#39#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P7MAP2 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#3A#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P7MAP3 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#3B#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P7MAP4 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#3C#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P7MAP5 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#3D#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P7MAP6 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#3E#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P7MAP7 : aliased PMAP8_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#3F#), Volatile_Full_Access => True, Import => True, Convention => Ada;

   P7MAP01 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#38#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P7MAP23 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#3A#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P7MAP45 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#3C#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   P7MAP67 : aliased PMAP16_Type with Address => System'To_Address (PMAP_BASEADDRESS + 16#3E#), Volatile_Full_Access => True, Import => True, Convention => Ada;

   ----------------------------------------------------------------------------
   -- 17 Watchdog Timer (WDT_A)
   ----------------------------------------------------------------------------

   -- 17.3.1 WDTCTL Register

   WDTIS_DIV2E31 : constant := 2#000#; -- Watchdog clock source / 2^31 (18:12:16 at 32.768 kHz)
   WDTIS_DIV2E27 : constant := 2#001#; -- Watchdog clock source / 2^27 (01:08:16 at 32.768 kHz)
   WDTIS_DIV2E23 : constant := 2#010#; -- Watchdog clock source / 2^23 (00:04:16 at 32.768 kHz)
   WDTIS_DIV2E19 : constant := 2#011#; -- Watchdog clock source / 2^19 (00:00:16 at 32.768 kHz)
   WDTIS_DIV2E15 : constant := 2#100#; -- Watchdog clock source / 2^15 (1 s at 32.768 kHz)
   WDTIS_DIV2E13 : constant := 2#101#; -- Watchdog clock source / 2^13 (250 ms at 32.768 kHz)
   WDTIS_DIV2E9  : constant := 2#110#; -- Watchdog clock source / 2^9 (15.625 ms at 32.768 kHz)
   WDTIS_DIV2E6  : constant := 2#111#; -- Watchdog clock source / 2^6 (1.95 ms at 32.768 kHz)

   WDTTMSEL_WATCHDOG : constant := 0; -- Watchdog mode
   WDTTMSEL_TIMER    : constant := 1; -- Interval timer mode

   WDTSSEL_SMCLK  : constant := 2#00#; -- SMCLK
   WDTSSEL_ACLK   : constant := 2#01#; -- ACLK
   WDTSSEL_VLOCLK : constant := 2#10#; -- VLOCLK
   WDTSSEL_BCLK   : constant := 2#11#; -- BCLK

   WDTPW_PASSWD : constant := 16#5A#;

   type WDTCTL_Type is record
      WDTIS    : Bits_3;  -- Watchdog timer interval select.
      WDTCNTCL : Boolean; -- Watchdog timer counter clear.
      WDTTMSEL : Bits_1;  -- Watchdog timer mode select
      WDTSSEL  : Bits_2;  -- Watchdog timer clock source select
      WDTHOLD  : Boolean; -- Watchdog timer hold.
      WDTPW    : Bits_8;  -- Watchdog timer password.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for WDTCTL_Type use record
      WDTIS    at 0 range 0 ..  2;
      WDTCNTCL at 0 range 3 ..  3;
      WDTTMSEL at 0 range 4 ..  4;
      WDTSSEL  at 0 range 5 ..  6;
      WDTHOLD  at 0 range 7 ..  7;
      WDTPW    at 0 range 8 .. 15;
   end record;

   -- Table 6-20. WDT_A Registers

   WDT_A_BASEADDRESS : constant := 16#4000_4800#;

   WDTCTL : aliased WDTCTL_Type
      with Address    => System'To_Address (WDT_A_BASEADDRESS + 16#0C#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 24 Enhanced Universal Serial Communication Interface (eUSCI) – UART Mode
   ----------------------------------------------------------------------------

   -- 24.4.1 UCAxCTLW0 Register Control Word Register 0

   UCSSELx_UCLK    : constant := 2#00#; -- UCLK
   UCSSELx_ACLK    : constant := 2#01#; -- ACLK
   UCSSELx_SMCLK   : constant := 2#10#; -- SMCLK
   UCSSELx_SMCLK_2 : constant := 2#11#; -- SMCLK

   UCMODEx_UART         : constant := 2#00#; -- UART mode
   UCMODEx_IDLEMP       : constant := 2#01#; -- Idle-line multiprocessor mode
   UCMODEx_ADDRMP       : constant := 2#10#; -- Address-bit multiprocessor mode
   UCMODEx_UARTAUTOBAUD : constant := 2#11#; -- UART mode with automatic baud-rate detection

   UCSPB_1 : constant := 0; -- One stop bit
   UCSPB_2 : constant := 1; -- Two stop bits

   UC7BIT_8 : constant := 0; -- 8-bit data
   UC7BIT_7 : constant := 1; -- 7-bit data

   UCMSB_LSB : constant := 0; -- LSB first
   UCMSB_MSB : constant := 1; -- MSB first

   UCPAR_ODD  : constant := 0; -- Odd parity
   UCPAR_EVEN : constant := 1; -- Even parity

   type UCAxCTLW0_Type is record
      UCSWRST  : Boolean := False;        -- Software reset enable
      UCTXBRK  : Boolean := False;        -- Transmit break.
      UCTXADDR : Boolean := False;        -- Transmit address.
      UCDORM   : Boolean := False;        -- Dormant.
      UCBRKIE  : Boolean := False;        -- Receive break character interrupt enable
      UCRXEIE  : Boolean := False;        -- Receive erroneous-character interrupt enable
      UCSSELx  : Bits_2  := 0;            -- eUSCI_A clock source select.
      UCSYNC   : Boolean := False;        -- Synchronous mode enable
      UCMODEx  : Bits_2  := UCMODEx_UART; -- eUSCI_A mode.
      UCSPB    : Bits_1  := UCSPB_1;      -- Stop bit select.
      UC7BIT   : Bits_1  := UC7BIT_8;     -- Character length.
      UCMSB    : Bits_1  := UCMSB_LSB;    -- MSB first select.
      UCPAR    : Bits_1  := UCPAR_ODD;    -- Parity select.
      UCPEN    : Boolean := False;        -- Parity enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxCTLW0_Type use record
      UCSWRST  at 0 range  0 .. 0;
      UCTXBRK  at 0 range  1 .. 1;
      UCTXADDR at 0 range  2 .. 2;
      UCDORM   at 0 range  3 .. 3;
      UCBRKIE  at 0 range  4 .. 4;
      UCRXEIE  at 0 range  5 .. 5;
      UCSSELx  at 0 range  6 .. 7;
      UCSYNC   at 0 range  8 .. 8;
      UCMODEx  at 0 range  9 .. 10;
      UCSPB    at 0 range 11 .. 11;
      UC7BIT   at 0 range 12 .. 12;
      UCMSB    at 0 range 13 .. 13;
      UCPAR    at 0 range 14 .. 14;
      UCPEN    at 0 range 15 .. 15;
   end record;

   -- 24.4.2 UCAxCTLW1 Register Control Word Register 1

   UCGLITx_5ns  : constant := 2#00#; -- Approximately 5 ns
   UCGLITx_20ns : constant := 2#01#; -- Approximately 20 ns
   UCGLITx_30ns : constant := 2#10#; -- Approximately 30 ns
   UCGLITx_50ns : constant := 2#11#; -- Approximately 50 ns

   type UCAxCTLW1_Type is record
      UCGLITx  : Bits_2;       -- Deglitch time
      Reserved : Bits_14 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxCTLW1_Type use record
      UCGLITx  at 0 range 0 ..  1;
      Reserved at 0 range 2 .. 15;
   end record;

   -- 24.4.4 UCAxMCTLW Register Modulation Control Word Register

   type UCAxMCTLW_Type is record
      UCOS16   : Boolean;      -- Oversampling mode enabled
      Reserved : Bits_3  := 0;
      UCBRFx   : Bits_4;       -- First modulation stage select.
      UCBRSx   : Bits_8;       -- Second modulation stage select.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxMCTLW_Type use record
      UCOS16   at 0 range 0 ..  0;
      Reserved at 0 range 1 ..  3;
      UCBRFx   at 0 range 4 ..  7;
      UCBRSx   at 0 range 8 .. 15;
   end record;

   -- 24.4.5 UCAxSTATW Register Status Register

   type UCAxSTATW_Type is record
      UCBUSY        : Boolean;      -- eUSCI_A busy.
      UCADDR_UCIDLE : Boolean;      -- UCADDR: Address received in address-bit multiprocessor mode. UCIDLE: ...
      UCRXERR       : Boolean;      -- Receive error flag.
      UCBRK         : Boolean;      -- Break detect flag.
      UCPE          : Boolean;      -- Parity error flag.
      UCOE          : Boolean;      -- Overrun error flag.
      UCFE          : Boolean;      -- Framing error flag.
      UCLISTEN      : Boolean;      -- Listen enable.
      Reserved      : Bits_8  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxSTATW_Type use record
      UCBUSY        at 0 range 0 ..  0;
      UCADDR_UCIDLE at 0 range 1 ..  1;
      UCRXERR       at 0 range 2 ..  2;
      UCBRK         at 0 range 3 ..  3;
      UCPE          at 0 range 4 ..  4;
      UCOE          at 0 range 5 ..  5;
      UCFE          at 0 range 6 ..  6;
      UCLISTEN      at 0 range 7 ..  7;
      Reserved      at 0 range 8 .. 15;
   end record;

   -- 24.4.6 UCAxRXBUF Register

   type UCAxRXBUF_Type is record
      UCRXBUFx : Unsigned_8;      -- The receive-data buffer is user accessible and contains the last received ...
      Reserved : Bits_8     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxRXBUF_Type use record
      UCRXBUFx at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   -- 24.4.7 UCAxTXBUF Register Transmit Buffer Register

   type UCAxTXBUF_Type is record
      UCTXBUFx : Unsigned_8;      -- The transmit data buffer is user accessible and holds the data waiting to be ...
      Reserved : Bits_8     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxTXBUF_Type use record
      UCTXBUFx at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   -- 24.4.8 UCAxABCTL Register Auto Baud Rate Control Register

   UCDELIMx_1 : constant := 2#00#; -- 1 bit time
   UCDELIMx_2 : constant := 2#01#; -- 2 bit times
   UCDELIMx_3 : constant := 2#10#; -- 3 bit times
   UCDELIMx_4 : constant := 2#11#; -- 4 bit times

   type UCAxABCTL_Type is record
      UCABDEN   : Boolean;      -- Automatic baud-rate detect enable
      Reserved1 : Bits_1  := 0;
      UCBTOE    : Boolean;      -- Break time out error
      UCSTOE    : Boolean;      -- Synch field time out error
      UCDELIMx  : Bits_2;       -- Break/synch delimiter length
      Reserved2 : Bits_10 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxABCTL_Type use record
      UCABDEN   at 0 range 0 ..  0;
      Reserved1 at 0 range 1 ..  1;
      UCBTOE    at 0 range 2 ..  2;
      UCSTOE    at 0 range 3 ..  3;
      UCDELIMx  at 0 range 4 ..  5;
      Reserved2 at 0 range 6 .. 15;
   end record;

   -- 24.4.9 UCAxIRCTL Register IrDA Control Word Register

   UCIRTXCLK_BRCLK          : constant := 0; -- BRCLK
   UCIRTXCLK_UCOS16BITCLK16 : constant := 1; -- BITCLK16 when UCOS16 = 1. Otherwise, BRCLK.

   UCIRRXPL_HI : constant := 0; -- IrDA transceiver delivers a high pulse when a light pulse is seen.
   UCIRRXPL_LO : constant := 1; -- IrDA transceiver delivers a low pulse when a light pulse is seen.

   type UCAxIRCTL_Type is record
      UCIREN    : Boolean := False;           -- IrDA encoder and decoder enable
      UCIRTXCLK : Bits_1  := UCIRTXCLK_BRCLK; -- IrDA transmit pulse clock select
      UCIRTXPLx : Bits_6  := 0;               -- Transmit pulse length.
      UCIRRXFE  : Boolean := False;           -- IrDA receive filter enabled
      UCIRRXPL  : Bits_1  := UCIRRXPL_HI;     -- IrDA receive input UCAxRXD polarity
      UCIRRXFLx : Bits_6  := 0;               -- Receive filter length.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxIRCTL_Type use record
      UCIREN    at 0 range  0 ..  0;
      UCIRTXCLK at 0 range  1 ..  1;
      UCIRTXPLx at 0 range  2 ..  7;
      UCIRRXFE  at 0 range  8 ..  8;
      UCIRRXPL  at 0 range  9 ..  9;
      UCIRRXFLx at 0 range 10 .. 15;
   end record;

   -- 24.4.10 UCAxIE Register Interrupt Enable Register

   type UCAxIE_Type is record
      UCRXIE    : Boolean;      -- Receive interrupt enable
      UCTXIE    : Boolean;      -- Transmit interrupt enable
      UCSTTIE   : Boolean;      -- Start bit interrupt enable
      UCTXCPTIE : Boolean;      -- Transmit complete interrupt enable
      Reserved  : Bits_12 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxIE_Type use record
      UCRXIE    at 0 range 0 ..  0;
      UCTXIE    at 0 range 1 ..  1;
      UCSTTIE   at 0 range 2 ..  2;
      UCTXCPTIE at 0 range 3 ..  3;
      Reserved  at 0 range 4 .. 15;
   end record;

   -- 24.4.11 UCAxIFG Register Interrupt Flag Register

   type UCAxIFG_Type is record
      UCRXIFG    : Boolean;      -- Receive interrupt flag.
      UCTXIFG    : Boolean;      -- Transmit interrupt flag.
      UCSTTIFG   : Boolean;      -- Start bit interrupt flag.
      UCTXCPTIFG : Boolean;      -- Transmit complete interrupt flag.
      Reserved   : Bits_12 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxIFG_Type use record
      UCRXIFG    at 0 range 0 ..  0;
      UCTXIFG    at 0 range 1 ..  1;
      UCSTTIFG   at 0 range 2 ..  2;
      UCTXCPTIFG at 0 range 3 ..  3;
      Reserved   at 0 range 4 .. 15;
   end record;

   -- 24.4.12 UCAxIV Register Interrupt Vector Register

   UCAxIV_NONE    : constant := 16#00#; -- No interrupt pending
   UCAxIV_RXFULL  : constant := 16#02#; -- Interrupt Source: Receive buffer full; Interrupt Flag: UCRXIFG; ...: Highest
   UCAxIV_TXEMPTY : constant := 16#04#; -- Interrupt Source: Transmit buffer empty; Interrupt Flag: UCTXIFG
   UCAxIV_START   : constant := 16#06#; -- Interrupt Source: Start bit received; Interrupt Flag: UCSTTIFG
   UCAxIV_TXDONE  : constant := 16#08#; -- Interrupt Source: Transmit complete; Interrupt Flag: UCTXCPTIFG; ...: Lowest

   -- 24.4 eUSCI_A UART Registers

   type eUSCI_Ax_Type is record
      UCAxCTLW0 : UCAxCTLW0_Type with Volatile_Full_Access => True;
      UCAxCTLW1 : UCAxCTLW1_Type with Volatile_Full_Access => True;
      UCAxBRW   : Unsigned_16    with Volatile_Full_Access => True;
      UCAxMCTLW : UCAxMCTLW_Type with Volatile_Full_Access => True;
      UCAxSTATW : UCAxSTATW_Type with Volatile_Full_Access => True;
      UCAxRXBUF : UCAxRXBUF_Type with Volatile_Full_Access => True;
      UCAxTXBUF : UCAxTXBUF_Type with Volatile_Full_Access => True;
      UCAxABCTL : UCAxABCTL_Type with Volatile_Full_Access => True;
      UCAxIRCTL : UCAxIRCTL_Type with Volatile_Full_Access => True;
      UCAxIE    : UCAxIE_Type    with Volatile_Full_Access => True;
      UCAxIFG   : UCAxIFG_Type   with Volatile_Full_Access => True;
      UCAxIV    : Unsigned_16    with Volatile_Full_Access => True;
   end record
      with Size => 16#20# * 8;
   for eUSCI_Ax_Type use record
      UCAxCTLW0 at 16#00# range 0 .. 15;
      UCAxCTLW1 at 16#02# range 0 .. 15;
      UCAxBRW   at 16#06# range 0 .. 15;
      UCAxMCTLW at 16#08# range 0 .. 15;
      UCAxSTATW at 16#0A# range 0 .. 15;
      UCAxRXBUF at 16#0C# range 0 .. 15;
      UCAxTXBUF at 16#0E# range 0 .. 15;
      UCAxABCTL at 16#10# range 0 .. 15;
      UCAxIRCTL at 16#12# range 0 .. 15;
      UCAxIE    at 16#1A# range 0 .. 15;
      UCAxIFG   at 16#1C# range 0 .. 15;
      UCAxIV    at 16#1E# range 0 .. 15;
   end record;

   -- Table 6-6. eUSCI_A0 Registers

   eUSCI_A0_ADDRESS : constant := 16#4000_1000#;

   eUSCI_A0 : aliased eUSCI_Ax_Type
      with Address    => System'To_Address (eUSCI_A0_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end MSP432P401R;
