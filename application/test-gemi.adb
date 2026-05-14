
with System;
with System.Storage_Elements;
with Interfaces;
with Bits;
with MMIO;
with UART16x50;
with uPD4991A;
with CPU;
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
         begin
            loop
               LEDPORT_Out (not Value);
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
               uPD4991A.Time_Read (BSP.RTC_Descriptor, TM);
               Console.Print (Prefix => "",  Value => TM.Year + 1_900);
               Console.Print (Prefix => "-", Value => TM.Mon + 1);
               Console.Print (Prefix => "-", Value => TM.MDay);
               Console.Print (Prefix => " ", Value => TM.Hour);
               Console.Print (Prefix => ":", Value => TM.Min);
               Console.Print (Prefix => ":", Value => TM.Sec);
               Console.Print_NewLine;
               for Delay_Loop_Count in 1 .. 300_000 loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
