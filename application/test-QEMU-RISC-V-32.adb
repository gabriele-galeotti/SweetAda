
with System.Storage_Elements;
with Interfaces;
with CPU;
with Virt;
with IOEMU;

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

   procedure Run is
   begin
      -------------------------------------------------------------------------
      if False then
         CPU.Asm_Call (System.Storage_Elements.To_Address (16#2000#));
      end if;
      -------------------------------------------------------------------------
      if True then
         Virt.mtimecmp := 16#0000_0000_0400_0000#;
         -- Virt.mtime    := 16#0000_0000_0000_0000#;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 300_000_000;
         begin
            IOEMU.IOEMU_IO1 := 0;
            IOEMU.IOEMU_IO2 := 0;
            loop
               -- IOEMU GPIO test
               IOEMU.IOEMU_IO0 := 16#FF#;
               IOEMU.IOEMU_IO0 := 16#00#;
               IOEMU.IOEMU_IO1 := @ + 1;
               IOEMU.IOEMU_IO2 := @ + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
