-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ msp432p401r.ads                                                                                           --
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
   -- SLAU356H March 2015 – Revised December 2017
   -- SLAS826H – MARCH 2015 – REVISED JUNE 2019
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Chapter 3 Reset Controller (RSTCTL)
   ----------------------------------------------------------------------------

   -- 3.3.1 RSTCTL_RESET_REQ Register

   RSTCTL_RESET_REQ_RSTKEY : constant := 16#69#;

   type RSTCTL_RESET_REQ_Type is record
      SOFT_REQ  : Boolean := False; -- If written with 1, generates a Hard Reset request to the Reset Controller
      HARD_REQ  : Boolean := False; -- If written with 1, generates a Soft Reset request to the Reset Controller
      Reserved1 : Bits_6  := 0;
      RSTKEY    : Bits_8  := 0;     -- Must be written with 69h to enable writes to bits 1-0 (in the same write operation), else writes to bits 1-0 are ignored
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for RSTCTL_PSSRESET_STAT_Type use record
      Reserved1 at 0 range 0 ..  0;
      SVSMH     at 0 range 1 ..  1;
      BGREF     at 0 range 2 ..  2;
      VCCDET    at 0 range 3 ..  3;
      Reserved2 at 0 range 4 .. 31;
   end record;

   -- 3.3.9 RSTCTL_PSSRESET_CLR Register

   type RSTCTL_PSSRESET_CLR_Type is record
      CLR      : Boolean := False; -- Write 1 clears all PSS Reset Flags in the RSTCTL_PSSRESET_STAT
      Reserved : Bits_31 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
   -- Chapter 4 System Controller (SYSCTL)
   ----------------------------------------------------------------------------

   -- 4.11.1 SYS_REBOOT_CTL Register

   SYS_REBOOT_CTL_WKEY : constant := 16#69#;

   type SYS_REBOOT_CTL_Type is record
      REBOOT    : Boolean := False; -- Write 1 initiates a Reboot of the device
      Reserved1 : Bits_7  := 0;
      WKEY      : Bits_8  := 0;     -- Key to enable writes to bit 0.
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for SYS_RESET_REQ_Type use record
      POR       at 0 range  0 ..  0;
      REBOOT    at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  7;
      WKEY      at 0 range  8 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   -- 4.11.16 SYS_RESET_STATOVER Register

   type SYS_RESET_STATOVER_Type is record
      SOFT      : Boolean := False; -- Indicates if SOFT Reset is asserted
      HARD      : Boolean := False; -- Indicates if HARD Reset is asserted
      REBOOT    : Boolean := False; -- Indicates if Reboot Reset is asserted
      Reserved1 : Bits_5  := 0;
      SOFT_OVER : Boolean := False; -- When 1, activates the override request for the SOFT Reset output of the Reset Controller.
      HARD_OVER : Boolean := False; -- When 1, activates the override request for the HARD Reset output of the Reset Controller.
      RBT_OVER  : Boolean := False; -- When 1, activates the override request for the Reboot Reset output of the Reset Controller
      Reserved2 : Bits_21 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
   -- Chapter 5 System Controller A (SYSCTL_A)
   ----------------------------------------------------------------------------

   -- additional types for SYSCTL_A

   type Bitmap_32_0 is array (0 .. 31) of Boolean
      with Component_Size => 1,
           Object_Size    => 32;
   type Bitmap_32_32 is array (32 .. 63) of Boolean
      with Component_Size => 1,
           Object_Size    => 32;
   type Bitmap_32_64 is array (64 .. 95) of Boolean
      with Component_Size => 1,
           Object_Size    => 32;
   type Bitmap_32_96 is array (96 .. 127) of Boolean
      with Component_Size => 1,
           Object_Size    => 32;

   type SYS_SRAM_STAT_Type is record
      BNKEN_RDY  : Boolean; -- SRAM is ready for accesses. All SRAM banks are enabled/disabled according to values of registers SYS_SRAM_BANKEN_CTLx (x=0,1,2,3)
      BLKRET_RDY : Boolean; -- SRAM is ready for accesses. All SRAM banks are enabled/disabled for retention according to values of registers SYS_SRAM_BLKRET_CTLx (x = 0,1,2,3)
      Reserved   : Bits_30;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for SYS_SRAM_STAT_Type use record
      BNKEN_RDY  at 0 range 0 ..  0;
      BLKRET_RDY at 0 range 1 ..  1;
      Reserved   at 0 range 2 .. 31;
   end record;

   -- 5.11.6 SYS_SRAM_NUMBANKS Register

   SYS_SRAM_NUMBANKS : aliased Unsigned_32
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0014#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.7 SYS_SRAM_NUMBLOCKS Register

   SYS_SRAM_NUMBLOCKS : aliased Unsigned_32
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0018#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.8 SYS_MAINFLASH_SIZE Register

   SYS_MAINFLASH_SIZE : aliased Unsigned_32
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0020#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.9 SYS_INFOFLASH_SIZE Register

   SYS_INFOFLASH_SIZE : aliased Unsigned_32
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0024#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.12 SYS_SRAM_BANKEN_CTL0 Register

   SYS_SRAM_BANKEN_CTL0 : aliased Bitmap_32_0
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0050#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.13 SYS_SRAM_BANKEN_CTL1 Register

   SYS_SRAM_BANKEN_CTL1 : aliased Bitmap_32_32
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0054#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.14 SYS_SRAM_BANKEN_CTL2 Register

   SYS_SRAM_BANKEN_CTL2 : aliased Bitmap_32_64
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0058#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.15 SYS_SRAM_BANKEN_CTL3 Register

   SYS_SRAM_BANKEN_CTL3 : aliased Bitmap_32_96
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#005C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.16 SYS_SRAM_BLKRET_CTL0 Register

   SYS_SRAM_BLKRET_CTL0 : aliased Bitmap_32_0
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0070#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.17 SYS_SRAM_BLKRET_CTL1 Register

   SYS_SRAM_BLKRET_CTL1 : aliased Bitmap_32_32
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0074#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.18 SYS_SRAM_BLKRET_CTL2 Register

   SYS_SRAM_BLKRET_CTL2 : aliased Bitmap_32_64
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0078#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.19 SYS_SRAM_BLKRET_CTL3 Register

   SYS_SRAM_BLKRET_CTL3 : aliased Bitmap_32_96
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#007C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.11.20 SYS_SRAM_STAT Register

   SYS_SRAM_STAT : aliased SYS_SRAM_STAT_Type
      with Address              => System'To_Address (SYSCTL_BASEADDRESS + 16#0090#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 6 Clock System (CS)
   ----------------------------------------------------------------------------

   -- 6.3.1 CSKEY Register Clock System Key Register

   CSKEY_CSKEY : constant := 16#695A#;

   type CSKEY_Type is record
      CSKEY    : Unsigned_16 := 16#A596#; -- Write CSKEY = xxxx_695Ah to unlock CS registers. All 16 LSBs need to be written together.
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      DCOTUNE   : Bits_10 := 0;          -- DCO frequency tuning select.
      Reserved1 : Bits_3  := 0;
      Reserved2 : Bits_3  := 0;
      DCORSEL   : Bits_3  := DCORSEL_3M; -- DCO frequency range select.
      Reserved3 : Bits_3  := 0;
      DCORES    : Boolean := False;      -- Enables the DCO external resistor mode.
      DCOEN     : Boolean := False;      -- Enables the DCO oscillator regardless if used as a clock resource.
      Reserved4 : Bits_1  := 0;
      Reserved5 : Bits_7  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      SELM      : Bits_3 := SELM_DCOCLK;  -- Selects the MCLK source.
      Reserved1 : Bits_1 := 0;
      SELS      : Bits_3 := SELS_DCOCLK;  -- Selects the SMCLK and HSMCLK source.
      Reserved2 : Bits_1 := 0;
      SELA      : Bits_3 := SELA_LFXTCLK; -- Selects the ACLK source.
      Reserved3 : Bits_1 := 0;
      SELB      : Bits_1 := SELB_LFXTCLK; -- Selects the BCLK source.
      Reserved4 : Bits_2 := 0;
      Reserved5 : Bits_1 := 0;
      DIVM      : Bits_3 := DIVM_DIV1;    -- MCLK source divider.
      Reserved6 : Bits_1 := 0;
      DIVHS     : Bits_3 := DIVHS_DIV1;   -- HSMCLK source divider.
      Reserved7 : Bits_1 := 0;
      DIVA      : Bits_3 := DIVA_DIV1;    -- ACLK source divider.
      Reserved8 : Bits_1 := 0;
      DIVS      : Bits_3 := DIVS_DIV1;    -- SMCLK source divider.
      Reserved9 : Bits_1 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      LFXTDRIVE  : Bits_2  := LFXTDRIVE_3;      -- The LFXT oscillator current can be adjusted to its drive needs.
      Reserved1  : Bits_1  := 0;
      Reserved2  : Bits_4  := 0;
      Reserved3  : Bits_1  := 0;
      LFXT_EN    : Boolean := False;            -- Turns on the LFXT oscillator regardless if used as a clock resource.
      LFXTBYPASS : Bits_1  := LFXTBYPASS_EXTAL; -- LFXT bypass select.
      Reserved4  : Bits_6  := 0;
      HFXTDRIVE  : Bits_1  := HFXTDRIVE_5_48;   -- HFXT oscillator drive selection.
      Reserved5  : Bits_2  := 0;
      Reserved6  : Bits_1  := 0;
      HFXTFREQ   : Bits_3  := HFXTFREQ_1_4;     -- HFXT frequency selection.
      Reserved7  : Bits_1  := 0;
      HFXT_EN    : Boolean := False;            -- Turns on the HFXT oscillator regardless if used as a clock resource.
      HFXTBYPASS : Bits_1  := HFXTBYPASS_EXTAL; -- HFXT bypass select.
      Reserved8  : Bits_6  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      FCNTLF    : Bits_2  := FCNTLF_32k; -- Start flag counter for LFXT.
      RFCNTLF   : Boolean := False;      -- Reset start fault counter for LFXT.
      FCNTLF_EN : Boolean := True;       -- Enable start fault counter for LFXT.
      FCNTHF    : Bits_2  := FCNTHF_32k; -- Start flag counter for HFXT.
      RFCNTHF   : Boolean := False;      -- Reset start fault counter for HFXT.
      FCNTHF_EN : Boolean := True;       -- Enable start fault counter for HFXT.
      Reserved  : Bits_24 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      ACLK_EN   : Boolean := True;         -- ACLK system clock conditional request enable
      MCLK_EN   : Boolean := True;         -- MCLK system clock conditional request enable
      HSMCLK_EN : Boolean := True;         -- HSMCLK system clock conditional request enable
      SMCLK_EN  : Boolean := True;         -- SMCLK system clock conditional request enable
      Reserved1 : Bits_4  := 0;
      VLO_EN    : Boolean := False;        -- Turns on the VLO oscillator regardless if used as a clock resource.
      REFO_EN   : Boolean := False;        -- Turns on the REFO oscillator regardless if used as a clock resource.
      MODOSC_EN : Boolean := False;        -- Turns on the MODOSC oscillator regardless if used as a clock resource.
      Reserved2 : Bits_4  := 0;
      REFOFSEL  : Bits_1  := REFOFSEL_32k; -- Selects REFO nominal frequency.
      Reserved3 : Bits_16 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      LFXTIE     : Boolean := False; -- LFXT oscillator fault flag interrupt enable.
      HFXTIE     : Boolean := False; -- HFXT oscillator fault flag interrupt enable.
      Reserved1  : Bits_1  := 0;
      Reserved2  : Bits_1  := 0;
      Reserved3  : Bits_1  := 0;
      Reserved4  : Bits_1  := 0;
      DCOR_OPNIE : Boolean := False; -- DCO external resistor open circuit fault flag interrupt enable.
      Reserved5  : Bits_1  := 0;
      FCNTLFIE   : Boolean := False; -- Start fault counter interrupt enable LFXT.
      FCNTHFIE   : Boolean := False; -- Start fault counter interrupt enable HFXT.
      Reserved6  : Bits_22 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      SET_LFXTIFG     : Boolean := False; -- Set LFXT oscillator fault interrupt flag.
      SET_HFXTIFG     : Boolean := False; -- Set HFXT oscillator fault interrupt flag.
      Reserved1       : Bits_1  := 0;
      Reserved2       : Bits_1  := 0;
      Reserved3       : Bits_1  := 0;
      Reserved4       : Bits_1  := 0;
      SET_DCOR_OPNIFG : Boolean := False; -- Set DCO external resistor open circuit fault interrupt flag.
      Reserved5       : Bits_1  := 0;
      SET_FCNTLFIFG   : Boolean := False; -- Start fault counter set interrupt flag LFXT.
      SET_FCNTHFIFG   : Boolean := False; -- Start fault counter set interrupt flag HFXT.
      Reserved6       : Bits_22 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      DCO_TCCAL       : Bits_2  := 0;       -- DCO Temperature compensation calibration.
      Reserved1       : Bits_14 := 0;
      DCO_FCAL_RSEL04 : Bits_10 := 16#100#; -- DCO frequency calibration for DCO frequency range (DCORSEL) 0 to 4.
      Reserved2       : Bits_6  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for CSDCOERCAL0_Type use record
      DCO_TCCAL       at 0 range  0 ..  1;
      Reserved1       at 0 range  2 .. 15;
      DCO_FCAL_RSEL04 at 0 range 16 .. 25;
      Reserved2       at 0 range 26 .. 31;
   end record;

   -- 6.3.13 CSDCOERCAL1 Register DCO External Resistor Calibration 1 Register

   type CSDCOERCAL1_Type is record
      DCO_FCAL_RSEL5 : Bits_10 := 16#100#; -- DCO frequency calibration for DCO frequency range (DCORSEL) 5.
      Reserved       : Bits_22 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
   -- Chapter 7 Power Supply System (PSS)
   ----------------------------------------------------------------------------

   -- 7.3.1 PSSKEY Register PSS Key Register

   PSSKEY_KEY : constant := 16#695A#;

   type PSSKEY_Type is record
      PSSKEY   : Unsigned_16 := 16#A596#; -- PSS key.
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      SVSMHOFF     : Boolean := False;       -- SVSM high-side off
      SVSMHLP      : Boolean := False;       -- SVSM high-side low power normal performance mode
      SVSMHS       : Bits_1  := SVSMHS_SVSH; -- Supply supervisor or monitor selection for the high-side
      SVSMHTH      : Bits_3  := SVSMHTH_0;   -- SVSM high-side reset voltage level.
      SVMHOE       : Boolean := False;       -- SVSM high-side output enable
      SVMHOUTPOLAL : Boolean := False;       -- SVMHOUT pin polarity active low.
      Reserved1    : Bits_2  := 0;
      DCDC_FORCE   : Boolean := False;       -- Force DC/DC regulator operation.
      Reserved2    : Bits_1  := 0;
      Reserved3    : Bits_2  := 2#10#;
      Reserved4    : Bits_18 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      SVSMHIE   : Boolean := False; -- High-side SVSM interrupt enable, when set as a monitor (SVSMHS = 1).
      Reserved2 : Bits_30 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for PSSIE_Type use record
      Reserved1 at 0 range 0 ..  0;
      SVSMHIE   at 0 range 1 ..  1;
      Reserved2 at 0 range 2 .. 31;
   end record;

   -- 7.3.4 PSSIFG Register PSS Interrupt Flag Register

   type PSSIFG_Type is record
      Reserved1 : Bits_1;
      SVSMHIFG  : Boolean; -- High-side SVSM interrupt flag.
      Reserved2 : Bits_30;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for PSSIFG_Type use record
      Reserved1 at 0 range 0 ..  0;
      SVSMHIFG  at 0 range 1 ..  1;
      Reserved2 at 0 range 2 .. 31;
   end record;

   -- 7.3.5 PSSCLRIFG Register PSS Clear Interrupt Flag Register

   type PSSCLRIFG_Type is record
      Reserved1   : Bits_1  := 0;
      CLRSVSMHIFG : Boolean := False; -- SVSMH clear interrupt flag
      Reserved2   : Bits_30 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
   -- Chapter 8 Power Control Manager (PCM)
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
      AMR      : Bits_4      := AMR_AM_LDO_VCORE0; -- Active Mode Request.
      LPMR     : Bits_4      := LPMR_LPM3;         -- Low Power Mode Request.
      CPM      : Bits_6      := CPM_AM_LDO_VCORE0; -- Current Power Mode.
      Reserved : Bits_2      := 0;
      PCMKEY   : Unsigned_16 := 16#A596#;          -- PCM key.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for PCMCTL0_Type use record
      AMR      at 0 range  0 ..  3;
      LPMR     at 0 range  4 ..  7;
      CPM      at 0 range  8 .. 13;
      Reserved at 0 range 14 .. 15;
      PCMKEY   at 0 range 16 .. 31;
   end record;

   -- 8.26.2 PCMCTL1 Register PCM Control 1 Register

   type PCMCTL1_Type is record
      LOCKLPM5        : Boolean     := False;    -- Lock LPM5.
      LOCKBKUP        : Boolean     := False;    -- Lock Backup.
      FORCE_LPM_ENTRY : Boolean     := False;    -- Bit selection for the application to determine whether the entry into LPM3/LPMx.5 should be forced even if there are active system clocks running which do not meet the LPM3/LPMx.5 criteria.
      Reserved1       : Bits_5      := 0;
      PMR_BUSY        : Boolean     := False;    -- Power mode request busy flag.
      Reserved2       : Bits_7      := 0;
      PCMKEY          : Unsigned_16 := 16#A596#; -- PCM key.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      LPM_INVALID_TR_IE  : Boolean := False; -- LPM invalid transition interrupt enable.
      LPM_INVALID_CLK_IE : Boolean := False; -- LPM invalid clock interrupt enable.
      AM_INVALID_TR_IE   : Boolean := False; -- Active mode invalid transition interrupt enable.
      Reserved1          : Bits_3  := 0;
      DCDC_ERROR_IE      : Boolean := False; -- DC-DC error interrupt enable.
      Reserved2          : Bits_25 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      LPM_INVALID_TR_IFG  : Boolean := False; -- LPM invalid transition flag.
      LPM_INVALID_CLK_IFG : Boolean := False; -- LPM invalid clock flag.
      AM_INVALID_TR_IFG   : Boolean := False; -- Active mode invalid transition flag.
      Reserved1           : Bits_3  := 0;
      DCDC_ERROR_IFG      : Boolean := False; -- DC-DC error flag.
      Reserved2           : Bits_25 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
   -- Chapter 9 Flash Controller (FLCTL)
   ----------------------------------------------------------------------------

   -- 9.4.1 FLCTL_POWER_STAT Register

   PSTAT_POWERDOWN        : constant := 2#000#; -- Flash IP in power-down mode
   PSTAT_VDDINPROGRESS    : constant := 2#001#; -- Flash IP Vdd domain power-up in progress
   PSTAT_PSSINPROGRESS    : constant := 2#010#; -- PSS LDO_GOOD, IREF_OK and VREF_OK check in progress
   PSTAT_SAFELVINPROGRESS : constant := 2#011#; -- Flash IP SAFE_LV check in progress
   PSTAT_ACTIVE           : constant := 2#100#; -- Flash IP Active
   PSTAT_ACTIVELF         : constant := 2#101#; -- Flash IP Active in Low-Frequency Active and Low-Frequency LPM0 modes.
   PSTAT_STANDBY          : constant := 2#110#; -- Flash IP in Standby mode
   PSTAT_MIRRORBOOST      : constant := 2#111#; -- Flash IP in Current mirror boost state

   type FLCTL_POWER_STAT_Type is record
      PSTAT    : Bits_3;  -- Flash power status
      LDOSTAT  : Boolean; -- PSS FLDO GOOD status
      VREFSTAT : Boolean; -- PSS VREF stable status
      IREFSTAT : Boolean; -- PSS IREF stable status
      TRIMSTAT : Boolean; -- PSS trim done status
      RD_2T    : Boolean; -- Indicates if Flash is being accessed in 2T mode
      Reserved : Bits_24;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_POWER_STAT_Type use record
      PSTAT    at 0 range 0 ..  2;
      LDOSTAT  at 0 range 3 ..  3;
      VREFSTAT at 0 range 4 ..  4;
      IREFSTAT at 0 range 5 ..  5;
      TRIMSTAT at 0 range 6 ..  6;
      RD_2T    at 0 range 7 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 9.4.2 FLCTL_BANK0_RDCTL Register

   RD_MODE_RDNORMAL    : constant := 2#0000#; -- Normal read mode
   RD_MODE_RDMARGIN0   : constant := 2#0001#; -- Read Margin 0
   RD_MODE_RDMARGIN1   : constant := 2#0010#; -- Read Margin 1
   RD_MODE_VERIFY      : constant := 2#0011#; -- Program Verify
   RD_MODE_ERASEVERIFY : constant := 2#0100#; -- Erase Verify

   WAIT_0  : constant := 2#0000#; -- 0 wait states
   WAIT_1  : constant := 2#0001#; -- 1 wait states
   WAIT_2  : constant := 2#0010#; -- 2 wait states
   WAIT_3  : constant := 2#0011#; -- 3 wait states
   WAIT_4  : constant := 2#0100#; -- 4 wait states
   WAIT_5  : constant := 2#0101#; -- 5 wait states
   WAIT_6  : constant := 2#0110#; -- 6 wait states
   WAIT_7  : constant := 2#0111#; -- 7 wait states
   WAIT_8  : constant := 2#1000#; -- 8 wait states
   WAIT_9  : constant := 2#1001#; -- 9 wait states
   WAIT_10 : constant := 2#1010#; -- 10 wait states
   WAIT_11 : constant := 2#1011#; -- 11 wait states
   WAIT_12 : constant := 2#1100#; -- 12 wait states
   WAIT_13 : constant := 2#1101#; -- 13 wait states
   WAIT_14 : constant := 2#1110#; -- 14 wait states
   WAIT_15 : constant := 2#1111#; -- 15 wait states

   RD_MODE_STATUS_RDNORMAL    renames RD_MODE_RDNORMAL;
   RD_MODE_STATUS_RDMARGIN0   renames RD_MODE_RDMARGIN0;
   RD_MODE_STATUS_RDMARGIN1   renames RD_MODE_RDMARGIN1;
   RD_MODE_STATUS_VERIFY      renames RD_MODE_VERIFY;
   RD_MODE_STATUS_ERASEVERIFY renames RD_MODE_ERASEVERIFY;

   type FLCTL_BANK0_RDCTL_Type is record
      RD_MODE        : Bits_4  := RD_MODE_RDNORMAL;        -- Flash read mode control setting for Bank
      BUFI           : Boolean := False;                   -- Enables read buffering feature for instruction fetches to this bank
      BUFD           : Boolean := False;                   -- Enables read buffering feature for data reads to this bank
      Reserved1      : Bits_2  := 0;
      Reserved2      : Bits_4  := 0;
      WAIT           : Bits_4  := WAIT_0;                  -- Defines the number of wait states required for a read operation to the bank
      RD_MODE_STATUS : Bits_4  := RD_MODE_STATUS_RDNORMAL; -- Reflects the current Read Mode of the Bank
      Reserved3      : Bits_12 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_BANK0_RDCTL_Type use record
      RD_MODE        at 0 range  0 ..  3;
      BUFI           at 0 range  4 ..  4;
      BUFD           at 0 range  5 ..  5;
      Reserved1      at 0 range  6 ..  7;
      Reserved2      at 0 range  8 .. 11;
      WAIT           at 0 range 12 .. 15;
      RD_MODE_STATUS at 0 range 16 .. 19;
      Reserved3      at 0 range 20 .. 31;
   end record;

   -- 9.4.3 FLCTL_BANK1_RDCTL Register

   type FLCTL_BANK1_RDCTL_Type is record
      RD_MODE        : Bits_4  := RD_MODE_RDNORMAL;        -- Flash read mode control setting for Bank
      BUFI           : Boolean := False;                   -- Enables read buffering feature for instruction fetches to this bank
      BUFD           : Boolean := False;                   -- Enables read buffering feature for data reads to this bank
      Reserved1      : Bits_2  := 0;
      Reserved2      : Bits_4  := 0;
      WAIT           : Bits_4  := WAIT_0;                  -- Defines the number of wait states required for a read operation to the bank
      RD_MODE_STATUS : Bits_4  := RD_MODE_STATUS_RDNORMAL; -- Reflects the current Read Mode of the Bank
      Reserved3      : Bits_12 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_BANK1_RDCTL_Type use record
      RD_MODE        at 0 range  0 ..  3;
      BUFI           at 0 range  4 ..  4;
      BUFD           at 0 range  5 ..  5;
      Reserved1      at 0 range  6 ..  7;
      Reserved2      at 0 range  8 .. 11;
      WAIT           at 0 range 12 .. 15;
      RD_MODE_STATUS at 0 range 16 .. 19;
      Reserved3      at 0 range 20 .. 31;
   end record;

   -- 9.4.4 FLCTL_RDBRST_CTLSTAT Register

   MEM_TYPE_MAIN  : constant := 2#00#; -- Main Memory
   MEM_TYPE_INFO  : constant := 2#01#; -- Information memory
   MEM_TYPE_RSVD1 : constant := 2#10#; -- Reserved
   MEM_TYPE_RSVD2 : constant := 2#11#; -- Reserved

   DATA_CMP_ALL0 : constant := 0; -- 0000_0000_0000_0000_0000_0000_0000_0000
   DATA_CMP_ALL1 : constant := 1; -- FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF

   BRST_STAT_IDLE       : constant := 2#00#; -- Idle
   BRST_STAT_PENDING    : constant := 2#01#; -- Burst/Compare START bit written, but operation pending
   BRST_STAT_INPROGRESS : constant := 2#10#; -- Burst/Compare in progress
   BRST_STAT_COMPLETE   : constant := 2#11#; -- Burst complete (status of completed burst remains in this state unless explicitly cleared by software)

   type FLCTL_RDBRST_CTLSTAT_Type is record
      START     : Boolean := False;          -- Write 1 triggers start of burst/compare operation
      MEM_TYPE  : Bits_2  := MEM_TYPE_MAIN;  -- Type of memory that burst is carried out on
      STOP_FAIL : Boolean := False;          -- If set to 1, causes burst/compare operation to terminate on first compare mismatch
      DATA_CMP  : Bits_1  := DATA_CMP_ALL0;  -- Data pattern used for comparison against memory read data
      Reserved1 : Bits_1  := 0;
      Reserved2 : Bits_10 := 0;
      BRST_STAT : Bits_2  := BRST_STAT_IDLE; -- Status of Burst/Compare operation
      CMP_ERR   : Boolean := False;          -- if 1, indicates that the Burst/Compare Operation encountered at least one data comparison error
      ADDR_ERR  : Boolean := False;          -- If 1, indicates that Burst/Compare Operation was terminated due to access to reserved memory
      Reserved3 : Bits_3  := 0;
      CLR_STAT  : Boolean := False;          -- Write 1 to clear status bits 19-16 of this register
      Reserved4 : Bits_8  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_RDBRST_CTLSTAT_Type use record
      START     at 0 range  0 ..  0;
      MEM_TYPE  at 0 range  1 ..  2;
      STOP_FAIL at 0 range  3 ..  3;
      DATA_CMP  at 0 range  4 ..  4;
      Reserved1 at 0 range  5 ..  5;
      Reserved2 at 0 range  6 .. 15;
      BRST_STAT at 0 range 16 .. 17;
      CMP_ERR   at 0 range 18 .. 18;
      ADDR_ERR  at 0 range 19 .. 19;
      Reserved3 at 0 range 20 .. 22;
      CLR_STAT  at 0 range 23 .. 23;
      Reserved4 at 0 range 24 .. 31;
   end record;

   -- 9.4.5 FLCTL_RDBRST_STARTADDR Register

   type FLCTL_RDBRST_STARTADDR_Type is record
      START_ADDRESS : Bits_21 := 0; -- Start Address of Burst Operation.
      Reserved      : Bits_11 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_RDBRST_STARTADDR_Type use record
      START_ADDRESS at 0 range  0 .. 20;
      Reserved      at 0 range 21 .. 31;
   end record;

   -- 9.4.6 FLCTL_RDBRST_LEN Register

   type FLCTL_RDBRST_LEN_Type is record
      BURST_LENGTH : Bits_21 := 0; -- Length of Burst Operation (in bytes).
      Reserved     : Bits_11 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_RDBRST_LEN_Type use record
      BURST_LENGTH at 0 range  0 .. 20;
      Reserved     at 0 range 21 .. 31;
   end record;

   -- 9.4.7 FLCTL_RDBRST_FAILADDR Register

   type FLCTL_RDBRST_FAILADDR_Type is record
      FAIL_ADDRESS : Bits_21 := 0; -- Reflects address of last failed compare.
      Reserved     : Bits_11 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_RDBRST_FAILADDR_Type use record
      FAIL_ADDRESS at 0 range  0 .. 20;
      Reserved     at 0 range 21 .. 31;
   end record;

   -- 9.4.8 FLCTL_RDBRST_FAILCNT Register

   type FLCTL_RDBRST_FAILCNT_Type is record
      FAIL_COUNT : Bits_17 := 0; -- Reflects number of failures encountered in burst operation.
      Reserved   : Bits_15 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_RDBRST_FAILCNT_Type use record
      FAIL_COUNT at 0 range  0 .. 16;
      Reserved   at 0 range 17 .. 31;
   end record;

   -- 9.4.9 FLCTL_PRG_CTLSTAT Register

   MODE_IMMEDIATE : constant := 0; -- Write immediate mode. Starts program operation immediately on each write to the Flash
   MODE_FULLWORD  : constant := 1; -- Full word write mode.

   STATUS_IDLE       : constant := 2#00#; -- Idle (no program operation currently active)
   STATUS_PENDING    : constant := 2#01#; -- Single word program operation triggered, but pending
   STATUS_INPROGRESS : constant := 2#10#; -- Single word program in progress
   STATUS_RSVD       : constant := 2#11#; -- Reserved (Idle)

   BNK_ACT_BANK0 : constant := 0;
   BNK_ACT_BANK1 : constant := 1;

   type FLCTL_PRG_CTLSTAT_Type is record
      ENABLE    : Boolean := False;          -- Master control for all word program operations
      MODE      : Bits_1  := MODE_IMMEDIATE; -- Controls write mode selected by application
      VER_PRE   : Boolean := True;           -- Controls automatic pre program verify operations
      VER_PST   : Boolean := True;           -- Controls automatic post program verify operations
      Reserved1 : Bits_12 := 0;
      STATUS    : Bits_2  := STATUS_IDLE;    --  Reflects the status of program operations in the Flash memory
      BNK_ACT   : Bits_1  := BNK_ACT_BANK0;  -- Reflects which bank is currently undergoing a program operation
      Reserved2 : Bits_13 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_PRG_CTLSTAT_Type use record
      ENABLE    at 0 range  0 ..  0;
      MODE      at 0 range  1 ..  1;
      VER_PRE   at 0 range  2 ..  2;
      VER_PST   at 0 range  3 ..  3;
      Reserved1 at 0 range  4 .. 15;
      STATUS    at 0 range 16 .. 17;
      BNK_ACT   at 0 range 18 .. 18;
      Reserved2 at 0 range 19 .. 31;
   end record;

   -- 9.4.10 FLCTL_PRGBRST_CTLSTAT

   -- __INF__ use "TYP3" instead of "TYPE"
   TYP3_MAIN  renames MEM_TYPE_MAIN;
   TYP3_INFO  renames MEM_TYPE_INFO;
   TYP3_RSVD1 renames MEM_TYPE_RSVD1;
   TYP3_RSVD2 renames MEM_TYPE_RSVD2;

   LEN_NONE  : constant := 2#000#; -- No burst operation
   LEN_128   : constant := 2#001#; -- 1 word burst of 128 bits, starting with address in the FLCTL_PRGBRST_STARTADDR Register
   LEN_256   : constant := 2#010#; -- 2*128 bits burst write, starting with address in the FLCTL_PRGBRST_STARTADDR Register
   LEN_384   : constant := 2#011#; -- 3*128 bits burst write, starting with address in the FLCTL_PRGBRST_STARTADDR Register
   LEN_512   : constant := 2#100#; -- 4*128 bits burst write, starting with address in the FLCTL_PRGBRST_STARTADDR Register
   LEN_RSVD1 : constant := 2#101#; -- Reserved. No burst operation.
   LEN_RSVD2 : constant := 2#110#; -- Reserved. No burst operation.
   LEN_RSVD3 : constant := 2#111#; -- Reserved. No burst operation.

   BURST_STATUS_IDLE     : constant := 2#000#; -- Idle (Burst not active)
   BURST_STATUS_PENDING  : constant := 2#001#; -- Burst program started but pending
   BURST_STATUS_128      : constant := 2#010#; -- Burst active, with 1st 128 bit word being written into Flash
   BURST_STATUS_256      : constant := 2#011#; -- Burst active, with 2nd 128 bit word being written into Flash
   BURST_STATUS_384      : constant := 2#100#; -- Burst active, with 3rd 128 bit word being written into Flash
   BURST_STATUS_512      : constant := 2#101#; -- Burst active, with 4th 128 bit word being written into Flash
   BURST_STATUS_RSVD     : constant := 2#110#; -- Reserved (Idle)
   BURST_STATUS_COMPLETE : constant := 2#111#; -- Burst Complete (status of completed burst remains in this state unless explicitly cleared by software)

   -- __INF__ use "TYP3" instead of "TYPE"
   type FLCTL_PRGBRST_CTLSTAT_Type is record
      START        : Boolean := False;             -- Write 1 triggers start of burst program operation
      TYP3         : Bits_2  := TYP3_MAIN;         -- Type of memory that burst program is carried out on
      LEN          : Bits_3  := LEN_NONE;          -- Length of burst (in 128 bit granularity)
      AUTO_PRE     : Boolean := True;              -- Controls the Auto-Verify operation before the Burst Program
      AUTO_PST     : Boolean := True;              -- Controls the Auto-Verify operation after the Burst Program
      Reserved1    : Bits_8  := 0;
      BURST_STATUS : Bits_3  := BURST_STATUS_IDLE; -- At any point in time, it reflects the status of a Burst Operation
      PRE_ERR      : Boolean := False;             -- If 1, indicates that Burst Operation encountered pre-program auto-verify errors
      PST_ERR      : Boolean := False;             -- if 1, indicates that the Burst Operation encountered post-program auto-verify errors
      ADDR_ERR     : Boolean := False;             -- If 1, indicates that Burst Operation was terminated due to attempted program of reserved memory
      Reserved2    : Bits_1  := 0;
      CLR_STAT     : Boolean := False;             -- Write 1 to clear status bits 21-16 of this register
      Reserved3    : Bits_8  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_PRGBRST_CTLSTAT_Type use record
      START        at 0 range  0 ..  0;
      TYP3         at 0 range  1 ..  2;
      LEN          at 0 range  3 ..  5;
      AUTO_PRE     at 0 range  6 ..  6;
      AUTO_PST     at 0 range  7 ..  7;
      Reserved1    at 0 range  8 .. 15;
      BURST_STATUS at 0 range 16 .. 18;
      PRE_ERR      at 0 range 19 .. 19;
      PST_ERR      at 0 range 20 .. 20;
      ADDR_ERR     at 0 range 21 .. 21;
      Reserved2    at 0 range 22 .. 22;
      CLR_STAT     at 0 range 23 .. 23;
      Reserved3    at 0 range 24 .. 31;
   end record;

   -- 9.4.11 FLCTL_PRGBRST_STARTADDR

   type FLCTL_PRGBRST_STARTADDR_Type is record
      START_ADDRESS : Bits_22 := 0; -- Start Address of Program Burst Operation.
      Reserved      : Bits_10 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_PRGBRST_STARTADDR_Type use record
      START_ADDRESS at 0 range  0 .. 21;
      Reserved      at 0 range 22 .. 31;
   end record;

   -- 9.4.12 FLCTL_PRGBRST_DATA0_0 Register
   -- 9.4.13 FLCTL_PRGBRST_DATA0_1 Register
   -- 9.4.14 FLCTL_PRGBRST_DATA0_2 Register
   -- 9.4.15 FLCTL_PRGBRST_DATA0_3 Register
   -- 9.4.16 FLCTL_PRGBRST_DATA1_0 Register
   -- 9.4.17 FLCTL_PRGBRST_DATA1_1 Register
   -- 9.4.18 FLCTL_PRGBRST_DATA1_2 Register
   -- 9.4.19 FLCTL_PRGBRST_DATA1_3 Register
   -- 9.4.20 FLCTL_PRGBRST_DATA2_0 Register
   -- 9.4.21 FLCTL_PRGBRST_DATA2_1 Register
   -- 9.4.22 FLCTL_PRGBRST_DATA2_2 Register
   -- 9.4.23 FLCTL_PRGBRST_DATA2_3 Register
   -- 9.4.24 FLCTL_PRGBRST_DATA3_0 Register
   -- 9.4.25 FLCTL_PRGBRST_DATA3_1 Register
   -- 9.4.26 FLCTL_PRGBRST_DATA3_2 Register
   -- 9.4.27 FLCTL_PRGBRST_DATA3_3 Register

   type FLCTL_PRGBRST_DATAy_x_Type is record
      DATAIN : Unsigned_32 := 16#FFFF_FFFF#; -- Program Burst 128 bit Data Word y (bits (32 × (x + 1) – 1) down to (32 × x) for (x = 0, 1, 2, 3)
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_PRGBRST_DATAy_x_Type use record
      DATAIN at 0 range 0 .. 31;
   end record;

   -- 9.4.28 FLCTL_ERASE_CTLSTAT Register

   MODE_SECTORERASE : constant := 0; -- Sector Erase (controlled by FLTCTL_ERASE_SECTADDR)
   MODE_MASSERASE   : constant := 1; -- Mass Erase (includes all Main and Information memory sectors that don't have corresponding WE bits set)

   -- TYP3_* already defined at 9.4.10

   -- STATUS_* already defined at 9.4.9

   -- __INF__ use "TYP3" instead of "TYPE"
   type FLCTL_ERASE_CTLSTAT_Type is record
      START     : Boolean := False;            -- Write 1 triggers start of Erase operation
      MODE      : Bits_1  := MODE_SECTORERASE; -- Controls erase mode selected by application
      TYP3      : Bits_2  := TYP3_MAIN;        -- Type of memory that erase operation is carried out on (don't care if mass erase is set to 1)
      Reserved1 : Bits_12 := 0;
      STATUS    : Bits_2  := STATUS_IDLE;      -- Reflects the status of erase operations in the Flash memory
      ADDR_ERR  : Boolean := False;            -- If 1, indicates that Erase Operation was terminated due to attempted erase of reserved memory address
      CLR_STAT  : Boolean := False;            -- Write 1 to clear status bits 18-16 of this register
      Reserved2 : Bits_12 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_ERASE_CTLSTAT_Type use record
      START     at 0 range  0 ..  0;
      MODE      at 0 range  1 ..  1;
      TYP3      at 0 range  2 ..  3;
      Reserved1 at 0 range  4 .. 15;
      STATUS    at 0 range 16 .. 17;
      ADDR_ERR  at 0 range 18 .. 18;
      CLR_STAT  at 0 range 19 .. 19;
      Reserved2 at 0 range 20 .. 31;
   end record;

   -- 9.4.29 FLCTL_ERASE_SECTADDR Register

   type FLCTL_ERASE_SECTADDR_Type is record
      SECT_ADDRESS : Bits_22 := 0; -- Address of Sector being Erased.
      Reserved     : Bits_10 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_ERASE_SECTADDR_Type use record
      SECT_ADDRESS at 0 range  0 .. 21;
      Reserved     at 0 range 22 .. 31;
   end record;

   -- 9.4.30 FLCTL_BANK0_INFO_WEPROT Register

   type FLCTL_BANK0_INFO_WEPROT_Type is record
      PROT     : Bitmap_2 := [others => True]; -- If set to 1, protects Sector ?? from program or erase operations
      Reserved : Bits_30  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_BANK0_INFO_WEPROT_Type use record
      PROT     at 0 range 0 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   -- 9.4.31 FLCTL_BANK0_MAIN_WEPROT Register

   type FLCTL_BANK0_MAIN_WEPROT_Type is record
      PROT : Bitmap_32 := [others => True]; -- If set to 1, protects Sector ?? from program or erase operations
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_BANK0_MAIN_WEPROT_Type use record
      PROT at 0 range 0 .. 31;
   end record;

   -- 9.4.32 FLCTL_BANK1_INFO_WEPROT Register

   type FLCTL_BANK1_INFO_WEPROT_Type is record
      PROT     : Bitmap_2 := [others => True]; -- If set to 1, protects Sector ?? from program or erase operations
      Reserved : Bits_30  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_BANK1_INFO_WEPROT_Type use record
      PROT     at 0 range 0 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   -- 9.4.33 FLCTL_BANK1_MAIN_WEPROT Register

   type FLCTL_BANK1_MAIN_WEPROT_Type is record
      PROT : Bitmap_32 := [others => True]; -- If set to 1, protects Sector ?? from program or erase operations
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_BANK1_MAIN_WEPROT_Type use record
      PROT at 0 range 0 .. 31;
   end record;

   -- 9.4.34 FLCTL_BMRK_CTLSTAT Register

   CMP_SEL_I_BMRK : constant := 0; -- Compares the Instruction Benchmark Register against the threshold value
   CMP_SEL_D_BMRK : constant := 1; -- Compares the Data Benchmark Register against the threshold value

   type FLCTL_BMRK_CTLSTAT_Type is record
      I_BMRK   : Boolean := False;          -- When 1, increments the Instruction Benchmark count register on each instruction fetch to the Flash
      D_BMRK   : Boolean := False;          -- When 1, increments the Data Benchmark count register on each data read access to the Flash
      CMP_EN   : Boolean := False;          -- When 1, enables comparison of the Instruction or Data Benchmark Registers against the threshold value
      CMP_SEL  : Bits_1  := CMP_SEL_I_BMRK; -- Selects which benchmark register should be compared against the threshold
      Reserved : Bits_28 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_BMRK_CTLSTAT_Type use record
      I_BMRK   at 0 range 0 ..  0;
      D_BMRK   at 0 range 1 ..  1;
      CMP_EN   at 0 range 2 ..  2;
      CMP_SEL  at 0 range 3 ..  3;
      Reserved at 0 range 4 .. 31;
   end record;

   -- 9.4.35 FLCTL_BMRK_IFETCH Register

   type FLCTL_BMRK_IFETCH_Type is record
      COUNT : Unsigned_32; -- Reflects the number of Instruction Fetches to the Flash (increments by one on each fetch)
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_BMRK_IFETCH_Type use record
      COUNT at 0 range 0 .. 31;
   end record;

   -- 9.4.36 FLCTL_BMRK_DREAD Register

   type FLCTL_BMRK_DREAD_Type is record
      COUNT : Unsigned_32; -- Reflects the number of Data Read operations to the Flash (increments by one on each read)
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_BMRK_DREAD_Type use record
      COUNT at 0 range 0 .. 31;
   end record;

   -- 9.4.37 FLCTL_BMRK_CMP Register

   type FLCTL_BMRK_CMP_Type is record
      COUNT : Unsigned_32 := 16#0001_0000#; -- Reflects the threshold value that is compared against either the IFETCH or DREAD Benchmark Counters
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_BMRK_CMP_Type use record
      COUNT at 0 range 0 .. 31;
   end record;

   -- 9.4.38 FLCTL_IFG Register

   type FLCTL_IFG_Type is record
      RDBRST    : Boolean; -- If set to 1, indicates that the Read Burst/Compare operation is complete
      AVPRE     : Boolean; -- If set to 1, indicates that the pre-program verify operation has detected an error
      AVPST     : Boolean; -- If set to 1, indicates that the post-program verify operation has failed comparison
      PRG       : Boolean; -- If set to 1, indicates that a word Program operation is complete
      PRGB      : Boolean; -- If set to 1, indicates that the configured Burst Program operation is complete
      ERASE     : Boolean; -- If set to 1, indicates that the Erase operation is complete
      Reserved1 : Bits_2;
      BMRK      : Boolean; -- If set to 1, indicates that a Benchmark Compare match occurred
      PRG_ERR   : Boolean; -- If set to 1, indicates a word composition error in full word write mode
      Reserved2 : Bits_22;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_IFG_Type use record
      RDBRST    at 0 range  0 ..  0;
      AVPRE     at 0 range  1 ..  1;
      AVPST     at 0 range  2 ..  2;
      PRG       at 0 range  3 ..  3;
      PRGB      at 0 range  4 ..  4;
      ERASE     at 0 range  5 ..  5;
      Reserved1 at 0 range  6 ..  7;
      BMRK      at 0 range  8 ..  8;
      PRG_ERR   at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 31;
   end record;

   -- 9.4.39 FLCTL_IE Register

   type FLCTL_IE_Type is record
      RDBRST    : Boolean := False; -- If set to 1, enables the Controller to generate an interrupt based on the corresponding bit in the FLCTL_IFG
      AVPRE     : Boolean := False; -- ''
      AVPST     : Boolean := False; -- ''
      PRG       : Boolean := False; -- ''
      PRGB      : Boolean := False; -- ''
      ERASE     : Boolean := False; -- ''
      Reserved1 : Bits_2  := 0;
      BMRK      : Boolean := False; -- ''
      PRG_ERR   : Boolean := False; -- ''
      Reserved2 : Bits_22 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_IE_Type use record
      RDBRST    at 0 range  0 ..  0;
      AVPRE     at 0 range  1 ..  1;
      AVPST     at 0 range  2 ..  2;
      PRG       at 0 range  3 ..  3;
      PRGB      at 0 range  4 ..  4;
      ERASE     at 0 range  5 ..  5;
      Reserved1 at 0 range  6 ..  7;
      BMRK      at 0 range  8 ..  8;
      PRG_ERR   at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 31;
   end record;

   -- 9.4.40 FLCTL_CLRIFG Register

   type FLCTL_CLRIFG_Type is record
      RDBRST    : Boolean := False; -- Write 1 clears the corresponding interrupt flag bit in the FLCTL_IFG
      AVPRE     : Boolean := False; -- ''
      AVPST     : Boolean := False; -- ''
      PRG       : Boolean := False; -- ''
      PRGB      : Boolean := False; -- ''
      ERASE     : Boolean := False; -- ''
      Reserved1 : Bits_2  := 0;
      BMRK      : Boolean := False; -- ''
      PRG_ERR   : Boolean := False; -- ''
      Reserved2 : Bits_22 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_CLRIFG_Type use record
      RDBRST    at 0 range  0 ..  0;
      AVPRE     at 0 range  1 ..  1;
      AVPST     at 0 range  2 ..  2;
      PRG       at 0 range  3 ..  3;
      PRGB      at 0 range  4 ..  4;
      ERASE     at 0 range  5 ..  5;
      Reserved1 at 0 range  6 ..  7;
      BMRK      at 0 range  8 ..  8;
      PRG_ERR   at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 31;
   end record;

   -- 9.4.41 FLCTL_SETIFG Register

   type FLCTL_SETIFG_Type is record
      RDBRST    : Boolean := False; -- Write 1 sets the corresponding interrupt flag bit in the FLCTL_IFG
      AVPRE     : Boolean := False; -- ''
      AVPST     : Boolean := False; -- ''
      PRG       : Boolean := False; -- ''
      PRGB      : Boolean := False; -- ''
      ERASE     : Boolean := False; -- ''
      Reserved1 : Bits_2  := 0;
      BMRK      : Boolean := False; -- ''
      PRG_ERR   : Boolean := False; -- ''
      Reserved2 : Bits_22 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_SETIFG_Type use record
      RDBRST    at 0 range  0 ..  0;
      AVPRE     at 0 range  1 ..  1;
      AVPST     at 0 range  2 ..  2;
      PRG       at 0 range  3 ..  3;
      PRGB      at 0 range  4 ..  4;
      ERASE     at 0 range  5 ..  5;
      Reserved1 at 0 range  6 ..  7;
      BMRK      at 0 range  8 ..  8;
      PRG_ERR   at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 31;
   end record;

   -- 9.4.42 FLCTL_READ_TIMCTL Register

   type FLCTL_READ_TIMCTL_Type is record
      SETUP       : Unsigned_8; -- Length of the Setup phase for this operation
      Reserved1   : Bits_4;
      IREF_BOOST1 : Bits_4;     -- Length of IREF_BOOST1 signal of the Flash memory
      SETUP_LONG  : Unsigned_8; -- This field defines the length of the Setup time into read mode when the device is recovering from one of the following conditions Moving from standby to active state in low-frequency active mode Recovering from the LDO Boost operation after a Mass Erase
      Reserved2   : Bits_8;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_READ_TIMCTL_Type use record
      SETUP       at 0 range  0 ..  7;
      Reserved1   at 0 range  8 .. 11;
      IREF_BOOST1 at 0 range 12 .. 15;
      SETUP_LONG  at 0 range 16 .. 23;
      Reserved2   at 0 range 24 .. 31;
   end record;

   -- 9.4.43 FLCTL_READMARGIN_TIMCTL Register

   type FLCTL_READMARGIN_TIMCTL_Type is record
      SETUP    : Unsigned_8; -- Length of the Setup phase for this operation
      Reserved : Bits_24;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_READMARGIN_TIMCTL_Type use record
      SETUP    at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 9.4.44 FLCTL_PRGVER_TIMCTL Register

   type FLCTL_PRGVER_TIMCTL_Type is record
      SETUP    : Unsigned_8; -- Length of the Setup phase for this operation
      ACTIVE   : Bits_4;     -- Length of the Active phase for this operation
      HOLD     : Bits_4;     -- Length of the Hold phase for this operation
      Reserved : Bits_16;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_PRGVER_TIMCTL_Type use record
      SETUP    at 0 range  0 ..  7;
      ACTIVE   at 0 range  8 .. 11;
      HOLD     at 0 range 12 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 9.4.45 FLCTL_ERSVER_TIMCTL Register

   type FLCTL_ERSVER_TIMCTL_Type is record
      SETUP    : Unsigned_8; -- Length of the Setup phase for this operation
      Reserved : Bits_24;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_ERSVER_TIMCTL_Type use record
      SETUP    at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 9.4.46 FLCTL_PROGRAM_TIMCTL Register

   type FLCTL_PROGRAM_TIMCTL_Type is record
      SETUP  : Unsigned_8; -- Length of the Setup phase for this operation
      ACTIVE : Bits_20;    -- Length of the Active phase for this operation
      HOLD   : Bits_4;     -- Length of the Hold phase for this operation
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_PROGRAM_TIMCTL_Type use record
      SETUP  at 0 range  0 ..  7;
      ACTIVE at 0 range  8 .. 27;
      HOLD   at 0 range 28 .. 31;
   end record;

   -- 9.4.47 FLCTL_ERASE_TIMCTL Register

   type FLCTL_ERASE_TIMCTL_Type is record
      SETUP  : Unsigned_8; -- Length of the Setup phase for this operation
      ACTIVE : Bits_20;    -- Length of the Active phase for this operation
      HOLD   : Bits_4;     -- Length of the Hold phase for this operation
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_ERASE_TIMCTL_Type use record
      SETUP  at 0 range  0 ..  7;
      ACTIVE at 0 range  8 .. 27;
      HOLD   at 0 range 28 .. 31;
   end record;

   -- 9.4.48 FLCTL_MASSERASE_TIMCTL Register

   type FLCTL_MASSERASE_TIMCTL_Type is record
      BOOST_ACTIVE : Unsigned_8; -- Length of the time for which LDO Boost Signal is kept active
      BOOST_HOLD   : Unsigned_8; -- Length for which Flash deactivates the LDO Boost signal before processing any new commands
      Reserved     : Bits_16;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_MASSERASE_TIMCTL_Type use record
      BOOST_ACTIVE at 0 range  0 ..  7;
      BOOST_HOLD   at 0 range  8 .. 15;
      Reserved     at 0 range 16 .. 31;
   end record;

   -- 9.4.49 FLCTL_BURSTPRG_TIMCTL Register

   type FLCTL_BURSTPRG_TIMCTL_Type is record
      Reserved1 : Bits_8;
      ACTIVE    : Bits_20; -- Length of the Active phase for this operation
      Reserved2 : Bits_4;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for FLCTL_BURSTPRG_TIMCTL_Type use record
      Reserved1 at 0 range  0 ..  7;
      ACTIVE    at 0 range  8 .. 27;
      Reserved2 at 0 range 28 .. 31;
   end record;

   -- Table 6-30. FLCTL Registers

   FLCTL_BASEADDRESS : constant := 16#4001_1000#;

   FLCTL_POWER_STAT : aliased FLCTL_POWER_STAT_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_BANK0_RDCTL : aliased FLCTL_BANK0_RDCTL_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#010#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_BANK1_RDCTL : aliased FLCTL_BANK1_RDCTL_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#014#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_RDBRST_CTLSTAT : aliased FLCTL_RDBRST_CTLSTAT_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#020#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_RDBRST_STARTADDR : aliased FLCTL_RDBRST_STARTADDR_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#024#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_RDBRST_LEN : aliased FLCTL_RDBRST_LEN_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#028#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_RDBRST_FAILADDR : aliased FLCTL_RDBRST_FAILADDR_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#03C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_RDBRST_FAILCNT : aliased FLCTL_RDBRST_FAILCNT_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#040#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRG_CTLSTAT : aliased FLCTL_PRG_CTLSTAT_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#050#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_CTLSTAT : aliased FLCTL_PRGBRST_CTLSTAT_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#054#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_STARTADDR : aliased FLCTL_PRGBRST_STARTADDR_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#058#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA0_0 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#060#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA0_1 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#064#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA0_2 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#068#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA0_3 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#06C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA1_0 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#070#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA1_1 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#074#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA1_2 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#078#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA1_3 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#07C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA2_0 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#080#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA2_1 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#084#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA2_2 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#088#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA2_3 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#08C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA3_0 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#090#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA3_1 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#094#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA3_2 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#098#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGBRST_DATA3_3 : aliased FLCTL_PRGBRST_DATAy_x_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#09C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_ERASE_CTLSTAT : aliased FLCTL_ERASE_CTLSTAT_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0A0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_ERASE_SECTADDR : aliased FLCTL_ERASE_SECTADDR_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0A4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_BANK0_INFO_WEPROT : aliased FLCTL_BANK0_INFO_WEPROT_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0B0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_BANK0_MAIN_WEPROT : aliased FLCTL_BANK0_MAIN_WEPROT_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0B4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_BANK1_INFO_WEPROT : aliased FLCTL_BANK1_INFO_WEPROT_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0C0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_BANK1_MAIN_WEPROT : aliased FLCTL_BANK1_MAIN_WEPROT_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0C4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_BMRK_CTLSTAT : aliased FLCTL_BMRK_CTLSTAT_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0D0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_BMRK_IFETCH : aliased FLCTL_BMRK_IFETCH_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0D4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_BMRK_DREAD : aliased FLCTL_BMRK_DREAD_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0D8#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_BMRK_CMP : aliased FLCTL_BMRK_CMP_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0DC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_IFG : aliased FLCTL_IFG_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0F0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_IE : aliased FLCTL_IE_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0F4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_CLRIFG : aliased FLCTL_CLRIFG_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0F8#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_SETIFG : aliased FLCTL_SETIFG_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#0FC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_READ_TIMCTL : aliased FLCTL_READ_TIMCTL_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#100#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_READMARGIN_TIMCTL : aliased FLCTL_READMARGIN_TIMCTL_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#104#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PRGVER_TIMCTL : aliased FLCTL_PRGVER_TIMCTL_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#108#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_ERSVER_TIMCTL : aliased FLCTL_ERSVER_TIMCTL_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#10C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_PROGRAM_TIMCTL : aliased FLCTL_PROGRAM_TIMCTL_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#114#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_ERASE_TIMCTL : aliased FLCTL_ERASE_TIMCTL_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#118#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_MASSERASE_TIMCTL : aliased FLCTL_MASSERASE_TIMCTL_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#11C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FLCTL_BURSTPRG_TIMCTL : aliased FLCTL_BURSTPRG_TIMCTL_Type
      with Address              => System'To_Address (FLCTL_BASEADDRESS + 16#120#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 10 Flash Controller A (FLCTL_A)
   ----------------------------------------------------------------------------

   -- 10.4.1 FLCTL_POWER_STAT Register
   -- 10.4.2 FLCTL_BANK0_RDCTL Register
   -- 10.4.3 FLCTL_BANK1_RDCTL Register
   -- 10.4.4 FLCTL_RDBRST_CTLSTAT Register
   -- 10.4.5 FLCTL_RDBRST_STARTADDR Register
   -- 10.4.6 FLCTL_RDBRST_LEN Register
   -- 10.4.7 FLCTL_RDBRST_FAILADDR Register
   -- 10.4.8 FLCTL_RDBRST_FAILCNT Register
   -- 10.4.9 FLCTL_PRG_CTLSTAT Register
   -- 10.4.10 FLCTL_PRGBRST_CTLSTAT Register
   -- 10.4.11 FLCTL_PRGBRST_STARTADDR Register
   -- 10.4.12 FLCTL_PRGBRST_DATA0_0 Register
   -- 10.4.13 FLCTL_PRGBRST_DATA0_1 Register
   -- 10.4.14 FLCTL_PRGBRST_DATA0_2 Register
   -- 10.4.15 FLCTL_PRGBRST_DATA0_3 Register
   -- 10.4.16 FLCTL_PRGBRST_DATA1_0 Register
   -- 10.4.17 FLCTL_PRGBRST_DATA1_1 Register
   -- 10.4.18 FLCTL_PRGBRST_DATA1_2 Register
   -- 10.4.19 FLCTL_PRGBRST_DATA1_3 Register
   -- 10.4.20 FLCTL_PRGBRST_DATA2_0 Register
   -- 10.4.21 FLCTL_PRGBRST_DATA2_1 Register
   -- 10.4.22 FLCTL_PRGBRST_DATA2_2 Register
   -- 10.4.23 FLCTL_PRGBRST_DATA2_3 Register
   -- 10.4.24 FLCTL_PRGBRST_DATA3_0 Register
   -- 10.4.25 FLCTL_PRGBRST_DATA3_1 Register
   -- 10.4.26 FLCTL_PRGBRST_DATA3_2 Register
   -- 10.4.27 FLCTL_PRGBRST_DATA3_3 Register
   -- 10.4.28 FLCTL_ERASE_CTLSTAT Register
   -- 10.4.29 FLCTL_ERASE_SECTADDR Register
   -- 10.4.30 FLCTL_BANK0_INFO_WEPROT Register
   -- 10.4.31 FLCTL_BANK0_MAIN_WEPROT Register
   -- 10.4.32 FLCTL_BANK1_INFO_WEPROT Register
   -- 10.4.33 FLCTL_BANK1_MAIN_WEPROT Register
   -- 10.4.34 FLCTL_BMRK_CTLSTAT Register
   -- 10.4.35 FLCTL_BMRK_IFETCH Register
   -- 10.4.36 FLCTL_BMRK_DREAD Register
   -- 10.4.37 FLCTL_BMRK_CMP Register
   -- 10.4.38 FLCTL_IFG Register
   -- 10.4.39 FLCTL_IE Register
   -- 10.4.40 FLCTL_CLRIFG Register
   -- 10.4.41 FLCTL_SETIFG Register
   -- 10.4.42 FLCTL_READ_TIMCTL Register
   -- 10.4.43 FLCTL_READMARGIN_TIMCTL Register
   -- 10.4.44 FLCTL_PRGVER_TIMCTL Register
   -- 10.4.45 FLCTL_ERSVER_TIMCTL Register
   -- 10.4.46 FLCTL_PROGRAM_TIMCTL Register
   -- 10.4.47 FLCTL_ERASE_TIMCTL Register
   -- 10.4.48 FLCTL_MASSERASE_TIMCTL Register
   -- 10.4.49 FLCTL_BURSTPRG_TIMCTL Register
   -- 10.4.50 FLCTL_BANK0_MAIN_WEPROT0 Register
   -- 10.4.51 FLCTL_BANK0_MAIN_WEPROT1 Register
   -- 10.4.52 FLCTL_BANK0_MAIN_WEPROT2 Register
   -- 10.4.53 FLCTL_BANK0_MAIN_WEPROT3 Register
   -- 10.4.54 FLCTL_BANK0_MAIN_WEPROT4 Register
   -- 10.4.55 FLCTL_BANK0_MAIN_WEPROT5 Register
   -- 10.4.56 FLCTL_BANK0_MAIN_WEPROT6 Register
   -- 10.4.57 FLCTL_BANK0_MAIN_WEPROT7 Register
   -- 10.4.58 FLCTL_BANK1_MAIN_WEPROT0 Register
   -- 10.4.59 FLCTL_BANK1_MAIN_WEPROT1 Register
   -- 10.4.60 FLCTL_BANK1_MAIN_WEPROT2 Register
   -- 10.4.61 FLCTL_BANK1_MAIN_WEPROT3 Register
   -- 10.4.62 FLCTL_BANK1_MAIN_WEPROT4 Register
   -- 10.4.63 FLCTL_BANK1_MAIN_WEPROT5 Register
   -- 10.4.64 FLCTL_BANK1_MAIN_WEPROT6 Register
   -- 10.4.65 FLCTL_BANK1_MAIN_WEPROT7 Register

   ----------------------------------------------------------------------------
   -- Chapter 11 DMA
   ----------------------------------------------------------------------------

   -- 11.3.1 DMA_DEVICE_CFG Register

   type DMA_DEVICE_CFG_Type is record
      NUM_DMA_CHANNELS    : Unsigned_8; -- Reflects the number of DMA channels available on the device
      NUM_SRC_PER_CHANNEL : Unsigned_8; -- Reflects the number of DMA sources per channel
      Reserved            : Bits_16;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_DEVICE_CFG_Type use record
      NUM_DMA_CHANNELS    at 0 range  0 ..  7;
      NUM_SRC_PER_CHANNEL at 0 range  8 .. 15;
      Reserved            at 0 range 16 .. 31;
   end record;

   -- 11.3.2 DMA_SW_CHTRIG Register

   type DMA_SW_CHTRIG_Type is record
      CH : Bitmap_32 := [others => False]; -- Write 1 triggers DMA_CHANNEL??. Bit is auto-cleared when channel goes active.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_SW_CHTRIG_Type use record
      CH at 0 range 0 .. 31;
   end record;

   -- 11.3.3 DMA_CHn_SRCCFG Register

   type DMA_CHn_SRCCFG_Type is record
      DMA_SRC  : Unsigned_8 := 0; -- Controls which device level DMA source is mapped to the channel input
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_CHn_SRCCFG_Type use record
      DMA_SRC  at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 11.3.4 DMA_INT1_SRCCFG Register

   type DMA_INT1_SRCCFG_Type is record
      INT_SRC  : Bits_5  := 0;     -- Controls which channel's completion event is mapped as a source of this Interrupt
      EN       : Boolean := False; -- When 1, enables the DMA_INT1 mapping.
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_INT1_SRCCFG_Type use record
      INT_SRC  at 0 range 0 ..  4;
      EN       at 0 range 5 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   -- 11.3.5 DMA_INT2_SRCCFG Register

   type DMA_INT2_SRCCFG_Type is record
      INT_SRC  : Bits_5  := 0;     -- Controls which channel's completion event is mapped as a source of this Interrupt
      EN       : Boolean := False; -- When 1, enables the DMA_INT2 mapping.
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_INT2_SRCCFG_Type use record
      INT_SRC  at 0 range 0 ..  4;
      EN       at 0 range 5 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   -- 11.3.6 DMA_INT3_SRCCFG Register

   type DMA_INT3_SRCCFG_Type is record
      INT_SRC  : Bits_5  := 0;     -- Controls which channel's completion event is mapped as a source of this Interrupt
      EN       : Boolean := False; -- When 1, enables the DMA_INT3 mapping.
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_INT3_SRCCFG_Type use record
      INT_SRC  at 0 range 0 ..  4;
      EN       at 0 range 5 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   -- 11.3.7 DMA_INT0_SRCFLG Register

   type DMA_INT0_SRCFLG_Type is record
      CH : Bitmap_32; -- If 1, indicates that Channel ?? was the source of DMA_INT0
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_INT0_SRCFLG_Type use record
      CH at 0 range 0 .. 31;
   end record;

   -- 11.3.8 DMA_INT0_CLRFLG Register

   type DMA_INT0_CLRFLG_Type is record
      CH : Bitmap_32 := [others => False]; -- Write 1 clears the corresponding flag bit in the DMA_INT0_SRCFLG register. Write 0 has no effect
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_INT0_CLRFLG_Type use record
      CH at 0 range 0 .. 31;
   end record;

   -- 11.3.9 DMA_STAT Register

   STATE_IDLE    : constant := 2#0000#; -- idle
   STATE_RCHCD   : constant := 2#0001#; -- reading channel controller data
   STATE_RSRCDEP : constant := 2#0010#; -- reading source data end pointer
   STATE_RDSTDEP : constant := 2#0011#; -- reading destination data end pointer
   STATE_RSRCD   : constant := 2#0100#; -- reading source data
   STATE_WDSTD   : constant := 2#0101#; -- writing destination data
   STATE_WRQCLR  : constant := 2#0110#; -- waiting for DMA request to clear
   STATE_WCHCD   : constant := 2#0111#; -- writing channel controller data
   STATE_STALLED : constant := 2#1000#; -- stalled
   STATE_DONE    : constant := 2#1001#; -- done
   STATE_SCAGAT  : constant := 2#1010#; -- peripheral scatter-gather transition
   STATE_RSVD1   : constant := 2#1011#; -- Reserved
   STATE_RSVD2   : constant := 2#1100#; -- Reserved
   STATE_RSVD3   : constant := 2#1101#; -- Reserved
   STATE_RSVD4   : constant := 2#1110#; -- Reserved
   STATE_RSVD5   : constant := 2#1111#; -- Reserved

   TESTSTAT_NONE : constant := 0; -- Controller does not include the integration test logic
   TESTSTAT_TEST : constant := 1; -- Controller includes the integration test logic

   type DMA_STAT_Type is record
      MASTEN    : Boolean; -- Enable status of the controller
      Reserved1 : Bits_3;
      STATE     : Bits_4;  -- Current state of the control state machine.
      Reserved2 : Bits_8;
      DMACHANS  : Bits_5;  -- Number of available DMA channels minus one.
      Reserved3 : Bits_7;
      TESTSTAT  : Bits_4;  -- To reduce the gate count you can configure the controller to exclude the integration test logic.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_STAT_Type use record
      MASTEN    at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  3;
      STATE     at 0 range  4 ..  7;
      Reserved2 at 0 range  8 .. 15;
      DMACHANS  at 0 range 16 .. 20;
      Reserved3 at 0 range 21 .. 27;
      TESTSTAT  at 0 range 28 .. 31;
   end record;

   -- 11.3.10 DMA_CFG Register

   type DMA_CFG_Type is record
      MASTEN            : Boolean := False; -- Enable status of the controller
      Reserved1         : Bits_4  := 0;
      CHPROTCTRL_HPROT1 : Boolean := False; -- Controls HPROT[1] to indicate if a privileged access is occurring.
      CHPROTCTRL_HPROT2 : Boolean := False; -- Controls HPROT[2] to indicate if a bufferable access is occurring.
      CHPROTCTRL_HPROT3 : Boolean := False; -- Controls HPROT[3] to indicate if a cacheable access is occurring.
      Reserved2         : Bits_24 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_CFG_Type use record
      MASTEN            at 0 range 0 ..  0;
      Reserved1         at 0 range 1 ..  4;
      CHPROTCTRL_HPROT1 at 0 range 5 ..  5;
      CHPROTCTRL_HPROT2 at 0 range 6 ..  6;
      CHPROTCTRL_HPROT3 at 0 range 7 ..  7;
      Reserved2         at 0 range 8 .. 31;
   end record;

   -- 11.3.11 DMA_CTLBASE Register

   type DMA_CTLBASE_Type is record
      Reserved : Bits_5  := 0;
      ADDR     : Bits_27 := 0; -- Pointer to the base address of the primary data structure.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_CTLBASE_Type use record
      Reserved at 0 range 0 ..  4;
      ADDR     at 0 range 5 .. 31;
   end record;

   -- 11.3.12 DMA_ALTBASE Register

   type DMA_ALTBASE_Type is record
      ADDR : Unsigned_32; -- Base address of the alternate data structure
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_ALTBASE_Type use record
      ADDR at 0 range 0 .. 31;
   end record;

   -- 11.3.13 DMA_WAITSTAT Register

   type DMA_WAITSTAT_Type is record
      WAITREQ : Bitmap_32; -- Channel wait on request status.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_WAITSTAT_Type use record
      WAITREQ at 0 range 0 .. 31;
   end record;

   -- 11.3.14 DMA_SWREQ Register

   type DMA_SWREQ_Type is record
      SWREQ : Bitmap_32 := [others => False]; -- Set the appropriate bit to generate a software DMA request on the corresponding DMA channel.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_SWREQ_Type use record
      SWREQ at 0 range 0 .. 31;
   end record;

   -- 11.3.15 DMA_USEBURSTSET Register

   type DMA_USEBURSTSET_Type is record
      SET : Bitmap_32 := [others => False]; -- Returns the useburst status, or disables dma_sreq[C] from generating DMA requests.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_USEBURSTSET_Type use record
      SET at 0 range 0 .. 31;
   end record;

   -- 11.3.16 DMA_USEBURSTCLR Register

   type DMA_USEBURSTCLR_Type is record
      CLR : Bitmap_32 := [others => False]; -- Set the appropriate bit to enable dma_sreq[] to generate requests.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_USEBURSTCLR_Type use record
      CLR at 0 range 0 .. 31;
   end record;

   -- 11.3.17 DMA_REQMASKSET Register

   type DMA_REQMASKSET_Type is record
      SET : Bitmap_32 := [others => False]; -- Returns the request mask status of dma_req[] and dma_sreq[], or disables the corresponding channel from generating DMA requests.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_REQMASKSET_Type use record
      SET at 0 range 0 .. 31;
   end record;

   -- 11.3.18 DMA_REQMASKCLR Register

   type DMA_REQMASKCLR_Type is record
      CLR : Bitmap_32 := [others => False]; -- Set the appropriate bit to enable DMA requests for the channel corresponding to dma_req[] and dma_sreq[].
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_REQMASKCLR_Type use record
      CLR at 0 range 0 .. 31;
   end record;

   -- 11.3.19 DMA_ENASET Register

   type DMA_ENASET_Type is record
      SET : Bitmap_32 := [others => False]; -- Returns the enable status of the channels, or enables the corresponding channels.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_ENASET_Type use record
      SET at 0 range 0 .. 31;
   end record;

   -- 11.3.20 DMA_ENACLR Register

   type DMA_ENACLR_Type is record
      CLR : Bitmap_32 := [others => False]; -- Set the appropriate bit to disable the corresponding DMA channel.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_ENACLR_Type use record
      CLR at 0 range 0 .. 31;
   end record;

   -- 11.3.21 DMA_ALTSET Register

   type DMA_ALTSET_Type is record
      SET : Bitmap_32 := [others => False]; -- Returns the channel control data structure status, or selects the alternate data structure for the corresponding DMA channel.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_ALTSET_Type use record
      SET at 0 range 0 .. 31;
   end record;

   -- 11.3.22 DMA_ALTCLR Register

   type DMA_ALTCLR_Type is record
      CLR : Bitmap_32 := [others => False]; -- Set the appropriate bit to select the primary data structure for the corresponding DMA channel.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_ALTCLR_Type use record
      CLR at 0 range 0 .. 31;
   end record;

   -- 11.3.23 DMA_PRIOSET Register

   type DMA_PRIOSET_Type is record
      SET : Bitmap_32 := [others => False]; -- Returns the channel priority mask status, or sets the channel priority to high.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_PRIOSET_Type use record
      SET at 0 range 0 .. 31;
   end record;

   -- 11.3.24 DMA_PRIOCLR Register

   type DMA_PRIOCLR_Type is record
      CLR : Bitmap_32 := [others => False]; -- Set the appropriate bit to select the default priority level for the specified DMA channel.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_PRIOCLR_Type use record
      CLR at 0 range 0 .. 31;
   end record;

   -- 11.3.25 DMA_ERRCLR Register

   type DMA_ERRCLR_Type is record
      ERRCLR   : Boolean := False; -- Returns the status of dma_err, or sets the signal LOW.
      Reserved : Bits_31 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMA_ERRCLR_Type use record
      ERRCLR   at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   -- Table 6-26. DMA Registers

   DMA_BASEADDRESS : constant := 16#400E_0000#;

   DMA_DEVICE_CFG : aliased DMA_DEVICE_CFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_SW_CHTRIG : aliased DMA_SW_CHTRIG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_CH0_SRCCFG : aliased DMA_CHn_SRCCFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0010#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_CH1_SRCCFG : aliased DMA_CHn_SRCCFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0014#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_CH2_SRCCFG : aliased DMA_CHn_SRCCFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0018#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_CH3_SRCCFG : aliased DMA_CHn_SRCCFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#001C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_CH4_SRCCFG : aliased DMA_CHn_SRCCFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0020#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_CH5_SRCCFG : aliased DMA_CHn_SRCCFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0024#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_CH6_SRCCFG : aliased DMA_CHn_SRCCFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0028#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_CH7_SRCCFG : aliased DMA_CHn_SRCCFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#002C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_INT1_SRCCFG : aliased DMA_INT1_SRCCFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0100#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_INT2_SRCCFG : aliased DMA_INT2_SRCCFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0104#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_INT3_SRCCFG : aliased DMA_INT3_SRCCFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0108#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_INT0_SRCFLG : aliased DMA_INT0_SRCFLG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0110#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_INT0_CLRFLG : aliased DMA_INT0_CLRFLG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#0114#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_STAT : aliased DMA_STAT_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_CFG : aliased DMA_CFG_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_CTLBASE : aliased DMA_CTLBASE_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1008#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_ALTBASE : aliased DMA_ALTBASE_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#100C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_WAITSTAT : aliased DMA_WAITSTAT_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1010#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_SWREQ : aliased DMA_SWREQ_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1014#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_USEBURSTSET : aliased DMA_USEBURSTSET_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1018#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_USEBURSTCLR : aliased DMA_USEBURSTCLR_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#101C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_REQMASKSET : aliased DMA_REQMASKSET_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1020#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_REQMASKCLR : aliased DMA_REQMASKCLR_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1024#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_ENASET : aliased DMA_ENASET_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1028#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_ENACLR : aliased DMA_ENACLR_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#102C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_ALTSET : aliased DMA_ALTSET_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1030#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_ALTCLR : aliased DMA_ALTCLR_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1034#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_PRIOSET : aliased DMA_PRIOSET_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#1038#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_PRIOCLR : aliased DMA_PRIOCLR_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#103C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DMA_ERRCLR : aliased DMA_ERRCLR_Type
      with Address              => System'To_Address (DMA_BASEADDRESS + 16#104C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 12 Digital I/O
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 16#1E# * 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 16#18# * 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 16#1E# * 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 16#20# * 8;
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
   -- Chapter 13 Port Mapping Controller (PMAP)
   ----------------------------------------------------------------------------

   -- 13.3.1 PMAPKEYID Register

   PMAPKEYx_KEY : constant := 16#2D52#;

   type PMAPKEYID_Type is record
      PMAPKEYx : Unsigned_16 := 16#96A5#; -- Port mapping controller write access key.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for PMAPKEYID_Type use record
      PMAPKEYx at 0 range 0 .. 15;
   end record;

   -- 13.3.2 PMAPCTL Register

   type PMAPCTL_Type is record
      PMAPLOCKED : Boolean := True;  -- Port mapping lock bit.
      PMAPRECFG  : Boolean := False; -- Port mapping reconfiguration control bit
      Reserved   : Bits_14 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for PMAPCTL_Type use record
      PMAPLOCKED at 0 range 0 ..  0;
      PMAPRECFG  at 0 range 1 ..  1;
      Reserved   at 0 range 2 .. 15;
   end record;

   -- 13.3.3 P1MAP0 to P1MAP7 Register

   type PMAP8_Type is record
      PMAP : Bitmap_8;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for PMAP8_Type use record
      PMAP at 0 range 0 .. 7;
   end record;

   -- 13.3.10 PxMAPyz Register

   type PMAP16_Type is record
      PMAP : Bitmap_16;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
   -- Chapter 14 Capacitive Touch IO (CAPTIO)
   ----------------------------------------------------------------------------

   -- 14.3.1 CAPTIOxCTL Register

   CAPTIOPISELx_0 : constant := 2#000#; -- Px.0
   CAPTIOPISELx_1 : constant := 2#001#; -- Px.1
   CAPTIOPISELx_2 : constant := 2#010#; -- Px.2
   CAPTIOPISELx_3 : constant := 2#011#; -- Px.3
   CAPTIOPISELx_4 : constant := 2#100#; -- Px.4
   CAPTIOPISELx_5 : constant := 2#101#; -- Px.5
   CAPTIOPISELx_6 : constant := 2#110#; -- Px.6
   CAPTIOPISELx_7 : constant := 2#111#; -- Px.7

   CAPTIOPOSELx_PJ  : constant := 2#0000#; -- Px = PJ
   CAPTIOPOSELx_P1  : constant := 2#0001#; -- Px = P1
   CAPTIOPOSELx_P2  : constant := 2#0010#; -- Px = P2
   CAPTIOPOSELx_P3  : constant := 2#0011#; -- Px = P3
   CAPTIOPOSELx_P4  : constant := 2#0100#; -- Px = P4
   CAPTIOPOSELx_P5  : constant := 2#0101#; -- Px = P5
   CAPTIOPOSELx_P6  : constant := 2#0110#; -- Px = P6
   CAPTIOPOSELx_P7  : constant := 2#0111#; -- Px = P7
   CAPTIOPOSELx_P8  : constant := 2#1000#; -- Px = P8
   CAPTIOPOSELx_P9  : constant := 2#1001#; -- Px = P9
   CAPTIOPOSELx_P10 : constant := 2#1010#; -- Px = P10
   CAPTIOPOSELx_P11 : constant := 2#1011#; -- Px = P11
   CAPTIOPOSELx_P12 : constant := 2#1100#; -- Px = P12
   CAPTIOPOSELx_P13 : constant := 2#1101#; -- Px = P13
   CAPTIOPOSELx_P14 : constant := 2#1110#; -- Px = P14
   CAPTIOPOSELx_P15 : constant := 2#1111#; -- Px = P15

   type CAPTIOxCTL_Type is record
      Reserved1    : Bits_1  := 0;
      CAPTIOPISELx : Bits_3  := CAPTIOPISELx_0;  -- Capacitive Touch IO pin select.
      CAPTIOPOSELx : Bits_4  := CAPTIOPOSELx_PJ; -- Capacitive Touch IO port select.
      CAPTIOEN     : Boolean := False;           -- Capacitive Touch IO enable
      CAPTIO       : Boolean := False;           -- Capacitive Touch IO state.
      Reserved2    : Bits_6  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for CAPTIOxCTL_Type use record
      Reserved1    at 0 range  0 ..  0;
      CAPTIOPISELx at 0 range  1 ..  3;
      CAPTIOPOSELx at 0 range  4 ..  7;
      CAPTIOEN     at 0 range  8 ..  8;
      CAPTIO       at 0 range  9 ..  9;
      Reserved2    at 0 range 10 .. 15;
   end record;

   -- Table 6-23. Capacitive Touch I/O 0 Registers

   CAPTIO0CTL_BASEADDRESS : constant := 16#4000_5400#;

   CAPTIO0CTL : aliased CAPTIOxCTL_Type
      with Address              => System'To_Address (CAPTIO0CTL_BASEADDRESS + 16#0E#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- Table 6-24. Capacitive Touch I/O 1 Registers

   CAPTIO1CTL_BASEADDRESS : constant := 16#4000_5800#;

   CAPTIO1CTL : aliased CAPTIOxCTL_Type
      with Address              => System'To_Address (CAPTIO1CTL_BASEADDRESS + 16#0E#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 15 CRC32 Module
   ----------------------------------------------------------------------------

   -- 15.3.0.1 CRC32DI Register
   -- 15.3.0.2 CRC32DIRB Register
   -- 15.3.0.3 CRC32INIRES_LO Register
   -- 15.3.0.4 CRC32INIRES_HI Register
   -- 15.3.0.5 CRC32RESR_LO Register
   -- 15.3.0.6 CRC32RESR_HI Register
   -- 15.3.0.7 CRC16DI Register
   -- 15.3.0.8 CRC16DIRB Register
   -- 15.3.0.9 CRC16INIRES Register
   -- 15.3.0.10 CRC16RESR Register

   ----------------------------------------------------------------------------
   -- Chapter 16 AES256 Accelerator
   ----------------------------------------------------------------------------

   -- 16.3.1 AESACTL0 Register
   -- 16.3.2 AESACTL1 Register
   -- 16.3.3 AESASTAT Register
   -- 16.3.4 AESAKEY Register
   -- 16.3.5 AESADIN Register
   -- 16.3.6 AESADOUT Register
   -- 16.3.7 AESAXDIN Register
   -- 16.3.8 AESAXIN Register

   ----------------------------------------------------------------------------
   -- Chapter 17 Watchdog Timer (WDT_A)
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
      WDTIS    : Bits_3     := WDTIS_DIV2E15;     -- Watchdog timer interval select.
      WDTCNTCL : Boolean    := False;             -- Watchdog timer counter clear.
      WDTTMSEL : Bits_1     := WDTTMSEL_WATCHDOG; -- Watchdog timer mode select
      WDTSSEL  : Bits_2     := WDTSSEL_SMCLK;     -- Watchdog timer clock source select
      WDTHOLD  : Boolean    := False;             -- Watchdog timer hold.
      WDTPW    : Unsigned_8 := 16#69#;            -- Watchdog timer password.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
      with Address              => System'To_Address (WDT_A_BASEADDRESS + 16#0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 18 Timer32
   ----------------------------------------------------------------------------

   -- 18.5.1 T32LOAD1 Register
   -- 18.5.8 T32LOAD2 Register

   type T32LOADx_Type is record
      LOAD : Unsigned_32 := 0; -- The value from which the Timer x counter decrements
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for T32LOADx_Type use record
      LOAD at 0 range 0 .. 31;
   end record;

   -- 18.5.2 T32VALUE1 Register
   -- 18.5.9 T32VALUE2 Register

   type T32VALUEx_Type is record
      VALUE : Unsigned_32; -- Reports the current value of the decrementing counter
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for T32VALUEx_Type use record
      VALUE at 0 range 0 .. 31;
   end record;

   -- 18.5.3 T32CONTROL1 Register
   -- 18.5.10 T32CONTROL2 Register

   SIZE_16 : constant := 0; -- 16-bit counter
   SIZE_32 : constant := 1; -- 32-bit counter

   PRESCALE_DIV1   : constant := 2#00#; -- 0 stages of prescale, clock is divided by 1
   PRESCALE_DIV16  : constant := 2#01#; -- 4 stages of prescale, clock is divided by 16
   PRESCALE_DIV256 : constant := 2#10#; -- 8 stages of prescale, clock is divided by 256
   PRESCALE_RSVD   : constant := 2#11#; -- Reserved

   MODE_FREERUN  : constant := 0; -- Timer is in free-running mode
   MODE_PERIODIC : constant := 1; -- Timer is in periodic mode

   type T32CONTROLx_Type is record
      ONESHOT   : Boolean := False;         -- Selects one-shot or wrapping counter mode
      SIZE      : Bits_1  := SIZE_16;       -- Selects 16 or 32 bit counter operation
      PRESCALE  : Bits_2  := PRESCALE_DIV1; -- Prescale bits
      Reserved1 : Bits_1  := 0;
      IE        : Boolean := True;          -- Interrupt enable bit
      MODE      : Bits_1  := MODE_FREERUN;  -- Mode bit
      ENABLE    : Boolean := False;         -- Enable bit
      Reserved2 : Bits_24 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for T32CONTROLx_Type use record
      ONESHOT   at 0 range 0 ..  0;
      SIZE      at 0 range 1 ..  1;
      PRESCALE  at 0 range 2 ..  3;
      Reserved1 at 0 range 4 ..  4;
      IE        at 0 range 5 ..  5;
      MODE      at 0 range 6 ..  6;
      ENABLE    at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   -- 18.5.4 T32INTCLR1 Register
   -- 18.5.11 T32INTCLR2 Register

   type T32INTCLRx_Type is record
      INTCLR : Bits_32; -- Any write to the T32INTCLRx register clears the interrupt output from the counter.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for T32INTCLRx_Type use record
      INTCLR at 0 range 0 .. 31;
   end record;

   -- 18.5.5 T32RIS1 Register
   -- 18.5.12 T32RIS2 Register

   type T32RISx_Type is record
      RAW_IFG  : Boolean; -- Raw interrupt status from the counter
      Reserved : Bits_31;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for T32RISx_Type use record
      RAW_IFG  at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   -- 18.5.6 T32MIS1 Register
   -- 18.5.13 T32MIS2 Register

   type T32MISx_Type is record
      IFG      : Boolean; -- Enabled interrupt status from the counter
      Reserved : Bits_31;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for T32MISx_Type use record
      IFG      at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   -- 18.5.7 T32BGLOAD1 Register
   -- 18.5.14 T32BGLOAD2 Register

   type T32BGLOADx_Type is record
      BGLOAD : Unsigned_32 := 0; -- Contains the value from which the counter decrements
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for T32BGLOADx_Type use record
      BGLOAD at 0 range 0 .. 31;
   end record;

   -- Table 18-1. Timer32 Registers

   Timer32_BASEADDRESS : constant := 16#4000_C000#;

   T32LOAD1 : aliased T32LOADx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32VALUE1 : aliased T32VALUEx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32CONTROL1 : aliased T32CONTROLx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#08#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32INTCLR1 : aliased T32INTCLRx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32RIS1 : aliased T32RISx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#10#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32MIS1 : aliased T32MISx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#14#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32BGLOAD1 : aliased T32BGLOADx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#18#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32LOAD2 : aliased T32LOADx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#20#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32VALUE2 : aliased T32VALUEx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#24#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32CONTROL2 : aliased T32CONTROLx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#28#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32INTCLR2 : aliased T32INTCLRx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#2C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32RIS2 : aliased T32RISx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#30#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32MIS2 : aliased T32MISx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#34#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   T32BGLOAD2 : aliased T32BGLOADx_Type
      with Address              => System'To_Address (Timer32_BASEADDRESS + 16#38#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 19 Timer_A
   ----------------------------------------------------------------------------

   -- 19.3.1 TAxCTL Register

   MC_STOP : constant := 2#00#; -- Stop mode: Timer is halted
   MC_UP   : constant := 2#01#; -- Up mode: Timer counts up to TAxCCR0
   MC_CONT : constant := 2#10#; -- Continuous mode: Timer counts up to 0FFFFh
   MC_UPDN : constant := 2#11#; -- Up/down mode: Timer counts up to TAxCCR0 then down to 0000h

   ID_DIV1 : constant := 2#00#; -- /1
   ID_DIV2 : constant := 2#01#; -- /2
   ID_DIV4 : constant := 2#10#; -- /4
   ID_DIV8 : constant := 2#11#; -- /8

   TASSEL_TAxCLK : constant := 2#00#; -- TAxCLK
   TASSEL_ACLK   : constant := 2#01#; -- ACLK
   TASSEL_SMCLK  : constant := 2#10#; -- SMCLK
   TASSEL_INCLK  : constant := 2#11#; -- INCLK

   type TAxCTL_Type is record
      TAIFG     : Boolean := False;         -- Timer_A interrupt flag
      TAIE      : Boolean := False;         -- Timer_A interrupt enable.
      TACLR     : Boolean := False;         -- Timer_A clear.
      Reserved1 : Bits_1  := 0;
      MC        : Bits_2  := MC_STOP;       -- Mode control.
      ID        : Bits_2  := ID_DIV1;       -- Input divider.
      TASSEL    : Bits_2  := TASSEL_TAxCLK; -- Timer_A clock source select
      Reserved2 : Bits_6  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for TAxCTL_Type use record
      TAIFG     at 0 range  0 ..  0;
      TAIE      at 0 range  1 ..  1;
      TACLR     at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  3;
      MC        at 0 range  4 ..  5;
      ID        at 0 range  6 ..  7;
      TASSEL    at 0 range  8 ..  9;
      Reserved2 at 0 range 10 .. 15;
   end record;

   -- 19.3.2 TAxR Register

   type TAxR_Type is record
      TAxR : Unsigned_16; -- Timer_A register.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for TAxR_Type use record
      TAxR at 0 range 0 .. 15;
   end record;

   -- 19.3.3 TAxCCTL0 to TAxCCTL6 Register

   -- __INF__ use "OU7" instead of "OUT"
   OU7_LOW  : constant := 0; -- Output low
   OU7_HIGH : constant := 1; -- Output high

   OUTMOD_OUT    : constant := 2#000#; -- OUT bit value
   OUTMOD_SET    : constant := 2#001#; -- Set
   OUTMOD_TGLRST : constant := 2#010#; -- Toggle/reset
   OUTMOD_SETRST : constant := 2#011#; -- Set/reset
   OUTMOD_TGL    : constant := 2#100#; -- Toggle
   OUTMOD_RST    : constant := 2#101#; -- Reset
   OUTMOD_TGLSET : constant := 2#110#; -- Toggle/set
   OUTMOD_RSTSET : constant := 2#111#; -- Reset/set

   CAP_COMPARE : constant := 0; -- Compare mode
   CAP_CAPTURE : constant := 1; -- Capture mode

   SCS_ASYNC : constant := 0; -- Asynchronous capture
   SCS_SYNC  : constant := 1; -- Synchronous capture

   CCIS_CCIxA : constant := 2#00#; -- CCIxA
   CCIS_CCIxB : constant := 2#01#; -- CCIxB
   CCIS_GND   : constant := 2#10#; -- GND
   CCIS_VCC   : constant := 2#11#; -- VCC

   CM_NONE     : constant := 2#00#; -- No capture
   CM_RISEDGE  : constant := 2#01#; -- Capture on rising edge
   CM_FALLEDGE : constant := 2#10#; -- Capture on falling edge
   CM_BOTHEDGE : constant := 2#11#; -- Capture on both rising and falling edges

   -- __INF__ use "OU7" instead of "OUT"
   type TAxCCTL_Type is record
      CCIFG    : Boolean := False;       -- Capture/compare interrupt flag
      COV      : Boolean := False;       -- Capture overflow.
      OU7      : Bits_1  := OU7_LOW;     -- Output.
      CCI      : Bits_1  := 0;           -- Capture/compare input.
      CCIE     : Boolean := False;       -- Capture/compare interrupt enable.
      OUTMOD   : Bits_3  := OUTMOD_OUT;  -- Output mode.
      CAP      : Bits_1  := CAP_COMPARE; -- Capture mode
      Reserved : Bits_1  := 0;
      SCCI     : Bits_1  := 0;           -- Synchronized capture/compare input.
      SCS      : Bits_1  := SCS_ASYNC;   -- Synchronize capture source.
      CCIS     : Bits_2  := CCIS_CCIxA;  -- Capture/compare input select.
      CM       : Bits_2  := CM_NONE;     -- Capture mode
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for TAxCCTL_Type use record
      CCIFG    at 0 range  0 ..  0;
      COV      at 0 range  1 ..  1;
      OU7      at 0 range  2 ..  2;
      CCI      at 0 range  3 ..  3;
      CCIE     at 0 range  4 ..  4;
      OUTMOD   at 0 range  5 ..  7;
      CAP      at 0 range  8 ..  8;
      Reserved at 0 range  9 ..  9;
      SCCI     at 0 range 10 .. 10;
      SCS      at 0 range 11 .. 11;
      CCIS     at 0 range 12 .. 13;
      CM       at 0 range 14 .. 15;
   end record;

   -- 19.3.4 TAxCCR0 to TAxCCR6 Register

   type TAxCCR_Type is record
      TAxCCR : Unsigned_16; -- Compare mode: TAxCCRn holds the data for the comparison to the timer value in the Timer_A Register, TAxR. Capture mode: The Timer_A Register, TAxR, is copied into the TAxCCRn register when a capture is performed.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for TAxCCR_Type use record
      TAxCCR at 0 range 0 .. 15;
   end record;

   -- 19.3.5 TAxIV Register

   TAIV_NONE          : constant := 16#00#; -- No interrupt pending
   TAIV_TAxCCR1_CCIFG : constant := 16#02#; -- Interrupt Source: Capture/compare 1; Interrupt Flag: TAxCCR1 CCIFG; Interrupt Priority: Highest
   TAIV_TAxCCR2_CCIFG : constant := 16#04#; -- Interrupt Source: Capture/compare 2; Interrupt Flag: TAxCCR2 CCIFG
   TAIV_TAxCCR3_CCIFG : constant := 16#06#; -- Interrupt Source: Capture/compare 3; Interrupt Flag: TAxCCR3 CCIFG
   TAIV_TAxCCR4_CCIFG : constant := 16#08#; -- Interrupt Source: Capture/compare 4; Interrupt Flag: TAxCCR4 CCIFG
   TAIV_TAxCCR5_CCIFG : constant := 16#0A#; -- Interrupt Source: Capture/compare 5; Interrupt Flag: TAxCCR5 CCIFG
   TAIV_TAxCCR6_CCIFG : constant := 16#0C#; -- Interrupt Source: Capture/compare 6; Interrupt Flag: TAxCCR6 CCIFG
   TAIV_TAxCTL_TAIFG  : constant := 16#0E#; -- Interrupt Source: Timer overflow; Interrupt Flag: TAxCTL TAIFG; Interrupt Priority: Lowest

   type TAxIV_Type is record
      TAIV : Unsigned_16; -- Timer_A interrupt vector value
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for TAxIV_Type use record
      TAIV at 0 range 0 .. 15;
   end record;

   -- 19.3.6 TAxEX0 Register

   TAIDEX_DIV1 : constant := 2#000#; -- Divide by 1
   TAIDEX_DIV2 : constant := 2#001#; -- Divide by 2
   TAIDEX_DIV3 : constant := 2#010#; -- Divide by 3
   TAIDEX_DIV4 : constant := 2#011#; -- Divide by 4
   TAIDEX_DIV5 : constant := 2#100#; -- Divide by 5
   TAIDEX_DIV6 : constant := 2#101#; -- Divide by 6
   TAIDEX_DIV7 : constant := 2#110#; -- Divide by 7
   TAIDEX_DIV8 : constant := 2#111#; -- Divide by 8

   type TAxEX0_Type is record
      TAIDEX   : Bits_3  := TAIDEX_DIV1; -- Input divider expansion.
      Reserved : Bits_13 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for TAxEX0_Type use record
      TAIDEX   at 0 range 0 ..  2;
      Reserved at 0 range 3 .. 15;
   end record;

   -- 19.3 Timer_A Registers

   type Timer_A_Type is record
      TAxCTL   : TAxCTL_Type  with Volatile_Full_Access => True;
      TAxCCTL0 : TAxCCTL_Type with Volatile_Full_Access => True;
      TAxCCTL1 : TAxCCTL_Type with Volatile_Full_Access => True;
      TAxCCTL2 : TAxCCTL_Type with Volatile_Full_Access => True;
      TAxCCTL3 : TAxCCTL_Type with Volatile_Full_Access => True;
      TAxCCTL4 : TAxCCTL_Type with Volatile_Full_Access => True;
      TAxCCTL5 : TAxCCTL_Type with Volatile_Full_Access => True;
      TAxCCTL6 : TAxCCTL_Type with Volatile_Full_Access => True;
      TAxR     : TAxR_Type    with Volatile_Full_Access => True;
      TAxCCR0  : TAxCCR_Type  with Volatile_Full_Access => True;
      TAxCCR1  : TAxCCR_Type  with Volatile_Full_Access => True;
      TAxCCR2  : TAxCCR_Type  with Volatile_Full_Access => True;
      TAxCCR3  : TAxCCR_Type  with Volatile_Full_Access => True;
      TAxCCR4  : TAxCCR_Type  with Volatile_Full_Access => True;
      TAxCCR5  : TAxCCR_Type  with Volatile_Full_Access => True;
      TAxCCR6  : TAxCCR_Type  with Volatile_Full_Access => True;
      TAxEX0   : TAxEX0_Type  with Volatile_Full_Access => True;
      TAxIV    : TAxIV_Type   with Volatile_Full_Access => True;
   end record
      with Object_Size => 16#30# * 8;
   for Timer_A_Type use record
      TAxCTL   at 16#00# range 0 .. 15;
      TAxCCTL0 at 16#02# range 0 .. 15;
      TAxCCTL1 at 16#04# range 0 .. 15;
      TAxCCTL2 at 16#06# range 0 .. 15;
      TAxCCTL3 at 16#08# range 0 .. 15;
      TAxCCTL4 at 16#0A# range 0 .. 15;
      TAxCCTL5 at 16#0C# range 0 .. 15;
      TAxCCTL6 at 16#0E# range 0 .. 15;
      TAxR     at 16#10# range 0 .. 15;
      TAxCCR0  at 16#12# range 0 .. 15;
      TAxCCR1  at 16#14# range 0 .. 15;
      TAxCCR2  at 16#16# range 0 .. 15;
      TAxCCR3  at 16#18# range 0 .. 15;
      TAxCCR4  at 16#1A# range 0 .. 15;
      TAxCCR5  at 16#1C# range 0 .. 15;
      TAxCCR6  at 16#1E# range 0 .. 15;
      TAxEX0   at 16#20# range 0 .. 15;
      TAxIV    at 16#2E# range 0 .. 15;
   end record;

   -- Table 6-2. Timer_A0 Registers

   Timer_A0_BASEADDRESS : constant := 16#4000_0000#;

   Timer_A0 : aliased Timer_A_Type
      with Address    => System'To_Address (Timer_A0_BASEADDRESS + 16#0C#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 20 Real-Time Clock (RTC_C)
   ----------------------------------------------------------------------------

   -- 20.3.1 RTCCTL0_L Register

   type RTCCTL0_L_Type is record
      RTCRDYIFG : Boolean := False; -- Real-time clock ready interrupt flag
      RTCAIFG   : Boolean := False; -- Real-time clock alarm interrupt flag.
      RTCTEVIFG : Boolean := False; -- Real-time clock time event interrupt flag.
      RTCOFIFG  : Boolean := True;  -- 32-kHz crystal oscillator fault interrupt flag.
      RTCRDYIE  : Boolean := False; -- Real-time clock ready interrupt enable
      RTCAIE    : Boolean := False; -- Real-time clock alarm interrupt enable.
      RTCTEVIE  : Boolean := False; -- Real-time clock time event interrupt enable.
      RTCOFIE   : Boolean := False; -- 32-kHz crystal oscillator fault interrupt enable.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCCTL0_L_Type use record
      RTCRDYIFG at 0 range 0 .. 0;
      RTCAIFG   at 0 range 1 .. 1;
      RTCTEVIFG at 0 range 2 .. 2;
      RTCOFIFG  at 0 range 3 .. 3;
      RTCRDYIE  at 0 range 4 .. 4;
      RTCAIE    at 0 range 5 .. 5;
      RTCTEVIE  at 0 range 6 .. 6;
      RTCOFIE   at 0 range 7 .. 7;
   end record;

   -- 20.3.2 RTCCTL0_H Register

   RTCKEY_KEY : constant := 16#A5#;

   type RTCCTL0_H_Type is record
      RTCKEY : Bits_8 := 16#96#; -- Real-time clock key.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCCTL0_H_Type use record
      RTCKEY at 0 range 0 .. 7;
   end record;

   -- 20.3.3 RTCCTL1 Register

   RTCTEVx_MIN      : constant := 2#00#; -- Minute changed
   RTCTEVx_HOUR     : constant := 2#01#; -- Hour changed
   RTCTEVx_MIDNIGHT : constant := 2#10#; -- Every day at midnight (00:00)
   RTCTEVx_NOON     : constant := 2#11#; -- Every day at noon (12:00)

   RTCSSELx_BCLK  : constant := 2#00#; -- BCLK
   RTCSSELx_RSVD1 : constant := 2#01#; -- Reserved. Defaults to BCLK.
   RTCSSELx_RSVD2 : constant := 2#10#; -- Reserved. Defaults to BCLK.
   RTCSSELx_RSVD3 : constant := 2#11#; -- Reserved. Defaults to BCLK

   RTCMODE_RSVD     : constant := 0; -- Reserved
   RTCMODE_CALENDAR : constant := 1; -- Calendar mode.

   RTCBCD_BIN : constant := 0; -- Binary (hexadecimal) code selected
   RTCBCD_BCD : constant := 1; -- Binary coded decimal (BCD) code selected

   type RTCCTL1_Type is record
      RTCTEVx  : Bits_2  := RTCTEVx_MIN;      -- Real-time clock time event
      RTCSSELx : Bits_2  := RTCSSELx_BCLK;    -- Real-time clock source select.
      RTCRDY   : Boolean := True;             -- Real-time clock ready
      RTCMODE  : Bits_1  := RTCMODE_CALENDAR; -- Real-time clock mode.
      RTCHOLD  : Boolean := True;             -- Real-time clock hold
      RTCBCD   : Bits_1  := RTCBCD_BIN;       -- Real-time clock BCD select.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCCTL1_Type use record
      RTCTEVx  at 0 range 0 .. 1;
      RTCSSELx at 0 range 2 .. 3;
      RTCRDY   at 0 range 4 .. 4;
      RTCMODE  at 0 range 5 .. 5;
      RTCHOLD  at 0 range 6 .. 6;
      RTCBCD   at 0 range 7 .. 7;
   end record;

   -- 20.3.4 RTCCTL3 Register

   RTCCALFx_NONE : constant := 2#00#; -- No frequency output to RTCCLK pin
   RTCCALFx_512  : constant := 2#01#; -- 512 Hz
   RTCCALFx_256  : constant := 2#10#; -- 256 Hz
   RTCCALFx_1    : constant := 2#11#; -- 1 Hz

   type RTCCTL3_Type is record
      RTCCALFx : Bits_2 := RTCCALFx_NONE; -- Real-time clock calibration frequency.
      Reserved : Bits_6 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCCTL3_Type use record
      RTCCALFx at 0 range 0 .. 1;
      Reserved at 0 range 2 .. 7;
   end record;

   -- 20.3.5 RTCOCAL Register

   RTCOCALS_DOWN : constant := 0; -- Down calibration.
   RTCOCALS_UP   : constant := 1; -- Up calibration.

   type RTCOCAL_Type is record
      RTCOCALx : Unsigned_8 := 0;             -- Real-time clock offset error calibration.
      Reserved : Bits_7     := 0;
      RTCOCALS : Bits_1     := RTCOCALS_DOWN; -- Real-time clock offset error calibration sign.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for RTCOCAL_Type use record
      RTCOCALx at 0 range  0 ..  7;
      Reserved at 0 range  8 .. 14;
      RTCOCALS at 0 range 15 .. 15;
   end record;

   -- 20.3.6 RTCTCMP Register

   RTCTCMPS_DOWN : constant := 0; -- Down calibration.
   RTCTCMPS_UP   : constant := 1; -- Up calibration.

   type RTCTCMP_Type is record
      RTCTCMPx : Unsigned_8 := 0;             -- Real-time clock temperature compensation.
      Reserved : Bits_5     := 0;
      RTCTCOK  : Boolean    := False;         -- Real-time clock temperature compensation write OK.
      RTCTCRDY : Boolean    := True;          -- Real-time clock temperature compensation ready.
      RTCTCMPS : Bits_1     := RTCTCMPS_DOWN; -- Real-time clock temperature compensation sign.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for RTCTCMP_Type use record
      RTCTCMPx at 0 range  0 ..  7;
      Reserved at 0 range  8 .. 12;
      RTCTCOK  at 0 range 13 .. 13;
      RTCTCRDY at 0 range 14 .. 14;
      RTCTCMPS at 0 range 15 .. 15;
   end record;

   -- 20.3.7 RTCSEC Register – Hexadecimal Format

   type RTCSEC_HEX_Type is record
      Seconds  : Bits_6;      -- Seconds (0 to 59)
      Reserved : Bits_2 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCSEC_HEX_Type use record
      Seconds  at 0 range 0 .. 5;
      Reserved at 0 range 6 .. 7;
   end record;

   -- 20.3.8 RTCSEC Register – BCD Format

   type RTCSEC_BCD_Type is record
      Seconds_LO : Bits_4;      -- Seconds – low digit (0 to 9)
      Seconds_HI : Bits_3;      -- Seconds – high digit (0 to 5)
      Reserved   : Bits_1 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCSEC_BCD_Type use record
      Seconds_LO at 0 range 0 .. 3;
      Seconds_HI at 0 range 4 .. 6;
      Reserved   at 0 range 7 .. 7;
   end record;

   -- 20.3.9 RTCMIN Register – Hexadecimal Format

   type RTCMIN_HEX_Type is record
      Minutes  : Bits_6;      -- Minutes (0 to 59)
      Reserved : Bits_2 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCMIN_HEX_Type use record
      Minutes  at 0 range 0 .. 5;
      Reserved at 0 range 6 .. 7;
   end record;

   -- 20.3.10 RTCMIN Register – BCD Format

   type RTCMIN_BCD_Type is record
      Minutes_LO : Bits_4;      -- Minutes – low digit (0 to 9)
      Minutes_HI : Bits_3;      -- Minutes – high digit (0 to 5)
      Reserved   : Bits_1 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCMIN_BCD_Type use record
      Minutes_LO at 0 range 0 .. 3;
      Minutes_HI at 0 range 4 .. 6;
      Reserved   at 0 range 7 .. 7;
   end record;

   -- 20.3.11 RTCHOUR Register – Hexadecimal Format

   type RTCHOUR_HEX_Type is record
      Hours    : Bits_5;      -- Hours (0 to 23)
      Reserved : Bits_3 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCHOUR_HEX_Type use record
      Hours    at 0 range 0 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   -- 20.3.12 RTCHOUR Register – BCD Format

   type RTCHOUR_BCD_Type is record
      Hours_LO : Bits_4;      -- Hours – low digit (0 to 9)
      Hours_HI : Bits_2;      -- Hours – high digit (0 to 2)
      Reserved : Bits_2 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCHOUR_BCD_Type use record
      Hours_LO at 0 range 0 .. 3;
      Hours_HI at 0 range 4 .. 5;
      Reserved at 0 range 6 .. 7;
   end record;

   -- 20.3.13 RTCDOW Register

   type RTCDOW_Type is record
      Day_of_week : Bits_3;      -- Day of week (0 to 6)
      Reserved    : Bits_5 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCDOW_Type use record
      Day_of_week at 0 range 0 .. 2;
      Reserved    at 0 range 3 .. 7;
   end record;

   -- 20.3.14 RTCDAY Register – Hexadecimal Format

   type RTCDAY_HEX_Type is record
      Day_of_month : Bits_5;      -- Day of month (1 to 28, 29, 30, 31)
      Reserved     : Bits_3 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCDAY_HEX_Type use record
      Day_of_month at 0 range 0 .. 4;
      Reserved     at 0 range 5 .. 7;
   end record;

   -- 20.3.15 RTCDAY Register – BCD Format

   type RTCDAY_BCD_Type is record
      Day_of_month_LO : Bits_4;      -- Day of month – low digit (0 to 9)
      Day_of_month_HI : Bits_2;      -- Day of month – high digit (0 to 3)
      Reserved        : Bits_2 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCDAY_BCD_Type use record
      Day_of_month_LO at 0 range 0 .. 3;
      Day_of_month_HI at 0 range 4 .. 5;
      Reserved        at 0 range 6 .. 7;
   end record;

   -- 20.3.16 RTCMON Register – Hexadecimal Format

   type RTCMON_HEX_Type is record
      Month    : Bits_4;      -- Month (1 to 12)
      Reserved : Bits_4 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCMON_HEX_Type use record
      Month    at 0 range 0 .. 3;
      Reserved at 0 range 4 .. 7;
   end record;

   -- 20.3.17 RTCMON Register – BCD Format

   type RTCMON_BCD_Type is record
      Month_LO : Bits_4;      -- Month – low digit (0 to 9)
      Month_HI : Bits_1;      -- Month – high digit (0 or 1)
      Reserved : Bits_3 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCMON_BCD_Type use record
      Month_LO at 0 range 0 .. 3;
      Month_HI at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   -- 20.3.18 RTCYEAR Register – Hexadecimal Format

   type RTCYEAR_HEX_Type is record
      Year_LO  : Bits_8;      -- Year – low byte.
      Year_HI  : Bits_4;      -- Year – high byte.
      Reserved : Bits_4 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for RTCYEAR_HEX_Type use record
      Year_LO  at 0 range  0 ..  7;
      Year_HI  at 0 range  8 .. 11;
      Reserved at 0 range 12 .. 15;
   end record;

   -- 20.3.19 RTCYEAR Register – BCD Format

   type RTCYEAR_BCD_Type is record
      Year       : Bits_4;      -- Year – lowest digit (0 to 9)
      Decade     : Bits_4;      -- Decade (0 to 9)
      Century_LO : Bits_4;      -- Century – low digit (0 to 9)
      Century_HI : Bits_3;      -- Century – high digit (0 to 4)
      Reserved   : Bits_1 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for RTCYEAR_BCD_Type use record
      Year       at 0 range  0 ..  3;
      Decade     at 0 range  4 ..  7;
      Century_LO at 0 range  8 .. 11;
      Century_HI at 0 range 12 .. 14;
      Reserved   at 0 range 15 .. 15;
   end record;

   -- 20.3.20 RTCAMIN Register – Hexadecimal Format

   type RTCAMIN_HEX_Type is record
      Minutes  : Bits_6;           -- Minutes (0 to 59)
      Reserved : Bits_1  := 0;
      AE       : Boolean := False; -- Alarm enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCAMIN_HEX_Type use record
      Minutes  at 0 range 0 .. 5;
      Reserved at 0 range 6 .. 6;
      AE       at 0 range 7 .. 7;
   end record;

   -- 20.3.21 RTCAMIN Register – BCD Format

   type RTCAMIN_BCD_Type is record
      Minutes_LO : Bits_4;           -- Minutes – low digit (0 to 9)
      Minutes_HI : Bits_3;           -- Minutes – high digit (0 to 5)
      AE         : Boolean := False; -- Alarm enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCAMIN_BCD_Type use record
      Minutes_LO at 0 range 0 .. 3;
      Minutes_HI at 0 range 4 .. 6;
      AE         at 0 range 7 .. 7;
   end record;

   -- 20.3.22 RTCAHOUR Register – Hexadecimal Format

   type RTCAHOUR_HEX_Type is record
      Hours    : Bits_5;           -- Hours (0 to 23)
      Reserved : Bits_2 := 0;
      AE       : Boolean := False; -- Alarm enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCAHOUR_HEX_Type use record
      Hours    at 0 range 0 .. 4;
      Reserved at 0 range 5 .. 6;
      AE       at 0 range 7 .. 7;
   end record;

   -- 20.3.23 RTCAHOUR Register – BCD Format

   type RTCAHOUR_BCD_Type is record
      Hours_LO : Bits_4;           -- Hours – low digit (0 to 9)
      Hours_HI : Bits_2;           -- Hours – high digit (0 to 2)
      Reserved : Bits_1  := 0;
      AE       : Boolean := False; -- Alarm enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCAHOUR_BCD_Type use record
      Hours_LO at 0 range 0 .. 3;
      Hours_HI at 0 range 4 .. 5;
      Reserved at 0 range 6 .. 6;
      AE       at 0 range 7 .. 7;
   end record;

   -- 20.3.24 RTCADOW Register – Calendar Mode

   type RTCADOW_Type is record
      Day_of_week : Bits_3;           -- Day of week (0 to 6)
      Reserved    : Bits_4  := 0;
      AE          : Boolean := False; -- Alarm enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCADOW_Type use record
      Day_of_week at 0 range 0 .. 2;
      Reserved    at 0 range 3 .. 6;
      AE          at 0 range 7 .. 7;
   end record;

   -- 20.3.25 RTCADAY Register – Hexadecimal Format

   type RTCADAY_HEX_Type is record
      Day_of_month : Bits_5;           -- Day of month (1 to 28, 29, 30, 31)
      Reserved     : Bits_2  := 0;
      AE           : Boolean := False; -- Alarm enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCADAY_HEX_Type use record
      Day_of_month at 0 range 0 .. 4;
      Reserved     at 0 range 5 .. 6;
      AE           at 0 range 7 .. 7;
   end record;

   -- 20.3.26 RTCADAY Register – BCD Format

   type RTCADAY_BCD_Type is record
      Day_of_month_LO : Bits_4;           -- Day of month – low digit (0 to 9)
      Day_of_month_HI : Bits_2;           -- Day of month – high digit (0 to 3)
      Reserved        : Bits_1  := 0;
      AE              : Boolean := False; -- Alarm enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCADAY_BCD_Type use record
      Day_of_month_LO at 0 range 0 .. 3;
      Day_of_month_HI at 0 range 4 .. 5;
      Reserved        at 0 range 6 .. 6;
      AE              at 0 range 7 .. 7;
   end record;

   -- 20.3.27 RTCPS0CTL Register
   -- 20.3.28 RTCPS1CTL Register

   RTxIP_DIV2   : constant := 2#000#; -- Divide by 2
   RTxIP_DIV4   : constant := 2#001#; -- Divide by 4
   RTxIP_DIV8   : constant := 2#010#; -- Divide by 8
   RTxIP_DIV16  : constant := 2#011#; -- Divide by 16
   RTxIP_DIV32  : constant := 2#100#; -- Divide by 32
   RTxIP_DIV64  : constant := 2#101#; -- Divide by 64
   RTxIP_DIV128 : constant := 2#110#; -- Divide by 128
   RTxIP_DIV256 : constant := 2#111#; -- Divide by 256

   type RTCPS0CTL_Type is record
      RT0PSIFG : Boolean := False;      -- Prescale timer 0 interrupt flag.
      RT0PSIE  : Boolean := False;      -- Prescale timer 0 interrupt enable
      RT0IP    : Bits_3  := RTxIP_DIV2; -- Prescale timer 0 interrupt interval
      Reserved : Bits_11 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for RTCPS0CTL_Type use record
      RT0PSIFG at 0 range 0 ..  0;
      RT0PSIE  at 0 range 1 ..  1;
      RT0IP    at 0 range 2 ..  4;
      Reserved at 0 range 5 .. 15;
   end record;

   type RTCPS1CTL_Type is record
      RT1PSIFG : Boolean := False;      -- Prescale timer 1 interrupt flag.
      RT1PSIE  : Boolean := False;      -- Prescale timer 1 interrupt enable
      RT1IPx   : Bits_3  := RTxIP_DIV2; -- Prescale timer 1 interrupt interval
      Reserved : Bits_11 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for RTCPS1CTL_Type use record
      RT1PSIFG at 0 range 0 ..  0;
      RT1PSIE  at 0 range 1 ..  1;
      RT1IPx   at 0 range 2 ..  4;
      Reserved at 0 range 5 .. 15;
   end record;

   -- 20.3.29 RTCPS0 Register

   type RTCPS0_Type is record
      RT0PS : Unsigned_8 := 0; -- Prescale timer 0 counter value
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCPS0_Type use record
      RT0PS at 0 range 0 .. 7;
   end record;

   -- 20.3.30 RTCPS1 Register

   type RTCPS1_Type is record
      RT1PS : Unsigned_8 := 0; -- Prescale timer 1 counter value
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RTCPS1_Type use record
      RT1PS at 0 range 0 .. 7;
   end record;

   -- 20.3.31 RTCIV Register

   RTCIVx_NONE      : constant := 16#00#; -- No interrupt pending
   RTCIVx_RTCOFIFG  : constant := 16#02#; -- Interrupt Source: RTC oscillator failure; Interrupt Flag: RTCOFIFG; Interrupt Priority: Highest
   RTCIVx_RTCRDYIFG : constant := 16#04#; -- Interrupt Source: RTC ready; Interrupt Flag: RTCRDYIFG
   RTCIVx_RTCTEVIFG : constant := 16#06#; -- Interrupt Source: RTC interval timer; Interrupt Flag: RTCTEVIFG
   RTCIVx_RTCAIFG   : constant := 16#08#; -- Interrupt Source: RTC user alarm; Interrupt Flag: RTCAIFG
   RTCIVx_RT0PSIFG  : constant := 16#0A#; -- Interrupt Source: RTC prescaler 0; Interrupt Flag: RT0PSIFG
   RTCIVx_RT1PSIFG  : constant := 16#0C#; -- Interrupt Source: RTC prescaler 1; Interrupt Flag: RT1PSIFG
   RTCIVx_RSVD      : constant := 16#0E#; -- Reserved
   RTCIVx_RSVD_IPL  : constant := 16#10#; -- Reserved ; Interrupt Priority: Lowest

   type RTCIV_Type is record
      RTCIVx : Bits_16; -- Real-time clock interrupt vector value
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for RTCIV_Type use record
      RTCIVx at 0 range 0 .. 15;
   end record;

   -- 20.3.32 RTCBIN2BCD Register

   type RTCBIN2BCD_Type is record
      BIN2BCDx : Unsigned_16; -- Read: 16-bit BCD conversion of previously written 12-bit binary number. Write: 12-bit binary number to be converted.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for RTCBIN2BCD_Type use record
      BIN2BCDx at 0 range 0 .. 15;
   end record;

   -- 20.3.33 RTCBCD2BIN Register

   type RTCBCD2BIN_Type is record
      BCD2BINx : Unsigned_16; -- Read: 12-bit binary conversion of previously written 16-bit BCD number. Write: 16-bit BCD number to be converted.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for RTCBCD2BIN_Type use record
      BCD2BINx at 0 range 0 .. 15;
   end record;

   -- Table 20-1. RTC_C Registers

   RTC_BASEADDRESS : constant := 16#4000_4400#;

   RTCCTL0_L : aliased RTCCTL0_L_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCCTL0_H : aliased RTCCTL0_H_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#01#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCCTL1 : aliased RTCCTL1_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#02#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCCTL3 : aliased RTCCTL3_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#03#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCOCAL : aliased RTCOCAL_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCTCMP : aliased RTCTCMP_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#06#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCSEC_HEX : aliased RTCSEC_HEX_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#10#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCSEC_BCD : aliased RTCSEC_BCD_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#10#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCMIN_HEX : aliased RTCMIN_HEX_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#11#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCMIN_BCD : aliased RTCMIN_BCD_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#11#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCHOUR_HEX : aliased RTCHOUR_HEX_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#12#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCHOUR_BCD : aliased RTCHOUR_BCD_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#12#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCDOW : aliased RTCDOW_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#13#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCDAY_HEX : aliased RTCDAY_HEX_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#14#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCDAY_BCD : aliased RTCDAY_BCD_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#14#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCMON_HEX : aliased RTCMON_HEX_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#15#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCMON_BCD : aliased RTCMON_BCD_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#15#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCYEAR_HEX : aliased RTCYEAR_HEX_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#16#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCYEAR_BCD : aliased RTCYEAR_BCD_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#16#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCAMIN_HEX : aliased RTCAMIN_HEX_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#18#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCAMIN_BCD : aliased RTCAMIN_BCD_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#18#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCAHOUR_HEX : aliased RTCAHOUR_HEX_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#19#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCAHOUR_BCD : aliased RTCAHOUR_BCD_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#19#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCADOW : aliased RTCADOW_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#1A#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCADAY_HEX : aliased RTCADAY_HEX_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#1B#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCADAY_BCD : aliased RTCADAY_BCD_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#1B#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCPS0CTL : aliased RTCPS0CTL_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#08#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCPS1CTL : aliased RTCPS1CTL_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#0A#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCPS0 : aliased RTCPS0_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCPS1 : aliased RTCPS1_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#0D#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCIV : aliased RTCIV_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#0E#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCBIN2BCD : aliased RTCBIN2BCD_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#1C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RTCBCD2BIN : aliased RTCBCD2BIN_Type
      with Address              => System'To_Address (RTC_BASEADDRESS + 16#1E#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 21 Reference Module (REF_A)
   ----------------------------------------------------------------------------

   -- 21.3.1 REFCTL0 Register

   REFVSEL_1V2  : constant := 2#00#; -- 1.2 V available when reference requested or REFON = 1
   REFVSEL_1V45 : constant := 2#01#; -- 1.45 V available when reference requested or REFON = 1
   REFVSEL_RSVD : constant := 2#10#; -- Reserved
   REFVSEL_2V5  : constant := 2#11#; -- 2.5 V available when reference requested or REFON = 1

   BGMODE_STATIC  : constant := 0; -- Static mode
   BGMODE_SAMPLED : constant := 1; -- Sampled mode

   type REFCTL0_Type is record
      REFON      : Boolean := False;         -- Reference enable.
      REFOUT     : Boolean := False;         -- Reference output buffer.
      Reserved1  : Bits_1  := 0;
      REFTCOFF   : Boolean := True;          -- Temperature sensor disabled.
      REFVSEL    : Bits_2  := REFVSEL_1V2;   -- Reference voltage level select.
      REFGENOT   : Boolean := False;         -- Reference generator one-time trigger.
      REFBGOT    : Boolean := False;         -- Bandgap and bandgap buffer one-time trigger.
      REFGENACT  : Boolean := False;         -- Reference generator active.
      REFBGACT   : Boolean := False;         -- Reference bandgap active.
      REFGENBUSY : Boolean := False;         -- Reference generator busy.
      BGMODE     : Bits_1  := BGMODE_STATIC; -- Bandgap mode.
      REFGENRDY  : Boolean := False;         -- Variable reference voltage ready status.
      REFBGRDY   : Boolean := False;         -- Buffered bandgap voltage ready status.
      Reserved2  : Bits_2  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for REFCTL0_Type use record
      REFON      at 0 range  0 ..  0;
      REFOUT     at 0 range  1 ..  1;
      Reserved1  at 0 range  2 ..  2;
      REFTCOFF   at 0 range  3 ..  3;
      REFVSEL    at 0 range  4 ..  5;
      REFGENOT   at 0 range  6 ..  6;
      REFBGOT    at 0 range  7 ..  7;
      REFGENACT  at 0 range  8 ..  8;
      REFBGACT   at 0 range  9 ..  9;
      REFGENBUSY at 0 range 10 .. 10;
      BGMODE     at 0 range 11 .. 11;
      REFGENRDY  at 0 range 12 .. 12;
      REFBGRDY   at 0 range 13 .. 13;
      Reserved2  at 0 range 14 .. 15;
   end record;

   -- 21.3 REF_A Registers

   REFCTL0_ADDRESS : constant := 16#4000_3000#;

   REFCTL0 : aliased REFCTL0_Type
      with Address              => System'To_Address (REFCTL0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 22 Precision ADC
   ----------------------------------------------------------------------------

   -- named constants to index ADC14MCTL and ADC14MEM arrays
   ADC14CH0  : constant := 0;
   ADC14CH1  : constant := 1;
   ADC14CH2  : constant := 2;
   ADC14CH3  : constant := 3;
   ADC14CH4  : constant := 4;
   ADC14CH5  : constant := 5;
   ADC14CH6  : constant := 6;
   ADC14CH7  : constant := 7;
   ADC14CH8  : constant := 8;
   ADC14CH9  : constant := 9;
   ADC14CH10 : constant := 10;
   ADC14CH11 : constant := 11;
   ADC14CH12 : constant := 12;
   ADC14CH13 : constant := 13;
   ADC14CH14 : constant := 14;
   ADC14CH15 : constant := 15;
   ADC14CH16 : constant := 16;
   ADC14CH17 : constant := 17;
   ADC14CH18 : constant := 18;
   ADC14CH19 : constant := 19;
   ADC14CH20 : constant := 20;
   ADC14CH21 : constant := 21;
   ADC14CH22 : constant := 22;
   ADC14CH23 : constant := 23;
   ADC14CH24 : constant := 24;
   ADC14CH25 : constant := 25;
   ADC14CH26 : constant := 26;
   ADC14CH27 : constant := 27;
   ADC14CH28 : constant := 28;
   ADC14CH29 : constant := 29;
   ADC14CH30 : constant := 30;
   ADC14CH31 : constant := 31;

   -- 22.3.1 ADC14CTL0 Register

   ADC14MSC_SHINOAUTO  : constant := 0; -- The sampling timer requires a rising edge of the SHI signal to trigger each sample-and-convert.
   ADC14MSC_SHI1STAUTO : constant := 1; -- The first rising edge of the SHI signal triggers the sampling timer, but further sample-and-conversions are performed automatically as soon as the prior conversion is completed.

   ADC14SHT0x_4     : constant :=2#0000#; -- 4
   ADC14SHT0x_8     : constant :=2#0001#; -- 8
   ADC14SHT0x_16    : constant :=2#0010#; -- 16
   ADC14SHT0x_32    : constant :=2#0011#; -- 32
   ADC14SHT0x_64    : constant :=2#0100#; -- 64
   ADC14SHT0x_96    : constant :=2#0101#; -- 96
   ADC14SHT0x_128   : constant :=2#0110#; -- 128
   ADC14SHT0x_192   : constant :=2#0111#; -- 192
   ADC14SHT0x_RSVD1 : constant :=2#1000#; -- Reserved
   ADC14SHT0x_RSVD2 : constant :=2#1001#; -- Reserved
   ADC14SHT0x_RSVD3 : constant :=2#1010#; -- Reserved
   ADC14SHT0x_RSVD4 : constant :=2#1011#; -- Reserved
   ADC14SHT0x_RSVD5 : constant :=2#1100#; -- Reserved
   ADC14SHT0x_RSVD6 : constant :=2#1101#; -- Reserved
   ADC14SHT0x_RSVD7 : constant :=2#1110#; -- Reserved
   ADC14SHT0x_RSVD8 : constant :=2#1111#; -- Reserved

   ADC14SHT1x_4     renames ADC14SHT0x_4;
   ADC14SHT1x_8     renames ADC14SHT0x_8;
   ADC14SHT1x_16    renames ADC14SHT0x_16;
   ADC14SHT1x_32    renames ADC14SHT0x_32;
   ADC14SHT1x_64    renames ADC14SHT0x_64;
   ADC14SHT1x_96    renames ADC14SHT0x_96;
   ADC14SHT1x_128   renames ADC14SHT0x_128;
   ADC14SHT1x_192   renames ADC14SHT0x_192;
   ADC14SHT1x_RSVD1 renames ADC14SHT0x_RSVD1;
   ADC14SHT1x_RSVD2 renames ADC14SHT0x_RSVD2;
   ADC14SHT1x_RSVD3 renames ADC14SHT0x_RSVD3;
   ADC14SHT1x_RSVD4 renames ADC14SHT0x_RSVD4;
   ADC14SHT1x_RSVD5 renames ADC14SHT0x_RSVD5;
   ADC14SHT1x_RSVD6 renames ADC14SHT0x_RSVD6;
   ADC14SHT1x_RSVD7 renames ADC14SHT0x_RSVD7;
   ADC14SHT1x_RSVD8 renames ADC14SHT0x_RSVD8;

   ADC14CONSEQx_SC       : constant := 2#00#; -- Single-channel, single-conversion
   ADC14CONSEQx_SEQCH    : constant := 2#01#; -- Sequence-of-channels
   ADC14CONSEQx_REPSC    : constant := 2#10#; -- Repeat-single-channel
   ADC14CONSEQx_REPSEQSC : constant := 2#11#; -- Repeat-sequence-of-channels

   ADC14SSELx_MODCLK : constant := 2#000#; -- MODCLK
   ADC14SSELx_SYSCLK : constant := 2#001#; -- SYSCLK
   ADC14SSELx_ACLK   : constant := 2#010#; -- ACLK
   ADC14SSELx_MCLK   : constant := 2#011#; -- MCLK
   ADC14SSELx_SMCLK  : constant := 2#100#; -- SMCLK
   ADC14SSELx_HSMCLK : constant := 2#101#; -- HSMCLK
   ADC14SSELx_RSVD1  : constant := 2#110#; -- Reserved
   ADC14SSELx_RSVD2  : constant := 2#111#; -- Reserved

   ADC14DIVx_DIV1 : constant := 2#000#; -- /1
   ADC14DIVx_DIV2 : constant := 2#001#; -- /2
   ADC14DIVx_DIV3 : constant := 2#010#; -- /3
   ADC14DIVx_DIV4 : constant := 2#011#; -- /4
   ADC14DIVx_DIV5 : constant := 2#100#; -- /5
   ADC14DIVx_DIV6 : constant := 2#101#; -- /6
   ADC14DIVx_DIV7 : constant := 2#110#; -- /7
   ADC14DIVx_DIV8 : constant := 2#111#; -- /8

   ADC14SHP_INPUT : constant := 0; -- SAMPCON signal is sourced from the sample-input signal.
   ADC14SHP_TIMER : constant := 1; -- SAMPCON signal is sourced from the sampling timer.

   ADC14SHSx_ADC14SC : constant := 2#000#; -- ADC14SC bit
   ADC14SHSx_TA0_C1  : constant := 2#001#; -- TA0_C1
   ADC14SHSx_TA0_C2  : constant := 2#010#; -- TA0_C2
   ADC14SHSx_TA1_C1  : constant := 2#011#; -- TA1_C1
   ADC14SHSx_TA1_C2  : constant := 2#100#; -- TA1_C2
   ADC14SHSx_TA2_C1  : constant := 2#101#; -- TA2_C1
   ADC14SHSx_TA2_C2  : constant := 2#110#; -- TA2_C2
   ADC14SHSx_TA3_C1  : constant := 2#111#; -- TA3_C1

   ADC14PDIV_DIV1  : constant := 2#00#; -- Predivide by 1
   ADC14PDIV_DIV4  : constant := 2#01#; -- Predivide by 4
   ADC14PDIV_DIV32 : constant := 2#10#; -- Predivide by 32
   ADC14PDIV_DIV64 : constant := 2#11#; -- Predivide by 64

   type ADC14CTL0_Type is record
      ADC14SC      : Boolean := False;              -- ADC14 start conversion.
      ADC14ENC     : Boolean := False;              -- ADC14 enable conversion
      Reserved1    : Bits_2  := 0;
      ADC14ON      : Boolean := False;              -- ADC14 on
      Reserved2    : Bits_2  := 0;
      ADC14MSC     : Bits_1  := ADC14MSC_SHINOAUTO; -- ADC14 multiple sample and conversion.
      ADC14SHT0x   : Bits_4  := ADC14SHT0x_4;       -- ADC14 sample-and-hold time for Pulse Sample Mode (ADC14SHP=1).
      ADC14SHT1x   : Bits_4  := ADC14SHT1x_4;       -- ADC14 sample-and-hold time for Pulse Sample Mode (ADC14SHP =1).
      ADC14BUSY    : Boolean := False;              -- ADC14 busy.
      ADC14CONSEQx : Bits_2  := ADC14CONSEQx_SC;    -- ADC14 conversion sequence mode select
      ADC14SSELx   : Bits_3  := ADC14SSELx_MODCLK;  -- ADC14 clock source select.
      ADC14DIVx    : Bits_3  := ADC14DIVx_DIV1;     -- ADC14 clock divider.
      ADC14ISSH    : Boolean := False;              -- ADC14 invert signal sample-and-hold.
      ADC14SHP     : Bits_1  := ADC14SHP_INPUT;     -- ADC14 sample-and-hold pulse-mode select.
      ADC14SHSx    : Bits_3  := ADC14SHSx_ADC14SC;  -- ADC14 sample-and-hold source select.
      ADC14PDIV    : Bits_2  := ADC14PDIV_DIV1;     -- ADC14 predivider.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14CTL0_Type use record
      ADC14SC      at 0 range  0 ..  0;
      ADC14ENC     at 0 range  1 ..  1;
      Reserved1    at 0 range  2 ..  3;
      ADC14ON      at 0 range  4 ..  4;
      Reserved2    at 0 range  5 ..  6;
      ADC14MSC     at 0 range  7 ..  7;
      ADC14SHT0x   at 0 range  8 .. 11;
      ADC14SHT1x   at 0 range 12 .. 15;
      ADC14BUSY    at 0 range 16 .. 16;
      ADC14CONSEQx at 0 range 17 .. 18;
      ADC14SSELx   at 0 range 19 .. 21;
      ADC14DIVx    at 0 range 22 .. 24;
      ADC14ISSH    at 0 range 25 .. 25;
      ADC14SHP     at 0 range 26 .. 26;
      ADC14SHSx    at 0 range 27 .. 29;
      ADC14PDIV    at 0 range 30 .. 31;
   end record;

   -- 22.3.2 ADC14CTL1 Register

   ADC14PWRMD_REGULAR : constant := 2#00#; -- Regular-power mode for use with any resolution setting.
   ADC14PWRMD_RSVD1   : constant := 2#01#; -- Reserved
   ADC14PWRMD_LOPOWER : constant := 2#10#; -- Low-power mode for 12-bit, 10-bit, and 8-bit resolution settings.
   ADC14PWRMD_RSVD2   : constant := 2#11#; -- Reserved

   ADC14REFBURST_CONTINUOUS : constant := 0; -- ADC reference buffer on continuously
   ADC14REFBURST_SAMPLECONV : constant := 1; -- ADC reference buffer on only during sample-and-conversion

   ADC14DF_UNSIGNED : constant := 0; -- Binary unsigned.
   ADC14DF_SIGNED2C : constant := 1; -- Signed binary (2s complement), left aligned.

   ADC14RES_8  : constant := 2#00#; -- 8 bit (9 clock cycle conversion time)
   ADC14RES_10 : constant := 2#01#; -- 10 bit (11 clock cycle conversion time)
   ADC14RES_12 : constant := 2#10#; -- 12 bit (14 clock cycle conversion time)
   ADC14RES_14 : constant := 2#11#; -- 14 bit (16 clock cycle conversion time)

   ADC14CSTARTADDx_ADC14MEM0  : constant := 2#00000#; -- ADC14MEM0
   ADC14CSTARTADDx_ADC14MEM1  : constant := 2#00001#; -- ADC14MEM1
   ADC14CSTARTADDx_ADC14MEM2  : constant := 2#00010#; -- ADC14MEM2
   ADC14CSTARTADDx_ADC14MEM3  : constant := 2#00011#; -- ADC14MEM3
   ADC14CSTARTADDx_ADC14MEM4  : constant := 2#00100#; -- ADC14MEM4
   ADC14CSTARTADDx_ADC14MEM5  : constant := 2#00101#; -- ADC14MEM5
   ADC14CSTARTADDx_ADC14MEM6  : constant := 2#00110#; -- ADC14MEM6
   ADC14CSTARTADDx_ADC14MEM7  : constant := 2#00111#; -- ADC14MEM7
   ADC14CSTARTADDx_ADC14MEM8  : constant := 2#01000#; -- ADC14MEM8
   ADC14CSTARTADDx_ADC14MEM9  : constant := 2#01001#; -- ADC14MEM9
   ADC14CSTARTADDx_ADC14MEM10 : constant := 2#01010#; -- ADC14MEM10
   ADC14CSTARTADDx_ADC14MEM11 : constant := 2#01011#; -- ADC14MEM11
   ADC14CSTARTADDx_ADC14MEM12 : constant := 2#01100#; -- ADC14MEM12
   ADC14CSTARTADDx_ADC14MEM13 : constant := 2#01101#; -- ADC14MEM13
   ADC14CSTARTADDx_ADC14MEM14 : constant := 2#01110#; -- ADC14MEM14
   ADC14CSTARTADDx_ADC14MEM15 : constant := 2#01111#; -- ADC14MEM15
   ADC14CSTARTADDx_ADC14MEM16 : constant := 2#10000#; -- ADC14MEM16
   ADC14CSTARTADDx_ADC14MEM17 : constant := 2#10001#; -- ADC14MEM17
   ADC14CSTARTADDx_ADC14MEM18 : constant := 2#10010#; -- ADC14MEM18
   ADC14CSTARTADDx_ADC14MEM19 : constant := 2#10011#; -- ADC14MEM19
   ADC14CSTARTADDx_ADC14MEM20 : constant := 2#10100#; -- ADC14MEM20
   ADC14CSTARTADDx_ADC14MEM21 : constant := 2#10101#; -- ADC14MEM21
   ADC14CSTARTADDx_ADC14MEM22 : constant := 2#10110#; -- ADC14MEM22
   ADC14CSTARTADDx_ADC14MEM23 : constant := 2#10111#; -- ADC14MEM23
   ADC14CSTARTADDx_ADC14MEM24 : constant := 2#11000#; -- ADC14MEM24
   ADC14CSTARTADDx_ADC14MEM25 : constant := 2#11001#; -- ADC14MEM25
   ADC14CSTARTADDx_ADC14MEM26 : constant := 2#11010#; -- ADC14MEM26
   ADC14CSTARTADDx_ADC14MEM27 : constant := 2#11011#; -- ADC14MEM27
   ADC14CSTARTADDx_ADC14MEM28 : constant := 2#11100#; -- ADC14MEM28
   ADC14CSTARTADDx_ADC14MEM29 : constant := 2#11101#; -- ADC14MEM29
   ADC14CSTARTADDx_ADC14MEM30 : constant := 2#11110#; -- ADC14MEM30
   ADC14CSTARTADDx_ADC14MEM31 : constant := 2#11111#; -- ADC14MEM31

   ADC14BATMAP_NOBAT : constant := 0; -- ADC internal 1/2 x AVCC channel is not selected for ADC
   ADC14BATMAP_BAT   : constant := 1; -- ADC internal 1/2 x AVCC channel is selected for ADC input channel MAX

   ADC14TCMAP_NOTC : constant := 0; -- ADC internal temperature sensor channel is not selected for ADC
   ADC14TCMAP_TC   : constant := 1; -- ADC internal temperature sensor channel is selected for ADC input channel MAX – 1

   ADC14CH0MAP_NOCH0 : constant := 0; -- ADC input channel internal 0 is not selected
   ADC14CH0MAP_CH0   : constant := 1; -- ADC input channel internal 0 is selected for ADC input channel MAX – 2

   ADC14CH1MAP_NOCH1 : constant := 0; -- ADC input channel internal 1 is not selected
   ADC14CH1MAP_CH1   : constant := 1; -- ADC input channel internal 1 is selected for ADC input channel MAX – 3

   ADC14CH2MAP_NOCH2 : constant := 0; -- ADC input channel internal 2 is not selected
   ADC14CH2MAP_CH2   : constant := 1; -- ADC input channel internal 2 is selected for ADC input channel MAX – 4

   ADC14CH3MAP_NOCH3 : constant := 0; -- ADC input channel internal 3 is not selected
   ADC14CH3MAP_CH3   : constant := 1; -- ADC input channel internal 3 is selected for ADC input channel MAX – 5

    type ADC14CTL1_Type is record
      ADC14PWRMD      : Bits_2  := ADC14PWRMD_REGULAR;        -- ADC power modes.
      ADC14REFBURST   : Bits_1  := ADC14REFBURST_CONTINUOUS;  -- ADC reference buffer burst.
      ADC14DF         : Bits_1  := ADC14DF_UNSIGNED;          -- ADC14 data read-back format.
      ADC14RES        : Bits_2  := ADC14RES_14;               -- ADC14 resolution.
      Reserved1       : Bits_10 := 0;
      ADC14CSTARTADDx : Bits_5  := ADC14CSTARTADDx_ADC14MEM0; -- ADC14 conversion start address.
      Reserved2       : Bits_1  := 0;
      ADC14BATMAP     : Bits_1  := ADC14BATMAP_NOBAT;         -- Controls 1/2 AVCC ADC input channel selection
      ADC14TCMAP      : Bits_1  := ADC14TCMAP_NOTC;           -- Controls temperature sensor ADC input channel selection
      ADC14CH0MAP     : Bits_1  := ADC14CH0MAP_NOCH0;         -- Controls internal channel 0 selection to ADC input channel MAX – 2
      ADC14CH1MAP     : Bits_1  := ADC14CH1MAP_NOCH1;         -- Controls internal channel 1 selection to ADC input channel MAX – 3
      ADC14CH2MAP     : Bits_1  := ADC14CH2MAP_NOCH2;         -- Controls internal channel 2 selection to ADC input channel MAX – 4
      ADC14CH3MAP     : Bits_1  := ADC14CH3MAP_NOCH3;         -- Controls internal channel 3 selection to ADC input channel MAX – 5
      Reserved3       : Bits_4  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14CTL1_Type use record
      ADC14PWRMD      at 0 range  0 ..  1;
      ADC14REFBURST   at 0 range  2 ..  2;
      ADC14DF         at 0 range  3 ..  3;
      ADC14RES        at 0 range  4 ..  5;
      Reserved1       at 0 range  6 .. 15;
      ADC14CSTARTADDx at 0 range 16 .. 20;
      Reserved2       at 0 range 21 .. 21;
      ADC14BATMAP     at 0 range 22 .. 22;
      ADC14TCMAP      at 0 range 23 .. 23;
      ADC14CH0MAP     at 0 range 24 .. 24;
      ADC14CH1MAP     at 0 range 25 .. 25;
      ADC14CH2MAP     at 0 range 26 .. 26;
      ADC14CH3MAP     at 0 range 27 .. 27;
      Reserved3       at 0 range 28 .. 31;
   end record;

   -- 22.3.3 ADC14LO0 Register

   type ADC14LO0_Type is record
      ADC14LO0 : Bits_16 := 0; -- Low threshold 0.
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14LO0_Type use record
      ADC14LO0 at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 22.3.4 ADC14HI0 Register

   type ADC14HI0_Type is record
      ADC14HI0 : Bits_16 := 16#3FFF#; -- High threshold 0.
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14HI0_Type use record
      ADC14HI0 at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 22.3.5 ADC14LO1 Register

   type ADC14LO1_Type is record
      ADC14LO1 : Bits_16 := 0; -- Low threshold 1.
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14LO1_Type use record
      ADC14LO1 at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 22.3.6 ADC14HI1 Register

   type ADC14HI1_Type is record
      ADC14HI1 : Bits_16 := 16#3FFF#; -- High threshold 1.
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14HI1_Type use record
      ADC14HI1 at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 22.3.7 ADC14MCTL0 to ADC14MCTL31 Register

   -- ADC14DIF = 0
   ADC14INCHx_A0  : constant := 2#00000#; -- If ADC14DIF = 0: A0
   ADC14INCHx_A1  : constant := 2#00001#; -- If ADC14DIF = 0: A1
   ADC14INCHx_A2  : constant := 2#00010#; -- If ADC14DIF = 0: A2
   ADC14INCHx_A3  : constant := 2#00011#; -- If ADC14DIF = 0: A3
   ADC14INCHx_A4  : constant := 2#00100#; -- If ADC14DIF = 0: A4
   ADC14INCHx_A5  : constant := 2#00101#; -- If ADC14DIF = 0: A5
   ADC14INCHx_A6  : constant := 2#00110#; -- If ADC14DIF = 0: A6
   ADC14INCHx_A7  : constant := 2#00111#; -- If ADC14DIF = 0: A7
   ADC14INCHx_A8  : constant := 2#01000#; -- If ADC14DIF = 0: A8
   ADC14INCHx_A9  : constant := 2#01001#; -- If ADC14DIF = 0: A9
   ADC14INCHx_A10 : constant := 2#01010#; -- If ADC14DIF = 0: A10
   ADC14INCHx_A11 : constant := 2#01011#; -- If ADC14DIF = 0: A11
   ADC14INCHx_A12 : constant := 2#01100#; -- If ADC14DIF = 0: A12
   ADC14INCHx_A13 : constant := 2#01101#; -- If ADC14DIF = 0: A13
   ADC14INCHx_A14 : constant := 2#01110#; -- If ADC14DIF = 0: A14
   ADC14INCHx_A15 : constant := 2#01111#; -- If ADC14DIF = 0: A15
   ADC14INCHx_A16 : constant := 2#10000#; -- If ADC14DIF = 0: A16
   ADC14INCHx_A17 : constant := 2#10001#; -- If ADC14DIF = 0: A17
   ADC14INCHx_A18 : constant := 2#10010#; -- If ADC14DIF = 0: A18
   ADC14INCHx_A19 : constant := 2#10011#; -- If ADC14DIF = 0: A19
   ADC14INCHx_A20 : constant := 2#10100#; -- If ADC14DIF = 0: A20
   ADC14INCHx_A21 : constant := 2#10101#; -- If ADC14DIF = 0: A21
   ADC14INCHx_A22 : constant := 2#10110#; -- If ADC14DIF = 0: A22
   ADC14INCHx_A23 : constant := 2#10111#; -- If ADC14DIF = 0: A23
   ADC14INCHx_A24 : constant := 2#11000#; -- If ADC14DIF = 0: A24
   ADC14INCHx_A25 : constant := 2#11001#; -- If ADC14DIF = 0: A25
   ADC14INCHx_A26 : constant := 2#11010#; -- If ADC14DIF = 0: A26
   ADC14INCHx_A27 : constant := 2#11011#; -- If ADC14DIF = 0: A27
   ADC14INCHx_A28 : constant := 2#11100#; -- If ADC14DIF = 0: A28
   ADC14INCHx_A29 : constant := 2#11101#; -- If ADC14DIF = 0: A29
   ADC14INCHx_A30 : constant := 2#11110#; -- If ADC14DIF = 0: A30
   ADC14INCHx_A31 : constant := 2#11111#; -- If ADC14DIF = 0: A31
   -- ADC14DIF = 1
   ADC14INCHx_A0PA1   : constant := 2#00000#; -- If ADC14DIF = 1: Ain+ = A0, Ain- = A1
   ADC14INCHx_A0NA1   : constant := 2#00001#; -- If ADC14DIF = 1: Ain+ = A0, Ain- = A1
   ADC14INCHx_A2PA3   : constant := 2#00010#; -- If ADC14DIF = 1: Ain+ = A2, Ain- = A3
   ADC14INCHx_A2NA3   : constant := 2#00011#; -- If ADC14DIF = 1: Ain+ = A2, Ain- = A3
   ADC14INCHx_A4PA5   : constant := 2#00100#; -- If ADC14DIF = 1: Ain+ = A4, Ain- = A5
   ADC14INCHx_A4NA5   : constant := 2#00101#; -- If ADC14DIF = 1: Ain+ = A4, Ain- = A5
   ADC14INCHx_A6PA7   : constant := 2#00110#; -- If ADC14DIF = 1: Ain+ = A6, Ain- = A7
   ADC14INCHx_A6NA7   : constant := 2#00111#; -- If ADC14DIF = 1: Ain+ = A6, Ain- = A7
   ADC14INCHx_A8PA9   : constant := 2#01000#; -- If ADC14DIF = 1: Ain+ = A8, Ain- = A9
   ADC14INCHx_A8NA9   : constant := 2#01001#; -- If ADC14DIF = 1: Ain+ = A8, Ain- = A9
   ADC14INCHx_A10PA11 : constant := 2#01010#; -- If ADC14DIF = 1: Ain+ = A10, Ain- = A11
   ADC14INCHx_A10NA11 : constant := 2#01011#; -- If ADC14DIF = 1: Ain+ = A10, Ain- = A11
   ADC14INCHx_A12PA13 : constant := 2#01100#; -- If ADC14DIF = 1: Ain+ = A12, Ain- = A13
   ADC14INCHx_A12NA13 : constant := 2#01101#; -- If ADC14DIF = 1: Ain+ = A12, Ain- = A13
   ADC14INCHx_A14PA15 : constant := 2#01110#; -- If ADC14DIF = 1: Ain+ = A14, Ain- = A15
   ADC14INCHx_A14NA15 : constant := 2#01111#; -- If ADC14DIF = 1: Ain+ = A14, Ain- = A15
   ADC14INCHx_A16PA17 : constant := 2#10000#; -- If ADC14DIF = 1: Ain+ = A16, Ain- = A17
   ADC14INCHx_A16NA17 : constant := 2#10001#; -- If ADC14DIF = 1: Ain+ = A16, Ain- = A17
   ADC14INCHx_A18PA19 : constant := 2#10010#; -- If ADC14DIF = 1: Ain+ = A18, Ain- = A19
   ADC14INCHx_A18NA19 : constant := 2#10011#; -- If ADC14DIF = 1: Ain+ = A18, Ain- = A19
   ADC14INCHx_A20PA21 : constant := 2#10100#; -- If ADC14DIF = 1: Ain+ = A20, Ain- = A21
   ADC14INCHx_A20NA21 : constant := 2#10101#; -- If ADC14DIF = 1: Ain+ = A20, Ain- = A21
   ADC14INCHx_A22PA23 : constant := 2#10110#; -- If ADC14DIF = 1: Ain+ = A22, Ain- = A23
   ADC14INCHx_A22NA23 : constant := 2#10111#; -- If ADC14DIF = 1: Ain+ = A22, Ain- = A23
   ADC14INCHx_A24PA25 : constant := 2#11000#; -- If ADC14DIF = 1: Ain+ = A24, Ain- = A25
   ADC14INCHx_A24NA25 : constant := 2#11001#; -- If ADC14DIF = 1: Ain+ = A24, Ain- = A25
   ADC14INCHx_A26PA27 : constant := 2#11010#; -- If ADC14DIF = 1: Ain+ = A26, Ain- = A27
   ADC14INCHx_A26NA27 : constant := 2#11011#; -- If ADC14DIF = 1: Ain+ = A26, Ain- = A27
   ADC14INCHx_A28PA29 : constant := 2#11100#; -- If ADC14DIF = 1: Ain+ = A28, Ain- = A29
   ADC14INCHx_A28NA29 : constant := 2#11101#; -- If ADC14DIF = 1: Ain+ = A28, Ain- = A29
   ADC14INCHx_A30PA31 : constant := 2#11110#; -- If ADC14DIF = 1: Ain+ = A30, Ain- = A31
   ADC14INCHx_A30NA31 : constant := 2#11111#; -- If ADC14DIF = 1: Ain+ = A30, Ain- = A31

   ADC14VRSEL_AVCCAVSS     : constant := 2#0000#; -- V(R+) = AVCC, V(R-) = AVSS
   ADC14VRSEL_VREFBUFDAVSS : constant := 2#0001#; -- V(R+) = VREF buffered, V(R-) = AVSS
   ADC14VRSEL_RSVD1        : constant := 2#0010#; -- Reserved
   ADC14VRSEL_RSVD2        : constant := 2#0011#; -- Reserved
   ADC14VRSEL_RSVD3        : constant := 2#0100#; -- Reserved
   ADC14VRSEL_RSVD4        : constant := 2#0101#; -- Reserved
   ADC14VRSEL_RSVD5        : constant := 2#0110#; -- Reserved
   ADC14VRSEL_RSVD6        : constant := 2#0111#; -- Reserved
   ADC14VRSEL_RSVD7        : constant := 2#1000#; -- Reserved
   ADC14VRSEL_RSVD8        : constant := 2#1001#; -- Reserved
   ADC14VRSEL_RSVD9        : constant := 2#1010#; -- Reserved
   ADC14VRSEL_RSVD10       : constant := 2#1011#; -- Reserved
   ADC14VRSEL_RSVD11       : constant := 2#1100#; -- Reserved
   ADC14VRSEL_RSVD12       : constant := 2#1101#; -- Reserved
   ADC14VRSEL_VeREF        : constant := 2#1110#; -- V(R+) = VeREF+, V(R-) = VeREF-
   ADC14VRSEL_VeREFBUFD    : constant := 2#1111#; -- V(R+) = VeREF+ buffered, V(R-) = VeREF-

   ADC14WINCTH_WINCMPTHR0 : constant := 0; -- Use window comparator thresholds 0, ADC14LO0 and ADC14HI0
   ADC14WINCTH_WINCMPTHR1 : constant := 1; -- Use window comparator thresholds 1, ADC14LO1 and ADC14HI1

   type ADC14MCTLx_Type is record
      ADC14INCHx  : Bits_5  := ADC14INCHx_A0;          -- Input channel select.
      Reserved1   : Bits_2  := 0;
      ADC14EOS    : Boolean := False;                  -- End of sequence.
      ADC14VRSEL  : Bits_4  := ADC14VRSEL_AVCCAVSS;    -- Selects combinations of V(R+) and V(R-) sources as well as the buffer selection and buffer on or off.
      Reserved2   : Bits_1  := 0;
      ADC14DIF    : Boolean := False;                  -- Differential mode.
      ADC14WINC   : Boolean := False;                  -- Comparator window enable
      ADC14WINCTH : Bits_1  := ADC14WINCTH_WINCMPTHR0; -- Window comparator threshold register selection
      Reserved3   : Bits_16 := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Object_Size          => 32,
           Volatile_Full_Access => True;
   for ADC14MCTLx_Type use record
      ADC14INCHx  at 0 range  0 ..  4;
      Reserved1   at 0 range  5 ..  6;
      ADC14EOS    at 0 range  7 ..  7;
      ADC14VRSEL  at 0 range  8 .. 11;
      Reserved2   at 0 range 12 .. 12;
      ADC14DIF    at 0 range 13 .. 13;
      ADC14WINC   at 0 range 14 .. 14;
      ADC14WINCTH at 0 range 15 .. 15;
      Reserved3   at 0 range 16 .. 31;
   end record;

   type ADC14MCTL_Type is array (ADC14CH0 .. ADC14CH31) of ADC14MCTLx_Type
      with Object_Size => 32 * 32;

   -- 22.3.8 ADC14MEM0 to ADC14MEM31 Register

   type ADC14MEMx_Type is record
      ConversionResults : Bits_16 := 0; -- If ADC14DF = 0, unsigned binary If ADC14DF = 1, 2s-complement format
      Reserved          : Bits_16 := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Object_Size          => 32,
           Volatile_Full_Access => True;
   for ADC14MEMx_Type use record
      ConversionResults at 0 range  0 .. 15;
      Reserved          at 0 range 16 .. 31;
   end record;

   type ADC14MEM_Type is array (ADC14CH0 .. ADC14CH31) of ADC14MEMx_Type
      with Object_Size => 32 * 32;

   -- 22.3.9 ADC14IER0 Register

   type ADC14IER0_Type is record
      ADC14IE : Bitmap_32 := [others => False]; -- Interrupt enable.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14IER0_Type use record
      ADC14IE at 0 range 0 .. 31;
   end record;

   -- 22.3.10 ADC14IER1 Register

   type ADC14IER1_Type is record
      Reserved1  : Bits_1  := 0;
      ADC14INIE  : Boolean := False; -- Interrupt enable for the ADC14MEMx result register being greater than the ADC14LO threshold and below the ADC14HI threshold.
      ADC14LOIE  : Boolean := False; -- Interrupt enable for the falling short of the lower limit interrupt of the window comparator for the ADC14MEMx result register.
      ADC14HIIE  : Boolean := False; -- Interrupt enable for the exceeding the upper limit interrupt of the window comparator for ADC14MEMx result register.
      ADC14OVIE  : Boolean := False; -- ADC14MEMx overflow-interrupt enable.
      ADC14TOVIE : Boolean := False; -- ADC14 conversion-time-overflow interrupt enable.
      ADC14RDYIE : Boolean := False; -- ADC14 local buffered reference ready interrupt enable.
      Reserved2  : Bits_25 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14IER1_Type use record
      Reserved1  at 0 range 0 ..  0;
      ADC14INIE  at 0 range 1 ..  1;
      ADC14LOIE  at 0 range 2 ..  2;
      ADC14HIIE  at 0 range 3 ..  3;
      ADC14OVIE  at 0 range 4 ..  4;
      ADC14TOVIE at 0 range 5 ..  5;
      ADC14RDYIE at 0 range 6 ..  6;
      Reserved2  at 0 range 7 .. 31;
   end record;

   -- 22.3.11 ADC14IFGR0 Register

   type ADC14IFGR0_Type is record
      ADC14IFG : Bitmap_32; -- ADC14MEMx interrupt flag.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14IFGR0_Type use record
      ADC14IFG at 0 range 0 .. 31;
   end record;

   -- 22.3.12 ADC14IFGR1 Register

   type ADC14IFGR1_Type is record
      Reserved1   : Bits_1  := 0;
      ADC14INIFG  : Boolean := False; -- Interrupt flag for the ADC14MEMx result register being greater than the ADC14LO threshold and below the ADC14HI threshold interrupt.
      ADC14LOIFG  : Boolean := False; -- Interrupt flag for falling short of the lower limit interrupt of the window comparator for the ADC14MEMx result register.
      ADC14HIIFG  : Boolean := False; -- Interrupt flag for exceeding the upper limit interrupt of the window comparator for ADC14MEMx result register.
      ADC14OVIFG  : Boolean := False; -- ADC14MEMx overflow interrupt flag.
      ADC14TOVIFG : Boolean := False; -- ADC14 conversion time overflow interrupt flag.
      ADC14RDYIFG : Boolean := False; -- ADC14 local buffered reference ready interrupt flag.
      Reserved2   : Bits_25 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14IFGR1_Type use record
      Reserved1   at 0 range 0 ..  0;
      ADC14INIFG  at 0 range 1 ..  1;
      ADC14LOIFG  at 0 range 2 ..  2;
      ADC14HIIFG  at 0 range 3 ..  3;
      ADC14OVIFG  at 0 range 4 ..  4;
      ADC14TOVIFG at 0 range 5 ..  5;
      ADC14RDYIFG at 0 range 6 ..  6;
      Reserved2   at 0 range 7 .. 31;
   end record;

   -- 22.3.13 ADC14CLRIFGR0 Register

   type ADC14CLRIFGR0_Type is record
      CLRADC14IFG : Bitmap_32 := [others => False]; -- clear ADC14IFGx
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14CLRIFGR0_Type use record
      CLRADC14IFG at 0 range 0 .. 31;
   end record;

   -- 22.3.14 ADC14CLRIFGR1 Register

   type ADC14CLRIFGR1_Type is record
      Reserved1      : Bits_1  := 0;
      CLRADC14INIFG  : Boolean := False; -- clear ADC14INIFG
      CLRADC14LOIFG  : Boolean := False; -- clear ADC14LOIFG
      CLRADC14HIIFG  : Boolean := False; -- clear ADC14HIIFG
      CLRADC14OVIFG  : Boolean := False; -- clear ADC14OVIFG
      CLRADC14TOVIFG : Boolean := False; -- clear ADC14TOVIFG
      CLRADC14RDYIFG : Boolean := False; -- clear ADC14RDYIFG
      Reserved2      : Bits_25 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14CLRIFGR1_Type use record
      Reserved1      at 0 range 0 ..  0;
      CLRADC14INIFG  at 0 range 1 ..  1;
      CLRADC14LOIFG  at 0 range 2 ..  2;
      CLRADC14HIIFG  at 0 range 3 ..  3;
      CLRADC14OVIFG  at 0 range 4 ..  4;
      CLRADC14TOVIFG at 0 range 5 ..  5;
      CLRADC14RDYIFG at 0 range 6 ..  6;
      Reserved2      at 0 range 7 .. 31;
   end record;

   -- 22.3.15 ADC14IV Register

   ADC14IVx_NONE        : constant := 16#00#; -- No interrupt pending
   ADC14IVx_ADC14OVIFG  : constant := 16#02#; -- Interrupt Source: ADC14MEMx overflow; Interrupt Flag: ADC14OVIFG; Interrupt Priority: Highest
   ADC14IVx_ADC14TOVIFG : constant := 16#04#; -- Interrupt Source: Conversion time overflow; Interrupt Flag: ADC14TOVIFG
   ADC14IVx_ADC14HIIFG  : constant := 16#06#; -- Interrupt Source: ADC14 window high interrupt flag; Interrupt Flag: ADC14HIIFG
   ADC14IVx_ADC14LOIFG  : constant := 16#08#; -- Interrupt Source: ADC14 window low interrupt flag; Interrupt Flag: ADC14LOIFG
   ADC14IVx_ADC14INIFG  : constant := 16#0A#; -- Interrupt Source: ADC14 in-window interrupt flag; Interrupt Flag: ADC14INIFG
   ADC14IVx_ADC14IFG0   : constant := 16#0C#; -- Interrupt Source: ADC14MEM0 interrupt flag; Interrupt Flag: ADC14IFG0
   ADC14IVx_ADC14IFG1   : constant := 16#0E#; -- Interrupt Source: ADC14MEM1 interrupt flag; Interrupt Flag: ADC14IFG1
   ADC14IVx_ADC14IFG2   : constant := 16#10#; -- Interrupt Source: ADC14MEM2 interrupt flag; Interrupt Flag: ADC14IFG2
   ADC14IVx_ADC14IFG3   : constant := 16#12#; -- Interrupt Source: ADC14MEM3 interrupt flag; Interrupt Flag: ADC14IFG3
   ADC14IVx_ADC14IFG4   : constant := 16#14#; -- Interrupt Source: ADC14MEM4 interrupt flag; Interrupt Flag: ADC14IFG4
   ADC14IVx_ADC14IFG5   : constant := 16#16#; -- Interrupt Source: ADC14MEM5 interrupt flag; Interrupt Flag: ADC14IFG5
   ADC14IVx_ADC14IFG6   : constant := 16#18#; -- Interrupt Source: ADC14MEM6 interrupt flag; Interrupt Flag: ADC14IFG6
   ADC14IVx_ADC14IFG7   : constant := 16#1A#; -- Interrupt Source: ADC14MEM7 interrupt flag; Interrupt Flag: ADC14IFG7
   ADC14IVx_ADC14IFG8   : constant := 16#1C#; -- Interrupt Source: ADC14MEM8 interrupt flag; Interrupt Flag: ADC14IFG8
   ADC14IVx_ADC14IFG9   : constant := 16#1E#; -- Interrupt Source: ADC14MEM9 interrupt flag; Interrupt Flag: ADC14IFG9
   ADC14IVx_ADC14IFG10  : constant := 16#20#; -- Interrupt Source: ADC14MEM10 interrupt flag; Interrupt Flag: ADC14IFG10
   ADC14IVx_ADC14IFG11  : constant := 16#22#; -- Interrupt Source: ADC14MEM11 interrupt flag; Interrupt Flag: ADC14IFG11
   ADC14IVx_ADC14IFG12  : constant := 16#24#; -- Interrupt Source: ADC14MEM12 interrupt flag; Interrupt Flag: ADC14IFG12
   ADC14IVx_ADC14IFG13  : constant := 16#26#; -- Interrupt Source: ADC14MEM13 interrupt flag; Interrupt Flag: ADC14IFG13
   ADC14IVx_ADC14IFG14  : constant := 16#28#; -- Interrupt Source: ADC14MEM14 interrupt flag; Interrupt Flag: ADC14IFG14
   ADC14IVx_ADC14IFG15  : constant := 16#2A#; -- Interrupt Source: ADC14MEM15 interrupt flag; Interrupt Flag: ADC14IFG15
   ADC14IVx_ADC14IFG16  : constant := 16#2C#; -- Interrupt Source: ADC14MEM16 interrupt flag; Interrupt Flag: ADC14IFG16
   ADC14IVx_ADC14IFG17  : constant := 16#2E#; -- Interrupt Source: ADC14MEM17 interrupt flag; Interrupt Flag: ADC14IFG17
   ADC14IVx_ADC14IFG18  : constant := 16#30#; -- Interrupt Source: ADC14MEM18 interrupt flag; Interrupt Flag: ADC14IFG18
   ADC14IVx_ADC14IFG19  : constant := 16#32#; -- Interrupt Source: ADC14MEM19 interrupt flag; Interrupt Flag: ADC14IFG19
   ADC14IVx_ADC14IFG20  : constant := 16#34#; -- Interrupt Source: ADC14MEM20 interrupt flag; Interrupt Flag: ADC14IFG20
   ADC14IVx_ADC14IFG21  : constant := 16#36#; -- Interrupt Source: ADC14MEM21 interrupt flag; Interrupt Flag: ADC14IFG21
   ADC14IVx_ADC14IFG22  : constant := 16#38#; -- Interrupt Source: ADC14MEM22 interrupt flag; Interrupt Flag: ADC14IFG22
   ADC14IVx_ADC14IFG23  : constant := 16#3A#; -- Interrupt Source: ADC14MEM23 interrupt flag; Interrupt Flag: ADC14IFG23
   ADC14IVx_ADC14IFG24  : constant := 16#3C#; -- Interrupt Source: ADC14MEM24 interrupt flag; Interrupt Flag: ADC14IFG24
   ADC14IVx_ADC14IFG25  : constant := 16#3E#; -- Interrupt Source: ADC14MEM25 interrupt flag; Interrupt Flag: ADC14IFG25
   ADC14IVx_ADC14IFG26  : constant := 16#40#; -- Interrupt Source: ADC14MEM26 interrupt flag; Interrupt Flag: ADC14IFG26
   ADC14IVx_ADC14IFG27  : constant := 16#42#; -- Interrupt Source: ADC14MEM27 interrupt flag; Interrupt Flag: ADC14IFG27
   ADC14IVx_ADC14IFG28  : constant := 16#44#; -- Interrupt Source: ADC14MEM28 interrupt flag; Interrupt Flag: ADC14IFG28
   ADC14IVx_ADC14IFG29  : constant := 16#46#; -- Interrupt Source: ADC14MEM29 interrupt flag; Interrupt Flag: ADC14IFG29
   ADC14IVx_ADC14IFG30  : constant := 16#48#; -- Interrupt Source: ADC14MEM30 interrupt flag; Interrupt Flag: ADC14IFG30
   ADC14IVx_ADC14IFG31  : constant := 16#4A#; -- Interrupt Source: ADC14MEM31 interrupt flag; Interrupt Flag: ADC14IFG31
   ADC14IVx_ADC14RDYIFG : constant := 16#4C#; -- Interrupt Source: ADC14RDYIFG interrupt flag; Interrupt Flag: ADC14RDYIFG; Priority: Lowest

   type ADC14IV_Type is record
      ADC14IVx : Unsigned_32 := 0; -- ADC14 interrupt vector value.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for ADC14IV_Type use record
      ADC14IVx at 0 range 0 .. 31;
   end record;

   -- Table 22-4. ADC14 Registers

   ADC14CTL0_ADDRESS : constant := 16#4001_2000#;

   ADC14CTL0 : aliased ADC14CTL0_Type
      with Address              => System'To_Address (ADC14CTL0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14CTL1_ADDRESS : constant := 16#4001_2004#;

   ADC14CTL1 : aliased ADC14CTL1_Type
      with Address              => System'To_Address (ADC14CTL1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14LO0_ADDRESS : constant := 16#4001_2008#;

   ADC14LO0 : aliased ADC14LO0_Type
      with Address              => System'To_Address (ADC14LO0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14HI0_ADDRESS : constant := 16#4001_200C#;

   ADC14HI0 : aliased ADC14HI0_Type
      with Address              => System'To_Address (ADC14HI0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14LO1_ADDRESS : constant := 16#4001_2010#;

   ADC14LO1 : aliased ADC14LO1_Type
      with Address              => System'To_Address (ADC14LO1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14HI1_ADDRESS : constant := 16#4001_2014#;

   ADC14HI1 : aliased ADC14HI1_Type
      with Address              => System'To_Address (ADC14HI1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14MCTL_ADDRESS : constant := 16#4001_2018#;

   ADC14MCTL : aliased array (ADC14CH0 .. ADC14CH31) of ADC14MCTL_Type
      with Address    => System'To_Address (ADC14MCTL_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ADC14MEM_ADDRESS : constant := 16#4001_2098#;

   ADC14MEM : aliased array (ADC14CH0 .. ADC14CH31) of ADC14MEM_Type
      with Address    => System'To_Address (ADC14MEM_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ADC14IER0_ADDRESS : constant := 16#4001_213C#;

   ADC14IER0 : aliased ADC14IER0_Type
      with Address              => System'To_Address (ADC14IER0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14IER1_ADDRESS : constant := 16#4001_2140#;

   ADC14IER1 : aliased ADC14IER1_Type
      with Address              => System'To_Address (ADC14IER1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14IFGR0_ADDRESS : constant := 16#4001_2144#;

   ADC14IFGR0 : aliased ADC14IFGR0_Type
      with Address              => System'To_Address (ADC14IFGR0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14IFGR1_ADDRESS : constant := 16#4001_2148#;

   ADC14IFGR1 : aliased ADC14IFGR1_Type
      with Address              => System'To_Address (ADC14IFGR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14CLRIFGR0_ADDRESS : constant := 16#4001_214C#;

   ADC14CLRIFGR0 : aliased ADC14CLRIFGR0_Type
      with Address              => System'To_Address (ADC14CLRIFGR0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14CLRIFGR1_ADDRESS : constant := 16#4001_2150#;

   ADC14CLRIFGR1 : aliased ADC14CLRIFGR1_Type
      with Address              => System'To_Address (ADC14CLRIFGR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC14IV_ADDRESS : constant := 16#4001_2154#;

   ADC14IV : aliased ADC14IV_Type
      with Address              => System'To_Address (ADC14IV_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 23 Comparator E Module (COMP_E)
   ----------------------------------------------------------------------------

   -- 23.3.1 CExCTL0 Register
   -- 23.3.2 CExCTL1 Register
   -- 23.3.3 CExCTL2 Register
   -- 23.3.4 CExCTL3 Register
   -- 23.3.5 CExINT Register
   -- 23.3.6 CExIV Register

   ----------------------------------------------------------------------------
   -- Chapter 24 Enhanced Universal Serial Communication Interface (eUSCI) – UART Mode
   ----------------------------------------------------------------------------

   -- 24.4.1 UCAxCTLW0 Register eUSCI_Ax Control Word Register 0

   UCSSELx_UCLK    : constant := 2#00#; -- UCLK
   UCSSELx_ACLK    : constant := 2#01#; -- ACLK
   UCSSELx_SMCLK   : constant := 2#10#; -- SMCLK
   UCSSELx_SMCLK_2 : constant := 2#11#; -- SMCLK

   UCSYNC_ASYNC : constant := 0; -- Asynchronous mode
   UCSYNC_SYNC  : constant := 1; -- Synchronous mode

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

   type UCAxCTLW0_UART_Type is record
      UCSWRST  : Boolean := False;        -- Software reset enable
      UCTXBRK  : Boolean := False;        -- Transmit break.
      UCTXADDR : Boolean := False;        -- Transmit address.
      UCDORM   : Boolean := False;        -- Dormant.
      UCBRKIE  : Boolean := False;        -- Receive break character interrupt enable
      UCRXEIE  : Boolean := False;        -- Receive erroneous-character interrupt enable
      UCSSELx  : Bits_2  := 0;            -- eUSCI_A clock source select.
      UCSYNC   : Bits_1  := UCSYNC_ASYNC; -- Synchronous mode enable
      UCMODEx  : Bits_2  := UCMODEx_UART; -- eUSCI_A mode.
      UCSPB    : Bits_1  := UCSPB_1;      -- Stop bit select.
      UC7BIT   : Bits_1  := UC7BIT_8;     -- Character length.
      UCMSB    : Bits_1  := UCMSB_LSB;    -- MSB first select.
      UCPAR    : Bits_1  := UCPAR_ODD;    -- Parity select.
      UCPEN    : Boolean := False;        -- Parity enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxCTLW0_UART_Type use record
      UCSWRST  at 0 range  0 ..  0;
      UCTXBRK  at 0 range  1 ..  1;
      UCTXADDR at 0 range  2 ..  2;
      UCDORM   at 0 range  3 ..  3;
      UCBRKIE  at 0 range  4 ..  4;
      UCRXEIE  at 0 range  5 ..  5;
      UCSSELx  at 0 range  6 ..  7;
      UCSYNC   at 0 range  8 ..  8;
      UCMODEx  at 0 range  9 .. 10;
      UCSPB    at 0 range 11 .. 11;
      UC7BIT   at 0 range 12 .. 12;
      UCMSB    at 0 range 13 .. 13;
      UCPAR    at 0 range 14 .. 14;
      UCPEN    at 0 range 15 .. 15;
   end record;

   -- 24.4.2 UCAxCTLW1 Register eUSCI_Ax Control Word Register 1

   UCGLITx_5ns  : constant := 2#00#; -- Approximately 5 ns
   UCGLITx_20ns : constant := 2#01#; -- Approximately 20 ns
   UCGLITx_30ns : constant := 2#10#; -- Approximately 30 ns
   UCGLITx_50ns : constant := 2#11#; -- Approximately 50 ns

   type UCAxCTLW1_UART_Type is record
      UCGLITx  : Bits_2  := UCGLITx_50ns; -- Deglitch time
      Reserved : Bits_14 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxCTLW1_UART_Type use record
      UCGLITx  at 0 range 0 ..  1;
      Reserved at 0 range 2 .. 15;
   end record;

   -- 24.4.3 UCAxBRW Register eUSCI_Ax Baud Rate Control Word Register

   type UCAxBRW_UART_Type is record
      UCBRx : Unsigned_16 := 0; -- Clock prescaler setting of the baud-rate generator
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxBRW_UART_Type use record
      UCBRx at 0 range 0 .. 15;
   end record;

   -- 24.4.4 UCAxMCTLW Register eUSCI_Ax Modulation Control Word Register

   type UCAxMCTLW_UART_Type is record
      UCOS16   : Boolean := False; -- Oversampling mode enabled
      Reserved : Bits_3  := 0;
      UCBRFx   : Bits_4  := 0;     -- First modulation stage select.
      UCBRSx   : Bits_8  := 0;     -- Second modulation stage select.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxMCTLW_UART_Type use record
      UCOS16   at 0 range 0 ..  0;
      Reserved at 0 range 1 ..  3;
      UCBRFx   at 0 range 4 ..  7;
      UCBRSx   at 0 range 8 .. 15;
   end record;

   -- 24.4.5 UCAxSTATW Register eUSCI_Ax Status Register

   type UCAxSTATW_UART_Type is record
      UCBUSY        : Boolean := False; -- eUSCI_A busy.
      UCADDR_UCIDLE : Boolean := False; -- UCADDR: Address received in address-bit multiprocessor mode. UCADDR is cleared when UCAxRXBUF is read. UCIDLE: Idle line detected in idle-line multiprocessor mode. UCIDLE is cleared when UCAxRXBUF is read.
      UCRXERR       : Boolean := False; -- Receive error flag.
      UCBRK         : Boolean := False; -- Break detect flag.
      UCPE          : Boolean := False; -- Parity error flag.
      UCOE          : Boolean := False; -- Overrun error flag.
      UCFE          : Boolean := False; -- Framing error flag.
      UCLISTEN      : Boolean := False; -- Listen enable.
      Reserved      : Bits_8  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxSTATW_UART_Type use record
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

   -- 24.4.6 UCAxRXBUF Register eUSCI_Ax Receive Buffer Register

   type UCAxRXBUF_UART_Type is record
      UCRXBUFx : Unsigned_8;      -- The receive-data buffer is user accessible and contains the last received character from the receive shift register.
      Reserved : Bits_8     := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxRXBUF_UART_Type use record
      UCRXBUFx at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   -- 24.4.7 UCAxTXBUF Register eUSCI_Ax Transmit Buffer Register

   type UCAxTXBUF_UART_Type is record
      UCTXBUFx : Unsigned_8;      -- The transmit data buffer is user accessible and holds the data waiting to be moved into the transmit shift register and transmitted on UCAxTXD.
      Reserved : Bits_8     := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxTXBUF_UART_Type use record
      UCTXBUFx at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   -- 24.4.8 UCAxABCTL Register eUSCI_Ax Auto Baud Rate Control Register

   UCDELIMx_1 : constant := 2#00#; -- 1 bit time
   UCDELIMx_2 : constant := 2#01#; -- 2 bit times
   UCDELIMx_3 : constant := 2#10#; -- 3 bit times
   UCDELIMx_4 : constant := 2#11#; -- 4 bit times

   type UCAxABCTL_UART_Type is record
      UCABDEN   : Boolean := False;      -- Automatic baud-rate detect enable
      Reserved1 : Bits_1  := 0;
      UCBTOE    : Boolean := False;      -- Break time out error
      UCSTOE    : Boolean := False;      -- Synch field time out error
      UCDELIMx  : Bits_2  := UCDELIMx_1; -- Break/synch delimiter length
      Reserved2 : Bits_10 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxABCTL_UART_Type use record
      UCABDEN   at 0 range 0 ..  0;
      Reserved1 at 0 range 1 ..  1;
      UCBTOE    at 0 range 2 ..  2;
      UCSTOE    at 0 range 3 ..  3;
      UCDELIMx  at 0 range 4 ..  5;
      Reserved2 at 0 range 6 .. 15;
   end record;

   -- 24.4.9 UCAxIRCTL Register eUSCI_Ax IrDA Control Word Register

   UCIRTXCLK_BRCLK          : constant := 0; -- BRCLK
   UCIRTXCLK_UCOS16BITCLK16 : constant := 1; -- BITCLK16 when UCOS16 = 1. Otherwise, BRCLK.

   UCIRRXPL_HI : constant := 0; -- IrDA transceiver delivers a high pulse when a light pulse is seen.
   UCIRRXPL_LO : constant := 1; -- IrDA transceiver delivers a low pulse when a light pulse is seen.

   type UCAxIRCTL_UART_Type is record
      UCIREN    : Boolean := False;           -- IrDA encoder and decoder enable
      UCIRTXCLK : Bits_1  := UCIRTXCLK_BRCLK; -- IrDA transmit pulse clock select
      UCIRTXPLx : Bits_6  := 0;               -- Transmit pulse length.
      UCIRRXFE  : Boolean := False;           -- IrDA receive filter enabled
      UCIRRXPL  : Bits_1  := UCIRRXPL_HI;     -- IrDA receive input UCAxRXD polarity
      UCIRRXFLx : Bits_6  := 0;               -- Receive filter length.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxIRCTL_UART_Type use record
      UCIREN    at 0 range  0 ..  0;
      UCIRTXCLK at 0 range  1 ..  1;
      UCIRTXPLx at 0 range  2 ..  7;
      UCIRRXFE  at 0 range  8 ..  8;
      UCIRRXPL  at 0 range  9 ..  9;
      UCIRRXFLx at 0 range 10 .. 15;
   end record;

   -- 24.4.10 UCAxIE Register eUSCI_Ax Interrupt Enable Register

   type UCAxIE_UART_Type is record
      UCRXIE    : Boolean := False; -- Receive interrupt enable
      UCTXIE    : Boolean := False; -- Transmit interrupt enable
      UCSTTIE   : Boolean := False; -- Start bit interrupt enable
      UCTXCPTIE : Boolean := False; -- Transmit complete interrupt enable
      Reserved  : Bits_12 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxIE_UART_Type use record
      UCRXIE    at 0 range 0 ..  0;
      UCTXIE    at 0 range 1 ..  1;
      UCSTTIE   at 0 range 2 ..  2;
      UCTXCPTIE at 0 range 3 ..  3;
      Reserved  at 0 range 4 .. 15;
   end record;

   -- 24.4.11 UCAxIFG Register eUSCI_Ax Interrupt Flag Register

   type UCAxIFG_UART_Type is record
      UCRXIFG    : Boolean := False; -- Receive interrupt flag.
      UCTXIFG    : Boolean := False; -- Transmit interrupt flag.
      UCSTTIFG   : Boolean := False; -- Start bit interrupt flag.
      UCTXCPTIFG : Boolean := False; -- Transmit complete interrupt flag.
      Reserved   : Bits_12 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxIFG_UART_Type use record
      UCRXIFG    at 0 range 0 ..  0;
      UCTXIFG    at 0 range 1 ..  1;
      UCSTTIFG   at 0 range 2 ..  2;
      UCTXCPTIFG at 0 range 3 ..  3;
      Reserved   at 0 range 4 .. 15;
   end record;

   -- 24.4.12 UCAxIV Register eUSCI_Ax Interrupt Vector Register

   UCAxIV_NONE    : constant := 16#0#; -- No interrupt pending
   UCAxIV_RXFULL  : constant := 16#2#; -- Interrupt Source: Receive buffer full; Interrupt Flag: UCRXIFG; Interrupt Priority: Highest
   UCAxIV_TXEMPTY : constant := 16#4#; -- Interrupt Source: Transmit buffer empty; Interrupt Flag: UCTXIFG
   UCAxIV_START   : constant := 16#6#; -- Interrupt Source: Start bit received; Interrupt Flag: UCSTTIFG
   UCAxIV_TXDONE  : constant := 16#8#; -- Interrupt Source: Transmit complete; Interrupt Flag: UCTXCPTIFG; Interrupt Priority: Lowest

   type UCAxIV_UART_Type is record
      UCIVx : Unsigned_16; -- eUSCI_A interrupt vector value
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxIV_UART_Type use record
      UCIVx at 0 range 0 .. 15;
   end record;

   -- 24.4 eUSCI_A UART Registers

   type eUSCI_Ax_UART_Type is record
      UCAxCTLW0 : UCAxCTLW0_UART_Type with Volatile_Full_Access => True;
      UCAxCTLW1 : UCAxCTLW1_UART_Type with Volatile_Full_Access => True;
      UCAxBRW   : UCAxBRW_UART_Type   with Volatile_Full_Access => True;
      UCAxMCTLW : UCAxMCTLW_UART_Type with Volatile_Full_Access => True;
      UCAxSTATW : UCAxSTATW_UART_Type with Volatile_Full_Access => True;
      UCAxRXBUF : UCAxRXBUF_UART_Type with Volatile_Full_Access => True;
      UCAxTXBUF : UCAxTXBUF_UART_Type with Volatile_Full_Access => True;
      UCAxABCTL : UCAxABCTL_UART_Type with Volatile_Full_Access => True;
      UCAxIRCTL : UCAxIRCTL_UART_Type with Volatile_Full_Access => True;
      UCAxIE    : UCAxIE_UART_Type    with Volatile_Full_Access => True;
      UCAxIFG   : UCAxIFG_UART_Type   with Volatile_Full_Access => True;
      UCAxIV    : UCAxIV_UART_Type    with Volatile_Full_Access => True;
   end record
      with Object_Size => 16#20# * 8;
   for eUSCI_Ax_UART_Type use record
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

   -- Table 6-6. eUSCI_A0 UART Registers

   eUSCI_A0_UART_ADDRESS : constant := 16#4000_1000#;

   eUSCI_A0_UART : aliased eUSCI_Ax_UART_Type
      with Address    => System'To_Address (eUSCI_A0_UART_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 25 Enhanced Universal Serial Communication Interface (eUSCI) – SPI Mode
   ----------------------------------------------------------------------------

   -- 25.4.1 UCAxCTLW0 Register eUSCI_Ax Control Register 0

   UCSTEM_NONE   : constant := 0; -- STE pin is used to prevent conflicts with other masters
   UCSTEM_ENABLE : constant := 1; -- STE pin is used to generate the enable signal for a 4-wire slave

   UCSSELx_RSVD    : constant := 2#00#; -- Reserved
   -- already defined at 24.4.1
   -- UCSSELx_ACLK    : constant := 2#01#; -- ACLK
   -- UCSSELx_SMCLK   : constant := 2#10#; -- SMCLK
   -- UCSSELx_SMCLK_2 : constant := 2#11#; -- SMCLK

   -- already defined at 24.4.1
   -- UCSYNC_ASYNC : constant := 0; -- Asynchronous mode
   -- UCSYNC_SYNC  : constant := 1; -- Synchronous mode

   UCMODEx_SPI3       : constant := 2#00#; -- 3-pin SPI
   UCMODEx_SPI4_STEHI : constant := 2#01#; -- 4-pin SPI with UCxSTE active high: Slave enabled when UCxSTE = 1
   UCMODEx_SPI4_STELO : constant := 2#10#; -- 4-pin SPI with UCxSTE active low: Slave enabled when UCxSTE = 0
   UCMODEx_I2C        : constant := 2#11#; -- I2C mode

   UCMST_SLAVE  : constant := 0; -- Slave mode
   UCMST_MASTER : constant := 1; -- Master mode

   -- already defined at 24.4.1
   -- UC7BIT_8 : constant := 0; -- 8-bit data
   -- UC7BIT_7 : constant := 1; -- 7-bit data

   -- already defined at 24.4.1
   -- UCMSB_LSB : constant := 0; -- LSB first
   -- UCMSB_MSB : constant := 1; -- MSB first

   UCCKPL_INACTIVEL : constant := 0; -- The inactive state is low.
   UCCKPL_INACTIVEH : constant := 1; -- The inactive state is high.

   UCCKPH_CHGCAP : constant := 0; -- Data is changed on the first UCLK edge and captured on the following edge.
   UCCKPH_CAPCHG : constant := 1; -- Data is captured on the first UCLK edge and changed on the following edge.

   type UCAxCTLW0_SPI_Type is record
      UCSWRST  : Boolean := True;             -- Software reset enable
      UCSTEM   : Bits_1  := UCSTEM_NONE;      -- STE mode select in master mode.
      Reserved : Bits_4  := 0;
      UCSSELx  : Bits_2  := UCSSELx_RSVD;     -- eUSCI clock source select.
      UCSYNC   : Bits_1  := UCSYNC_ASYNC;     -- Synchronous mode enable
      UCMODEx  : Bits_2  := UCMODEx_SPI3;     -- eUSCI mode.
      UCMST    : Bits_1  := UCMST_SLAVE;      -- Master mode select
      UC7BIT   : Bits_1  := UC7BIT_8;         -- Character length.
      UCMSB    : Bits_1  := UCMSB_LSB;        -- MSB first select.
      UCCKPL   : Bits_1  := UCCKPL_INACTIVEL; -- Clock polarity select
      UCCKPH   : Bits_1  := UCCKPH_CHGCAP;    -- Clock phase select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxCTLW0_SPI_Type use record
      UCSWRST  at 0 range  0 ..  0;
      UCSTEM   at 0 range  1 ..  1;
      Reserved at 0 range  2 ..  5;
      UCSSELx  at 0 range  6 ..  7;
      UCSYNC   at 0 range  8 ..  8;
      UCMODEx  at 0 range  9 .. 10;
      UCMST    at 0 range 11 .. 11;
      UC7BIT   at 0 range 12 .. 12;
      UCMSB    at 0 range 13 .. 13;
      UCCKPL   at 0 range 14 .. 14;
      UCCKPH   at 0 range 15 .. 15;
   end record;

   -- 25.4.2 UCAxBRW Register eUSCI_Ax Bit Rate Control Register 1

   type UCAxBRW_SPI_Type is record
      UCBRx : Unsigned_16; -- Bit clock prescaler setting
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxBRW_SPI_Type use record
      UCBRx at 0 range 0 .. 15;
   end record;

   -- 25.4.3 UCAxSTATW Register eUSCI_Ax Status Register

   type UCAxSTATW_SPI_Type is record
      UCBUSY    : Boolean := False; -- eUSCI busy.
      Reserved1 : Bits_4  := 0;
      UCOE      : Boolean := False; -- Overrun error flag.
      UCFE      : Boolean := False; -- Framing error flag.
      UCLISTEN  : Boolean := False; -- Listen enable.
      Reserved2 : Bits_8  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxSTATW_SPI_Type use record
      UCBUSY    at 0 range 0 ..  0;
      Reserved1 at 0 range 1 ..  4;
      UCOE      at 0 range 5 ..  5;
      UCFE      at 0 range 6 ..  6;
      UCLISTEN  at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 15;
   end record;

   -- 25.4.4 UCAxRXBUF Register eUSCI_Ax Receive Buffer Register

   type UCAxRXBUF_SPI_Type is record
      UCRXBUFx : Bits_8 := 0; -- The receive-data buffer is user accessible and contains the last received character from the receive shift register.
      Reserved : Bits_8 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxRXBUF_SPI_Type use record
      UCRXBUFx at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   -- 25.4.5 UCAxTXBUF Register eUSCI_Ax Transmit Buffer Register

   type UCAxTXBUF_SPI_Type is record
      UCTXBUFx : Bits_8 := 0; -- The transmit data buffer is user accessible and holds the data waiting to be moved into the transmit shift register and transmitted.
      Reserved : Bits_8 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxTXBUF_SPI_Type use record
      UCTXBUFx at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   -- 25.4.6 UCAxIE Register eUSCI_Ax Interrupt Enable Register

   type UCAxIE_SPI_Type is record
      UCRXIE   : Boolean := False; -- Receive interrupt enable
      UCTXIE   : Boolean := False; -- Transmit interrupt enable
      Reserved : Bits_14 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxIE_SPI_Type use record
      UCRXIE   at 0 range 0 ..  0;
      UCTXIE   at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 15;
   end record;

   -- 25.4.7 UCAxIFG Register eUSCI_Ax Interrupt Flag Register

   type UCAxIFG_SPI_Type is record
      UCRXIFG  : Boolean := False; -- Receive interrupt flag.
      UCTXIFG  : Boolean := False; -- Transmit interrupt flag.
      Reserved : Bits_14 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxIFG_SPI_Type use record
      UCRXIFG  at 0 range 0 ..  0;
      UCTXIFG  at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 15;
   end record;

   -- 25.4.8 UCAxIV Register eUSCI_Ax Interrupt Vector Register

   UCIVx_NONE : constant := 16#0#; -- No interrupt pending
   UCIVx_RX   : constant := 16#2#; -- Interrupt Source: Data received; Interrupt Flag: UCRXIFG; Interrupt Priority: Highest
   UCIVx_TBE  : constant := 16#4#; -- Interrupt Source: Transmit buffer empty; Interrupt Flag: UCTXIFG; Interrupt Priority: Lowest

   type UCAxIV_SPI_Type is record
      UCIVx : Unsigned_16; -- eUSCI interrupt vector value
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCAxIV_SPI_Type use record
      UCIVx at 0 range 0 .. 15;
   end record;

   -- 25.4 eUSCI_A SPI Registers

   type eUSCI_Ax_SPI_Type is record
      UCAxCTLW0 : UCAxCTLW0_SPI_Type with Volatile_Full_Access => True;
      UCAxBRW   : UCAxBRW_SPI_Type   with Volatile_Full_Access => True;
      UCAxSTATW : UCAxSTATW_SPI_Type with Volatile_Full_Access => True;
      UCAxRXBUF : UCAxRXBUF_SPI_Type with Volatile_Full_Access => True;
      UCAxTXBUF : UCAxTXBUF_SPI_Type with Volatile_Full_Access => True;
      UCAxIE    : UCAxIE_SPI_Type    with Volatile_Full_Access => True;
      UCAxIFG   : UCAxIFG_SPI_Type   with Volatile_Full_Access => True;
      UCAxIV    : UCAxIV_SPI_Type    with Volatile_Full_Access => True;
   end record
      with Object_Size => 16#20# * 8;
   for eUSCI_Ax_SPI_Type use record
      UCAxCTLW0 at 16#00# range 0 .. 15;
      UCAxBRW   at 16#06# range 0 .. 15;
      UCAxSTATW at 16#0A# range 0 .. 15;
      UCAxRXBUF at 16#0C# range 0 .. 15;
      UCAxTXBUF at 16#0E# range 0 .. 15;
      UCAxIE    at 16#1A# range 0 .. 15;
      UCAxIFG   at 16#1C# range 0 .. 15;
      UCAxIV    at 16#1E# range 0 .. 15;
   end record;

   -- Table 6-6. eUSCI_A0 UART Registers

   eUSCI_A0_SPI_ADDRESS : constant := 16#4000_1000#;

   eUSCI_A0_SPI : aliased eUSCI_Ax_SPI_Type
      with Address    => System'To_Address (eUSCI_A0_SPI_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 26 Enhanced Universal Serial Communication Interface (eUSCI) – I2C Mode
   ----------------------------------------------------------------------------

   -- 26.4.1 UCBxCTLW0 Register

   UCTR_RX : constant := 0; -- Receiver
   UCTR_TX : constant := 1; -- Transmitter

   -- UCSSELx_* already defined at 24.4.1
   -- UCSSELx_UCLKI   : constant := 2#00#; -- UCLKI
   -- UCSSELx_ACLK    : constant := 2#01#; -- ACLK
   -- UCSSELx_SMCLK   : constant := 2#10#; -- SMCLK
   -- UCSSELx_SMCLK_2 : constant := 2#11#; -- SMCLK

   -- UCMODEx_* already defined at 25.4.1
   -- UCMODEx_SPI3       : constant := 2#00#; -- 3-pin SPI
   -- UCMODEx_SPI4_STEHI : constant := 2#01#; -- 4-pin SPI (master or slave enabled if STE = 1)
   -- UCMODEx_SPI4_STELO : constant := 2#10#; -- 4-pin SPI (master or slave enabled if STE = 0)
   -- UCMODEx_I2C        : constant := 2#11#; -- I2C mode

   -- UCMST_* already defined at 25.4.1
   -- UCMST_SLAVE  : constant := 0; -- Slave mode
   -- UCMST_MASTER : constant := 1; -- Master mode

   UCMM_SINGLE : constant := 0; -- Single master environment.
   UCMM_MULTI  : constant := 1; -- Multi-master environment

   UCSLA10_7  : constant := 0; -- Address slave with 7-bit address
   UCSLA10_10 : constant := 1; -- Address slave with 10-bit address

   UCA10_7  : constant := 0; -- Own address is a 7-bit address.
   UCA10_10 : constant := 1; -- Own address is a 10-bit address.

   type UCBxCTLW0_Type is record
      UCSWRST  : Boolean := True;            -- Software reset enable.
      UCTXSTT  : Boolean := False;           -- Transmit START condition in master mode.
      UCTXSTP  : Boolean := False;           -- Transmit STOP condition in master mode.
      UCTXNACK : Boolean := False;           -- Transmit a NACK.
      UCTR     : Bits_1  := UCTR_RX;         -- Transmitter/receiver
      UCTXACK  : Boolean := False;           -- Transmit ACK condition in slave mode with enabled address mask register.
      UCSSELx  : Bits_2  := UCSSELx_SMCLK_2; -- eUSCI_B clock source select.
      UCSYNC   : Boolean := True;            -- Synchronous mode enable.
      UCMODEx  : Bits_2  := UCMODEx_SPI3;    -- eUSCI_B mode.
      UCMST    : Bits_1  := UCMST_SLAVE;     -- Master mode select.
      Reserved : Bits_1  := 0;
      UCMM     : Bits_1  := UCMM_SINGLE;     -- Multi-master environment select.
      UCSLA10  : Bits_1  := UCSLA10_7;       -- Slave addressing mode select
      UCA10    : Bits_1  := UCA10_7;         -- Own addressing mode select.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxCTLW0_Type use record
      UCSWRST  at 0 range  0 ..  0;
      UCTXSTT  at 0 range  1 ..  1;
      UCTXSTP  at 0 range  2 ..  2;
      UCTXNACK at 0 range  3 ..  3;
      UCTR     at 0 range  4 ..  4;
      UCTXACK  at 0 range  5 ..  5;
      UCSSELx  at 0 range  6 ..  7;
      UCSYNC   at 0 range  8 ..  8;
      UCMODEx  at 0 range  9 .. 10;
      UCMST    at 0 range 11 .. 11;
      Reserved at 0 range 12 .. 12;
      UCMM     at 0 range 13 .. 13;
      UCSLA10  at 0 range 14 .. 14;
      UCA10    at 0 range 15 .. 15;
   end record;

   -- 26.4.2 UCBxCTLW1 Register

   UCGLITx_50n  : constant := 2#00#; -- 50 ns
   UCGLITx_25n  : constant := 2#01#; -- 25 ns
   UCGLITx_12n5 : constant := 2#10#; -- 12.5 ns
   UCGLITx_6n25 : constant := 2#11#; -- 6.25 ns

   UCASTPx_NONE : constant := 2#00#; -- No automatic STOP generation.
   UCASTPx_THRE : constant := 2#01#; -- UCBCNTIFG is set with the byte counter reaches the threshold defined in UCBxTBCNT
   UCASTPx_AUTO : constant := 2#10#; -- A STOP condition is generated automatically after the byte counter value reached UCBxTBCNT.
   UCASTPx_RSVD : constant := 2#11#; -- Reserved

   UCSWACK_MODULE : constant := 0; -- The address acknowledge of the slave is controlled by the eUSCI_B module
   UCSWACK_USER   : constant := 1; -- The user needs to trigger the sending of the address ACK by issuing UCTXACK

   UCSTPNACK_STD : constant := 0; -- Send a not acknowledge before the STOP condition as a master receiver (conform to I2C standard)
   UCSTPNACK_ALL : constant := 1; -- All bytes are acknowledged by the eUSCI_B when configured as master receiver

   UCCLTO_DISABLE    : constant := 2#00#; -- Disable clock low timeout counter
   UCCLTO_SYSCLK135k : constant := 2#01#; -- 135 000 SYSCLK cycles (approximately 28 ms)
   UCCLTO_SYSCLK150k : constant := 2#10#; -- 150 000 SYSCLK cycles (approximately 31 ms)
   UCCLTO_SYSCLK165k : constant := 2#11#; -- 165 000 SYSCLK cycles (approximately 34 ms)

   UCETXINT_ADDRMATCH : constant := 0; -- UCTXIFGx is set after an address match with UCxI2COAx and the direction bit indicating slave transmit
   UCETXINT_START     : constant := 1; -- UCTXIFG0 is set for each START condition

   type UCBxCTLW1_Type is record
      UCGLITx   : Bits_2 := UCGLITx_50n;        -- Deglitch time
      UCASTPx   : Bits_2 := UCASTPx_NONE;       -- Automatic STOP condition generation.
      UCSWACK   : Bits_1 := UCSWACK_MODULE;     -- Using this bit it is possible to select, whether the eUSCI_B module triggers the sending of the ACK of the address or if it is controlled by software.
      UCSTPNACK : Bits_1 := UCSTPNACK_STD;      -- The UCSTPNACK bit allows to make the eUSCI_B master acknowledge the last byte in master receiver mode as well.
      UCCLTO    : Bits_2 := UCCLTO_DISABLE;     -- Clock low timeout select.
      UCETXINT  : Bits_1 := UCETXINT_ADDRMATCH; -- Early UCTXIFG0.
      Reserved  : Bits_7 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxCTLW1_Type use record
      UCGLITx   at 0 range 0 ..  1;
      UCASTPx   at 0 range 2 ..  3;
      UCSWACK   at 0 range 4 ..  4;
      UCSTPNACK at 0 range 5 ..  5;
      UCCLTO    at 0 range 6 ..  7;
      UCETXINT  at 0 range 8 ..  8;
      Reserved  at 0 range 9 .. 15;
   end record;

   -- 26.4.3 UCBxBRW Register

   type UCBxBRW_Type is record
      UCBRx : Unsigned_16; -- Bit clock prescaler.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxBRW_Type use record
      UCBRx at 0 range 0 .. 15;
   end record;

   -- 26.4.4 UCBxSTATW

   type UCBxSTATW_Type is record
      Reserved1 : Bits_4;
      UCBBUSY   : Boolean;    -- Bus busy
      UCGC      : Boolean;    -- General call address received.
      UCSCLLOW  : Boolean;    -- SCL low
      Reserved2 : Bits_1;
      UCBCNTx   : Unsigned_8; -- Hardware byte counter value.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxSTATW_Type use record
      Reserved1 at 0 range 0 ..  3;
      UCBBUSY   at 0 range 4 ..  4;
      UCGC      at 0 range 5 ..  5;
      UCSCLLOW  at 0 range 6 ..  6;
      Reserved2 at 0 range 7 ..  7;
      UCBCNTx   at 0 range 8 .. 15;
   end record;

   -- 26.4.5 UCBxTBCNT Register

   type UCBxTBCNT_Type is record
      UCTBCNTx : Unsigned_8 := 0; -- The byte counter threshold value is used to set the number of I2C data bytes after which the automatic STOP or the UCSTPIFG should occur.
      Reserved : Bits_8     := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxTBCNT_Type use record
      UCTBCNTx at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   -- 26.4.6 UCBxRXBUF Register

   type UCBxRXBUF_Type is record
      UCRXBUFx : Unsigned_8; -- The receive-data buffer is user accessible and contains the last received character from the receive shift register.
      Reserved : Bits_8;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxRXBUF_Type use record
      UCRXBUFx at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   -- 26.4.7 UCBxTXBUF

   type UCBxTXBUF_Type is record
      UCTXBUFx : Unsigned_8 := 0; -- The transmit data buffer is user accessible and holds the data waiting to be moved into the transmit shift register and transmitted.
      Reserved : Bits_8     := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxTXBUF_Type use record
      UCTXBUFx at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   -- 26.4.8 UCBxI2COA0 Register

   type UCBxI2COA0_Type is record
      I2COA0   : Bits_10 := 0;     -- I2C own address.
      UCOAEN   : Boolean := False; -- Own Address enable register.
      Reserved : Bits_4  := 0;
      UCGCEN   : Boolean := False; -- General call response enable.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxI2COA0_Type use record
      I2COA0   at 0 range  0 ..  9;
      UCOAEN   at 0 range 10 .. 10;
      Reserved at 0 range 11 .. 14;
      UCGCEN   at 0 range 15 .. 15;
   end record;

   -- 26.4.9 UCBxI2COA1 Register

   type UCBxI2COA1_Type is record
      I2COA1   : Bits_10 := 0;     -- I2C own address.
      UCOAEN   : Boolean := False; -- Own Address enable register.
      Reserved : Bits_5  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxI2COA1_Type use record
      I2COA1   at 0 range  0 ..  9;
      UCOAEN   at 0 range 10 .. 10;
      Reserved at 0 range 11 .. 15;
   end record;

   -- 26.4.10 UCBxI2COA2 Register

   type UCBxI2COA2_Type is record
      I2COA2   : Bits_10 := 0;     -- I2C own address.
      UCOAEN   : Boolean := False; -- Own Address enable register.
      Reserved : Bits_5  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxI2COA2_Type use record
      I2COA2   at 0 range  0 ..  9;
      UCOAEN   at 0 range 10 .. 10;
      Reserved at 0 range 11 .. 15;
   end record;

   -- 26.4.11 UCBxI2COA3 Register

   type UCBxI2COA3_Type is record
      I2COA3   : Bits_10 := 0;     -- I2C own address.
      UCOAEN   : Boolean := False; -- Own Address enable register.
      Reserved : Bits_5  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxI2COA3_Type use record
      I2COA3   at 0 range  0 ..  9;
      UCOAEN   at 0 range 10 .. 10;
      Reserved at 0 range 11 .. 15;
   end record;

   -- 26.4.12 UCBxADDRX Register

   type UCBxADDRX_Type is record
      ADDRXx   : Bits_10; -- Received Address Register.
      Reserved : Bits_6;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxADDRX_Type use record
      ADDRXx   at 0 range  0 ..  9;
      Reserved at 0 range 10 .. 15;
   end record;

   -- 26.4.13 UCBxADDMASK Register

   type UCBxADDMASK_Type is record
      ADDMASKx : Bits_10; -- Address Mask Register.
      Reserved : Bits_6;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxADDMASK_Type use record
      ADDMASKx at 0 range  0 ..  9;
      Reserved at 0 range 10 .. 15;
   end record;

   -- 26.4.14 UCBxI2CSA Register

   type UCBxI2CSA_Type is record
      I2CSAx   : Bits_10; -- I2C slave address.
      Reserved : Bits_6;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxI2CSA_Type use record
      I2CSAx   at 0 range  0 ..  9;
      Reserved at 0 range 10 .. 15;
   end record;

   -- 26.4.15 UCBxIE Register

   type UCBxIE_Type is record
      UCRXIE0  : Boolean := False; -- Receive interrupt enable 0
      UCTXIE0  : Boolean := False; -- Transmit interrupt enable 0
      UCSTTIE  : Boolean := False; -- START condition interrupt enable
      UCSTPIE  : Boolean := False; -- STOP condition interrupt enable
      UCALIE   : Boolean := False; -- Arbitration lost interrupt enable
      UCNACKIE : Boolean := False; -- Not-acknowledge interrupt enable
      UCBCNTIE : Boolean := False; -- Byte counter interrupt enable.
      UCCLTOIE : Boolean := False; -- Clock low timeout interrupt enable.
      UCRXIE1  : Boolean := False; -- Receive interrupt enable 1
      UCTXIE1  : Boolean := False; -- Transmit interrupt enable 1
      UCRXIE2  : Boolean := False; -- Receive interrupt enable 2
      UCTXIE2  : Boolean := False; -- Transmit interrupt enable 2
      UCRXIE3  : Boolean := False; -- Receive interrupt enable 3
      UCTXIE3  : Boolean := False; -- Transmit interrupt enable 3
      UCBIT9IE : Boolean := False; -- Bit position 9 interrupt enable
      Reserved : Bits_1  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxIE_Type use record
      UCRXIE0  at 0 range  0 ..  0;
      UCTXIE0  at 0 range  1 ..  1;
      UCSTTIE  at 0 range  2 ..  2;
      UCSTPIE  at 0 range  3 ..  3;
      UCALIE   at 0 range  4 ..  4;
      UCNACKIE at 0 range  5 ..  5;
      UCBCNTIE at 0 range  6 ..  6;
      UCCLTOIE at 0 range  7 ..  7;
      UCRXIE1  at 0 range  8 ..  8;
      UCTXIE1  at 0 range  9 ..  9;
      UCRXIE2  at 0 range 10 .. 10;
      UCTXIE2  at 0 range 11 .. 11;
      UCRXIE3  at 0 range 12 .. 12;
      UCTXIE3  at 0 range 13 .. 13;
      UCBIT9IE at 0 range 14 .. 14;
      Reserved at 0 range 15 .. 15;
   end record;

   -- 26.4.16 UCBxIFG Register

   type UCBxIFG_Type is record
      UCRXIFG0  : Boolean := False; -- eUSCI_B receive interrupt flag 0.
      UCTXIFG0  : Boolean := False; -- eUSCI_B transmit interrupt flag 0.
      UCSTTIFG  : Boolean := False; -- START condition interrupt flag
      UCSTPIFG  : Boolean := False; -- STOP condition interrupt flag
      UCALIFG   : Boolean := False; -- Arbitration lost interrupt flag
      UCNACKIFG : Boolean := False; -- Not-acknowledge received interrupt flag.
      UCBCNTIFG : Boolean := False; -- Byte counter interrupt flag.
      UCCLTOIFG : Boolean := False; -- Clock low timeout interrupt flag
      UCRXIFG1  : Boolean := False; -- Receive interrupt flag 1.
      UCTXIFG1  : Boolean := True;  -- eUSCI_B transmit interrupt flag 1.
      UCRXIFG2  : Boolean := False; -- Receive interrupt flag 2.
      UCTXIFG2  : Boolean := False; -- eUSCI_B transmit interrupt flag 2.
      UCRXIFG3  : Boolean := False; -- Receive interrupt flag 3.
      UCTXIFG3  : Boolean := True;  -- eUSCI_B transmit interrupt flag 3.
      UCBIT9IFG : Boolean := False; -- Bit position 9 interrupt flag
      Reserved  : Bits_1  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxIFG_Type use record
      UCRXIFG0  at 0 range  0 ..  0;
      UCTXIFG0  at 0 range  1 ..  1;
      UCSTTIFG  at 0 range  2 ..  2;
      UCSTPIFG  at 0 range  3 ..  3;
      UCALIFG   at 0 range  4 ..  4;
      UCNACKIFG at 0 range  5 ..  5;
      UCBCNTIFG at 0 range  6 ..  6;
      UCCLTOIFG at 0 range  7 ..  7;
      UCRXIFG1  at 0 range  8 ..  8;
      UCTXIFG1  at 0 range  9 ..  9;
      UCRXIFG2  at 0 range 10 .. 10;
      UCTXIFG2  at 0 range 11 .. 11;
      UCRXIFG3  at 0 range 12 .. 12;
      UCTXIFG3  at 0 range 13 .. 13;
      UCBIT9IFG at 0 range 14 .. 14;
      Reserved  at 0 range 15 .. 15;
   end record;

   -- 26.4.17 UCBxIV Register

   -- UCIVx_NONE already defined at 24.4.12
   -- UCIVx_NONE      : constant := 16#00#; -- No interrupt pending
   UCIVx_UCALIFG   : constant := 16#02#; -- Interrupt Source: Arbitration lost; Interrupt Flag: UCALIFG; Interrupt Priority: Highest
   UCIVx_UCNACKIFG : constant := 16#04#; -- Interrupt Source: Not acknowledgment; Interrupt Flag: UCNACKIFG
   UCIVx_UCSTTIFG  : constant := 16#06#; -- Interrupt Source: Start condition received; Interrupt Flag: UCSTTIFG
   UCIVx_UCSTPIFG  : constant := 16#08#; -- Interrupt Source: Stop condition received; Interrupt Flag: UCSTPIFG
   UCIVx_UCRXIFG3  : constant := 16#0A#; -- Interrupt Source: Slave 3 Data received; Interrupt Flag: UCRXIFG3
   UCIVx_UCTXIFG3  : constant := 16#0C#; -- Interrupt Source: Slave 3 Transmit buffer empty; Interrupt Flag: UCTXIFG3
   UCIVx_UCRXIFG2  : constant := 16#0E#; -- Interrupt Source: Slave 2 Data received; Interrupt Flag: UCRXIFG2
   UCIVx_UCTXIFG2  : constant := 16#10#; -- Interrupt Source: Slave 2 Transmit buffer empty; Interrupt Flag: UCTXIFG2
   UCIVx_UCRXIFG1  : constant := 16#12#; -- Interrupt Source: Slave 1 Data received; Interrupt Flag: UCRXIFG1
   UCIVx_UCTXIFG1  : constant := 16#14#; -- Interrupt Source: Slave 1 Transmit buffer empty; Interrupt Flag: UCTXIFG1
   UCIVx_UCRXIFG0  : constant := 16#16#; -- Interrupt Source: Data received; Interrupt Flag: UCRXIFG0
   UCIVx_UCTXIFG0  : constant := 16#18#; -- Interrupt Source: Transmit buffer empty; Interrupt Flag: UCTXIFG0
   UCIVx_UCBCNTIFG : constant := 16#1A#; -- Interrupt Source: Byte counter zero; Interrupt Flag: UCBCNTIFG
   UCIVx_UCCLTOIFG : constant := 16#1C#; -- Interrupt Source: Clock low timeout; Interrupt Flag: UCCLTOIFG
   UCIVx_UCBIT9IFG : constant := 16#1E#; -- Interrupt Source: 9th bit position; Interrupt Flag: UCBIT9IFG; Priority: Lowest

   type UCBxIV_Type is record
      UCIVx : Unsigned_16; -- eUSCI_B interrupt vector value.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for UCBxIV_Type use record
      UCIVx at 0 range 0 .. 15;
   end record;

   -- 26.4 eUSCI_B I2C Registers

   type eUSCI_B0_I2C_Type is record
      UCBxCTLW0   : UCBxCTLW0_Type   with Volatile_Full_Access => True;
      UCBxCTLW1   : UCBxCTLW1_Type   with Volatile_Full_Access => True;
      UCBxBRW     : UCBxBRW_Type     with Volatile_Full_Access => True;
      UCBxSTATW   : UCBxSTATW_Type   with Volatile_Full_Access => True;
      UCBxTBCNT   : UCBxTBCNT_Type   with Volatile_Full_Access => True;
      UCBxRXBUF   : UCBxRXBUF_Type   with Volatile_Full_Access => True;
      UCBxTXBUF   : UCBxTXBUF_Type   with Volatile_Full_Access => True;
      UCBxI2COA0  : UCBxI2COA0_Type  with Volatile_Full_Access => True;
      UCBxI2COA1  : UCBxI2COA1_Type  with Volatile_Full_Access => True;
      UCBxI2COA2  : UCBxI2COA2_Type  with Volatile_Full_Access => True;
      UCBxI2COA3  : UCBxI2COA3_Type  with Volatile_Full_Access => True;
      UCBxADDRX   : UCBxADDRX_Type   with Volatile_Full_Access => True;
      UCBxADDMASK : UCBxADDMASK_Type with Volatile_Full_Access => True;
      UCBxI2CSA   : UCBxI2CSA_Type   with Volatile_Full_Access => True;
      UCBxIE      : UCBxIE_Type      with Volatile_Full_Access => True;
      UCBxIFG     : UCBxIFG_Type     with Volatile_Full_Access => True;
      UCBxIV      : UCBxIV_Type      with Volatile_Full_Access => True;
   end record
      with Object_Size => 16#30# * 8;
   for eUSCI_B0_I2C_Type use record
      UCBxCTLW0   at 16#00# range 0 .. 15;
      UCBxCTLW1   at 16#02# range 0 .. 15;
      UCBxBRW     at 16#06# range 0 .. 15;
      UCBxSTATW   at 16#08# range 0 .. 15;
      UCBxTBCNT   at 16#0A# range 0 .. 15;
      UCBxRXBUF   at 16#0C# range 0 .. 15;
      UCBxTXBUF   at 16#0E# range 0 .. 15;
      UCBxI2COA0  at 16#14# range 0 .. 15;
      UCBxI2COA1  at 16#16# range 0 .. 15;
      UCBxI2COA2  at 16#18# range 0 .. 15;
      UCBxI2COA3  at 16#1A# range 0 .. 15;
      UCBxADDRX   at 16#1C# range 0 .. 15;
      UCBxADDMASK at 16#1E# range 0 .. 15;
      UCBxI2CSA   at 16#20# range 0 .. 15;
      UCBxIE      at 16#2A# range 0 .. 15;
      UCBxIFG     at 16#2C# range 0 .. 15;
      UCBxIV      at 16#2E# range 0 .. 15;
   end record;

   -- Table 6-10. eUSCI_B0 Registers

   eUSCI_B0_I2C_ADDRESS : constant := 16#4000_2000#;

   eUSCI_B0_I2C : aliased eUSCI_B0_I2C_Type
      with Address    => System'To_Address (eUSCI_B0_I2C_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 27 LCD_F Controller
   ----------------------------------------------------------------------------

   -- 27.3.1 LCDCTL Register
   -- 27.3.2 LCDBMCTL Register
   -- 27.3.3 LCDVCTL Register
   -- 27.3.4 LCDPCTL0 Register
   -- 27.3.5 LCDPCTL1 Register
   -- 27.3.6 LCDCSSEL0 Register
   -- 27.3.7 LCDCSSEL1 Register
   -- 27.3.8 LCDANMCTL Register
   -- 27.3.9 LCDIE Register
   -- 27.3.10 LCDIFG Register
   -- 27.3.11 LCDSETIFG Register
   -- 27.3.12 LCDCLRIFG Register
   -- 27.3.13 LCDM[index] Register
   -- 27.3.14 LCDBM[index] Register
   -- 27.3.15 LCDANM[index] Register

pragma Style_Checks (On);

end MSP432P401R;
