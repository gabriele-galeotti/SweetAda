
with Interfaces;
with Bits;
with CPU;
with PC;
with VGA;
with BSP;

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
   use BSP;

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
      if True then
         declare
            Delay_Count : Integer;
            Value       : Unsigned_8;
         begin
            Delay_Count := 500_000_000; -- QEMU
            Value := 0;
            loop
               PC.PPI_DataOut (Value);
               VGA.Print (0, 5, To_Ch (32 + (Value and 16#1F#)));
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               Value := @ + 1;
               PC.PPI_ControlOut (16#FF#);
               PC.PPI_ControlOut (16#00#);
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
