-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ p8.adb                                                                                                    --
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

with System.Machine_Code;
with Definitions;

package body P8 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use Interfaces;

   CRLF : String renames Definitions.CRLF;

   procedure SYNC
      with Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- SYNC
   ----------------------------------------------------------------------------
   procedure SYNC
      is
   begin
      Asm (
           Template => ""             & CRLF &
                       "        sync" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end SYNC;

   ----------------------------------------------------------------------------
   -- HMER_Clear
   ----------------------------------------------------------------------------
   procedure HMER_Clear
      is
      HMER            : constant := 16#150#;
      -- FAIL + DONE + STATUS
      HMER_CLEAR_MASK : constant := 16#00C0_0700_0000_0000#;
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mtspr   %0,%1" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Integer'Asm_Input ("i", HMER),
                        Unsigned_64'Asm_Input ("r", HMER_CLEAR_MASK)
                       ],
           Clobber  => "memory",
           Volatile => True
          );
   end HMER_Clear;

   ----------------------------------------------------------------------------
   -- HMER_Read
   ----------------------------------------------------------------------------
   function HMER_Read
      return Unsigned_64
      is
      HMER  : constant := 16#150#;
      Value : Unsigned_64;
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mfspr   %0,%1" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=r", Value),
           Inputs   => Integer'Asm_Input ("i", HMER),
           Clobber  => "memory",
           Volatile => True
          );
      return Value;
   end HMER_Read;

   ----------------------------------------------------------------------------
   -- XSCOM_Address
   ----------------------------------------------------------------------------
   function XSCOM_Address
      (Base   : Unsigned_64;
       Offset : Unsigned_64)
      return Integer_Address
      is
   begin
      return Integer_Address (
                (Shift_Left (Offset, 4) and not 16#FF#) or
                (Shift_Left (Offset, 3) and     16#78#) or
                Base
                );
   end XSCOM_Address;

   ----------------------------------------------------------------------------
   -- XSCOM_Wait_Done
   ----------------------------------------------------------------------------
   procedure XSCOM_Wait_Done
      is
      HMER : Unsigned_64 with Volatile => True;
   begin
      loop
         exit when (HMER_Read and 16#0040_0000_0000_0000#) /= 0;
      end loop;
      -- HW822317
      HMER := HMER_Read;
   end XSCOM_Wait_Done;

   ----------------------------------------------------------------------------
   -- XSCOM_In64
   ----------------------------------------------------------------------------
   function XSCOM_In64
      (Device_Address : Integer_Address)
      return Unsigned_64
      is
      Value : Unsigned_64;
   begin
      SYNC;
      -- Caching-inhibited storage
      Asm (
           Template => ""                        & CRLF &
                       "        .machine power8" & CRLF &
                       "        ldcix   %0,0,%1" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=r", Value),
           Inputs   => Integer_Address'Asm_Input ("r", Device_Address),
           Clobber  => "memory",
           Volatile => True
          );
      return Value;
   end XSCOM_In64;

   ----------------------------------------------------------------------------
   -- XSCOM_Out64
   ----------------------------------------------------------------------------
   procedure XSCOM_Out64
      (Device_Address : in Integer_Address;
       Value          : in Unsigned_64)
      is
   begin
      SYNC;
      -- Caching-inhibited storage
      Asm (
           Template => ""                        & CRLF &
                       "        .machine power8" & CRLF &
                       "        stdcix  %0,0,%1" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_64'Asm_Input ("r", Value),
                        Integer_Address'Asm_Input ("r", Device_Address)
                       ],
           Clobber  => "memory",
           Volatile => True
          );
   end XSCOM_Out64;

end P8;
