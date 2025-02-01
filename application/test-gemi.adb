
with System;
with System.Storage_Elements;
with Interfaces;
with Bits;
with MMIO;
with UART16x50;
with uPD4991A;
with SH;
with GEMI;
with Time;
with BSP;
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
   procedure Run
      is
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            Value          : Unsigned_8 := 16#10#;
            Direction_Left : Boolean := True;
            TM             : Time.TM_Time;
            procedure Wait;
            procedure Wait
               is
               X : Unsigned_32 with Volatile => True;
            begin
               X := 0;
               loop
                  X := @ + 1;
                  exit when X = 16#4000#;
               end loop;
            end Wait;
         begin
            loop
               LEDPORT := not Value;
               if Direction_Left then
                  Value := Rotate_Left (Value, 1);
               else
                  Value := Rotate_Right (Value, 1);
               end if;
               if Value = 16#80# then
                  Direction_Left := False;
               end if;
               if Value = 16#10# then
                  Direction_Left := True;
               end if;
               -- UART16x50.TX (BSP.UART_Descriptor, To_U8 ('.'));
               uPD4991A.Read_Clock (BSP.RTC_Descriptor, TM);
               Console.Print (Prefix => "",  Value => TM.Year + 1_900);
               Console.Print (Prefix => "-", Value => TM.Mon);
               Console.Print (Prefix => "-", Value => TM.MDay);
               Console.Print (Prefix => " ", Value => TM.Hour);
               Console.Print (Prefix => ":", Value => TM.Min);
               Console.Print (Prefix => ":", Value => TM.Sec);
               Console.Print_NewLine;
               Wait;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
