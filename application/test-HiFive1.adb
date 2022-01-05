
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
      -- iof_sel GPIO #19/21/22 = IOF0
      HiFive1.GPIO_IOFSEL := @ and 16#FF97_FFFF#;
      HiFive1.GPIO_PORT   := @ or 16#0068_0000#;
      HiFive1.GPIO_OEN    := @ or 16#0068_0000#;
      declare
         Delay_Count : constant := 3_000_000;
      begin
         while True loop
            -- turn on RED (GPIO #22)
            HiFive1.GPIO_PORT := @ and 16#FFBF_FFFF#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            HiFive1.GPIO_PORT := @ or 16#0068_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- turn on GREEN (GPIO #19)
            HiFive1.GPIO_PORT := @ and 16#FFF7_FFFF#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            HiFive1.GPIO_PORT := @ or 16#0068_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- turn on BLUE (GPIO #21)
            HiFive1.GPIO_PORT := @ and 16#FFDF_FFFF#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            HiFive1.GPIO_PORT := @ or 16#0068_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
