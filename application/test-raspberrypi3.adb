
with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Definitions;
with Core;
with Bits;
with CPU;
with ARMv8A;
with RPI3;
with Mutex;
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
   use Interfaces;
   use Definitions;
   use Bits;

   function Clock_Get
      (Clock_ID : Unsigned_32)
      return Integer;
   procedure Clock_Set
      (Clock_ID : in Unsigned_32;
       Value    : in Unsigned_32);
   function Voltage_Get
      (Voltage_ID : Unsigned_32)
      return Integer;
   function Temperature_Get
      (Temperature_ID : Unsigned_32)
      return Integer;

   -- "application" cores

   AP_Key : aliased Unsigned_32
      with Atomic        => True,
           Export        => True,
           External_Name => "ap_key",
           Convention    => Asm;

   type AP_x_Type is array (0 .. 3) of Unsigned_64
      with Pack       => True,
           Convention => Asm;

   AP_sp : aliased AP_x_Type := [0, 0, 0, 0]
      with Export        => True,
           External_Name => "ap_sp";
   AP_pc : aliased AP_x_Type := [0, 0, 0, 0]
      with Export        => True,
           External_Name => "ap_pc";

   -- AP core stack size = 4 kB
   SP1 : aliased array (0 .. KiB4 - 1) of Unsigned_8
      with Alignment => 8;
   SP2 : aliased array (0 .. KiB4 - 1) of Unsigned_8
      with Alignment => 8;
   SP3 : aliased array (0 .. KiB4 - 1) of Unsigned_8
      with Alignment => 8;

   -- Console mutex
   M : Mutex.Semaphore_Binary := Mutex.SEMAPHORE_UNLOCKED;

   procedure AP1;
   procedure AP2;
   procedure AP3;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Clock_Get
   ----------------------------------------------------------------------------
   function Clock_Get
      (Clock_ID : Unsigned_32)
      return Integer
      is
      type Message_Data_Type is array (0 .. 7) of Unsigned_32
         with Alignment => 16,
              Size      => 8 * 32;
      M_Data : aliased Message_Data_Type
         with Address    => System'To_Address (16#3AC00000#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;
      M      : RPI3.Message_Type
         with Unreferenced => True;
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      while RPI3.MAIL0_Status.Full loop CPU.NOP; end loop;
      M_Data (0) := 8 * 4;              -- total size (bytes)
      M_Data (1) := 0;                  -- response to all tag messages
      -- tag #0
      M_Data (2) := RPI3.TAG_GET_CLOCK; -- tag ID
      M_Data (3) := 8;                  -- buffer size = M_Data (5) + M_Data (6)
      M_Data (4) := 0;                  -- request/response code
      M_Data (5) := Clock_ID;           -- value buffer
      M_Data (6) := 0;                  -- value buffer
      M_Data (7) := 0;                  -- no more tags
      RPI3.MAIL0_Write := (RPI3.PROPERTY_CHANNEL_ID, Bits.Bits_28 (Shift_Right (To_U64 (M_Data'Address), 4)));
      while RPI3.MAIL0_Status.Empty loop CPU.NOP; end loop;
      M := RPI3.MAIL0_Read;
      return Integer (M_Data (6));
   end Clock_Get;

   ----------------------------------------------------------------------------
   -- Clock_Set
   ----------------------------------------------------------------------------
   procedure Clock_Set
      (Clock_ID : in Unsigned_32;
       Value    : in Unsigned_32)
      is
      type Message_Data_Type is array (0 .. 11) of Unsigned_32
         with Alignment => 16,
              Size      => 12 * 32;
      M_Data : aliased Message_Data_Type
         with Address    => System'To_Address (16#3AC00000#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;
      M      : RPI3.Message_Type
         with Unreferenced => True;
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      while RPI3.MAIL0_Status.Full loop CPU.NOP; end loop;
      M_Data (0)  := 12 * 4;             -- total size (bytes)
      M_Data (1)  := 0;                  -- response to all tag messages
      -- tag #0
      M_Data (2)  := RPI3.TAG_SET_CLOCK; -- tag ID
      M_Data (3)  := 12;                 -- buffer size = M_Data (5) + M_Data (6) + M_Data (7)
      M_Data (4)  := 0;                  -- request/response code
      M_Data (5)  := Clock_ID;           -- value buffer
      M_Data (6)  := Value;              -- value buffer
      M_Data (7)  := 1;                  -- value buffer, skip turbo
      M_Data (8)  := 0;                  -- no more tags
      M_Data (9)  := 0;                  -- no more tags
      M_Data (10) := 0;                  -- no more tags
      M_Data (11) := 0;                  -- no more tags
      RPI3.MAIL0_Write := (RPI3.PROPERTY_CHANNEL_ID, Bits.Bits_28 (Shift_Right (To_U64 (M_Data'Address), 4)));
      while RPI3.MAIL0_Status.Empty loop CPU.NOP; end loop;
      M := RPI3.MAIL0_Read;
   end Clock_Set;

   ----------------------------------------------------------------------------
   -- Voltage_Get
   ----------------------------------------------------------------------------
   function Voltage_Get
      (Voltage_ID : Unsigned_32)
      return Integer
      is
      type Message_Data_Type is array (0 .. 7) of Unsigned_32
         with Alignment => 16,
              Size      => 8 * 32;
      M_Data : aliased Message_Data_Type
         with Address    => System'To_Address (16#3AC00000#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;
      M      : RPI3.Message_Type
         with Unreferenced => True;
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      while RPI3.MAIL0_Status.Full loop CPU.NOP; end loop;
      M_Data (0) := 8 * 4;                -- total size (bytes)
      M_Data (1) := 0;                    -- response to all tag messages
      -- tag #0
      M_Data (2) := RPI3.TAG_GET_VOLTAGE; -- tag ID
      M_Data (3) := 8;                    -- buffer size = M_Data (5) + M_Data (6)
      M_Data (4) := 0;                    -- request/response code
      M_Data (5) := Voltage_ID;           -- value buffer
      M_Data (6) := 0;                    -- value buffer
      M_Data (7) := 0;                    -- no more tags
      RPI3.MAIL0_Write := (RPI3.PROPERTY_CHANNEL_ID, Bits.Bits_28 (Shift_Right (To_U64 (M_Data'Address), 4)));
      while RPI3.MAIL0_Status.Empty loop CPU.NOP; end loop;
      M := RPI3.MAIL0_Read;
      return Integer (M_Data (6));
   end Voltage_Get;

   ----------------------------------------------------------------------------
   -- Temperature_Get
   ----------------------------------------------------------------------------
   function Temperature_Get
      (Temperature_ID : Unsigned_32)
      return Integer
      is
      type Message_Data_Type is array (0 .. 7) of Unsigned_32
         with Alignment => 16,
              Size      => 8 * 32;
      M_Data : aliased Message_Data_Type
         with Address    => System'To_Address (16#3AC00000#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;
      M      : RPI3.Message_Type
         with Unreferenced => True;
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      while RPI3.MAIL0_Status.Full loop CPU.NOP; end loop;
      M_Data (0) := 8 * 4;                    -- total size (bytes)
      M_Data (1) := 0;                        -- response to all tag messages
      -- tag #0
      M_Data (2) := RPI3.TAG_GET_TEMPERATURE; -- tag ID
      M_Data (3) := 8;                        -- buffer size = M_Data (5) + M_Data (6)
      M_Data (4) := 0;                        -- request/response code
      M_Data (5) := RPI3.TEMPERATURE_ID;      -- value buffer
      M_Data (6) := 0;                        -- value buffer
      M_Data (7) := 0;                        -- no more tags
      RPI3.MAIL0_Write := (RPI3.PROPERTY_CHANNEL_ID, Bits.Bits_28 (Shift_Right (To_U64 (M_Data'Address), 4)));
      while RPI3.MAIL0_Status.Empty loop CPU.NOP; end loop;
      M := RPI3.MAIL0_Read;
      return Integer (M_Data (6));
   end Temperature_Get;

   ----------------------------------------------------------------------------
   -- AP1
   ----------------------------------------------------------------------------
   procedure AP1
      is
      Delay_Count : constant := 100_000_000;
   begin
      while True loop
         Mutex.Acquire (M); -- acquire console mutex
         -- dump informations from GPU side
         Console.Print ("--------------------------------", NL => True);
         Console.Print (Prefix => "Clock (CORE):     ", Value => Clock_Get (RPI3.CLOCK_CORE_ID), NL => True);
         Console.Print (Prefix => "Clock (ARM):      ", Value => Clock_Get (RPI3.CLOCK_ARM_ID), NL => True);
         Console.Print (Prefix => "Clock (UART):     ", Value => Clock_Get (RPI3.CLOCK_UART_ID), NL => True);
         Console.Print (Prefix => "Voltage (CORE):   ", Value => Voltage_Get (RPI3.VOLTAGE_CORE_ID), NL => True);
         Console.Print (Prefix => "Voltage (SDRAMC): ", Value => Voltage_Get (RPI3.VOLTAGE_SDRAMC_ID), NL => True);
         Console.Print (Prefix => "Voltage (SDRAMP): ", Value => Voltage_Get (RPI3.VOLTAGE_SDRAMP_ID), NL => True);
         Console.Print (Prefix => "Voltage (SDRAMI): ", Value => Voltage_Get (RPI3.VOLTAGE_SDRAMI_ID), NL => True);
         Console.Print (Prefix => "Temperature:      ", Value => Temperature_Get (RPI3.TEMPERATURE_ID), NL => True);
         Mutex.Release (M); -- release console mutex
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
      end loop;
   end AP1;

   ----------------------------------------------------------------------------
   -- AP2
   ----------------------------------------------------------------------------
   procedure AP2
      is
      Delay_Count : constant := 30_000_000;
   begin
      while True loop
         -- GPIO06 ON
         RPI3.GPSET0 := (SET6 => True, others => False);
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         -- GPIO06 OFF
         RPI3.GPCLR0 := (CLR6 => True, others => False);
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
      end loop;
   end AP2;

   ----------------------------------------------------------------------------
   -- AP3
   ----------------------------------------------------------------------------
   procedure AP3
      is
      Delay_Count : constant := 3_000_000;
      Count       : Unsigned_32; -- with Unreferenced => True;
   begin
      Count := 0;
      while True loop
         Count := @ + 1;
         Mutex.Acquire (M); -- acquire console mutex
         Console.Print (Prefix => "Count: ", Value => Count, NL => True);
         Mutex.Release (M); -- release console mutex
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
      end loop;
   end AP3;

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run
      is
   begin
      -- start "application" cores --------------------------------------------
      if True then
         AP_Key := 16#AA55_AA55#;
         declare
            function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
         begin
            AP_sp (1) := To_U64 (SP1 (SP1'Last)'Address) + 1;
            AP_pc (1) := To_U64 (AP1'Address);
            AP_sp (2) := To_U64 (SP2 (SP2'Last)'Address) + 1;
            AP_pc (2) := To_U64 (AP2'Address);
            AP_sp (3) := To_U64 (SP3 (SP3'Last)'Address) + 1;
            AP_pc (3) := To_U64 (AP3'Address);
         end;
      end if;
      -------------------------------------------------------------------------
      if False then
         -- test: change core frequency
         Clock_Set (RPI3.CLOCK_CORE_ID, 125 * MHz1);
         RPI3.AUX_MU_BAUD.Baudrate := 16#0CB6# / 2; -- 9600 bps @ 125 MHz
      end if;
      -------------------------------------------------------------------------
      while True loop
         ARMv8A.WFI;
         -- Mutex.Acquire (M); -- acquire console mutex
         -- Console.Print ("*** Wake up from interrupt", NL => True);
         -- Mutex.Release (M); -- release console mutex
      end loop;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
