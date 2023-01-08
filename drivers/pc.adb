-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pc.adb                                                                                                    --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with CPU.IO;

package body PC is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use type CPU.Irq_Id_Type;

   PIC_Lock : CPU.Lock_Type;
   PIT_Lock : CPU.Lock_Type;
   RTC_Lock : CPU.Lock_Type;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- PIC_Init
   ----------------------------------------------------------------------------
   -- NOTE: PIC1 = master and PIC2 = slave are set at the hardware level:
   -- pin 16 (SP/EN) is HIGH for PIC1 and LOW for PIC2
   -- ICW1 = 0x19 for level triggered mode
   ----------------------------------------------------------------------------
   procedure PIC_Init (Vector_Offset_Master : in Unsigned_8; Vector_Offset_Slave : in Unsigned_8) is
   begin
      CPU.Lock (PIC_Lock);
      -- PIC2 (slave)
      CPU.IO.PortOut (PIC2_ICW1, Unsigned_8'(16#11#));  -- edge triggered, cascade mode, ICW4 required
      CPU.IO.PortOut (PIC2_ICW2, Vector_Offset_Slave);  -- vector offset, for an x86 PC = 0x28 (40 .. 47)
      CPU.IO.PortOut (PIC2_ICW3, Unsigned_8'(16#02#));  -- slave PIC id (is connected to IR 2)
      CPU.IO.PortOut (PIC2_ICW4, Unsigned_8'(16#01#));  -- no SFNM, non-buffered, manual EOI, 8086 mode
      -- PIC1 (master)
      CPU.IO.PortOut (PIC1_ICW1, Unsigned_8'(16#11#));  -- edge triggered, cascade mode, ICW4 required
      CPU.IO.PortOut (PIC1_ICW2, Vector_Offset_Master); -- vector offset, for an x86 PC = 0x20 (32 .. 39)
      CPU.IO.PortOut (PIC1_ICW3, Unsigned_8'(16#04#));  -- (1 << 2): IR line 2 is connected to a slave PIC
      CPU.IO.PortOut (PIC1_ICW4, Unsigned_8'(16#01#));  -- no SFNM, non-buffered, manual EOI, 8086 mode
      -- after initialization sequence, all IRQ lines default to enabled,
      -- so disable them
      CPU.IO.PortOut (PIC2_OCW1, Unsigned_8'(16#FF#));  -- PIC2: all masked
      CPU.IO.PortOut (PIC1_OCW1, Unsigned_8'(16#FB#));  -- PIC1: all masked except IR line 2
      --
      CPU.Unlock (PIC_Lock);
   end PIC_Init;

   ----------------------------------------------------------------------------
   -- PIC_Irq_Enable
   ----------------------------------------------------------------------------
   -- Enable an IRQ hardware signal.
   ----------------------------------------------------------------------------
   procedure PIC_Irq_Enable (Irq : in CPU.Irq_Id_Type) is
      Irq_Line : Natural range 0 .. 7;
      Port     : Unsigned_16;
      Data     : Unsigned_8;
   begin
      if Irq > PIC_Irq7 then
         Irq_Line := Natural (Irq - PIC_Irq8);
         Port := PIC2_OCW1;
      else
         Irq_Line := Natural (Irq - PIC_Irq0);
         Port := PIC1_OCW1;
      end if;
      CPU.Lock (PIC_Lock);
      Data := CPU.IO.PortIn (Port);
      CPU.IO.PortOut (Port, Data and not Shift_Left (1, Irq_Line));
      CPU.Unlock (PIC_Lock);
   end PIC_Irq_Enable;

   ----------------------------------------------------------------------------
   -- PIC_Irq_Disable
   ----------------------------------------------------------------------------
   -- Disable an IRQ hardware signal.
   ----------------------------------------------------------------------------
   procedure PIC_Irq_Disable (Irq : in CPU.Irq_Id_Type) is
      Irq_Line : Natural range 0 .. 7;
      Port     : Unsigned_16;
      Data     : Unsigned_8;
   begin
      if Irq = PIC_Irq2 then
         -- prevent disabling all PIC2 IRs at once
         return;
      end if;
      if Irq > PIC_Irq7 then
         Irq_Line := Natural (Irq - PIC_Irq8);
         Port := PIC2_OCW1;
      else
         Irq_Line := Natural (Irq - PIC_Irq0);
         Port := PIC1_OCW1;
      end if;
      CPU.Lock (PIC_Lock);
      Data := CPU.IO.PortIn (Port);
      CPU.IO.PortOut (Port, Data or Shift_Left (1, Irq_Line));
      CPU.Unlock (PIC_Lock);
   end PIC_Irq_Disable;

   ----------------------------------------------------------------------------
   -- PIC1_EOI
   ----------------------------------------------------------------------------
   procedure PIC1_EOI is
   begin
      CPU.IO.PortOut (PIC1_OCW2, Unsigned_8'(16#20#));
   end PIC1_EOI;

   ----------------------------------------------------------------------------
   -- PIC2_EOI
   ----------------------------------------------------------------------------
   -- For a slave PIC interrupt, an EOI should be sent also to the master.
   ----------------------------------------------------------------------------
   procedure PIC2_EOI is
   begin
      CPU.Lock (PIC_Lock);
      CPU.IO.PortOut (PIC1_OCW2, Unsigned_8'(16#20#));
      CPU.IO.PortOut (PIC2_OCW2, Unsigned_8'(16#20#));
      CPU.Unlock (PIC_Lock);
   end PIC2_EOI;

   ----------------------------------------------------------------------------
   -- PIT_Counter0_Init
   ----------------------------------------------------------------------------
   procedure PIT_Counter0_Init (Count : in Unsigned_16) is
   begin
      -- MODE2 = Rate Generator
      CPU.IO.PortOut (CONTROL_WORD, To_U8 (PIT_Control_Word_Type'(
                                                                  BCD  => False,
                                                                  MODE => MODE2,
                                                                  RW   => RW_BOTH_BYTE,
                                                                  SC   => SELECT_COUNTER0
                                                                 )));
      CPU.IO.PortOut (COUNTER0, Bits.LByte (Count));
      CPU.IO.PortOut (COUNTER0, Bits.HByte (Count));
   end PIT_Counter0_Init;

   ----------------------------------------------------------------------------
   -- PIT_Counter1_Delay
   ----------------------------------------------------------------------------
   -- Perform a delay in 100 us unit by using PIT COUNTER1.
   -- PIT timer input frequency: 1.19318 MHz, T = 0.838 us
   -- NOTE: for MODE0 count is N + 1 cycles
   -- NOTE: PIT should be reprogrammed after every terminal count
   ----------------------------------------------------------------------------
   procedure PIT_Counter1_Delay (Delay100us_Units : in Positive) is
      US100_count : constant := ((((PIT_CLK * 100) + (1_000_000 / 2)) / 1_000_000) - 1);
   begin
      CPU.Lock (PIT_Lock);
      for Index in 1 .. Delay100us_Units loop
         -- MODE0: INTERRUPT ON TERMINAL COUNT, two bytes of counting,
         CPU.IO.PortOut (CONTROL_WORD, To_U8 (PIT_Control_Word_Type'(
                                                                     BCD  => False,
                                                                     MODE => MODE0,
                                                                     RW   => RW_BOTH_BYTE,
                                                                     SC   => SELECT_COUNTER1
                                                                    )));
         CPU.IO.PortOut (COUNTER1, Bits.LByte (Unsigned_16 (US100_count)));
         CPU.IO.PortOut (COUNTER1, Bits.HByte (Unsigned_16 (US100_count)));
         loop
            -- latch STATUS
            CPU.IO.PortOut (CONTROL_WORD, To_U8 (PIT_Control_Word_Type'(
                                                                        BCD  => False,
                                                                        MODE => READBACK_COUNTER1,
                                                                        RW   => READBACK_LATCH_STATUS,
                                                                        SC   => READBACK
                                                                       )));

            -- read STATUS from COUNTER1 and test if OUT is high
            exit when To_PIT_Status (Unsigned_8'(CPU.IO.PortIn (COUNTER1))).OUT_Pin;
         end loop;
      end loop;
      CPU.Unlock (PIT_Lock);
   end PIT_Counter1_Delay;

   ----------------------------------------------------------------------------
   -- RTC_Init
   ----------------------------------------------------------------------------
   procedure RTC_Init is
      Data : Unsigned_8 with Volatile => True;
   begin
      CPU.Lock (RTC_Lock);
      -- operating time base = 32.768 kHz, periodic interrupt = 1024 Hz
      CPU.IO.PortOut (RTC_INDEX, Unsigned_8'(RTC_NMI_DISABLE or RTC_REGISTER_A));
      CPU.IO.PortOut (RTC_DATA, Unsigned_8'(16#26#));
      -- clear pending interrupts
      CPU.IO.PortOut (RTC_INDEX, Unsigned_8'(RTC_NMI_DISABLE or RTC_REGISTER_C));
      Data := CPU.IO.PortIn (RTC_DATA);
      -- read register B
      CPU.IO.PortOut (RTC_INDEX, Unsigned_8'(RTC_NMI_DISABLE or RTC_REGISTER_B));
      Data := CPU.IO.PortIn (RTC_DATA);
      -- enable PIE interrupt in register B
      CPU.IO.PortOut (RTC_INDEX, Unsigned_8'(RTC_NMI_DISABLE or RTC_REGISTER_B));
      CPU.IO.PortOut (RTC_DATA, Data or 16#40#);
      CPU.Unlock (RTC_Lock);
   end RTC_Init;

   ----------------------------------------------------------------------------
   -- RTC_Handle
   ----------------------------------------------------------------------------
   procedure RTC_Handle (Data_Address : in System.Address) is
      pragma Unreferenced (Data_Address);
      Unused : Unsigned_8 with Unreferenced => True;
   begin
      -- reset RTC flag interrupt by reading register C
      CPU.IO.PortOut (RTC_INDEX, Unsigned_8'(RTC_NMI_DISABLE or RTC_REGISTER_C));
      Unused := CPU.IO.PortIn (RTC_DATA);
   end RTC_Handle;

   ----------------------------------------------------------------------------
   -- RTC_Read_Clock
   ----------------------------------------------------------------------------
   procedure RTC_Read_Clock (T : in out Time.TM_Time) is
      RTC_BCD    : Boolean;
      RTC_Second : Unsigned_8;
      RTC_Minute : Unsigned_8;
      RTC_Hour   : Unsigned_8;
      RTC_DayOfWeek  : Unsigned_8;
      RTC_DayOfMonth : Unsigned_8;
      RTC_Month  : Unsigned_8;
      RTC_Year   : Unsigned_8;
      function Register_Read (Register : Unsigned_8) return Unsigned_8;
      function Register_Read (Register : Unsigned_8) return Unsigned_8 is
      begin
         CPU.IO.PortOut (RTC_INDEX, RTC_NMI_DISABLE or Register);
         return Unsigned_8'(CPU.IO.PortIn (RTC_DATA));
      end Register_Read;
      function Adjust_BCD (V : Unsigned_8; BCD : Boolean) return Unsigned_8;
      function Adjust_BCD (V : Unsigned_8; BCD : Boolean) return Unsigned_8 is
      begin
         if BCD then
            return (V and 16#0F#) + (V / 2**4) * 10;
         else
            return V;
         end if;
      end Adjust_BCD;
   begin
      RTC_BCD := not To_RTC_RegisterB (Register_Read (RTC_REGISTER_B)).DM;
      while True loop
         exit when not To_RTC_RegisterA (Register_Read (RTC_REGISTER_A)).UIP;
      end loop;
      -- register reads within 244 us
      RTC_Second := Register_Read (RTC_REGISTER_Seconds);
      RTC_Minute := Register_Read (RTC_REGISTER_Minutes);
      RTC_Hour   := Register_Read (RTC_REGISTER_Hours);
      RTC_DayOfWeek  := Register_Read (RTC_REGISTER_DayOfWeek);
      RTC_DayOfMonth := Register_Read (RTC_REGISTER_DayOfMonth);
      RTC_Month  := Register_Read (RTC_REGISTER_Month);
      RTC_Year   := Register_Read (RTC_REGISTER_Year);
      T.Sec   := Natural (Adjust_BCD (RTC_Second, RTC_BCD));
      T.Min   := Natural (Adjust_BCD (RTC_Minute, RTC_BCD));
      T.Hour   := Natural (Adjust_BCD (RTC_Hour, RTC_BCD));
      T.WDay  := Natural (Adjust_BCD (RTC_DayOfWeek, RTC_BCD));
      T.MDay  := Natural (Adjust_BCD (RTC_DayOfMonth, RTC_BCD));
      T.Mon   := Natural (Adjust_BCD (RTC_Month - 1, RTC_BCD));
      T.Year   := Natural (Adjust_BCD (RTC_Year, RTC_BCD));
      T.YDay  := 0;
      T.IsDST := (if To_RTC_RegisterB (Register_Read (RTC_REGISTER_B)).DSE then 1 else 0);
   end RTC_Read_Clock;

   ----------------------------------------------------------------------------
   -- PPI_DataIn
   ----------------------------------------------------------------------------
   procedure PPI_DataIn (Value : out Unsigned_8) is
   begin
      Value := CPU.IO.PortIn (PPI_DATA);
   end PPI_DataIn;

   ----------------------------------------------------------------------------
   -- PPI_DataOut
   ----------------------------------------------------------------------------
   procedure PPI_DataOut (Value : in Unsigned_8) is
   begin
      CPU.IO.PortOut (PPI_DATA, Value);
   end PPI_DataOut;

   ----------------------------------------------------------------------------
   -- PPI_StatusIn
   ----------------------------------------------------------------------------
   procedure PPI_StatusIn (Value : out PPI_Status_Type) is
   begin
      Value := To_PPI_Status (CPU.IO.PortIn (PPI_STATUS));
   end PPI_StatusIn;

   ----------------------------------------------------------------------------
   -- PPI_ControlIn
   ----------------------------------------------------------------------------
   procedure PPI_ControlIn (Value : out PPI_Control_Type) is
   begin
      Value := To_PPI_Control (CPU.IO.PortIn (PPI_CONTROL));
   end PPI_ControlIn;

   ----------------------------------------------------------------------------
   -- PPI_ControlOut
   ----------------------------------------------------------------------------
   procedure PPI_ControlOut (Value : in PPI_Control_Type) is
   begin
      CPU.IO.PortOut (PPI_CONTROL, To_U8 (Value));
   end PPI_ControlOut;

   ----------------------------------------------------------------------------
   -- PPI_Init
   ----------------------------------------------------------------------------
   procedure PPI_Init is
   begin
      PPI_ControlOut ((
                       Strobe    => True,
                       AUTOLF    => True,
                       INIT      => False,
                       SelectOut => True,
                       IRQEN     => False,
                       BIDIR     => False,
                       Unused    => 0
                      ));
      PPI_DataOut (0);
   end PPI_Init;

end PC;
