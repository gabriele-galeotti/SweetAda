
with Interfaces;
with CPU;
with HiFive1;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

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
      HiFive1.LEDs_IOF  := HiFive1.LEDs_IOF and 16#FF97_FFFF#;
      HiFive1.LEDs_PORT := HiFive1.LEDs_PORT or 16#0068_0000#;
      HiFive1.LEDs_OEN  := HiFive1.LEDs_OEN or 16#0068_0000#;
      declare
         Delay_Count : constant := 5_000_000;
      begin
         while True loop
            -- turn on RED
            HiFive1.LEDs_PORT := @ and 16#FFBF_FFFF#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            HiFive1.LEDs_PORT := @ or 16#0068_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- turn on GREEN
            HiFive1.LEDs_PORT := @ and 16#FFF7_FFFF#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            HiFive1.LEDs_PORT := @ or 16#0068_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- turn on BLUE
            HiFive1.LEDs_PORT := @ and 16#FFDF_FFFF#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            HiFive1.LEDs_PORT := @ or 16#0068_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
