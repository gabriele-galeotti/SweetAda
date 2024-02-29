
with System.Storage_Elements;
with Ada.Characters.Latin_1;
with Interfaces;
with Configure;
with Core;
with Bits;
with BSP;
with CPU;
with Z8530;
with Sun4m;
with IOEMU;
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
   procedure Run
      is
      procedure CHANNELB_Putchar
         (C : in Character);
      procedure CHANNELB_Putchar
         (C : in Character)
         is
      begin
         Z8530.TX (BSP.SCC_Descriptor, Z8530.CHANNELB, To_U8 (C));
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
                  -- QEMU machine
                  Delay_Count := 300_000_000;
               else
                  -- physical machine
                  Delay_Count := 50_000;
               end if;
            end if;
            if Configure.USE_QEMU_IOEMU then
               IOEMU.IO1 := 0;
            end if;
            loop
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               Console.Print ("hello, SweetAda", NL => True);
               CHANNELB_Putchar ('O');
               CHANNELB_Putchar ('K');
               CHANNELB_Putchar (Ada.Characters.Latin_1.CR);
               CHANNELB_Putchar (Ada.Characters.Latin_1.LF);
               if Configure.USE_QEMU_IOEMU then
                  -- IOEMU GPIO test
                  IOEMU.IO1 := @ + 1;
               end if;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
