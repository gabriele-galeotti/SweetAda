
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
      P2.PxDIR (0) := True;
      P2.PxDIR (1) := True;
      P2.PxDIR (2) := True;
      Dummy := 1;
      while True loop
         P2.PxOUT (0) := (Dummy and 2#001#) /= 0;
         P2.PxOUT (1) := (Dummy and 2#010#) /= 0;
         P2.PxOUT (2) := (Dummy and 2#100#) /= 0;
         Dummy := Shift_Left (@, 1);
         if Dummy > 7 then
            Dummy := 1;
         end if;
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
      end loop;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
