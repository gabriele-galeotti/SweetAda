
with System.Storage_Elements;
with Interfaces;
with Bits;
with Core;
with MIPS;
with MIPS32;
with Malta;
with IDE;
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

   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use MIPS;
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
            MC146818A.Read_Clock (Malta.PIIX4_RTC_Descriptor, TM);
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
            Delay_Count : constant := 100_000_000;
            Value       : Unsigned_8;
         begin
            Value := 0;
            loop
               LEDBAR := Byte_Reverse (Value);
               Value := @ + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop MIPS.NOP; end loop;
            end loop;

         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
