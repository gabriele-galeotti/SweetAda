
with Interfaces;
with Configure;
with SH7750;
with BSP;
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

   use Interfaces;
   use SH7750;
   use BSP;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Roto with Import => True, Convention => Asm, External_Name => "roto";
   procedure Serial with Import => True, Convention => Asm, External_Name => "serial";
   procedure Video with Import => True, Convention => Asm, External_Name => "video";

   procedure Run is
   begin
      -------------------------------------------------------------------------
      if Configure.ROM_BOOT = "Y" then
         Roto; -- works only in ROM booting
      end if;
      -------------------------------------------------------------------------
      if False then
         Serial;
      end if;
      -------------------------------------------------------------------------
      if False then
         Video;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 10_000_000; -- normal
            -- Delay_Count : constant := 100; -- debug
            Value : Unsigned_8;
         begin
            Value := 0;
            loop
               -- pulse LED
               IOEMU.IOEMU_IO0 := 1;
               IOEMU.IOEMU_IO0 := 0;
               -- display values
               IOEMU.IOEMU_IO1 := Value;
               IOEMU.IOEMU_IO2 := Unsigned_32 (Value);
               Value := @ + 1;
               -- emit an OK message
               Console.Print ("OK", NL => True);
               for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
