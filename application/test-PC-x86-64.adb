
with Interfaces;
with Bits;
with Configure;
with CPU;
with CPU.IO;
with PC;
with VGA;
with BSP;
with IOEMU;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;
   use CPU.IO;
   use BSP;

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
      if True then
         declare
            Delay_Count : constant := 500_000_000;
            Value       : Unsigned_8;
         begin
            Value := 0;
            loop
               -- roll characters on VGA since modern machines do not have I/O
               -- VGA.Print (0, 5, To_Ch (32 + (Value and 16#1F#)));
               if Configure.USE_QEMU_IOEMU then
                  -- IOEMU GPIO test
                  PortOut (IOEMU.IO0_ADDRESS, Value);
               end if;
               Value := @ + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
