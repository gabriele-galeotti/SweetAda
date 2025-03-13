-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ p8.ads                                                                                                    --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;

package P8
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   package SSE renames System.Storage_Elements;
   use SSE;
   use Interfaces;

   XSCOM_BASEADDRESS : constant := 16#0003_FC00_0000_0000#;

   CFAM_REG      : constant := 16#000F_000F#;
   CFAM_ID_P8    : constant := 16#220E_A049_8000_0000#; -- P8 Venice DD2.0
   CFAM_ID_P8E   : constant := 16#221E_F049_8000_0000#; -- P8 Murano DD2.1
   CFAM_ID_P8NVL : constant := 16#120D_3049_8000_0000#; -- P8 Naples DD1.0

   PNV_XSCOM_LPC_BASE : constant := 16#000B_0020#;
   LPC_IO_OPB_ADDR    : constant := 16#D001_0000#;

   ECCB_CTL   : constant := 0;
   ECCB_RESET : constant := 1;
   ECCB_STAT  : constant := 2;
   ECCB_DATA  : constant := 3;

   type LPC_CMD_Type is record
      Magic   : Bits.Bits_4 := 0; -- 0xD
      Size    : Bits.Bits_4;      -- size
      Unused2 : Bits.Bits_7 := 0;
      Read    : Boolean;          -- read/write
      Unused3 : Bits.Bits_7 := 0;
      Addrlen : Bits.Bits_3 := 0; -- address length (4)
      Unused4 : Bits.Bits_6 := 0;
      Address : Unsigned_32;      -- address
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for LPC_CMD_Type use record
      Magic   at 0 range  0 ..  3;
      Size    at 0 range  4 ..  7;
      Unused2 at 0 range  8 .. 14;
      Read    at 0 range 15 .. 15;
      Unused3 at 0 range 16 .. 22;
      Addrlen at 0 range 23 .. 25;
      Unused4 at 0 range 26 .. 31;
      Address at 0 range 32 .. 63;
   end record;

   function To_U64 is new Ada.Unchecked_Conversion (LPC_CMD_Type, Unsigned_64);

   procedure HMER_Clear
      with Inline => True;
   function HMER_Read
      return Unsigned_64
      with Inline => True;
   function XSCOM_Address
      (Base   : Unsigned_64;
       Offset : Unsigned_64)
      return Integer_Address
      with Inline => True;
   procedure XSCOM_Wait_Done
      with Inline => True;
   function XSCOM_In64
      (Device_Address : Integer_Address)
      return Unsigned_64
      with Inline => True;
   procedure XSCOM_Out64
      (Device_Address : in Integer_Address;
       Value          : in Unsigned_64)
      with Inline => True;

end P8;
