
with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Definitions;
with Bits;
with CPU;
with RISCV;
with Virt;
with Console;
with BSP;
with Goldfish;
with Time;
with LLutils;
with Mutex;

package body Application
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Definitions;
   use RISCV;

   -- "application" harts

   type AP_x_Type is array (0 .. 3) of MXLEN_Type
      with Pack       => True,
           Convention => Asm;

   AP_sp : aliased AP_x_Type := [0, 0, 0, 0]
      with Export        => True,
           External_Name => "ap_sp";
   AP_pc : aliased AP_x_Type := [0, 0, 0, 0]
      with Export        => True,
           External_Name => "ap_pc";

   -- AP hart stack size = 4 kB
   SP1 : aliased array (0 .. kB4 - 1) of Unsigned_8
      with Alignment => 8;
   SP2 : aliased array (0 .. kB4 - 1) of Unsigned_8
      with Alignment => 8;
   SP3 : aliased array (0 .. kB4 - 1) of Unsigned_8
      with Alignment => 8;

   -- Console mutex
   M : Mutex.Semaphore_Binary := Mutex.SEMAPHORE_UNLOCKED;

   procedure StartAP;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- StartAP
   ----------------------------------------------------------------------------
   procedure StartAP
      is
      HartID      : MXLEN_Type;
      C           : Character;
      Delay_Count : Integer;
      Count       : Unsigned_32;
   begin
      HartID := mhartid_Read;
      case HartID is
         when 1      => C := '1'; Delay_Count := 27_000_000;
         when 2      => C := '2'; Delay_Count := 28_000_000;
         when 3      => C := '3'; Delay_Count := 29_000_000;
         when others => C := 'X'; Delay_Count := 30_000_000;
      end case;
      Count := 0;
      loop
         Mutex.Acquire (M);
         Console.Print ("Hart #");
         Console.Print (C);
         Console.Print (": ");
         Console.Print (Count);
         Console.Print_NewLine;
         Mutex.Release (M);
         Count := @ + 1;
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
      end loop;
   end StartAP;

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run
      is
   begin
      -- start "application" harts --------------------------------------------
      if True then
         declare
            function To_MXLEN is new Ada.Unchecked_Conversion (Address, MXLEN_Type);
         begin
            AP_sp (1) := To_MXLEN (SP1 (SP1'Last)'Address) + 1;
            AP_pc (1) := To_MXLEN (StartAP'Address);
            AP_sp (2) := To_MXLEN (SP2 (SP2'Last)'Address) + 1;
            AP_pc (2) := To_MXLEN (StartAP'Address);
            AP_sp (3) := To_MXLEN (SP3 (SP3'Last)'Address) + 1;
            AP_pc (3) := To_MXLEN (StartAP'Address);
         end;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 300_000_000;
            TM          : Time.TM_Time;
         begin
            loop
               Goldfish.Read_Clock (BSP.RTC_Descriptor, TM);
               Mutex.Acquire (M);
               Console.Print (Prefix => "",  Value =>
                  Time.Day_Of_Week (Time.NDay_Of_Week (TM.MDay, TM.Mon + 1, TM.Year + 1_900)));
               Console.Print (Prefix => " ", Value => Time.Month_Name (TM.Mon + 1));
               Console.Print (Prefix => " ", Value => TM.MDay);
               Console.Print (Prefix => " ", Value => TM.Year + 1_900);
               Console.Print (Prefix => " ", Value => TM.Hour);
               Console.Print (Prefix => ":", Value => TM.Min);
               Console.Print (Prefix => ":", Value => TM.Sec);
               Console.Print_NewLine;
               Mutex.Release (M);
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
