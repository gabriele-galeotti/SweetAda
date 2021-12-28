
with System.Storage_Elements;
with Interfaces;
with ML605;
with CPU;
with IOEMU;
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
            if IOEMU.IOEMU_IO1 = 16#01# then
               Y := Integer (IOEMU.IOEMU_IO0) / 6;
               IOEMU.IOEMU_IO0 := Unsigned_8 (Y);
            end if;
         end;
      end if;
      -------------------------------------------------------------------------
      if False then
         Console.Print ("*** SWITCH TEST IN PROGRESS ***", NL => True);
         loop
            IOEMU.IOEMU_IO1 := IOEMU.IOEMU_IO3;
            -- Console.Print (IOEMU.IOEMU_IO3, NL => True);
            -- IOEMU.IOEMU_IO1 := 16#55#;
            -- IOEMU.IOEMU_IO3 := IOEMU.IOEMU_IO1;
         end loop;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 50_000_000; -- normal
            -- Delay_Count : constant := 10; -- debug
            Value       : Unsigned_8;
         begin
            Value := 0;
            IOEMU.IOEMU_IO1 := 0;
            loop
               if (Value mod 10) = 0 then
                  Console.Print ("hello, SweetAda", NL => True);
               end if;
               Value := @ + 1;
               IOEMU.IOEMU_IO1 := @ + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
