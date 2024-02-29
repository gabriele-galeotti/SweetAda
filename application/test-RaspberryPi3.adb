
with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Core;
with Bits;
with CPU;
with RPI3;
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
         with Volatile => True;
      M      : RPI3.Message_Type
         with Unreferenced => True;
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      while RPI3.MAIL0_Status.Full loop null; end loop;
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
      while RPI3.MAIL0_Status.Empty loop null; end loop;
      M := RPI3.MAIL0_Read;
      -- Console.Print (M_Data (1), Prefix => "Response(1): ", NL => True);
      -- Console.Print (M_Data (4), Prefix => "Response(4): ", NL => True);
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
         with Volatile => True;
      M      : RPI3.Message_Type
         with Unreferenced => True;
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      while RPI3.MAIL0_Status.Full loop null; end loop;
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
      while RPI3.MAIL0_Status.Empty loop null; end loop;
      M := RPI3.MAIL0_Read;
      -- Console.Print (M_Data (1), Prefix => "Response(1): ", NL => True);
      -- Console.Print (M_Data (4), Prefix => "Response(4): ", NL => True);
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
         with Volatile => True;
      M      : RPI3.Message_Type
         with Unreferenced => True;
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      while RPI3.MAIL0_Status.Full loop null; end loop;
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
      while RPI3.MAIL0_Status.Empty loop null; end loop;
      M := RPI3.MAIL0_Read;
      -- Console.Print (M_Data (1), Prefix => "Response(1): ", NL => True);
      -- Console.Print (M_Data (4), Prefix => "Response(4): ", NL => True);
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
         with Volatile => True;
      M      : RPI3.Message_Type
         with Unreferenced => True;
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      while RPI3.MAIL0_Status.Full loop null; end loop;
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
      while RPI3.MAIL0_Status.Empty loop null; end loop;
      M := RPI3.MAIL0_Read;
      -- Console.Print (M_Data (1), Prefix => "Response(1): ", NL => True);
      -- Console.Print (M_Data (4), Prefix => "Response(4): ", NL => True);
      return Integer (M_Data (6));
   end Temperature_Get;

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run
      is
   begin
      -------------------------------------------------------------------------
      declare
         Delay_Count : constant := 3_000_000;
      begin
         -- test: change core frequency
         -- Clock_Set (RPI3.CLOCK_CORE_ID, 125_000_000);
         -- RPI3.AUX_MU_BAUD.Baudrate := 16#0CB6# / 2; -- 9600 bps @ 125 MHz
         while True loop
            -- GPIO06 ON
            RPI3.GPSET0 := (SET6 => True, others => False);
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- GPIO06 OFF
            RPI3.GPCLR0 := (CLR6 => True, others => False);
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- dump informations from GPU side
            Console.Print ("--------------------------------", NL => True);
            Console.Print (Clock_Get (RPI3.CLOCK_CORE_ID),        Prefix => "Clock (CORE):     ", NL => True);
            Console.Print (Clock_Get (RPI3.CLOCK_ARM_ID),         Prefix => "Clock (ARM):      ", NL => True);
            Console.Print (Clock_Get (RPI3.CLOCK_UART_ID),        Prefix => "Clock (UART):     ", NL => True);
            Console.Print (Voltage_Get (RPI3.VOLTAGE_CORE_ID),    Prefix => "Voltage (CORE):   ", NL => True);
            Console.Print (Voltage_Get (RPI3.VOLTAGE_SDRAMC_ID),  Prefix => "Voltage (SDRAMC): ", NL => True);
            Console.Print (Voltage_Get (RPI3.VOLTAGE_SDRAMP_ID),  Prefix => "Voltage (SDRAMP): ", NL => True);
            Console.Print (Voltage_Get (RPI3.VOLTAGE_SDRAMI_ID),  Prefix => "Voltage (SDRAMI): ", NL => True);
            Console.Print (Temperature_Get (RPI3.TEMPERATURE_ID), Prefix => "Temperature:      ", NL => True);
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
