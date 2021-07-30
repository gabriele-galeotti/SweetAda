
with System.Storage_Elements;
with Interfaces;
with BSP;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

   -- IOEMU GPIO 0x80000800
   IOEMU_IO0 : Unsigned_8 with
      Address    => To_Address (16#8000_0400#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO1 : Unsigned_8 with
      Address    => To_Address (16#8000_0401#),
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
            Delay_Count : constant := 10_000_000; -- normal
            -- Delay_Count : constant := 100; -- debug
            Value       : Unsigned_8;
         begin
            Value := 0;
            loop
               BSP.Console_Putchar ('*');
               -- IOEMU GPIO test
               Value := Value + 1;
               IOEMU_IO1 := Value;
               for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
