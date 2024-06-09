
with Interfaces;
with CPU;
with Console;

with System; use System;
with Ada.Unchecked_Conversion;
with ARMv8A; use ARMv8A;
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

   use Interfaces;

   -- "application" cores

   AP_Key : aliased Unsigned_32
      with Atomic        => True,
           Export        => True,
           External_Name => "ap_key",
           Convention    => Asm;

   type AP_x_Type is array (0 .. 3) of Unsigned_64
      with Pack       => True,
           Convention => Asm;

   AP_sp : aliased AP_x_Type := [0, 0, 0, 0]
      with Export        => True,
           External_Name => "ap_sp";
   AP_pc : aliased AP_x_Type := [0, 0, 0, 0]
      with Export        => True,
           External_Name => "ap_pc";

   -- AP core stack size = 4 kB
   SP1 : aliased array (0 .. 2**12 - 1) of Unsigned_64;
   SP2 : aliased array (0 .. 2**12 - 1) of Unsigned_64;
   SP3 : aliased array (0 .. 2**12 - 1) of Unsigned_64;

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
      CoreID      : Unsigned_8;
      C           : Character;
      Delay_Count : Integer;
      Count       : Unsigned_32;
   begin
      CoreID := MPIDR_EL1_Read.Aff0;
      case CoreID is
         when 1      => C := '1'; Delay_Count := 47_000_000;
         when 2      => C := '2'; Delay_Count := 48_000_000;
         when 3      => C := '3'; Delay_Count := 49_000_000;
         when others => C := 'X'; Delay_Count := 50_000_000;
      end case;
      Count := 0;
      loop
         Mutex.Acquire (M);
         Console.Print ("Core #");
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
         AP_Key := 16#AA55_AA55#;
         declare
            function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
         begin
            AP_sp (1) := To_U64 (SP1 (SP1'Last)'Address) + 8;
            AP_pc (1) := To_U64 (StartAP'Address);
            AP_sp (2) := To_U64 (SP2 (SP2'Last)'Address) + 8;
            AP_pc (2) := To_U64 (StartAP'Address);
            AP_sp (3) := To_U64 (SP3 (SP3'Last)'Address) + 8;
            AP_pc (3) := To_U64 (StartAP'Address);
         end;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : Integer;
         begin
            Delay_Count := 50_000_000;
            loop
               Mutex.Acquire (M);
               Console.Print ("hello, SweetAda", NL => True);
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
