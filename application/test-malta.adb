
with Interfaces;
with Bits;
with MIPS;
with Malta;
with BSP;
with BlockDevices;
with MBR;
with FATFS;
with FATFS.Applications;
with VGA;
with SweetAda;
with Console;
with MC146818A;
with Time;

package body Application
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;
   use Malta;

   Fatfs_Object : FATFS.Descriptor_Type;

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
            TM : Time.TM_Time;
         begin
            Console.Print ("Current date: ", NL => False);
            MC146818A.Time_Read (Malta.PIIX4_RTC_Descriptor, TM);
            Console.Print (Prefix => "",  Value => TM.Year + 1_900);
            Console.Print (Prefix => "-", Value => TM.Mon + 1);
            Console.Print (Prefix => "-", Value => TM.MDay);
            Console.Print (Prefix => " ", Value => TM.Hour);
            Console.Print (Prefix => ":", Value => TM.Min);
            Console.Print (Prefix => ":", Value => TM.Sec);
            Console.Print_NewLine;
         end;
      end if;
      -------------------------------------------------------------------------
      if True then
         PCI_Devices_Detect;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Success   : Boolean;
            Partition : MBR.Partition_Entry_Type;
         begin
            MBR.Read (Malta.PIIX4_IDE_Descriptor'Access, MBR.PARTITION1, Partition, Success);
            if Success then
               Fatfs_Object.Device := Malta.PIIX4_IDE_Descriptor'Access;
               FATFS.Open
                  (Fatfs_Object,
                   BlockDevices.Sector_Type (Partition.LBA_Start),
                   Success);
               if Success then
                  FATFS.Applications.Test (Fatfs_Object);
                  FATFS.Applications.Load_AUTOEXECBAT (Fatfs_Object);
               end if;
            end if;
         end;
      end if;
      -------------------------------------------------------------------------
      if True then
         Console.Print ("Wait while drawing the screen ...", NL => True);
         -- VGA.Clear_Screen;
         -- VGA.Print (0, 0, "hello SweetAda ...");
         VGA.Draw_Picture (SweetAda.SweetAda_Picture);
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 300_000_000;
         begin
            loop
               -- output the LSB of tick count on LEDBAR (visible in QEMU by
               -- activating the built-in screen with CTRL-ALT-3)
               LEDBAR := Unsigned_8 (BSP.Tick_Count and 16#FF#);
               Console.Print ("hello, SweetAda", NL => True);
               for Delay_Loop_Count in 1 .. Delay_Count loop MIPS.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
