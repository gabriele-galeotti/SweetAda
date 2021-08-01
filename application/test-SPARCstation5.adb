
with System.Storage_Elements;
with Ada.Characters.Latin_1;
with Interfaces;
with Configure;
with Bits;
with BSP;
with SCC;
with Sun4m;
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
   use Bits;
   use Sun4m;

   -- IOEMU GPIO 0x72000000..0x72000003
   IOEMU_IO0 : Unsigned_8 with
      Address    => To_Address (16#7200_0000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO1 : Unsigned_8 with
      Address    => To_Address (16#7200_0001#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO2 : Unsigned_8 with
      Address    => To_Address (16#7200_0002#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO3 : Unsigned_8 with
      Address    => To_Address (16#7200_0003#),
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
      procedure CHANNELB_Putchar (C : in Character);
      procedure CHANNELB_Putchar (C : in Character) is
      begin
         SCC.TX (BSP.SCC_Descriptor, SCC.CHANNELB, To_U8 (C));
      end CHANNELB_Putchar;
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : Integer;
         begin
            if Configure.BOOT_FROM_NETWORK then
               Delay_Count := 5_000_000;
            else
               if BSP.QEMU then
                  Delay_Count := 500_000_000;
               else
                  Delay_Count := 50_000;
               end if;
            end if;
            IOEMU_IO1 := 0;
            loop
               Console.Print ("hello, SweetAda", NL => True);
               CHANNELB_Putchar ('O');
               CHANNELB_Putchar ('K');
               CHANNELB_Putchar (Ada.Characters.Latin_1.CR);
               CHANNELB_Putchar (Ada.Characters.Latin_1.LF);
               for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
               -- IOEMU GPIO test
               IOEMU_IO1 := IOEMU_IO1 + 1;
               if System_Timer.Counter.LR = 1 then
                  declare
                     -- Unused : Slavio_Timer_Limit_Type with Unreferenced => True;
                  begin
                     -- Unused := System_Timer.Limit;
                     System_Timer_ClearLR;
                     IOEMU_IO0 := 1;
                     IOEMU_IO0 := 0;
                  end;
               end if;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
