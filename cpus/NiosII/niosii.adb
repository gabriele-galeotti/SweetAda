-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ niosii.adb                                                                                                --
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

package body NiosII
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

   ----------------------------------------------------------------------------
   -- status_Read/Write
   ----------------------------------------------------------------------------

   function status_Read
      return status_Type
      is
      Value : status_Type;
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        rdctl   %0,status" & CRLF &
                       "",
           Outputs  => status_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end status_Read;

   procedure status_Write
      (Value : in status_Type)
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        wrctl   status,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => status_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end status_Write;

   ----------------------------------------------------------------------------
   -- estatus_Read/Write
   ----------------------------------------------------------------------------

   function estatus_Read
      return status_Type
      is
      Value : status_Type;
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        rdctl   %0,estatus" & CRLF &
                       "",
           Outputs  => status_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end estatus_Read;

   procedure estatus_Write
      (Value : in status_Type)
      is
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        wrctl   estatus,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => status_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end estatus_Write;

   ----------------------------------------------------------------------------
   -- bstatus_Read/Write
   ----------------------------------------------------------------------------

   function bstatus_Read
      return status_Type
      is
      Value : status_Type;
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        rdctl   %0,bstatus" & CRLF &
                       "",
           Outputs  => status_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end bstatus_Read;

   procedure bstatus_Write
      (Value : in status_Type)
      is
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        wrctl   bstatus,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => status_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end bstatus_Write;

   ----------------------------------------------------------------------------
   -- ienable_Read/Write
   ----------------------------------------------------------------------------

   function ienable_Read
      return Bitmap_32
      is
      Value : Bitmap_32;
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        rdctl   %0,ienable" & CRLF &
                       "",
           Outputs  => Bitmap_32'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end ienable_Read;

   procedure ienable_Write
      (Value : in Bitmap_32)
      is
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        wrctl   ienable,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Bitmap_32'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end ienable_Write;

   ----------------------------------------------------------------------------
   -- ipending_Read
   ----------------------------------------------------------------------------
   function ipending_Read
      return Bitmap_32
      is
      Value : Bitmap_32;
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        rdctl   %0,ipending" & CRLF &
                       "",
           Outputs  => Bitmap_32'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end ipending_Read;

   ----------------------------------------------------------------------------
   -- cpuid_Read
   ----------------------------------------------------------------------------
   function cpuid_Read
      return Unsigned_32
      is
      Value : Unsigned_32;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        rdctl   %0,cpuid" & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end cpuid_Read;

   ----------------------------------------------------------------------------
   -- exception_control_Read
   ----------------------------------------------------------------------------
   function exception_control_Read
      return exception_control_Type
      is
      Value : exception_control_Type;
   begin
      Asm (
           Template => ""                             & CRLF &
                       "        rdctl   %0,exception" & CRLF &
                       "",
           Outputs  => exception_control_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end exception_control_Read;

   ----------------------------------------------------------------------------
   -- NOP
   ----------------------------------------------------------------------------
   procedure NOP
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        nop" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end NOP;

   ----------------------------------------------------------------------------
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call
      (Target_Address : in Address)
      is
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        callr   %0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Address'Asm_Input ("r", Target_Address),
           Clobber  => "",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Irq_Enable/Disable
   ----------------------------------------------------------------------------

   procedure PIE_Set
      (PIE : in Boolean)
      is
      status : status_Type;
   begin
      status := status_Read;
      status.PIE := PIE;
      status_Write (status);
   end PIE_Set;

   procedure Irq_Enable
      is
   begin
      PIE_Set (True);
   end Irq_Enable;

   procedure Irq_Disable
      is
   begin
      PIE_Set (False);
   end Irq_Disable;

   function Irq_State_Get
      return Irq_State_Type
      is
   begin
      return status_Read.PIE;
   end Irq_State_Get;

   procedure Irq_State_Set
      (Irq_State : in Irq_State_Type)
      is
   begin
      PIE_Set (Irq_State);
   end Irq_State_Set;

end NiosII;
