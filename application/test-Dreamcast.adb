
with Interfaces;
with Configure;
with CPU;
with Dreamcast;
with IOEMU;
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

   use Interfaces;

   procedure Video with Import => True, Convention => Asm, External_Name => "video";
   procedure Roto with Import => True, Convention => Asm, External_Name => "roto";

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
      -------------------------------------------------------------------------
      if Configure.BOOTTYPE = "ROM" or else Configure.BOOTTYPE = "CDROM" then
         Console.Print ("Starting ""video"" demo ...", NL => True);
         Video;
         for Delay_Loop_Count in 1 .. 30_000_000 loop CPU.NOP; end loop;
      end if;
      -------------------------------------------------------------------------
      if Configure.BOOTTYPE = "ROM" or else Configure.BOOTTYPE = "CDROM" then
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
               -- IOEMU "TIMER" LED blinking
               IOEMU.IO0 := 1;
               IOEMU.IO0 := 0;
               -- display values
               IOEMU.IO1 := Value;
               IOEMU.IO2 := Value + 0;
               IOEMU.IO2 := Value + 1;
               IOEMU.IO2 := Value + 2;
               IOEMU.IO2 := Value + 3;
               Value := @ + 1;
               -- emit a message
               Console.Print ("hello, SweetAda", NL => True);
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
