
with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;
with CPU;
with RISCV;
with Virt;
with Console;
with BSP;
with Goldfish;
with Time;

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
   SP1 : aliased array (0 .. 2**12 - 1) of MXLEN_Type;
   SP2 : aliased array (0 .. 2**12 - 1) of MXLEN_Type;
   SP3 : aliased array (0 .. 2**12 - 1) of MXLEN_Type;

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
      Delay_Count : constant := 100_000_000;
      HartID      : MXLEN_Type;
      C           : Character;
   begin
      HartID := mhartid_Read;
      case HartID is
         when 1      => C := '1';
         when 2      => C := '2';
         when 3      => C := '3';
         when others => C := 'X';
      end case;
      loop
         -- need a lock on the device, just use it for a demo
         BSP.Console_Putchar (C);
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
            AP_sp (1) := To_MXLEN (SP1 (SP1'Last)'Address) + MXLEN_Type'Size / 8;
            AP_pc (1) := To_MXLEN (StartAP'Address);
            AP_sp (2) := To_MXLEN (SP2 (SP2'Last)'Address) + MXLEN_Type'Size / 8;
            AP_pc (2) := To_MXLEN (StartAP'Address);
            AP_sp (3) := To_MXLEN (SP3 (SP3'Last)'Address) + MXLEN_Type'Size / 8;
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
               Console.Print (Time.Day_Of_Week (Time.NDay_Of_Week (TM.MDay, TM.Mon + 1, TM.Year + 1_900)));
               Console.Print (" ");
               Console.Print (Time.Month_Name (TM.Mon + 1));
               Console.Print (" ");
               Console.Print (TM.MDay);
               Console.Print (" ");
               Console.Print (TM.Year + 1_900);
               Console.Print (" ");
               Console.Print (TM.Hour);
               Console.Print (":");
               Console.Print (TM.Min);
               Console.Print (":");
               Console.Print (TM.Sec);
               Console.Print_NewLine;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
