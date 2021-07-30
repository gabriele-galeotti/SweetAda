
with System.Storage_Elements;
with Interfaces;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;

   -- IOEMU GPIO 0x1B000000
   IOEMU_IO0 : Unsigned_8 with
      Address    => To_Address (16#1B00_0000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO1 : Unsigned_8 with
      Address    => To_Address (16#1B00_0001#),
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
            Delay_Count : constant := 300_000_000;
         begin
            IOEMU_IO1 := 16#00#;
            loop
               -- IOEMU GPIO test
               IOEMU_IO1 := IOEMU_IO1 + 1;
               IOEMU_IO0 := 16#FF#;
               IOEMU_IO0 := 16#00#;
               for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
