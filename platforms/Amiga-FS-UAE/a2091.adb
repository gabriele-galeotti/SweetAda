-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ a2091.adb                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with MMIO;
with LLutils;
with Memory_Functions;
with Amiga;
with Console;

package body A2091 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Amiga;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Probe
   ----------------------------------------------------------------------------
   procedure Probe (Success : out Boolean) is
      type Offset_Byte is
      record
         Offset : Storage_Offset;
         Value  : Unsigned_8;
      end record;
      -- A2091 Zorro II signature
      A2091_Pattern : constant array (Natural range <>) of Offset_Byte :=
         (
          (16#00#,     16#C1#), -- Type
          (16#04#, not 16#03#), -- Product
          (16#10#, not 16#02#), -- Manufacturer (HIGH)
          (16#14#, not 16#02#)  -- Manufacturer (LOW)
         );
   begin
      -- check for A2091 signature
      for Index in A2091_Pattern'Range loop
         if ZorroII_Signature_Read (A2091_Pattern (Index).Offset) /= A2091_Pattern (Index).Value then
            Success := False;
            return;
         end if;
      end loop;
      -- log informations
      Console.Print (Unsigned_32'(0), Prefix => "A2091: SCSI card @ ", NL => True);
--       Console.Print (Unsigned_32'(A2065_BASEADDRESS), Prefix => "A2091: SCSI card @ ", NL => True);
--       -- configure A2065 address
--       MMIO.Write (ZorroII_Cfg_Space'Address + 16#48#, NByte (Unsigned_32'(A2065_BASEADDRESS)));
--       MMIO.Write (ZorroII_Cfg_Space'Address + 16#44#, HByte (Unsigned_32'(A2065_BASEADDRESS)));
      Success := True;
   end Probe;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
   begin
      null;
   end Init;

end A2091;
