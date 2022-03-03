
with Interfaces;
with MSP432P401R;

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
      Delay_Count : constant := 500_000;
      Dummy       : Unsigned_8;
   begin
      WDTCTL := 16#5A84#; -- stop WDT
      -- blink on-board LED
      PADIR_L := PADIR_L or 16#01#;
      Dummy := PAOUT_L;
      while True loop
         Dummy := Dummy xor 1;
         PAOUT_L := Dummy;
         for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
--          Dummy := Dummy xor 1;
--          PAOUT_L := Dummy;
--          for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
      end loop;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
