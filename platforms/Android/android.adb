-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ android.adb                                                                                               --
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
with System.Machine_Code;
with Interfaces;
with Definitions;
with Console;
with Time;

package body Android
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Machine_Code;
   use Interfaces;
   use Definitions;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   --   arch    syscall#    return  arg0    arg1    arg2    arg3    arg4    arg5
   --   ARM     R7          R0      R0      R1      R2      R3      R4      R5
   --   ARM64   X8          X0      X0      X1      X2      X3      X4      X5

   SYSCALL_CLOSE         : constant := 57;
   SYSCALL_READ          : constant := 63;
   SYSCALL_WRITE         : constant := 64;
   SYSCALL_EXIT          : constant := 93;
   SYSCALL_CLOCK_GETTIME : constant := 113;
   SYSCALL_UNAME         : constant := 160;
   SYSCALL_GETTIMEOFDAY  : constant := 169;
   SYSCALL_GETPID        : constant := 172;
   SYSCALL_EXECVE        : constant := 221;

   STDOUT_FILENO : constant := 1;

   ----------------------------------------------------------------------------
   -- Print_Message
   ----------------------------------------------------------------------------
   procedure Print_Message
      (Message : in String)
      is
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mov     x0,%0" & CRLF &
                       "        mov     x1,%1" & CRLF &
                       "        mov     x2,%2" & CRLF &
                       "        mov     x8,%3" & CRLF &
                       "        svc     #0   " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_64'Asm_Input ("i", STDOUT_FILENO),
                        Address'Asm_Input ("r", Message'Address),
                        Integer'Asm_Input ("r", Message'Length),
                        Unsigned_64'Asm_Input ("i", SYSCALL_WRITE)
                       ],
           Clobber  => "x0,x1,x2,x8",
           Volatile => True
          );
   end Print_Message;

   type Old_UTSName_Type is record
      nodename : String (1 .. 65);
      release  : String (1 .. 65);
      version  : String (1 .. 65);
      machine  : String (1 .. 65);
   end record
      with Size => 65 * 4 * 8,
           Pack => True;

   ----------------------------------------------------------------------------
   -- Uname_Get
   ----------------------------------------------------------------------------
   procedure Uname_Get
      is
      Uname : Old_UTSName_Type;
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mov     x0,%0" & CRLF &
                       "        mov     x8,%1" & CRLF &
                       "        svc     #0   " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Address'Asm_Input ("r", Uname'Address),
                        Unsigned_64'Asm_Input ("i", SYSCALL_UNAME)
                       ],
           Clobber  => "x0,x8",
           Volatile => True
          );
      Console.Print_ASCIIZ_String (Prefix => "nodename: ", String_Address => Uname.nodename'Address, NL => True);
      Console.Print_ASCIIZ_String (Prefix => "release:  ", String_Address => Uname.release'Address,  NL => True);
      Console.Print_ASCIIZ_String (Prefix => "version:  ", String_Address => Uname.version'Address,  NL => True);
      Console.Print_ASCIIZ_String (Prefix => "machine:  ", String_Address => Uname.machine'Address,  NL => True);
   end Uname_Get;

   type Timeval_Type is record
      tv_sec  : Unsigned_32;
      tv_usec : Unsigned_32;
   end record
      with Pack => True;

   type Timezone_Type is record
      tz_minuteswest : Integer;
      tz_dsttime     : Integer;
   end record
      with Pack => True;

   ----------------------------------------------------------------------------
   -- Gettimeofday
   ----------------------------------------------------------------------------
   procedure Gettimeofday
      is
      tv     : Timeval_Type;
      tz     : Timezone_Type;
      Status : Unsigned_64;
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mov     x0,%1" & CRLF &
                       "        mov     x1,%2" & CRLF &
                       "        mov     x8,%3" & CRLF &
                       "        svc     #0   " & CRLF &
                       "        mov     %0,x0" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=r", Status),
           Inputs   => [
                        Address'Asm_Input ("r", tv'Address),
                        Address'Asm_Input ("r", tz'Address),
                        Unsigned_64'Asm_Input ("i", SYSCALL_GETTIMEOFDAY)
                       ],
           Clobber  => "x0,x1,x8",
           Volatile => True
          );
      Console.Print (Prefix => "TV.sec:  ", Value => tv.tv_sec, NL => True);
      Console.Print (Prefix => "TV.usec: ", Value => tv.tv_usec, NL => True);
      Console.Print (Prefix => "TZ.mws:  ", Value => tz.tz_minuteswest, NL => True);
      Console.Print (Prefix => "TZ.dst:  ", Value => tz.tz_dsttime, NL => True);
      declare
         TM : Time.TM_Time;
      begin
         Time.Make_Time (tv.tv_sec, TM);
         Console.Print ("Current date: ", NL => False);
         Console.Print (TM.Year + 1_900, NL => False);
         Console.Print ("-", NL => False);
         Console.Print (TM.Mon + 1, NL => False);
         Console.Print ("-", NL => False);
         Console.Print (TM.MDay, NL => False);
         Console.Print (" ", NL => False);
         Console.Print (TM.Hour, NL => False);
         Console.Print (":", NL => False);
         Console.Print (TM.Min, NL => False);
         Console.Print (":", NL => False);
         Console.Print (TM.Sec, NL => False);
         Console.Print_NewLine;
      end;
   end Gettimeofday;

   ----------------------------------------------------------------------------
   -- Getpid
   ----------------------------------------------------------------------------
   procedure Getpid
      is
      Pid : Unsigned_64;
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mov     x8,%1" & CRLF &
                       "        svc     #0   " & CRLF &
                       "        mov     %0,x0" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=r", Pid),
           Inputs   => Unsigned_64'Asm_Input ("i", SYSCALL_GETPID),
           Clobber  => "x0,x8",
           Volatile => True
          );
      Console.Print (Prefix => "PID: ", Value => Pid, NL => True);
   end Getpid;

   ----------------------------------------------------------------------------
   -- System_Exit
   ----------------------------------------------------------------------------
   procedure System_Exit
      (Exit_Status : in Integer)
      is
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mov     x0,%0" & CRLF &
                       "        mov     x8,%1" & CRLF &
                       "        svc     #0   " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_64'Asm_Input ("r", Unsigned_64 (Exit_Status)),
                        Unsigned_64'Asm_Input ("i", SYSCALL_EXIT)
                       ],
           Clobber  => "x0,x8",
           Volatile => True
          );
   end System_Exit;

end Android;
