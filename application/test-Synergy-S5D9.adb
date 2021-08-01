
with Interfaces;
with Bits;
with S5D9;
with LCD;

package body Application is

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

   procedure Run is
   begin
      -- blink on-board LED3 (yellow) pin 120 port P602: GPIO output ----------
      PFSR (P602).PMR := False;
      PORT (6).PDR.PDR02 := True;
      -- test loop
      declare
         Delay_Count : constant := 5_000_000;
         C           : Unsigned_8;
      begin
         C := 16#20#;
         while True loop
            PORT (6).PODR.PODR02 := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            PORT (6).PODR.PODR02 := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            SCI (3).TDR := C;
            C := C + 1;
            if C > 16#7F# then
               C := 16#20#;
            end if;
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
