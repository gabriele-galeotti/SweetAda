-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ touchscreen.adb                                                                                           --
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

with S5D9;

package body Touchscreen
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use S5D9;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   -- SX8676IWLTRT
   ----------------------------------------------------------------------------
   procedure Init
      is
      Pinf : PFSR_Type;
   begin
      -- ADDRESS = 0x48
      -- pin 609 (NRST) function = I/O
      Pinf := PFSR (P609);
      Pinf.PMR := False;
      PFSR (P100) := Pinf;
      -- pin 004 (NIRQ) function =
      -- per IRQ settare ISEL su port 0
      -- pin 511 (SDA) function = IIC (channel 2)
      Pinf := PFSR (P511);
      Pinf.PSEL := PSEL_IIC;
      Pinf.PMR  := True;
      PFSR (P511) := Pinf;
      -- pin 512 (SCL) function = IIC (channel 2)
      Pinf := PFSR (P512);
      Pinf.PSEL := PSEL_IIC;
      Pinf.PMR  := True;
      PFSR (P512) := Pinf;
      -- send RESET
   end Init;

end Touchscreen;
