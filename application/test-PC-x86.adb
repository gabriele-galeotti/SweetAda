
with System;
with System.Storage_Elements;
with System.Machine_Code;
with Ada.Unchecked_Conversion;
with Interfaces;
with Interfaces.C;
with Definitions;
with Core;
with Bits;
with Malloc;
with CPU;
with CPU.IO;
with PC;
with Exceptions;
with PCI;
with IDE;
with PIIX;
with BlockDevices;
with MBR;
with FATFS;
with FATFS.Applications;
with UART16x50;
with PBUF;
with Ethernet;
with Time;
with PCICAN;
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

   use System;
   use System.Storage_Elements;
   use System.Machine_Code;
   use Interfaces;
   use Core;
   use Bits;
   use CPU.IO;
   use PC;
   use Exceptions;
   use PCI;
   use PIIX;

   use type Interfaces.C.size_t; -- directly useing this unit creates problem with
                                 -- visibility of False/True due to C_bool

   CRLF : String renames Definitions.CRLF;

   -- Malloc memory area
   Heap : aliased Storage_Array (0 .. Definitions.kB64 - 1) with
       Alignment               => 16#1000#,
       Suppress_Initialization => True; -- pragma Initialize_Scalars

   function Tick_Count_Expired (Flash_Count : Unsigned_32; Timeout : Unsigned_32) return Boolean;
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
   function Tick_Count_Expired (Flash_Count : Unsigned_32; Timeout : Unsigned_32) return Boolean is
   begin
      return (Tick_Count - Flash_Count) > Timeout;
   end Tick_Count_Expired;

   ----------------------------------------------------------------------------
   -- Handle_Ethernet
   ----------------------------------------------------------------------------
   procedure Handle_Ethernet is
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
   procedure Run is
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            TM : Time.TM_Time;
         begin
            Console.Print ("Current date: ", NL => False);
            RTC_Read_Clock (TM);
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
                  -- PythonVM.Run;
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
            TC1   : Unsigned_32 := Tick_Count;
            TC2   : Unsigned_32 := Tick_Count;
            Value : Unsigned_8 := 0;
         begin
            loop
               if Tick_Count_Expired (TC1, 50) then
                  Handle_Ethernet;
                  TC1 := Tick_Count;
               end if;
               if Tick_Count_Expired (TC2, 300) then
                  -- IOEMU GPIO test
                  if Core.Debug_Flag then
                     PortOut (IOEMU.IO0_ADDRESS, Unsigned_8'(Value * 1));
                     PortOut (IOEMU.IO1_ADDRESS, Unsigned_8'(Value * 2));
                     PortOut (IOEMU.IO2_ADDRESS, Unsigned_8'(Value * 3));
                     PortOut (IOEMU.IO3_ADDRESS, Unsigned_8'(Value * 4));
                  end if;
                  Value := @ + 1;
                  TC2 := Tick_Count;
               end if;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
