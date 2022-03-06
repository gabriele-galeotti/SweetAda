
with System.Storage_Elements;
with Interfaces;
with Bits;
with MMIO;
with NETARM;
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
      Console.Print (NETARM.SCBRGR.EBIT, Prefix => "EBIT: ", NL => True);
      Console.Print (Unsigned_16 (NETARM.SCBRGR.TMODE), Prefix => "TMODE: ", NL => True);
      Console.Print (Unsigned_16 (NETARM.SCBRGR.CLKMUX), Prefix => "CLKMUX: ", NL => True);
      Console.Print (Unsigned_16 (NETARM.SCBRGR.NREG), Prefix => "NREG: ", NL => True);
      -------------------------------------------------------------------------
      if False then
         declare
            Delay_Count : constant := 500_000;
         begin
            loop
               NETARM.PORTC := NETARM.PORTC and 16#FFFF_FFBF#;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               NETARM.PORTC := NETARM.PORTC or 16#0000_0040#;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 500_000;
         begin
            loop
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               MMIO.Write_U8 (To_Address (NETARM.SERTX), Bits.To_U8 ('.'));
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
