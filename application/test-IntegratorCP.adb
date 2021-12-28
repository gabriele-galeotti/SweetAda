
with System.Storage_Elements;
with Interfaces;
with CPU;
with IOEMU;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
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
      if True then
         declare
            Delay_Count : constant := 300_000_000;
         begin
            IOEMU.IOEMU_IO1 := 16#00#;
            loop
               -- IOEMU GPIO test
               IOEMU.IOEMU_IO1 := @ + 1;
               IOEMU.IOEMU_IO0 := 16#FF#;
               IOEMU.IOEMU_IO0 := 16#00#;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
