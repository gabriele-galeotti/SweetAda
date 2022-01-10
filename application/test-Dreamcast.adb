
with Interfaces;
with Configure;
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

   use Interfaces;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Serial with Import => True, Convention => Asm, External_Name => "serial";
   procedure Recvw with Import => True, Convention => Asm, External_Name => "recvw";
   procedure Video with Import => True, Convention => Asm, External_Name => "video";
   procedure Roto with Import => True, Convention => Asm, External_Name => "roto";

   procedure Run is
   begin
      -------------------------------------------------------------------------
      if Configure.ROM_BOOT = "Y" or else Configure.CDROM_BOOT = "Y" then
         Console.Print ("Starting ""serial"" demo ...", NL => True);
         Serial;
         Console.Print ("Press any key to continue ...", NL => True);
         Recvw;
      end if;
      -------------------------------------------------------------------------
      if Configure.ROM_BOOT = "Y" or else Configure.CDROM_BOOT = "Y" then
         Console.Print ("Starting ""video"" demo ...", NL => True);
         Video;
         for Delay_Loop_Count in 1 .. 30_000_000 loop CPU.NOP; end loop;
      end if;
      -------------------------------------------------------------------------
      if Configure.ROM_BOOT = "Y" or else Configure.CDROM_BOOT = "Y" then
         Console.Print ("Starting ""roto"" demo ...", NL => True);
         Roto;
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
               IOEMU.IOEMU_IO2 := Value + 0;
               IOEMU.IOEMU_IO2 := Value + 1;
               IOEMU.IOEMU_IO2 := Value + 2;
               IOEMU.IOEMU_IO2 := Value + 3;
               Value := @ + 1;
               -- emit an OK message
               Console.Print ("OK", NL => True);
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
