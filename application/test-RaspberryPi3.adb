
with Ada.Unchecked_Conversion;
with System;
with System.Storage_Elements;
with Interfaces;
with Bits;
with CPU;
with RPI3;
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
   use Interfaces;
   use Bits;

   function Voltage return Integer;
   function Temperature return Integer;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Voltage
   ----------------------------------------------------------------------------
   function Voltage return Integer is
      type Message_Data_Type is array (0 .. 7) of Unsigned_32 with
         Alignment => 16,
         Size      => 8 * 32;
      M      : RPI3.Message_Type;
      M_Data : aliased Message_Data_Type with
         Volatile => True;
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      while RPI3.MAIL0_Status.Full loop null; end loop;
      M_Data (0) := 8 * 4;        -- total size
      M_Data (1) := 0;            -- response to all tag messages
      -- tag #0
      -- M_Data (2) := 16#00030003#; -- tag ID: 3=HW, 0=get, 003=command
      -- M_Data (3) := 8;            -- buffer size = M_Data (5) + M_Data (6)
      -- M_Data (4) := 0;            -- request/response
      -- M_Data (5) := 1;            -- value buffer
      -- M_Data (6) := 0;            -- value buffer
      -- M_Data (7) := 0;            -- no more tags
      M_Data (2) := 16#00030002#; -- tag ID: 3=HW, 0=get, 003=command
      M_Data (3) := 8;            -- buffer size = M_Data (5) + M_Data (6)
      M_Data (4) := 0;            -- request/response
      M_Data (5) := 1;            -- value buffer
      M_Data (6) := 0;            -- value buffer
      M_Data (7) := 0;            -- no more tags
      RPI3.MAIL0_Write := (8, Bits.Bits_28 (Shift_Right (To_U64 (M_Data'Address), 4)));
      while RPI3.MAIL0_Status.Empty loop null; end loop;
      M := RPI3.MAIL0_Read;
      Console.Print (M_Data (4), Prefix => "Response: ", NL => True);
      return Integer (M_Data (6));
   end Voltage;

   ----------------------------------------------------------------------------
   -- Temperature
   ----------------------------------------------------------------------------
   function Temperature return Integer is
      type Message_Data_Type is array (0 .. 7) of Unsigned_32 with
         Alignment => 16,
         Size      => 8 * 32;
      M      : RPI3.Message_Type;
      M_Data : aliased Message_Data_Type with
         Volatile => True;
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      while RPI3.MAIL0_Status.Full loop null; end loop;
      M_Data (0) := 8 * 4;        -- total size
      M_Data (1) := 0;            -- response to all tag messages
      -- tag #0
      M_Data (2) := 16#00030006#; -- tag ID: 3=HW, 0=get, 006=command
      M_Data (3) := 8;            -- buffer size = M_Data (5) + M_Data (6)
      M_Data (4) := 0;            -- request/response
      M_Data (5) := 0;            -- value buffer
      M_Data (6) := 0;            -- value buffer
      M_Data (7) := 0;            -- no more tags
      RPI3.MAIL0_Write := (8, Bits.Bits_28 (Shift_Right (To_U64 (M_Data'Address), 4)));
      while RPI3.MAIL0_Status.Empty loop null; end loop;
      M := RPI3.MAIL0_Read;
      Console.Print (M_Data (4), Prefix => "Response: ", NL => True);
      return Integer (M_Data (6));
   end Temperature;

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run is
   begin
      -------------------------------------------------------------------------
      declare
         Delay_Count : constant := 1_000_000;
      begin
         -- GPIO16 pin #36 is an output
         RPI3.GPFSEL1 := (@ and 16#FFE3_FFFF#) or 16#0004_0000#;
         while True loop
            RPI3.LEDON := 16#0001_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            RPI3.LEDOFF := 16#0001_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- Console.Print ("hello, SweetAda", NL => True);
            Console.Print (Voltage, Prefix => "Voltage: ", NL => True);
            Console.Print (Temperature, Prefix => "Temperature: ", NL => True);
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
