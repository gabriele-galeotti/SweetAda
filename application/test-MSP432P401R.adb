
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
      Delay_Count : constant := 100_000;
      Dummy       : Unsigned_8;
   begin
      WDTCTL := 16#5A84#; -- stop WDT
      -- blink on-board LED1
      PADIR_L := PADIR_L or 16#01#;
      Dummy := PAOUT_L;
      while True loop
         Dummy := Dummy xor 1;
         PAOUT_L := Dummy;
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
      end loop;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
