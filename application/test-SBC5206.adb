
with System.Storage_Elements;
with Interfaces;
with BSP;
with Console;

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
   use BSP;

   -- IOEMU GPIO 0x30000000
   IOEMU_IO0 : Unsigned_8 with
      Address    => To_Address (16#3000_0000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

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
            Delay_Count : constant := 50_000_000;
         begin
            IOEMU_IO0 := 0;
            loop
               Console.Print ("hello, SweetAda", NL => True);
               -- IOEMU GPIO test
               IOEMU_IO0 := IOEMU_IO0 + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
