
with RISCV;
with MTIME;
with BSP;
with Console;
with MMIO;
with System.Storage_Elements;
with Configure;

package body Application
   is

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
   procedure Run
      is
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 500_000;
         begin
            loop
               -- Console.Print ("hello, SweetAda", NL => True);
               -- Console.Print (BSP.Tick_Count, NL => True);
               -- Console.Print (MTIME.mtime_Read, NL => True);
               Console.Print (MMIO.Read_U64 (System.Storage_Elements.To_Address (Configure.MTIME_ADDRESS)), NL => True);
               -- for Delay_Loop_Count in 1 .. Delay_Count loop RISCV.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
