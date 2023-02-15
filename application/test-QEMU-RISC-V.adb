
with System.Storage_Elements;
with Interfaces;
with Bits;
with CPU;
with Configure;
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
            TM          : Time.TM_Time;
         begin
            if Configure.USE_QEMU_IOEMU then
               IOEMU.IO1 := 0;
               IOEMU.IO2 := 0;
            end if;
            loop
               if Configure.USE_QEMU_IOEMU then
                  IOEMU.IO1 := @ + 1;
                  IOEMU.IO2 := @ + 1;
               end if;
               -- strictly adhere to Goldfish RTC specifications
               Time_L  := Virt.Goldfish_RTC.TIME_LOW;
               Time_H  := Virt.Goldfish_RTC.TIME_HIGH;
               Time_ns := Integer_64 (Bits.Make_Word (Time_H, Time_L));
               Time.Make_Time (Unsigned_32 (Time_ns / 10**9), TM);
               Console.Print (Time.Day_Of_Week (Time.NDay_Of_Week (TM.MDay, TM.Mon + 1, TM.Year + 1900)));
               Console.Print (" ");
               Console.Print (Time.Month_Name (TM.Mon + 1));
               Console.Print (" ");
               Console.Print (TM.MDay);
               Console.Print (" ");
               Console.Print (TM.Year + 1900);
               Console.Print (" ");
               Console.Print (TM.Hour);
               Console.Print (":");
               Console.Print (TM.Min);
               Console.Print (":");
               Console.Print (TM.Sec);
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
