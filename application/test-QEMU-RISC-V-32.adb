
with System.Storage_Elements;
with Interfaces;

with RISCV;

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

   ----------------------------------------------------------------------------
   -- IOEMU
   ----------------------------------------------------------------------------

   IOEMU_BASEADDRESS : constant := 16#1000_0100#;

   IOEMU_IO0 : aliased Unsigned_8 with
      Address    => To_Address (IOEMU_BASEADDRESS + 0),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO1 : aliased Unsigned_8 with
      Address    => To_Address (IOEMU_BASEADDRESS + 1),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO2 : aliased Unsigned_8 with
      Address    => To_Address (IOEMU_BASEADDRESS + 2),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

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
         RISCV.Asm_Call (System.Storage_Elements.To_Address (16#2000#));
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 300_000_000;
         begin
            IOEMU_IO1 := 0;
            IOEMU_IO2 := 0;
            loop
               -- IOEMU GPIO test
               IOEMU_IO0 := 16#FF#;
               IOEMU_IO0 := 16#00#;
               IOEMU_IO1 := IOEMU_IO1 + 1;
               IOEMU_IO2 := IOEMU_IO2 + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop RISCV.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
