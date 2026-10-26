
with System;
with System.Storage_Elements;
with Interfaces;
with MMIO;
with CPU;
with MVME1600011;
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

   use System;
   use System.Storage_Elements;
   use Interfaces;

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
      X : Unsigned_8;
   begin
      -------------------------------------------------------------------------
      if True then
         loop
            Console.Print ("hello, SweetAda", NL => True);
            for D3lay in 1 .. 30_000_000 loop CPU.NOP; end loop;
            X := MMIO.Read_U8 (To_Address (MVME1600011.Z8536_PORTA_ADDRESS));
            X := @ xor 16#40#;
            MMIO.Write_U8 (To_Address (MVME1600011.Z8536_PORTA_ADDRESS), X);
         end loop;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
