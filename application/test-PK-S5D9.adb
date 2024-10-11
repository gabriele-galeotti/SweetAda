
with Interfaces;
with Bits;
with CPU;
with S5D9;
with LCD;
with BSP;

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
   use S5D9;

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
      declare
         Delay_Count : constant := 5_000_000;
         C           : Unsigned_8;
      begin
         C := 16#20#;
         while True loop
            -- blink LED3 (yellow)
            PORT (6).PODR.PODR02 := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            PORT (6).PODR.PODR02 := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            BSP.Console_Putchar (Bits.To_Ch (C));
            C := @ + 1;
            if C > 16#7F# then
               C := 16#20#;
            end if;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
