
with Interfaces;
with MSP432P401R;
with CPU;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use MSP432P401R;

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
      Delay_Count : constant := 300_000;
      Dummy       : Unsigned_8;
   begin
      -- blink on-board LED2
      P2DIR_L := P2DIR_L or 16#07#;
      Dummy := 0;
      while True loop
         P2OUT_L := Dummy;
         Dummy := @ + 1;
         if Dummy > 7 then
            Dummy := 0;
         end if;
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
      end loop;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
