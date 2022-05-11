
with System.Storage_Elements;
with Interfaces;
with Bits;
with CPU;
with Virt;
with IOEMU;
with Time;
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
      if True then
         declare
            Delay_Count : constant := 300_000_000;
            Time_L      : Unsigned_32;
            Time_H      : Unsigned_32;
            Time_ns     : Integer_64;
            SS          : Natural;
            MM          : Natural;
            HH          : Natural;
            D           : Natural;
            M           : Natural;
            Y           : Natural;
         begin
            IOEMU.IOEMU_IO1 := 0;
            IOEMU.IOEMU_IO2 := 0;
            loop
               IOEMU.IOEMU_IO1 := @ + 1;
               IOEMU.IOEMU_IO2 := @ + 1;
               -- strictly adhere to Goldfish RTC specifications
               Time_L  := Virt.Goldfish_RTC.TIME_LOW;
               Time_H  := Virt.Goldfish_RTC.TIME_HIGH;
               Time_ns := Integer_64 (Bits.Make_Word (Time_H, Time_L));
               Time.Make_Time (
                               Unsigned_32 (Time_ns / 10**9),
                               SS, MM, HH, D, M, Y
                              );
               Console.Print (Time.Day_Of_Week (Time.NDay_Of_Week (D, M, Y)));
               Console.Print (" ");
               Console.Print (Time.Month_Name (M));
               Console.Print (" ");
               Console.Print (D);
               Console.Print (" ");
               Console.Print (Y);
               Console.Print (" ");
               Console.Print (HH);
               Console.Print (":");
               Console.Print (MM);
               Console.Print (":");
               Console.Print (SS);
               Console.Print_NewLine;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
