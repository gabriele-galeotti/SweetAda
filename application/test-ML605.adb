
with System.Storage_Elements;
with Interfaces;
with ML605;
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
   use ML605;

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
            -- X : Integer := 33434334;
            Y : Integer;
         begin
            if IOEMU_IO1 = 16#01# then
               Y := Integer (IOEMU_IO0) / 6;
               IOEMU_IO0 := Unsigned_8 (Y);
            end if;
         end;
      end if;
      -------------------------------------------------------------------------
      if True then
         Console.Print ("*** SWITCH TEST IN PROGRESS ***", NL => True);
         loop
            IOEMU_IO1 := IOEMU_IO3;
            -- Console.Print (IO3, NL => True);
            -- IO1 := 16#55#;
            -- IO3 := IO1;
         end loop;
      end if;
      -------------------------------------------------------------------------
      if False then
         declare
            Delay_Count : constant := 50_000_000; -- normal
            -- Delay_Count : constant := 10; -- debug
            Value       : Unsigned_8;
         begin
            Value := 0;
            IOEMU_IO1 := 0;
            loop
               if (Value mod 10) = 0 then
                  IOEMU_IO0 := IOEMU_IO0 xor 16#FF#; -- LED on/off
                  Console.Print ("hello, SweetAda", NL => True);
               end if;
               Value := Value + 1;
               IOEMU_IO1 := IOEMU_IO1 + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
