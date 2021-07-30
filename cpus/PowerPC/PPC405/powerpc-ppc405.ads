-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc-ppc405.ads                                                                                        --
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

package PowerPC.PPC405 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- DCRs function templates
   ----------------------------------------------------------------------------

   type DCR_Type is mod 2**10; -- 0 .. 1023

   -- DCR numbers
   UIC0_SR  : constant DCR_Type := 16#00C0#; -- UIC Status Register
   UIC0_ER  : constant DCR_Type := 16#00C2#; -- UIC Enable Register
   UIC0_CR  : constant DCR_Type := 16#00C3#; -- UIC Critical Register
   UIC0_PR  : constant DCR_Type := 16#00C4#; -- UIC Polarity Register
   UIC0_TR  : constant DCR_Type := 16#00C5#; -- UIC Trigger Register
   UIC0_MSR : constant DCR_Type := 16#00C6#; -- UIC Masked Status Register
   UIC0_VR  : constant DCR_Type := 16#00C7#; -- UIC Vector Register
   UIC0_VCR : constant DCR_Type := 16#00C8#; -- UIC Vector Configuration Register

   generic
      DCR : in DCR_Type;
      type Register_Type is private;
   function MFDCR return Register_Type;

   generic
      DCR : in DCR_Type;
      type Register_Type is private;
   procedure MTDCR (Register_Value : in Register_Type);

   ----------------------------------------------------------------------------
   -- TSR Timer Status Register
   ----------------------------------------------------------------------------

   -- Watchdog Reset, common to both TSR and TCR
   type TSR_TCR_WR_Type is new Bits_2;
   TSR_NONE   : constant TSR_TCR_WR_Type := 2#00#;
   TSR_CORE   : constant TSR_TCR_WR_Type := 2#01#;
   TSR_CHIP   : constant TSR_TCR_WR_Type := 2#10#;
   TSR_SYSTEM : constant TSR_TCR_WR_Type := 2#11#;

   TSR : constant SPR_Type := 984; -- 0x3d8

   type TSR_Register_Type is
   record
      ENW      : Boolean;
      WIS      : Boolean;
      WRS      : TSR_TCR_WR_Type;
      PIS      : Boolean;
      FIS      : Boolean;
      Reserved : Bits_26_Zeroes;
   end record with
      Size => 32;
   for TSR_Register_Type use
   record
      ENW      at 0 range 0 .. 0;
      WIS      at 0 range 1 .. 1;
      WRS      at 0 range 2 .. 3;
      PIS      at 0 range 4 .. 4;
      FIS      at 0 range 5 .. 5;
      Reserved at 0 range 6 .. 31;
   end record;

   function TSR_Read return TSR_Register_Type;
   procedure TSR_Write (Value : in TSR_Register_Type);

   ----------------------------------------------------------------------------
   -- TCR Timer Control Register
   ----------------------------------------------------------------------------

   TCR : constant SPR_Type := 986; -- 0x3da

   type TCR_WP_Type is new Bits_2;
   TCR_WP_17 : constant TCR_WP_Type := 2#00#; -- 2^17 clocks
   TCR_WP_21 : constant TCR_WP_Type := 2#01#; -- 2^21 clocks
   TCR_WP_25 : constant TCR_WP_Type := 2#10#; -- 2^25 clocks
   TCR_WP_29 : constant TCR_WP_Type := 2#11#; -- 2^29 clocks

   type FIT_Period_Type is new Bits_2;
   FIT_P_9  : constant FIT_Period_Type := 2#00#; -- 2^9 clocks
   FIT_P_13 : constant FIT_Period_Type := 2#01#; -- 2^13 clocks
   FIT_P_17 : constant FIT_Period_Type := 2#10#; -- 2^17 clocks
   FIT_P_21 : constant FIT_Period_Type := 2#11#; -- 2^21 clocks

   type TCR_Register_Type is
   record
      WP       : TCR_WP_Type;
      WRC      : TSR_TCR_WR_Type;
      WIE      : Boolean;
      PIE      : Boolean;
      FP       : FIT_Period_Type;
      FIE      : Boolean;
      ARE      : Boolean;
      Reserved : Bits_22_Zeroes := Bits_22_0;
   end record with
      Size => 32;
   for TCR_Register_Type use
   record
      WP       at 0 range 0 .. 1;
      WRC      at 0 range 2 .. 3;
      WIE      at 0 range 4 .. 4;
      PIE      at 0 range 5 .. 5;
      FP       at 0 range 6 .. 7;
      FIE      at 0 range 8 .. 8;
      ARE      at 0 range 9 .. 9;
      Reserved at 0 range 10 .. 31;
   end record;

   function TCR_Read return TCR_Register_Type;
   procedure TCR_Write (Value : in TCR_Register_Type);

   ----------------------------------------------------------------------------
   -- PIT Programmable Interval Timer
   ----------------------------------------------------------------------------

   PIT : constant SPR_Type := 987; -- 0x3db

   function PIT_Read return Unsigned_32;
   procedure PIT_Write (Value : in Unsigned_32);

   ----------------------------------------------------------------------------
   -- UIC Universal Interrupt Controller
   ----------------------------------------------------------------------------

   type UIC0_ER_Register_Type is
   record
      U0IE      : Boolean;
      U1IE      : Boolean;
      IICIE     : Boolean;
      PCIIE     : Boolean;
      Reserved1 : Bits_1_Zeroes := Bits_1_0; -- bit #4 reserved
      D0IE      : Boolean;
      D1IE      : Boolean;
      D2IE      : Boolean;
      D3IE      : Boolean;
      EWIE      : Boolean;
      MSIE      : Boolean;
      MTEIE     : Boolean;
      MREIE     : Boolean;
      MTDIE     : Boolean;
      MRDIE     : Boolean;
      EIE0      : Boolean;
      EPSIE     : Boolean;
      EIE1      : Boolean;
      PPMI      : Boolean;
      GTI0E     : Boolean;
      GTI1E     : Boolean;
      GTI2E     : Boolean;
      GTI3E     : Boolean;
      GTI4E     : Boolean;
      Reserved2 : Bits_1_Zeroes := Bits_1_0; -- bit #24 reserved
      EIR0E     : Boolean;
      EIR1E     : Boolean;
      EIR2E     : Boolean;
      EIR3E     : Boolean;
      EIR4E     : Boolean;
      EIR5E     : Boolean;
      EIR6E     : Boolean;
   end record with
      Size => 32;
   for UIC0_ER_Register_Type use
   record
      U0IE      at 0 range 0 .. 0;
      U1IE      at 0 range 1 .. 1;
      IICIE     at 0 range 2 .. 2;
      PCIIE     at 0 range 3 .. 3;
      Reserved1 at 0 range 4 .. 4;
      D0IE      at 0 range 5 .. 5;
      D1IE      at 0 range 6 .. 6;
      D2IE      at 0 range 7 .. 7;
      D3IE      at 0 range 8 .. 8;
      EWIE      at 0 range 9 .. 9;
      MSIE      at 0 range 10 .. 10;
      MTEIE     at 0 range 11 .. 11;
      MREIE     at 0 range 12 .. 12;
      MTDIE     at 0 range 13 .. 13;
      MRDIE     at 0 range 14 .. 14;
      EIE0      at 0 range 15 .. 15;
      EPSIE     at 0 range 16 .. 16;
      EIE1      at 0 range 17 .. 17;
      PPMI      at 0 range 18 .. 18;
      GTI0E     at 0 range 19 .. 19;
      GTI1E     at 0 range 20 .. 20;
      GTI2E     at 0 range 21 .. 21;
      GTI3E     at 0 range 22 .. 22;
      GTI4E     at 0 range 23 .. 23;
      Reserved2 at 0 range 24 .. 24;
      EIR0E     at 0 range 25 .. 25;
      EIR1E     at 0 range 26 .. 26;
      EIR2E     at 0 range 27 .. 27;
      EIR3E     at 0 range 28 .. 28;
      EIR4E     at 0 range 29 .. 29;
      EIR5E     at 0 range 30 .. 30;
      EIR6E     at 0 range 31 .. 31;
   end record;

   function UIC0_ER_Read return UIC0_ER_Register_Type;
   procedure UIC0_ER_Write (Value : in UIC0_ER_Register_Type);

   procedure MSREE_Set;
   procedure MSREE_Clear;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Inline (TSR_Read);
   pragma Inline (TSR_Write);
   pragma Inline (TCR_Read);
   pragma Inline (TCR_Write);
   pragma Inline (PIT_Read);
   pragma Inline (PIT_Write);

   pragma Inline (UIC0_ER_Read);
   pragma Inline (UIC0_ER_Write);

   pragma Inline (MSREE_Set);
   pragma Inline (MSREE_Clear);

end PowerPC.PPC405;
