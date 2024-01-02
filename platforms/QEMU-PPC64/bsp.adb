-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with Definitions;
with Bits;
with CPU;
with P8;
with Console;

package body BSP
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Definitions;
   use Interfaces;
   use Bits;
   use P8;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
      Data   : Unsigned_64;
      Lpccmd : LPC_CMD_Type;
   begin
      Data := Shift_Left (Unsigned_64 (To_U8 (C)), 56);
      HMER_Clear;
      XSCOM_Out64 (XSCOM_Address (XSCOM_BASEADDRESS, PNV_XSCOM_LPC_BASE + ECCB_DATA), Data);
      XSCOM_Wait_Done;
      Lpccmd := (Size => 1, Address => LPC_IO_OPB_ADDR + 16#3F8#, Read => False, others => <>);
      HMER_Clear;
      XSCOM_Out64 (XSCOM_Address (XSCOM_BASEADDRESS, PNV_XSCOM_LPC_BASE + ECCB_CTL), To_U64 (Lpccmd));
      XSCOM_Wait_Done;
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      Data := 0;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Power8 (QEMU emulator)", NL => True);
      -------------------------------------------------------------------------
      declare
         CFAM : Unsigned_64;
      begin
         HMER_Clear;
         CFAM := XSCOM_In64 (XSCOM_Address (XSCOM_BASEADDRESS, CFAM_REG));
         XSCOM_Wait_Done;
         Console.Print (CFAM, Prefix => "CFAM: ", NL => True);
      end;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
