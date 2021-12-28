
with System.Storage_Elements;
with Interfaces;
with Bits;
with MIPS;
with Malta;
with IDE;
with BlockDevices;
with MBR;
with FATFS;
with FATFS.Applications;
with PythonVM;
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
   use MIPS;
   use Malta;

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
         PCI_Devices_Detect;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Success   : Boolean;
            Partition : MBR.Partition_Entry_Type;
         begin
            MBR.Init (IDE.Read'Access);
            MBR.Read (MBR.PARTITION1, Partition, Success);
            if Success then
               FATFS.Register_BlockRead_Procedure (IDE.Read'Access);
               FATFS.Register_BlockWrite_Procedure (IDE.Write'Access);
               FATFS.Open (BlockDevices.Sector_Type (Partition.LBA_Start), Success);
               if Success then
                  FATFS.Applications.Test;
                  FATFS.Applications.Load_AUTOEXECBAT;
                  FATFS.Applications.Load_PROVA02PYC (PythonVM.Python_Code'Address);
               end if;
            end if;
         end;
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
               -- IOEMU GPIO test
               IOEMU.IOEMU_IO1 := Value;
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
