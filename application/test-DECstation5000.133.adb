
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

   Dummy : Unsigned_32 := 16#AA55_AA55# with
      Volatile => True,
      Export   => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Run is
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : Integer;
         begin
            if Configure.BOOT_FROM_NETWORK then
               Delay_Count := 5_000_000; -- network boot, with cache
            else
               Delay_Count := 100_000;   -- ROM without cache
            end if;
            loop
               for Value in Unsigned_8'Range loop
                  if Dummy = 16#AA55_AA55# then
                     IOASIC_CSR.LED0 := False;
                     for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
                     IOASIC_CSR.LED0 := True;
                     for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
                     Console.Print ("OK", NL => True);
                  else
                     IOASIC_CSR.LED3 := False;
                     for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
                     IOASIC_CSR.LED3 := True;
                     for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
                  end if;
               end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
