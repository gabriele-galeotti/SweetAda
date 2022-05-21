
with Interfaces;
with Bits;
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
            Delay_Count : Integer;
            Value       : Unsigned_8;
         begin
            Delay_Count := 500_000_000; -- QEMU
            Value := 0;
            loop
               -- roll characters on VGA since modern machines do not have I/O
               VGA.Print (0, 5, To_Ch (32 + (Value and 16#1F#)));
               -- IOEMU GPIO test
               PortOut (IOEMU.IO0_ADDRESS, Value);
               Value := @ + 1;
               PC.PPI_ControlOut (PC.To_PPICT (16#FF#));
               PC.PPI_ControlOut (PC.To_PPICT (16#00#));
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
