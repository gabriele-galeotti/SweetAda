
with Interfaces;
with GHRD;
with BSP;
with Console;

package body Application
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

   function Tick_Count_Expired
      (Flash_Count : Unsigned_32;
       Timeout     : Unsigned_32)
      return Boolean;

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
   function Tick_Count_Expired
      (Flash_Count : Unsigned_32;
       Timeout     : Unsigned_32)
      return Boolean
      is
   begin
      return (BSP.Tick_Count - Flash_Count) > Timeout;
   end Tick_Count_Expired;

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run
      is
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            TC1 : Unsigned_32;
         begin
            TC1 := BSP.Tick_Count;
            loop
               if Tick_Count_Expired (TC1, 3_000) then
                  TC1 := BSP.Tick_Count;
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
