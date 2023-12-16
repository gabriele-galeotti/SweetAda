-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv7m-fpu.ads                                                                                            --
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

package ARMv7M.FPU
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- B3.2.21 Floating Point Context Control Register, FPCCR

   type FPCCR_Type is record
      LSPACT    : Boolean;      -- Indicates whether Lazy preservation of the FP state is active
      USER      : Boolean;      -- Indicates the privilege level ... when the processor allocated the FP stack frame
      Reserved1 : Bits_1 := 0;
      THREAD    : Boolean;      -- Indicates the processor mode when it allocated the FP stack frame
      HFRDY     : Boolean;      -- Indicates whether the ... FP stack able to set the HardFault exception to pending
      MMRDY     : Boolean;      -- Indicates whether the ... FP stack frame was able to set the MemManage exception to pending
      BFRDY     : Boolean;      -- Indicates whether the ... FP stack frame was able to set the BusFault exception to pending
      Reserved2 : Bits_1 := 0;
      MONRDY    : Boolean;      -- Indicates whether the ... FP stack frame was able to set the DebugMonitor exception to pending
      Reserved3 : Bits_21 := 0;
      LSPEN     : Boolean;      -- Enables lazy context save of FP state
      ASPEN     : Boolean;      -- When this bit is set to 1, execution of a floating-point instr sets the CONTROL.FPCA bit to 1
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FPCCR_Type use record
      LSPACT    at 0 range  0 ..  0;
      USER      at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  2;
      THREAD    at 0 range  3 ..  3;
      HFRDY     at 0 range  4 ..  4;
      MMRDY     at 0 range  5 ..  5;
      BFRDY     at 0 range  6 ..  6;
      Reserved2 at 0 range  7 ..  7;
      MONRDY    at 0 range  8 ..  8;
      Reserved3 at 0 range  9 .. 29;
      LSPEN     at 0 range 30 .. 30;
      ASPEN     at 0 range 31 .. 31;
   end record;

   FPCCR : aliased FPCCR_Type
      with Address              => To_Address (FPCCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- B3.2.22 Floating Point Context Address Register, FPCAR

   type FPCAR_Type is record
      Reserved : Bits_3 := 0;
      ADDRESS  : Bits_29;     -- The location of the unpopulated floating-point reg space allocated on an exception stack frame.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FPCAR_Type use record
      Reserved at 0 range 0 ..  2;
      ADDRESS  at 0 range 3 .. 31;
   end record;

   FPCAR : aliased FPCAR_Type
      with Address              => To_Address (FPCAR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- A2.5.3 Floating-point Status and Control Register, FPSCR

   RMode_RN : constant := 2#00#; -- Round to Nearest (RN) mode.
   RMode_RP : constant := 2#01#; -- Round towards Plus Infinity (RP) mode.
   RMode_RM : constant := 2#10#; -- Round towards Minus Infinity (RM) mode.
   RMode_RZ : constant := 2#11#; -- Round towards Zero (RZ) mode.

   type FPSCR_Type is record
      IOC       : Boolean;      -- Invalid Operation cumulative exception bit.
      DZC       : Boolean;      -- Division by Zero cumulative exception bit.
      OFC       : Boolean;      -- Overflow cumulative exception bit.
      UFC       : Boolean;      -- Underflow cumulative exception bit.
      IXC       : Boolean;      -- Inexact cumulative exception bit.
      Reserved1 : Bits_2 := 0;
      IDC       : Boolean;      -- Input Denormal cumulative exception bit.
      Reserved2 : Bits_14 := 0;
      RMode     : Bits_2;       -- Rounding mode control field.
      FZ        : Boolean;      -- Flush-to-zero mode control bit
      DN        : Boolean;      -- Default NaN mode control bit
      AHP       : Boolean;      -- Alternative half-precision control bit
      Reserved3 : Bits_1 := 0;
      V         : Boolean;      -- Overflow condition flag.
      C         : Boolean;      -- Carry condition flag.
      Z         : Boolean;      -- Zero condition flag.
      N         : Boolean;      -- Negative condition flag.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FPSCR_Type use record
      IOC       at 0 range  0 ..  0;
      DZC       at 0 range  1 ..  1;
      OFC       at 0 range  2 ..  2;
      UFC       at 0 range  3 ..  3;
      IXC       at 0 range  4 ..  4;
      Reserved1 at 0 range  5 ..  6;
      IDC       at 0 range  7 ..  7;
      Reserved2 at 0 range  8 .. 21;
      RMode     at 0 range 22 .. 23;
      FZ        at 0 range 24 .. 24;
      DN        at 0 range 25 .. 25;
      AHP       at 0 range 26 .. 26;
      Reserved3 at 0 range 27 .. 27;
      V         at 0 range 28 .. 28;
      C         at 0 range 29 .. 29;
      Z         at 0 range 30 .. 30;
      N         at 0 range 31 .. 31;
   end record;

   function FPSCR_Read
      return FPSCR_Type;
   procedure FPSCR_Write
      (Value : in FPSCR_Type);

   -- B3.2.23 Floating Point Default Status Control Register, FPDSCR

   type FPDSCR_Type is record
      Reserved1 : Bits_22 := 0;
      RMode     : Bits_2;       -- Default value for FPSCR.RMode.
      FZ        : Boolean;      -- Default value for FPSCR.FZ.
      DN        : Boolean;      -- Default value for FPSCR.DN.
      AHP       : Boolean;      -- Default value for FPSCR.AHP.
      Reserved2 : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FPDSCR_Type use record
      Reserved1 at 0 range  0 .. 21;
      RMode     at 0 range 22 .. 23;
      FZ        at 0 range 24 .. 24;
      DN        at 0 range 25 .. 25;
      AHP       at 0 range 26 .. 26;
      Reserved2 at 0 range 27 .. 31;
   end record;

   FPDSCR : aliased FPDSCR_Type
      with Address              => To_Address (FPDSCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

end ARMv7M.FPU;
