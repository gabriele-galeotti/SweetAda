-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mc146818a.adb                                                                                             --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with LLutils;
with CPU;

package body MC146818A
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use LLutils;

   ----------------------------------------------------------------------------
   -- Register types
   ----------------------------------------------------------------------------

   type Register_Type is
      (Seconds, Seconds_Alarm, Minutes,   Minutes_Alarm, Hours,     Hours_Alarm, DayOfWeek, DayOfMonth,
       Month,   Year,          RegisterA, RegisterB,     RegisterC, RegisterD,   RAM0E,     RAM0F,
       RAM10,   RAM11,         RAM12,     RAM13,         RAM14,     RAM15,       RAM16,     RAM17,
       RAM18,   RAM19,         RAM1A,     RAM1B,         RAM1C,     RAM1D,       RAM1E,     RAM1F,
       RAM20,   RAM21,         RAM22,     RAM23,         RAM24,     RAM25,       RAM26,     RAM27,
       RAM28,   RAM29,         RAM2A,     RAM2B,         RAM2C,     RAM2D,       RAM2E,     RAM2F,
       RAM30,   RAM31,         RAM32,     RAM33,         RAM34,     RAM35,       RAM36,     RAM37,
       RAM38,   RAM39,         RAM3A,     RAM3B,         RAM3C,     RAM3D,       RAM3E,     RAM3F);
   for Register_Type use
      (
       16#00#, -- Seconds
       16#01#, -- Seconds_Alarm
       16#02#, -- Minutes
       16#03#, -- Minutes_Alarm
       16#04#, -- Hours
       16#05#, -- Hours_Alarm
       16#06#, -- DayOfWeek
       16#07#, -- DayOfMonth
       16#08#, -- Month
       16#09#, -- Year
       16#0A#, -- RegisterA
       16#0B#, -- RegisterB
       16#0C#, -- RegisterC
       16#0D#, -- RegisterD
       -- RAM
       16#0E#, 16#0F#, 16#10#, 16#11#, 16#12#, 16#13#, 16#14#, 16#15#,
       16#16#, 16#17#, 16#18#, 16#19#, 16#1A#, 16#1B#, 16#1C#, 16#1D#,
       16#1E#, 16#1F#, 16#20#, 16#21#, 16#22#, 16#23#, 16#24#, 16#25#,
       16#26#, 16#27#, 16#28#, 16#29#, 16#2A#, 16#2B#, 16#2C#, 16#2D#,
       16#2E#, 16#2F#, 16#30#, 16#31#, 16#32#, 16#33#, 16#34#, 16#35#,
       16#36#, 16#37#, 16#38#, 16#39#, 16#3A#, 16#3B#, 16#3C#, 16#3D#,
       16#3E#, 16#3F#
      );

   -- REGISTER A ($0A)

   -- TABLE 5 – PERIODIC INTERRUPT RATE AND SQUARE WAVE OUTPUT FREQUENCY
   RS_None  : constant := 2#0000#; -- N/A
   RS_256   : constant := 2#0001#; -- PIR = 3.90625 ms, SQW f = 256 Hz
   RS_128   : constant := 2#0010#; -- PIR = 7.8125 ms, SQW f = 128 Hz
   RS_8k192 : constant := 2#0011#; -- PIR = 122.070 us, SQW f = 8.192 kHz
   RS_4k096 : constant := 2#0100#; -- PIR = 244.141 us, SQW f = 4.096 kHz
   RS_2k048 : constant := 2#0101#; -- PIR = 488.281 us, SQW f = 2.048 kHz
   RS_1k024 : constant := 2#0110#; -- PIR = 976.562 us, SQW f = 1.024 kHz
   RS_512   : constant := 2#0111#; -- PIR = 1.953125 ms, SQW f = 512 Hz
   RS_256_2 : constant := 2#1000#; -- PIR = 3.90625 ms, SQW f = 256 Hz
   RS_128_2 : constant := 2#1001#; -- PIR = 7.8125 ms, SQW f = 128 Hz
   RS_64    : constant := 2#1010#; -- PIR = 15.625 ms, SQW f = 64 Hz
   RS_32    : constant := 2#1011#; -- PIR = 31.25 ms, SQW f = 32 Hz
   RS_16    : constant := 2#1100#; -- PIR = 62.5 ms, SQW f = 16 Hz
   RS_8     : constant := 2#1101#; -- PIR = 125 ms, SQW f = 8 Hz
   RS_4     : constant := 2#1110#; -- PIR = 250 ms, SQW f = 4 Hz
   RS_2     : constant := 2#1111#; -- PIR = 500 ms, SQW f = 2 Hz

   -- TABLE 4 - DIVIDER CONFIGURATIONS
   DIV_4M   : constant := 2#000#; -- Time Base Frequency = 4.194304 MHz, Operation Mode = Yes, N = 0
   DIV_1M   : constant := 2#001#; -- Time Base Frequency = 1.048576 MHz, Operation Mode = Yes, N = 2
   DIV_32k  : constant := 2#010#; -- Time Base Frequency = 32.768 kHz, Operation Mode = Yes, N = 7
   DIV_Any1 : constant := 2#110#; -- Time Base Frequency = Any, Operation Mode = No
   DIV_Any2 : constant := 2#111#; -- Time Base Frequency = Any, Operation Mode = No

   type RegisterA_Type is record
      RS  : Bits_4;           -- rate selection
      DIV : Bits_3;           -- divider chain
      UIP : Boolean := False; -- update in progress
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RegisterA_Type use record
      RS  at 0 range 0 .. 3;
      DIV at 0 range 4 .. 6;
      UIP at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (RegisterA_Type, Unsigned_8);
   function To_RA is new Ada.Unchecked_Conversion (Unsigned_8, RegisterA_Type);

   -- REGISTER B ($0B)

   Hour24_12 : constant := 0; -- 12-hour mode
   Hour24_24 : constant := 1; -- 24-hour mode

   DM_BCD    : constant := 0; -- binary-coded-decimal (BCD) data
   DM_BINARY : constant := 1; -- binary data

   type RegisterB_Type is record
      DSE    : Boolean; -- daylight savings enable
      Hour24 : Bits_1;  -- format of the hours bytes
      DM     : Bits_1;  -- data mode
      SQWE   : Boolean; -- square-wave enable
      UIE    : Boolean; -- update-ended interrupt enable)
      AIE    : Boolean; -- alarm interrupt enable
      PIE    : Boolean; -- periodic interrupt enable
      SET    : Boolean; -- initialize the time and calendar bytes
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RegisterB_Type use record
      DSE    at 0 range 0 .. 0;
      Hour24 at 0 range 1 .. 1;
      DM     at 0 range 2 .. 2;
      SQWE   at 0 range 3 .. 3;
      UIE    at 0 range 4 .. 4;
      AIE    at 0 range 5 .. 5;
      PIE    at 0 range 6 .. 6;
      SET    at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (RegisterB_Type, Unsigned_8);
   function To_RB is new Ada.Unchecked_Conversion (Unsigned_8, RegisterB_Type);

   -- REGISTER C ($0C)

   type RegisterC_Type is record
      Unused : Bits_4;
      UF     : Boolean; -- update-ended interrupt flag
      AF     : Boolean; -- alarm interrupt flag
      PF     : Boolean; -- periodic interrupt flag
      IRQF   : Boolean; -- interrupt request flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RegisterC_Type use record
      Unused at 0 range 0 .. 3;
      UF     at 0 range 4 .. 4;
      AF     at 0 range 5 .. 5;
      PF     at 0 range 6 .. 6;
      IRQF   at 0 range 7 .. 7;
   end record;

   function To_RC is new Ada.Unchecked_Conversion (Unsigned_8, RegisterC_Type);

   -- REGISTER D ($0D)

   type RegisterD_Type is record
      Unused : Bits_7;
      VRT    : Boolean; -- valid RAM and time
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RegisterD_Type use record
      Unused at 0 range 0 .. 6;
      VRT    at 0 range 7 .. 7;
   end record;

   function To_RD is new Ada.Unchecked_Conversion (Unsigned_8, RegisterD_Type);

   -- Register_Read/Write

   function Register_Read
      (D : Descriptor_Type;
       R : Register_Type)
      return Unsigned_8
      with Inline => True;

   procedure Register_Write
      (D     : in Descriptor_Type;
       R     : in Register_Type;
       Value : in Unsigned_8)
      with Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Register_Read
   ----------------------------------------------------------------------------
   function Register_Read
      (D : Descriptor_Type;
       R : Register_Type)
      return Unsigned_8
      is
   begin
      return D.Read_8 (Build_Address (
         D.Base_Address,
         Storage_Offset (Register_Type'Enum_Rep (R)),
         D.Scale_Address
         ));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Register_Write
      (D     : in Descriptor_Type;
       R     : in Register_Type;
       Value : in Unsigned_8)
      is
   begin
      D.Write_8 (Build_Address (
         D.Base_Address,
         Storage_Offset (Register_Type'Enum_Rep (R)),
         D.Scale_Address
         ), Value);
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Handle
   ----------------------------------------------------------------------------
   procedure Handle
      (Data_Address : in System.Address)
      is
      D      : aliased Descriptor_Type
         with Address    => Data_Address,
              Import     => True,
              Convention => Ada;
      Unused : Unsigned_8 with Unreferenced => True;
   begin
      -- reset RTC interrupt flag by reading Register C
      Unused := Register_Read (D, RegisterC);
   end Handle;

   ----------------------------------------------------------------------------
   -- Read_Clock
   ----------------------------------------------------------------------------
   procedure Read_Clock
      (D : in     Descriptor_Type;
       T :    out Time.TM_Time)
      is
      Intcontext     : CPU.Intcontext_Type;
      RB             : RegisterB_Type;
      RTC_BCD        : Boolean;
      RTC_Second     : Unsigned_8;
      RTC_Minute     : Unsigned_8;
      RTC_Hour       : Unsigned_8;
      RTC_DayOfWeek  : Unsigned_8;
      RTC_DayOfMonth : Unsigned_8;
      RTC_Month      : Unsigned_8;
      RTC_Year       : Unsigned_8;
      function Adjust_BCD
         (V   : Unsigned_8;
          BCD : Boolean)
         return Unsigned_8
         with Inline => True;
      function Adjust_BCD
         (V   : Unsigned_8;
          BCD : Boolean)
         return Unsigned_8
         is
      begin
         return (if BCD then BCD2U8 (V) else V);
      end Adjust_BCD;
   begin
      CPU.Intcontext_Get (Intcontext);
      CPU.Irq_Disable;
      loop
         exit when not To_RA (Register_Read (D, RegisterA)).UIP;
      end loop;
      -- register reads within 244 us
      RTC_Second     := Register_Read (D, Seconds);
      RTC_Minute     := Register_Read (D, Minutes);
      RTC_Hour       := Register_Read (D, Hours);
      RTC_DayOfWeek  := Register_Read (D, DayOfWeek);
      RTC_DayOfMonth := Register_Read (D, DayOfMonth);
      RTC_Month      := Register_Read (D, Month);
      RTC_Year       := Register_Read (D, Year);
      RB := To_RB (Register_Read (D, RegisterB));
      CPU.Intcontext_Set (Intcontext);
      RTC_BCD := RB.DM = DM_BCD;
      T.IsDST := (if RB.DSE then 1 else 0);
      T.Sec   := Natural (Adjust_BCD (RTC_Second, RTC_BCD));
      T.Min   := Natural (Adjust_BCD (RTC_Minute, RTC_BCD));
      T.Hour  := Natural (Adjust_BCD (RTC_Hour, RTC_BCD));
      T.WDay  := Natural (Adjust_BCD (RTC_DayOfWeek, RTC_BCD));
      T.MDay  := Natural (Adjust_BCD (RTC_DayOfMonth, RTC_BCD));
      T.Mon   := Natural (Adjust_BCD (RTC_Month - 1, RTC_BCD));
      T.Year  := Natural (Adjust_BCD (RTC_Year, RTC_BCD));
      T.Year  := @ + (if @ < 70 then 100 else 0);
      T.YDay  := 0;
   end Read_Clock;

   ----------------------------------------------------------------------------
   -- Set_Clock
   ----------------------------------------------------------------------------
   procedure Set_Clock
      (D : in Descriptor_Type;
       T : in Time.TM_Time)
      is
      RB      : RegisterB_Type;
      RTC_BCD : Boolean;
      function Adjust_BCD
         (V   : Unsigned_8;
          BCD : Boolean)
         return Unsigned_8
         with Inline => True;
      function Adjust_BCD
         (V   : Unsigned_8;
          BCD : Boolean)
         return Unsigned_8
         is
      begin
         return (if BCD then U82BCD (V) else V);
      end Adjust_BCD;
   begin
      RB := To_RB (Register_Read (D, RegisterB));
      RB.SET := True;
      RTC_BCD := RB.DM = DM_BCD;
      Register_Write (D, RegisterB, To_U8 (RB));
      Register_Write (D, Seconds, Adjust_BCD (Unsigned_8 (T.Sec), RTC_BCD));
      Register_Write (D, Minutes, Adjust_BCD (Unsigned_8 (T.Min), RTC_BCD));
      Register_Write (D, Hours, Adjust_BCD (Unsigned_8 (T.Hour), RTC_BCD));
      Register_Write (D, DayOfMonth, Adjust_BCD (Unsigned_8 (T.MDay), RTC_BCD));
      Register_Write (D, Month, Adjust_BCD (Unsigned_8 (T.Mon) + 1, RTC_BCD));
      Register_Write (D, Year, Adjust_BCD (Unsigned_8 (T.Year), RTC_BCD));
      RB.DSE := T.IsDST > 0;
      RB.SET := False;
      Register_Write (D, RegisterB, To_U8 (RB));
   end Set_Clock;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      (D : in Descriptor_Type)
      is
      RA     : RegisterA_Type;
      Unused : Unsigned_8 with Unreferenced => True;
      RB     : RegisterB_Type;
   begin
      -- operating time base = 32.768 kHz, periodic interrupt = 1024 Hz
      RA := (RS => RS_1k024, DIV => DIV_32k, others => <>);
      Register_Write (D, RegisterA, To_U8 (RA));
      -- clear pending interrupts
      Unused := Register_Read (D, RegisterC);
      -- enable PIE interrupt in Register B
      RB := To_RB (Register_Read (D, RegisterB));
      RB.DM  := DM_BCD;
      RB.AIE := False;
      RB.PIE := True;
      RB.SET := False;
      Register_Write (D, RegisterB, To_U8 (RB));
   end Init;

end MC146818A;
