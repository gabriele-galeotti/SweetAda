
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

   function Tick_Count_Expired (Flash_Count : Unsigned_32; Timeout : Unsigned_32) return Boolean;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Tick_Count_Expired
   ----------------------------------------------------------------------------
   function Tick_Count_Expired (Flash_Count : Unsigned_32; Timeout : Unsigned_32) return Boolean is
   begin
      return (Core.Tick_Count - Flash_Count) > Timeout;
   end Tick_Count_Expired;

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run is
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            TC1 : Unsigned_32;
            TC2 : Unsigned_32;
         begin
            TC1 := Core.Tick_Count;
            TC2 := Core.Tick_Count;
            IOEMU.IOEMU_IO1 := 0;
            IOEMU.IOEMU_IO2 := 0;
            loop
               if Tick_Count_Expired (TC1, 2_000) then
                  TC1 := Core.Tick_Count;
                  IOEMU.IOEMU_IO1 := @ + 1;
                  IOEMU.IOEMU_IO2 := @ + 1;
               end if;
               if Tick_Count_Expired (TC2, 3_000) then
                  TC2 := Core.Tick_Count;
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
