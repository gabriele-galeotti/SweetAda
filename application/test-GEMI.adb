
with System;
with System.Storage_Elements;
with Interfaces;
with Bits;
with MMIO;
with UART16x50;
with SH;
with GEMI;
with BSP;

package body Application is

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
   use Bits;
   use GEMI;

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
            Value : Unsigned_8 := 16#10#;
            procedure Wait;
            procedure Wait is
               X : Unsigned_32 with Volatile => True;
            begin
               X := 0;
               loop
                  X := @ + 1;
                  exit when X = 16#8000#;
               end loop;
            end Wait;
         begin
            loop
               LEDPORT := not Value;
               Value := Rotate_Left (Value, 1);
               if Value = 1 then
                  Value := 16#10#;
               end if;
               UART16x50.TX (BSP.UART_Descriptor, To_U8 ('.'));
               Wait;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
