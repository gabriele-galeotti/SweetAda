
with System.Storage_Elements;
with Ada.Characters.Latin_1;
with Interfaces;
with Configure;
with Core;
with Bits;
with BSP;
with CPU;
with SCC;
with Sun4m;
with IOEMU;
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
                  Delay_Count := 100_000_000;
               else
                  Delay_Count := 50_000;
               end if;
            end if;
            IOEMU.IOEMU_IO1 := 0;
            loop
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               Console.Print ("hello, SweetAda", NL => True);
               CHANNELB_Putchar ('O');
               CHANNELB_Putchar ('K');
               CHANNELB_Putchar (Ada.Characters.Latin_1.CR);
               CHANNELB_Putchar (Ada.Characters.Latin_1.LF);
               -- IOEMU GPIO test
               IOEMU.IOEMU_IO1 := IOEMU.IOEMU_IO1 + 1;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
