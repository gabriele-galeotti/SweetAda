
with System.Storage_Elements;
with Ada.Characters.Latin_1;
with Interfaces;
with Configure;
with Core;
with Bits;
with BSP;
with CPU;
with Z8530;
with Sun4m;
with Console;

package body Application
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run
      is
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : Integer;
         begin
            if Configure.BOOT_FROM_NETWORK then
               Delay_Count := 5_000_000;
            else
               if BSP.QEMU then
                  -- QEMU machine
                  Delay_Count := 300_000_000;
               else
                  -- physical machine
                  Delay_Count := 50_000;
               end if;
            end if;
            loop
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               Console.Print ("hello, SweetAda", NL => True);
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
