
with Interfaces;
with Configure;
with CPU;
with PL110;
with Console;
with IOEMU;

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

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run is
   begin
      if True then
         PL110.Print (0, 0, "hello SweetAda ...");
      end if;
      -------------------------------------------------------------------------
      if True then
         if Configure.USE_QEMU_IOEMU then
            IOEMU.IO1 := 16#00#;
         end if;
         declare
            Delay_Count : constant := 100_000_000;
         begin
            loop
               if Configure.USE_QEMU_IOEMU then
                  -- IOEMU GPIO test
                  IOEMU.IO1 := @ + 1;
               end if;
               Console.Print ("Hello, SweetAda", NL => True);
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
