
with Interfaces;
with CPU;
with MPC8306;
with Switch;
with Console;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

   procedure SETR;
   procedure SETW;
   procedure SETACK;
   procedure SETNOACK;
   procedure TX (Code : in Unsigned_8);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure SETR is
   begin
      MPC8306.I2C.CR.MTX := MPC8306.MTX_Receive;
   end SETR;

   procedure SETW is
   begin
      MPC8306.I2C.CR.MTX := MPC8306.MTX_Transmit;
   end SETW;

   procedure SETACK is
   begin
      MPC8306.I2C.CR.TXAK := False;
   end SETACK;

   procedure SETNOACK is
   begin
      MPC8306.I2C.CR.TXAK := True;
   end SETNOACK;

   procedure TX (Code : in Unsigned_8) is
   begin
      MPC8306.I2C.DR := Code;
      loop
         exit when MPC8306.I2C.SR.MIF;
      end loop;
      MPC8306.I2C.SR.MIF := False;
      loop
         exit when not MPC8306.I2C.SR.RXAK;
      end loop;
   end TX;

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run is
   begin
      -- GPIO test ------------------------------------------------------------
      if False then
         declare
            Delay_Count : constant := 5_000_000;
         begin
            loop
               MPC8306.GP1DAT := 16#0000_0200#;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               MPC8306.GP1DAT := 16#0000_0000#;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -- LM75 test ------------------------------------------------------------
      if True then
         declare
            Data  : Unsigned_8 with Unreferenced => True;
            Data1 : Unsigned_8;
            Data2 : Unsigned_8;
         begin
            loop
               MPC8306.I2C.FDR      := 16#3F#; -- prescaler, /32768
               MPC8306.I2C.ADR.ADDR := 16#02#; -- slave address
               MPC8306.I2C.CR       := (
                                        MEN    => False,
                                        MIEN   => False,
                                        MSTA   => True,
                                        MTX    => MPC8306.MTX_Transmit,
                                        TXAK   => False,
                                        RSTA   => False,
                                        BCST   => False,
                                        others => 0
                                        );
               MPC8306.I2C.CR.MEN   := True; -- master, transmit
               -- wait bus busy
               loop
                  exit when MPC8306.I2C.SR.MBB;
               end loop;
               TX (Switch.LM75AIM_I2C_ADDRESS + 1);
               SETR;
               SETACK;
               --
               Data := MPC8306.I2C.DR;
               loop
                  exit when MPC8306.I2C.SR.MIF;
               end loop;
               MPC8306.I2C.SR.MIF := False;
               SETNOACK;
               --
               Data1 := MPC8306.I2C.DR;
               loop
                  exit when MPC8306.I2C.SR.MIF;
               end loop;
               MPC8306.I2C.SR.MIF := False;
               --
               MPC8306.I2C.CR.MSTA := False;
               Data2 := MPC8306.I2C.DR;
               --
               Console.Print (Data1, Prefix => "", NL => False);
               Console.Print (Data2, Prefix => "", NL => True);
               for Delay_Loop_Count in 1 .. 1_000_000 loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;
end Application;
