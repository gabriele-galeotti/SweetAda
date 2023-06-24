
with System.Storage_Elements;
with Interfaces;
with Configure;
with MMIO;
with MIPS;
with R3000;
with CPU;
with KN02BA;
with Console;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use MIPS;
   use R3000;
   use KN02BA;

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
   procedure Run is
   begin
      -- rear LEDs test -------------------------------------------------------
      if True then
         declare
            Delay_Count : Integer;
         begin
            Delay_Count := (if Configure.BOOT_FROM_NETWORK then 5_000_000 else 100_000);
            loop
               IOASIC_SSR.LED0 := False;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               IOASIC_SSR.LED0 := True;
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
