
with System.Machine_Code;
with Ada.Unchecked_Conversion;
with Interfaces;
with Configure;
with Core;
with Bits;
with MMIO;
with M68k;
with Amiga;
with PBUF;
with Ethernet;
with A2065;
with IDE;
with BlockDevices;
with MBR;
with FATFS;
with FATFS.Applications;
with IOEMU;
with PythonVM;
with Console;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use Interfaces;
   use Configure;
   use Core;
   use Bits;
   use MMIO;
   use M68k;
   use Amiga;

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
      IOEMU.IOEMU_CIA_IO1 := (Unsigned_8 (Ethernet.Nqueue (Ethernet.Packet_Queue'Access))); -- # of items in queue
      -- IOEMU.IOEMU_CIA_IO2 := (Unsigned_8 (PBUF.Nalloc));                                    -- # of PBUFs allocated
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
            Ethernet_Descriptor : Ethernet.Ethernet_Descriptor_Type;
         begin
            -- Ethernet module initialization ------------------------------
            Ethernet_Descriptor.Haddress := A2065.A2065_MAC;
            Ethernet_Descriptor.Paddress := [192, 168, 3, 2];
            Ethernet_Descriptor.RX       := null;
            Ethernet_Descriptor.TX       := A2065.Transmit'Access;
            Ethernet.Init (Ethernet_Descriptor);
            -- A2065 initialization ----------------------------------------
            A2065.Init;
         end;
      end if;
      -------------------------------------------------------------------------
      if False then
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
      if False then
         declare
            L       : Lock_Type;
            Success : Boolean;
         begin
            Lock_Try (L, Success);
         end;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            TC1   : Unsigned_32 := Tick_Count;
            TC2   : Unsigned_32 := Tick_Count;
            TC3   : Unsigned_32 := Tick_Count;
            Value : Unsigned_8 := 0;
         begin
            loop
               if Tick_Count_Expired (TC1, 50) then
                  Handle_Ethernet;
                  TC1 := Tick_Count;
               end if;
               if Tick_Count_Expired (TC2, 300) then
                  IOEMU.IOEMU_CIA_IO5 := Value;
                  Value := Value + 1;
                  TC2 := Tick_Count;
               end if;
               if Tick_Count_Expired (TC3, 300) then
                  -- Serialport_TX ('.');
                  TC3 := Tick_Count;
               end if;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
