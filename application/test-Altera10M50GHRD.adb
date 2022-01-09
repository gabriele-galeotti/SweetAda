
with Interfaces;
with Core;
with GHRD;
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

   function Tick_Count_Expired (Flash_Count : Unsigned_32; Timeout : Unsigned_32) return Boolean;
   function Tick_Count_Expired (Flash_Count : Unsigned_32; Timeout : Unsigned_32) return Boolean is
   begin
      return (Core.Tick_Count - Flash_Count) > Timeout;
   end Tick_Count_Expired;

   procedure Run is
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            TC : Unsigned_32;
         begin
            IOEMU.IOEMU_IO0 := 0;
            TC := Core.Tick_Count;
            loop
               if Tick_Count_Expired (TC, 1_000) then
                  TC := Core.Tick_Count;
                  -- blink IOEMU LED
                  IOEMU.IOEMU_IO0 := 1;
                  IOEMU.IOEMU_IO0 := 0;
                  Console.Print ("hello, SweetAda", NL => True);
               end if;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
