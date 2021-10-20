
with System;
with System.Storage_Elements;
with Interfaces;
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
   use GEMI;

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
            A : Address := To_Address (16#0A00_0000#);
            B : Address := To_Address (16#0A00_8000#);
            V1 : Unsigned_32 with
               Volatile => True,
               Address  => A;
            V2 : Unsigned_32 with
               Volatile => True,
               Address  => B;
         begin
            loop
               V1 := 16#AA55_AA55#;
               V2 := 16#55AA_55AA#;
               exit when ((V1 and 16#FFFF_FFFF#) = 16#AA55_AA55#) and then ((V2 and 16#FFFF_FFFF#) = 16#55AA_55AA#);
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 30_000;
            Value : Unsigned_8;
         begin
            Value := 16#10#;
            loop
               LEDPORT := not Value;
               for Delay_Loop_Count in 1 .. Delay_Count loop
                  SH.NOP;
               end loop;
               Value := Rotate_Left (Value, 1);
               if Value = 1 then
                  Value := 16#10#;
               end if;
               -- UART16x50.TX (BSP.UART_Descriptor, 16#30#);
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
