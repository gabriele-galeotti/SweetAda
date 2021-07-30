-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memecfx12.adb                                                                                             --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Bits;

package body MemecFX12 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Wait
   ----------------------------------------------------------------------------
   procedure Wait (Loops : in Positive) is
      Value : Integer with
         Volatile => True;
   begin
      Value := 0;
      for Delay_Loop_Count in 1 .. Loops loop Value := Value + 1; end loop;
   end Wait;

   ----------------------------------------------------------------------------
   -- LCD_Display_Update
   ----------------------------------------------------------------------------
   -- The following subprogram writes a byte of data to the LCD panel according
   -- to the following table:
   --
   -- mode            operation performed
   -- -----------------------------------------------------------------------
   -- 0               write to the LCD control register
   -- 1               read from LCD control register (not used)
   -- 2               write to the LCD data register
   -- 3               read from LCD data register (not used)
   --
   -- It should be noted that the MBS of node is used as the lcd_rs signal,
   -- while the LSB of the mode is used as the lcd_rw signal. Hence, mode
   -- and 8 bits of data are used to form a 10-bit quantity that will be
   -- writen to the LCD panel over the OPB data bus.
   ----------------------------------------------------------------------------
   procedure LCD_Display_Update (
                                 Base_Address : in System.Address;
                                 Data         : in Unsigned_8;
                                 Mode         : in Unsigned_32
                                ) is
      LCD_Port : Unsigned_32 with
         Address    => Base_Address,
         Volatile   => True,
         Import     => True,
         Convention => Ada;
      Extended_Mode : Unsigned_32;
      Extended_Data : Unsigned_32;
      Control_Data  : Unsigned_32;
   begin
      Extended_Mode := Mode * 2**8 and 16#0000_0300#;
      Extended_Data := Unsigned_32 (Data);
      Control_Data := Extended_Mode or Extended_Data;
      LCD_Port := Control_Data;
      Wait (5000);
   end LCD_Display_Update;

   ----------------------------------------------------------------------------
   -- LCD_Write
   ----------------------------------------------------------------------------
   -- This subprogram is used to write a string of characters to the LCD panel.
   ----------------------------------------------------------------------------
   procedure LCD_Write (Base_Address : in System.Address; S : in String) is
   begin
      for Index in S'Range loop
         LCD_Display_Update (Base_Address, Bits.To_U8 (S (Index)), 2);
      end loop;
   end LCD_Write;

   ----------------------------------------------------------------------------
   -- LCD_Clear
   ----------------------------------------------------------------------------
   -- The following subprogram is used to clear the LCD panel.
   ----------------------------------------------------------------------------
   procedure LCD_Clear (Base_Address : in System.Address) is
   begin
      LCD_Display_Update (Base_Address, 16#01#, 0);
   end LCD_Clear;

   ----------------------------------------------------------------------------
   -- LCD_Line
   ----------------------------------------------------------------------------
   -- The following subprogram is used to select which line of the LCD is being
   -- writen to (line 1 or 2).
   ----------------------------------------------------------------------------
   procedure LCD_Line (Base_Address : in System.Address; Line : in Integer) is
   begin
      case Line is
         when 1      => LCD_Display_Update (Base_Address, 16#80#, 0);
         when 2      => LCD_Display_Update (Base_Address, 16#C0#, 0);
         when others => LCD_Display_Update (Base_Address, 16#80#, 0);
      end case;
   end LCD_Line;

   ----------------------------------------------------------------------------
   -- LCD_Init
   ----------------------------------------------------------------------------
   -- The following subprogram performs LCD initializations. It must be called
   -- in the main program before any access to the LCD panel is performed.
   ----------------------------------------------------------------------------
   procedure LCD_Init is
      LCD_Data : constant array (Natural range <>) of Unsigned_8 := (16#38#, 16#06#, 16#0E#, 16#01#, 16#80#, 16#0C#);
   begin
      Wait (150000);
      for Index in LCD_Data'Range loop
         LCD_Display_Update (LCD'Address, LCD_Data (Index), 0);
         Wait (500000);
      end loop;
      Wait (500000);
   end LCD_Init;

end MemecFX12;
