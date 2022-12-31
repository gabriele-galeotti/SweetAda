
with Interfaces;
with CPU;
with DE10Lite;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use DE10Lite;

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
      -- GPIO test ------------------------------------------------------------
      if True then
         declare
            Value       : Unsigned_32;
            Delay_Count : constant := 300_000;
         begin
            Value := 0;
            LEDs_Dir := 16#FFFF_FFFF#;
            loop
               LEDs_IO := Value;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               Value := Value + 1;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
