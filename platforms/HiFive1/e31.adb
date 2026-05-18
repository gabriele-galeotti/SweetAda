-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ e31.adb                                                                                                   --
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

with System.Machine_Code;
with Definitions;

package body E31
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;

   CRLF : String renames Definitions.CRLF;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- Implemented as state machine in L1 D$, for cores with data caches.
   procedure CFLUSH_D_L1
      (VAddress : in Integer_Address)
      is
   begin
      if VAddress /= 0 then
         Asm (
              Template => ""                                     & CRLF &
                          "        .insn   i 0x73,0,x0,%0,-0x40" & CRLF &
                          "",
              Outputs  => No_Output_Operands,
              Inputs   => Integer_Address'Asm_Input ("r", VAddress),
              Clobber  => "",
              Volatile => True
             );
      else
         Asm (
              Template => ""                                     & CRLF &
                          "        .insn   i 0x73,0,x0,x0,-0x40" & CRLF &
                          "",
              Outputs  => No_Output_Operands,
              Inputs   => No_Input_Operands,
              Clobber  => "",
              Volatile => True
             );
      end if;
   end CFLUSH_D_L1;

   -- Implemented as state machine in L1 D$, for cores with data caches.
   procedure CDISCARD_D_L1
      (VAddress : in Integer_Address)
      is
   begin
      if VAddress /= 0 then
         Asm (
              Template => ""                                     & CRLF &
                          "        .insn   i 0x73,0,x0,%0,-0x3E" & CRLF &
                          "",
              Outputs  => No_Output_Operands,
              Inputs   => Integer_Address'Asm_Input ("r", VAddress),
              Clobber  => "",
              Volatile => True
             );
      else
         Asm (
              Template => ""                                     & CRLF &
                          "        .insn   i 0x73,0,x0,x0,-0x3E" & CRLF &
                          "",
              Outputs  => No_Output_Operands,
              Inputs   => No_Input_Operands,
              Clobber  => "",
              Volatile => True
             );
      end if;
   end CDISCARD_D_L1;

end E31;
