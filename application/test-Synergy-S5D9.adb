
with Interfaces;
with Bits;
with CPU;
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

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run is
   begin
      PFSR (P600).PMR := False;
      PORT (6).PDR.PDR00 := True;
      PORT (6).PODR.PODR00 := True; -- LED1 (green) off
      PFSR (P601).PMR := False;
      PORT (6).PDR.PDR01 := True;
      PORT (6).PODR.PODR01 := True; -- LED2 (red) off
      PFSR (P602).PMR := False;
      PORT (6).PDR.PDR02 := True;
      PORT (6).PODR.PODR02 := True; -- LED3 (yellow) off
      -- blink LED3 -----------------------------------------------------------
      declare
         Delay_Count : constant := 5_000_000;
         C           : Unsigned_8;
      begin
         C := 16#20#;
         while True loop
            PORT (6).PODR.PODR02 := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            PORT (6).PODR.PODR02 := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
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
