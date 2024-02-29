
with System;
with System.Storage_Elements;
with System.Machine_Code;
with Ada.Unchecked_Conversion;
with Interfaces;
with Interfaces.C;
with Configure;
with Definitions;
with Core;
with Bits;
with Malloc;
with CPU;
with CPU.IO;
with PC;
with BSP;
with Exceptions;
with PCI;
with IDE;
with PIIX;
with BlockDevices;
with MBR;
with FATFS;
with FATFS.Applications;
with MC146818A;
with UART16x50;
with PBUF;
with Ethernet;
with Time;
with PCICAN;
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

   use System;
   use System.Storage_Elements;
   use System.Machine_Code;
   use Interfaces;
   use Bits;
   use CPU.IO;
   use PC;
   use Exceptions;
   use PCI;
   use PIIX;

   use type Interfaces.C.size_t; -- directly useing this unit creates problem with
                                 -- visibility of False/True due to C_bool

   -- Malloc memory area
   Heap : aliased Storage_Array (0 .. Definitions.kB64 - 1)
       with Alignment               => 16#1000#,
            Suppress_Initialization => True; -- pragma Initialize_Scalars

   Fatfs_Object : FATFS.Descriptor_Type;

   function Tick_Count_Expired
      (Flash_Count : Unsigned_32;
       Timeout     : Unsigned_32)
      return Boolean;
   procedure Handle_Ethernet;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Tick_Count_Expired
   ----------------------------------------------------------------------------
   function Tick_Count_Expired
      (Flash_Count : Unsigned_32;
       Timeout     : Unsigned_32)
      return Boolean
      is
   begin
      return (BSP.Tick_Count - Flash_Count) > Timeout;
   end Tick_Count_Expired;

   ----------------------------------------------------------------------------
   -- Handle_Ethernet
   ----------------------------------------------------------------------------
   procedure Handle_Ethernet
      is
      P       : PBUF.Pbuf_Ptr;
      Success : Boolean;
   begin
      -- PPI_DataOut (Unsigned_8 (PBUF.Nalloc));                                      -- # of PBUFs allocated
      -- PPI_StatusOut (Unsigned_8 (Ethernet.Nqueue (Ethernet.Packet_Queue'Access))); -- # of items in queue
      Ethernet.Dequeue (Ethernet.Packet_Queue'Access, P, Success);
      if Success then
         Ethernet.Packet_Handler (P);
         PBUF.Free (P);
      end if;
   end Handle_Ethernet;

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
            MC146818A.Read_Clock (BSP.RTC_Descriptor, TM);
            if TM.Year < 70 then
               Console.Print (TM.Year + 2_000, NL => False);
            else
               Console.Print (TM.Year + 1_900, NL => False);
            end if;
            Console.Print ("-", NL => False);
            Console.Print (TM.Mon + 1, NL => False);
            Console.Print ("-", NL => False);
            Console.Print (TM.MDay, NL => False);
            Console.Print (" ", NL => False);
            Console.Print (TM.Hour, NL => False);
            Console.Print (":", NL => False);
            Console.Print (TM.Min, NL => False);
            Console.Print (":", NL => False);
            Console.Print (TM.Sec, NL => False);
            Console.Print_NewLine;
         end;
      end if;
      -------------------------------------------------------------------------
      if False then
         Malloc.Init (Heap'Address, Heap'Size / Storage_Unit, False);
      end if;
      -------------------------------------------------------------------------
      if False then
         declare
            Video : aliased array (0 .. (640 * 480 / 2) - 1) of Unsigned_8 with
               Address => To_Address (16#000A_0000#);
            Value : Unsigned_8;
         begin
            Value := 0;
            for Index in Video'Range loop
               Video (Index) := Value;
               Value := @ + 1;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            procedure Ctest with
               Import        => True,
               Convention    => C,
               External_Name => "ctest";
         begin
            Ctest;
         end;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Success   : Boolean;
            Partition : MBR.Partition_Entry_Type;
         begin
            MBR.Read (BSP.IDE_Descriptors (1)'Access, MBR.PARTITION1, Partition, Success);
            if Success then
               Fatfs_Object.Device := BSP.IDE_Descriptors (1)'Access;
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
      if False then
         PCICAN.TX;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            TC1   : Unsigned_32 := BSP.Tick_Count;
            TC2   : Unsigned_32 := BSP.Tick_Count;
            Value : Unsigned_8 := 0;
         begin
            loop
               if Tick_Count_Expired (TC1, 50) then
                  Handle_Ethernet;
                  TC1 := BSP.Tick_Count;
               end if;
               if Tick_Count_Expired (TC2, 300) then
                  if Configure.USE_QEMU_IOEMU then
                     -- IOEMU GPIO test
                     PortOut (IOEMU.IO0_ADDRESS, Unsigned_8'(Value * 1));
                     PortOut (IOEMU.IO1_ADDRESS, Unsigned_8'(Value * 2));
                     PortOut (IOEMU.IO2_ADDRESS, Unsigned_8'(Value * 3));
                     PortOut (IOEMU.IO3_ADDRESS, Unsigned_8'(Value * 4));
                  end if;
                  Value := @ + 1;
                  TC2 := BSP.Tick_Count;
               end if;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
