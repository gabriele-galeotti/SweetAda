-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bits.ads                                                                                                  --
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

with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Interfaces.C;

package Bits is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Pure;

   use type System.Bit_Order;

   package SSE renames System.Storage_Elements;

   ----------------------------------------------------------------------------
   -- Basic definitions.
   ----------------------------------------------------------------------------

   BigEndian    : constant Boolean := System.Default_Bit_Order = System.High_Order_First;
   LittleEndian : constant Boolean := System.Default_Bit_Order = System.Low_Order_First;
   -- BE_ByteOrder is 1 if target has big-endian bit order, else 0
   -- LE_ByteOrder is 1 if target has little-endian bit order, else 0
   BE_ByteOrder : constant := Boolean'Pos (BigEndian);
   LE_ByteOrder : constant := Boolean'Pos (LittleEndian);

   -- Positive Boolean
   type PBoolean is (PFalse, PTrue);
   for PBoolean'Size use 1;
   for PBoolean use (PFalse => 0, PTrue => 1);

   -- Negative Boolean
   type NBoolean is (NTrue, NFalse);
   for NBoolean'Size use 1;
   for NBoolean use (NTrue => 0, NFalse => 1);

   -- CPU_Integer is a signed type holding generic CPU register values
   type CPU_Integer is range -2**(System.Word_Size - 1) .. +2**(System.Word_Size - 1) - 1 with
      Size => System.Word_Size;

   -- CPU_Unsigned is a modular type holding generic CPU register values
   type CPU_Unsigned is mod 2**System.Word_Size with
      Size => System.Word_Size;

   -- Mod_Integer is a modular type same size as the base Integer type
   type Mod_Integer is mod 2**Integer'Size with
      Size => Integer'Size;

   -- canonical bit sizes of memory words
   type Bitsize is (BITNONE, BIT8, BIT16, BIT32, BIT64);

   -- Bytesize is a modular type representing size in bytes of large objects
   subtype Bytesize is Interfaces.C.size_t;

   -- useful for Suppress_LSB function
   subtype Integer_Bit_Number is Natural range 0 .. Integer'Size - 1;

   ----------------------------------------------------------------------------
   -- Fundamental bit-level types and constants.
   ----------------------------------------------------------------------------
   -- Bits_XX low-level types could be defined as modular types derived from
   -- the unsigned ones in package Interfaces.C.Extensions.
   ----------------------------------------------------------------------------

   type Bits_1  is mod 2**1 with
      Size => 1;
   type Bits_2  is mod 2**2 with
      Size => 2;
   type Bits_3  is mod 2**3 with
      Size => 3;
   type Bits_4  is mod 2**4 with
      Size => 4;
   type Bits_5  is mod 2**5 with
      Size => 5;
   type Bits_6  is mod 2**6 with
      Size => 6;
   type Bits_7  is mod 2**7 with
      Size => 7;
   type Bits_8  is mod 2**8 with
      Size => 8;
   type Bits_9  is mod 2**9 with
      Size => 9;
   type Bits_10 is mod 2**10 with
      Size => 10;
   type Bits_11 is mod 2**11 with
      Size => 11;
   type Bits_12 is mod 2**12 with
      Size => 12;
   type Bits_13 is mod 2**13 with
      Size => 13;
   type Bits_14 is mod 2**14 with
      Size => 14;
   type Bits_15 is mod 2**15 with
      Size => 15;
   type Bits_16 is mod 2**16 with
      Size => 16;
   type Bits_17 is mod 2**17 with
      Size => 17;
   type Bits_18 is mod 2**18 with
      Size => 18;
   type Bits_19 is mod 2**19 with
      Size => 19;
   type Bits_20 is mod 2**20 with
      Size => 20;
   type Bits_21 is mod 2**21 with
      Size => 21;
   type Bits_22 is mod 2**22 with
      Size => 22;
   type Bits_23 is mod 2**23 with
      Size => 23;
   type Bits_24 is mod 2**24 with
      Size => 24;
   type Bits_25 is mod 2**25 with
      Size => 25;
   type Bits_26 is mod 2**26 with
      Size => 26;
   type Bits_27 is mod 2**27 with
      Size => 27;
   type Bits_28 is mod 2**28 with
      Size => 28;
   type Bits_29 is mod 2**29 with
      Size => 29;
   type Bits_30 is mod 2**30 with
      Size => 30;
   type Bits_31 is mod 2**31 with
      Size => 31;
   type Bits_32 is mod 2**32 with
      Size => 32;
   type Bits_33 is mod 2**33 with
      Size => 33;
   type Bits_34 is mod 2**34 with
      Size => 34;
   type Bits_35 is mod 2**35 with
      Size => 35;
   type Bits_36 is mod 2**36 with
      Size => 36;
   type Bits_40 is mod 2**40 with
      Size => 40;
   type Bits_48 is mod 2**48 with
      Size => 48;
   type Bits_56 is mod 2**56 with
      Size => 56;
   type Bits_64 is mod 2**64 with
      Size => 64;

   subtype Bits_1_Zeroes  is Bits_1 range Bits_1'First .. Bits_1'First;
   Bits_1_0 : constant := Bits_1_Zeroes'First;
   subtype Bits_1_Ones    is Bits_1 range Bits_1'Last .. Bits_1'Last;
   Bits_1_1 : constant := Bits_1_Ones'First;
   subtype Bits_2_Zeroes  is Bits_2 range Bits_2'First .. Bits_2'First;
   Bits_2_0 : constant := Bits_2_Zeroes'First;
   subtype Bits_2_Ones    is Bits_2 range Bits_2'Last .. Bits_2'Last;
   Bits_2_1 : constant := Bits_2_Ones'First;
   subtype Bits_3_Zeroes  is Bits_3 range Bits_3'First .. Bits_3'First;
   Bits_3_0 : constant := Bits_3_Zeroes'First;
   subtype Bits_3_Ones    is Bits_3 range Bits_3'Last .. Bits_3'Last;
   Bits_3_1 : constant := Bits_3_Ones'First;
   subtype Bits_4_Zeroes  is Bits_4 range Bits_4'First .. Bits_4'First;
   Bits_4_0 : constant := Bits_4_Zeroes'First;
   subtype Bits_4_Ones    is Bits_4 range Bits_4'Last .. Bits_4'Last;
   Bits_4_1 : constant := Bits_4_Ones'First;
   subtype Bits_5_Zeroes  is Bits_5 range Bits_5'First .. Bits_5'First;
   Bits_5_0 : constant := Bits_5_Zeroes'First;
   subtype Bits_5_Ones    is Bits_5 range Bits_5'Last .. Bits_5'Last;
   Bits_5_1 : constant := Bits_5_Ones'First;
   subtype Bits_6_Zeroes  is Bits_6 range Bits_6'First .. Bits_6'First;
   Bits_6_0 : constant := Bits_6_Zeroes'First;
   subtype Bits_6_Ones    is Bits_6 range Bits_6'Last .. Bits_6'Last;
   Bits_6_1 : constant := Bits_6_Ones'First;
   subtype Bits_7_Zeroes  is Bits_7 range Bits_7'First .. Bits_7'First;
   Bits_7_0 : constant := Bits_7_Zeroes'First;
   subtype Bits_7_Ones    is Bits_7 range Bits_7'Last .. Bits_7'Last;
   Bits_7_1 : constant := Bits_7_Ones'First;
   subtype Bits_8_Zeroes  is Bits_8 range Bits_8'First .. Bits_8'First;
   Bits_8_0 : constant := Bits_8_Zeroes'First;
   subtype Bits_8_Ones    is Bits_8 range Bits_8'Last .. Bits_8'Last;
   Bits_8_1 : constant := Bits_8_Ones'First;
   subtype Bits_9_Zeroes  is Bits_9 range Bits_9'First .. Bits_9'First;
   Bits_9_0 : constant := Bits_9_Zeroes'First;
   subtype Bits_9_Ones    is Bits_9 range Bits_9'Last .. Bits_9'Last;
   Bits_9_1 : constant := Bits_9_Ones'First;
   subtype Bits_10_Zeroes is Bits_10 range Bits_10'First .. Bits_10'First;
   Bits_10_0 : constant := Bits_10_Zeroes'First;
   subtype Bits_10_Ones   is Bits_10 range Bits_10'Last .. Bits_10'Last;
   Bits_10_1 : constant := Bits_10_Ones'First;
   subtype Bits_11_Zeroes is Bits_11 range Bits_11'First .. Bits_11'First;
   Bits_11_0 : constant := Bits_11_Zeroes'First;
   subtype Bits_11_Ones   is Bits_11 range Bits_11'Last .. Bits_11'Last;
   Bits_11_1 : constant := Bits_11_Ones'First;
   subtype Bits_12_Zeroes is Bits_12 range Bits_12'First .. Bits_12'First;
   Bits_12_0 : constant := Bits_12_Zeroes'First;
   subtype Bits_12_Ones   is Bits_12 range Bits_12'Last .. Bits_12'Last;
   Bits_12_1 : constant := Bits_12_Ones'First;
   subtype Bits_13_Zeroes is Bits_13 range Bits_13'First .. Bits_13'First;
   Bits_13_0 : constant := Bits_13_Zeroes'First;
   subtype Bits_13_Ones   is Bits_13 range Bits_13'Last .. Bits_13'Last;
   Bits_13_1 : constant := Bits_13_Ones'First;
   subtype Bits_14_Zeroes is Bits_14 range Bits_14'First .. Bits_14'First;
   Bits_14_0 : constant := Bits_14_Zeroes'First;
   subtype Bits_14_Ones   is Bits_14 range Bits_14'Last .. Bits_14'Last;
   Bits_14_1 : constant := Bits_14_Ones'First;
   subtype Bits_15_Zeroes is Bits_15 range Bits_15'First .. Bits_15'First;
   Bits_15_0 : constant := Bits_15_Zeroes'First;
   subtype Bits_15_Ones   is Bits_15 range Bits_15'Last .. Bits_15'Last;
   Bits_15_1 : constant := Bits_15_Ones'First;
   subtype Bits_16_Zeroes is Bits_16 range Bits_16'First .. Bits_16'First;
   Bits_16_0 : constant := Bits_16_Zeroes'First;
   subtype Bits_16_Ones   is Bits_16 range Bits_16'Last .. Bits_16'Last;
   Bits_16_1 : constant := Bits_16_Ones'First;
   subtype Bits_17_Zeroes is Bits_17 range Bits_17'First .. Bits_17'First;
   Bits_17_0 : constant := Bits_17_Zeroes'First;
   subtype Bits_17_Ones   is Bits_17 range Bits_17'Last .. Bits_17'Last;
   Bits_17_1 : constant := Bits_17_Ones'First;
   subtype Bits_18_Zeroes is Bits_18 range Bits_18'First .. Bits_18'First;
   Bits_18_0 : constant := Bits_18_Zeroes'First;
   subtype Bits_18_Ones   is Bits_18 range Bits_18'Last .. Bits_18'Last;
   Bits_18_1 : constant := Bits_18_Ones'First;
   subtype Bits_19_Zeroes is Bits_19 range Bits_19'First .. Bits_19'First;
   Bits_19_0 : constant := Bits_19_Zeroes'First;
   subtype Bits_19_Ones   is Bits_19 range Bits_19'Last .. Bits_19'Last;
   Bits_19_1 : constant := Bits_19_Ones'First;
   subtype Bits_20_Zeroes is Bits_20 range Bits_20'First .. Bits_20'First;
   Bits_20_0 : constant := Bits_20_Zeroes'First;
   subtype Bits_20_Ones   is Bits_20 range Bits_20'Last .. Bits_20'Last;
   Bits_20_1 : constant := Bits_20_Ones'First;
   subtype Bits_21_Zeroes is Bits_21 range Bits_21'First .. Bits_21'First;
   Bits_21_0 : constant := Bits_21_Zeroes'First;
   subtype Bits_21_Ones   is Bits_21 range Bits_21'Last .. Bits_21'Last;
   Bits_21_1 : constant := Bits_21_Ones'First;
   subtype Bits_22_Zeroes is Bits_22 range Bits_22'First .. Bits_22'First;
   Bits_22_0 : constant := Bits_22_Zeroes'First;
   subtype Bits_22_Ones   is Bits_22 range Bits_22'Last .. Bits_22'Last;
   Bits_22_1 : constant := Bits_22_Ones'First;
   subtype Bits_23_Zeroes is Bits_23 range Bits_23'First .. Bits_23'First;
   Bits_23_0 : constant := Bits_23_Zeroes'First;
   subtype Bits_23_Ones   is Bits_23 range Bits_23'Last .. Bits_23'Last;
   Bits_23_1 : constant := Bits_23_Ones'First;
   subtype Bits_24_Zeroes is Bits_24 range Bits_24'First .. Bits_24'First;
   Bits_24_0 : constant := Bits_24_Zeroes'First;
   subtype Bits_24_Ones   is Bits_24 range Bits_24'Last .. Bits_24'Last;
   Bits_24_1 : constant := Bits_24_Ones'First;
   subtype Bits_25_Zeroes is Bits_25 range Bits_25'First .. Bits_25'First;
   Bits_25_0 : constant := Bits_25_Zeroes'First;
   subtype Bits_25_Ones   is Bits_25 range Bits_25'Last .. Bits_25'Last;
   Bits_25_1 : constant := Bits_25_Ones'First;
   subtype Bits_26_Zeroes is Bits_26 range Bits_26'First .. Bits_26'First;
   Bits_26_0 : constant := Bits_26_Zeroes'First;
   subtype Bits_26_Ones   is Bits_26 range Bits_26'Last .. Bits_26'Last;
   Bits_26_1 : constant := Bits_26_Ones'First;
   subtype Bits_27_Zeroes is Bits_27 range Bits_27'First .. Bits_27'First;
   Bits_27_0 : constant := Bits_27_Zeroes'First;
   subtype Bits_27_Ones   is Bits_27 range Bits_27'Last .. Bits_27'Last;
   Bits_27_1 : constant := Bits_27_Ones'First;
   subtype Bits_28_Zeroes is Bits_28 range Bits_28'First .. Bits_28'First;
   Bits_28_0 : constant := Bits_28_Zeroes'First;
   subtype Bits_28_Ones   is Bits_28 range Bits_28'Last .. Bits_28'Last;
   Bits_28_1 : constant := Bits_28_Ones'First;
   subtype Bits_29_Zeroes is Bits_29 range Bits_29'First .. Bits_29'First;
   Bits_29_0 : constant := Bits_29_Zeroes'First;
   subtype Bits_29_Ones   is Bits_29 range Bits_29'Last .. Bits_29'Last;
   Bits_29_1 : constant := Bits_29_Ones'First;
   subtype Bits_30_Zeroes is Bits_30 range Bits_30'First .. Bits_30'First;
   Bits_30_0 : constant := Bits_30_Zeroes'First;
   subtype Bits_30_Ones   is Bits_30 range Bits_30'Last .. Bits_30'Last;
   Bits_30_1 : constant := Bits_30_Ones'First;
   subtype Bits_31_Zeroes is Bits_31 range Bits_31'First .. Bits_31'First;
   Bits_31_0 : constant := Bits_31_Zeroes'First;
   subtype Bits_31_Ones   is Bits_31 range Bits_31'Last .. Bits_31'Last;
   Bits_31_1 : constant := Bits_31_Ones'First;
   subtype Bits_32_Zeroes is Bits_32 range Bits_32'First .. Bits_32'First;
   Bits_32_0 : constant := Bits_32_Zeroes'First;
   subtype Bits_32_Ones   is Bits_32 range Bits_32'Last .. Bits_32'Last;
   Bits_32_1 : constant := Bits_32_Ones'First;

   Bits_1_Mask  : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001#;
   Bits_2_Mask  : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0011#;
   Bits_3_Mask  : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0111#;
   Bits_4_Mask  : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1111#;
   Bits_5_Mask  : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001_1111#;
   Bits_6_Mask  : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0011_1111#;
   Bits_7_Mask  : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0111_1111#;
   Bits_8_Mask  : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1111_1111#;
   Bits_9_Mask  : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001_1111_1111#;
   Bits_10_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0011_1111_1111#;
   Bits_11_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0111_1111_1111#;
   Bits_12_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1111_1111_1111#;
   Bits_13_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001_1111_1111_1111#;
   Bits_14_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0011_1111_1111_1111#;
   Bits_15_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0111_1111_1111_1111#;
   Bits_16_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1111_1111_1111_1111#;
   Bits_17_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001_1111_1111_1111_1111#;
   Bits_18_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0011_1111_1111_1111_1111#;
   Bits_19_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0111_1111_1111_1111_1111#;
   Bits_20_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1111_1111_1111_1111_1111#;
   Bits_21_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001_1111_1111_1111_1111_1111#;
   Bits_22_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0011_1111_1111_1111_1111_1111#;
   Bits_23_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0111_1111_1111_1111_1111_1111#;
   Bits_24_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1111_1111_1111_1111_1111_1111#;
   Bits_25_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0001_1111_1111_1111_1111_1111_1111#;
   Bits_26_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0011_1111_1111_1111_1111_1111_1111#;
   Bits_27_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0111_1111_1111_1111_1111_1111_1111#;
   Bits_28_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_1111_1111_1111_1111_1111_1111_1111#;
   Bits_29_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0001_1111_1111_1111_1111_1111_1111_1111#;
   Bits_30_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0011_1111_1111_1111_1111_1111_1111_1111#;
   Bits_31_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_32_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_33_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0001_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_34_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0011_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_35_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_36_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0000_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_40_Mask : constant := 2#0000_0000_0000_0000_0000_0000_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_48_Mask : constant := 2#0000_0000_0000_0000_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_56_Mask : constant := 2#0000_0000_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_64_Mask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;

   Bits_1_RMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110#;
   Bits_2_RMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100#;
   Bits_3_RMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000#;
   Bits_4_RMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000#;
   Bits_5_RMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000#;
   Bits_6_RMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000#;
   Bits_7_RMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000#;
   Bits_8_RMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000#;
   Bits_9_RMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000#;
   Bits_10_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000#;
   Bits_11_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000#;
   Bits_12_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000#;
   Bits_13_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000#;
   Bits_14_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000#;
   Bits_15_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000#;
   Bits_16_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000#;
   Bits_17_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000_0000#;
   Bits_18_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000_0000#;
   Bits_19_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000_0000#;
   Bits_20_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000#;
   Bits_21_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000_0000_0000#;
   Bits_22_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000_0000_0000#;
   Bits_23_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000_0000_0000#;
   Bits_24_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000#;
   Bits_25_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000_0000_0000_0000#;
   Bits_26_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000_0000_0000_0000#;
   Bits_27_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000_0000_0000_0000#;
   Bits_28_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000#;
   Bits_29_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000_0000_0000_0000_0000#;
   Bits_30_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000_0000_0000_0000_0000#;
   Bits_31_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_32_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_33_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_34_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_35_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_36_RMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_40_RMask : constant := 2#1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_48_RMask : constant := 2#1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_56_RMask : constant := 2#1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_64_RMask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;

   -- Bitmaps
   type Bitmap_8 is array (0 .. 7) of Boolean with
      Component_Size => 1,
      Size           => 8;
   type Bitmap_16 is array (0 .. 15) of Boolean with
      Component_Size => 1,
      Size           => 16;
   type Bitmap_32 is array (0 .. 31) of Boolean with
      Component_Size => 1,
      Size           => 32;
   type Bitmap_64 is array (0 .. 63) of Boolean with
      Component_Size => 1,
      Size           => 64;

   ----------------------------------------------------------------------------
   -- Array types.
   ----------------------------------------------------------------------------

   type U8_Array is array (Natural range <>) of Interfaces.Unsigned_8 with
      Alignment      => 1,
      Component_Size => 8;

   type U16_Array is array (Natural range <>) of Interfaces.Unsigned_16 with
      Alignment      => 2,
      Component_Size => 16;

   type U32_Array is array (Natural range <>) of Interfaces.Unsigned_32 with
      Alignment      => 4,
      Component_Size => 32;

   type U64_Array is array (Natural range <>) of Interfaces.Unsigned_64 with
      Alignment      => 8,
      Component_Size => 64;

   -- useful alias
   subtype Byte_Array is U8_Array;

   -- special versions of U8_Array with high-order alignment
   type Byte_A2Array is array (Natural range <>) of Interfaces.Unsigned_8 with
      Alignment      => 2,
      Component_Size => 8;
   type Byte_A4Array is array (Natural range <>) of Interfaces.Unsigned_8 with
      Alignment      => 4,
      Component_Size => 8;
   type Byte_A8Array is array (Natural range <>) of Interfaces.Unsigned_8 with
      Alignment      => 8,
      Component_Size => 8;

   -- 16-bit value converted to an array of components
   -- index offsets of 8-bit vector values
   H16_8_IDX  : constant := BE_ByteOrder * 0 + LE_ByteOrder * 1;
   L16_8_IDX  : constant := BE_ByteOrder * 1 + LE_ByteOrder * 0;

   -- 32-bit value converted to an array of components
   -- index offsets of 8-bit vector values
   H32_8_IDX  : constant := BE_ByteOrder * 0 + LE_ByteOrder * 3;
   N32_8_IDX  : constant := BE_ByteOrder * 1 + LE_ByteOrder * 2;
   M32_8_IDX  : constant := BE_ByteOrder * 2 + LE_ByteOrder * 1;
   L32_8_IDX  : constant := BE_ByteOrder * 3 + LE_ByteOrder * 0;
   -- index offsets of 16-bit vector values
   H32_16_IDX : constant := BE_ByteOrder * 0 + LE_ByteOrder * 1;
   L32_16_IDX : constant := BE_ByteOrder * 1 + LE_ByteOrder * 0;

   -- 64-bit value converted to an array of components
   -- index offsets of 8-bit vector values
   H64_8_IDX  : constant := BE_ByteOrder * 0 + LE_ByteOrder * 7;
   R64_8_IDX  : constant := BE_ByteOrder * 1 + LE_ByteOrder * 6;
   Q64_8_IDX  : constant := BE_ByteOrder * 2 + LE_ByteOrder * 5;
   P64_8_IDX  : constant := BE_ByteOrder * 3 + LE_ByteOrder * 4;
   O64_8_IDX  : constant := BE_ByteOrder * 4 + LE_ByteOrder * 3;
   N64_8_IDX  : constant := BE_ByteOrder * 5 + LE_ByteOrder * 2;
   M64_8_IDX  : constant := BE_ByteOrder * 6 + LE_ByteOrder * 1;
   L64_8_IDX  : constant := BE_ByteOrder * 7 + LE_ByteOrder * 0;
   -- index offsets of 16-bit vector values
   H64_16_IDX : constant := BE_ByteOrder * 0 + LE_ByteOrder * 3;
   N64_16_IDX : constant := BE_ByteOrder * 1 + LE_ByteOrder * 2;
   M64_16_IDX : constant := BE_ByteOrder * 2 + LE_ByteOrder * 1;
   L64_16_IDX : constant := BE_ByteOrder * 3 + LE_ByteOrder * 0;
   -- index offsets of 32-bit vector values
   H64_32_IDX : constant := BE_ByteOrder * 0 + LE_ByteOrder * 1;
   L64_32_IDX : constant := BE_ByteOrder * 1 + LE_ByteOrder * 0;

   ----------------------------------------------------------------------------
   -- Additional useful types and constants.
   ----------------------------------------------------------------------------

   subtype Flag is Bits_1;
   BITZERO : constant Flag := 0;
   BITONE  : constant Flag := 1;
   BITL    : constant Flag := 0;
   BITH    : constant Flag := 1;
   BITOFF  : constant Flag := 0;
   BITON   : constant Flag := 1;

   subtype BEUnsigned_16 is Interfaces.Unsigned_16;
   subtype BEUnsigned_32 is Interfaces.Unsigned_32;
   subtype BEUnsigned_64 is Interfaces.Unsigned_64;
   subtype LEUnsigned_16 is Interfaces.Unsigned_16;
   subtype LEUnsigned_32 is Interfaces.Unsigned_32;
   subtype LEUnsigned_64 is Interfaces.Unsigned_64;

   -- NOTE: System.Address'Size is non-static (System.Address is private), use
   -- static-equivalent Standard'Address_Size
   subtype Address_Bit_Number is Natural range 0 .. Standard'Address_Size - 1;

   -- amount of bit-shift in decoding CPU address spaces
   subtype Address_Shift is Address_Bit_Number;

   -- useful unsigned types bitmasks

   Unsigned_8_Mask  : constant := 16#0000_0000_0000_00FF#;
   Unsigned_16_Mask : constant := 16#0000_0000_0000_FFFF#;
   Unsigned_32_Mask : constant := 16#0000_0000_FFFF_FFFF#;
   Unsigned_64_Mask : constant := 16#FFFF_FFFF_FFFF_FFFF#;

   Unsigned_8_RMask  : constant := 16#FFFF_FFFF_FFFF_FF00#;
   Unsigned_16_RMask : constant := 16#FFFF_FFFF_FFFF_0000#;
   Unsigned_32_RMask : constant := 16#FFFF_FFFF_0000_0000#;
   Unsigned_64_RMask : constant := 16#0000_0000_0000_0000#;

   ----------------------------------------------------------------------------
   -- Types and pointers for low-level interfacing.
   ----------------------------------------------------------------------------

   -- null object
   type Null_Object is limited private;

   -- C-style void pointer
   type Void_Ptr is access all Null_Object with
      Storage_Size => 0;

   -- low-level assembler interfacing
   type Asm_Entry_Point is limited private;

   ----------------------------------------------------------------------------
   -- Subprograms.
   ----------------------------------------------------------------------------

   -- P/NBooleans
   function Inactive (Value : PBoolean) return Boolean with
      Inline => True;
   function Active (Value : PBoolean) return Boolean with
      Inline => True;
   function Inactive (Value : NBoolean) return Boolean with
      Inline => True;
   function Active (Value : NBoolean) return Boolean with
      Inline => True;

   -- Map_Bitsize
   function Map_Bitsize (Size : Positive) return Bitsize with
      Inline => True;

   -- Bits_1 <=> Boolean conversions
   function To_Boolean (Value : Bits_1) return Boolean with
      Inline => True;
   function To_Bits_1 (Value : Boolean) return Bits_1 with
      Inline => True;

   -- Bits_XX <=> Bitmap_XX conversions
   function To_B8 (Value : Bitmap_8) return Bits_8 with
      Inline => True;
   function To_BM8 (Value : Bits_8) return Bitmap_8 with
      Inline => True;
   function To_B16 (Value : Bitmap_16) return Bits_16 with
      Inline => True;
   function To_BM16 (Value : Bits_16) return Bitmap_16 with
      Inline => True;
   function To_B32 (Value : Bitmap_32) return Bits_32 with
      Inline => True;
   function To_BM32 (Value : Bits_32) return Bitmap_32 with
      Inline => True;
   function To_B64 (Value : Bitmap_64) return Bits_64 with
      Inline => True;
   function To_BM64 (Value : Bits_64) return Bitmap_64 with
      Inline => True;

   -- Unsigned_8 <=> Storage_Element conversions
   function To_U8 (Value : SSE.Storage_Element) return Interfaces.Unsigned_8 with
      Inline => True;
   function To_SE (Value : Interfaces.Unsigned_8) return SSE.Storage_Element with
      Inline => True;

   -- Unsigned_8 <=> Character conversions
   function To_U8 (C : Character) return Interfaces.Unsigned_8 with
      Inline => True;
   function To_Ch (Value : Interfaces.Unsigned_8) return Character with
      Inline => True;

   -- Unsigned_8
   function ShL (Value : Interfaces.Unsigned_8; Amount : Natural)
                return Interfaces.Unsigned_8 renames Interfaces.Shift_Left;
   function ShR (Value : Interfaces.Unsigned_8; Amount : Natural)
                return Interfaces.Unsigned_8 renames Interfaces.Shift_Right;
   function ShRA (Value : Interfaces.Unsigned_8; Amount : Natural)
                 return Interfaces.Unsigned_8 renames Interfaces.Shift_Right_Arithmetic;
   function RoL (Value : Interfaces.Unsigned_8; Amount : Natural)
                return Interfaces.Unsigned_8 renames Interfaces.Rotate_Left;
   function RoR (Value : Interfaces.Unsigned_8; Amount : Natural)
                return Interfaces.Unsigned_8 renames Interfaces.Rotate_Right;

   -- Unsigned_16
   function ShL (Value : Interfaces.Unsigned_16; Amount : Natural)
                return Interfaces.Unsigned_16 renames Interfaces.Shift_Left;
   function ShR (Value : Interfaces.Unsigned_16; Amount : Natural)
                return Interfaces.Unsigned_16 renames Interfaces.Shift_Right;
   function ShRA (Value : Interfaces.Unsigned_16; Amount : Natural)
                 return Interfaces.Unsigned_16 renames Interfaces.Shift_Right_Arithmetic;
   function RoL (Value : Interfaces.Unsigned_16; Amount : Natural)
                return Interfaces.Unsigned_16 renames Interfaces.Rotate_Left;
   function RoR (Value : Interfaces.Unsigned_16; Amount : Natural)
                return Interfaces.Unsigned_16 renames Interfaces.Rotate_Right;

   -- Unsigned_32
   function ShL (Value : Interfaces.Unsigned_32; Amount : Natural)
                return Interfaces.Unsigned_32 renames Interfaces.Shift_Left;
   function ShR (Value : Interfaces.Unsigned_32; Amount : Natural)
                return Interfaces.Unsigned_32 renames Interfaces.Shift_Right;
   function ShRA (Value : Interfaces.Unsigned_32; Amount : Natural)
                 return Interfaces.Unsigned_32 renames Interfaces.Shift_Right_Arithmetic;
   function RoL (Value : Interfaces.Unsigned_32; Amount : Natural)
                return Interfaces.Unsigned_32 renames Interfaces.Rotate_Left;
   function RoR (Value : Interfaces.Unsigned_32; Amount : Natural)
                return Interfaces.Unsigned_32 renames Interfaces.Rotate_Right;

   -- Unsigned_64
   function ShL (Value : Interfaces.Unsigned_64; Amount : Natural)
                return Interfaces.Unsigned_64 renames Interfaces.Shift_Left;
   function ShR (Value : Interfaces.Unsigned_64; Amount : Natural)
                return Interfaces.Unsigned_64 renames Interfaces.Shift_Right;
   function ShRA (Value : Interfaces.Unsigned_64; Amount : Natural)
                 return Interfaces.Unsigned_64 renames Interfaces.Shift_Right_Arithmetic;
   function RoL (Value : Interfaces.Unsigned_64; Amount : Natural)
                return Interfaces.Unsigned_64 renames Interfaces.Rotate_Left;
   function RoR (Value : Interfaces.Unsigned_64; Amount : Natural)
                return Interfaces.Unsigned_64 renames Interfaces.Rotate_Right;

   -- Unsigned => Signed
   function Signed is new Ada.Unchecked_Conversion (Interfaces.Unsigned_8, Interfaces.Integer_8);
   function Signed is new Ada.Unchecked_Conversion (Interfaces.Unsigned_16, Interfaces.Integer_16);
   function Signed is new Ada.Unchecked_Conversion (Interfaces.Unsigned_32, Interfaces.Integer_32);
   function Signed is new Ada.Unchecked_Conversion (Interfaces.Unsigned_64, Interfaces.Integer_64);

   -- Signed => Unsigned
   function Unsigned is new Ada.Unchecked_Conversion (Interfaces.Integer_8, Interfaces.Unsigned_8);
   function Unsigned is new Ada.Unchecked_Conversion (Interfaces.Integer_16, Interfaces.Unsigned_16);
   function Unsigned is new Ada.Unchecked_Conversion (Interfaces.Integer_32, Interfaces.Unsigned_32);
   function Unsigned is new Ada.Unchecked_Conversion (Interfaces.Integer_64, Interfaces.Unsigned_64);

   -- CPU_Unsigned
   function Shift_Left (Value : CPU_Unsigned; Amount : Natural) return CPU_Unsigned with
      Import     => True,
      Convention => Intrinsic;
   function Shift_Right (Value : CPU_Unsigned; Amount : Natural) return CPU_Unsigned with
      Import     => True,
      Convention => Intrinsic;
   function Shift_Right_Arithmetic (Value : CPU_Unsigned; Amount : Natural) return CPU_Unsigned with
      Import     => True,
      Convention => Intrinsic;
   function Rotate_Left (Value : CPU_Unsigned; Amount : Natural) return CPU_Unsigned with
      Import     => True,
      Convention => Intrinsic;
   function Rotate_Right (Value : CPU_Unsigned; Amount : Natural) return CPU_Unsigned with
      Import     => True,
      Convention => Intrinsic;
   function ShL (Value : CPU_Unsigned; Amount : Natural) return CPU_Unsigned renames Shift_Left;
   function ShR (Value : CPU_Unsigned; Amount : Natural) return CPU_Unsigned renames Shift_Right;
   function ShRA (Value : CPU_Unsigned; Amount : Natural) return CPU_Unsigned renames Shift_Right_Arithmetic;
   function RoL (Value : CPU_Unsigned; Amount : Natural) return CPU_Unsigned renames Rotate_Left;
   function RoR (Value : CPU_Unsigned; Amount : Natural) return CPU_Unsigned renames Rotate_Right;

   -- Bytesize
   function Shift_Left (Value : Bytesize; Amount : Natural) return Bytesize with
      Import     => True,
      Convention => Intrinsic;
   function Shift_Right (Value : Bytesize; Amount : Natural) return Bytesize with
      Import     => True,
      Convention => Intrinsic;
   function Shift_Right_Arithmetic (Value : Bytesize; Amount : Natural) return Bytesize with
      Import     => True,
      Convention => Intrinsic;
   function Rotate_Left (Value : Bytesize; Amount : Natural) return Bytesize with
      Import     => True,
      Convention => Intrinsic;
   function Rotate_Right (Value : Bytesize; Amount : Natural) return Bytesize with
      Import     => True,
      Convention => Intrinsic;
   function ShL (Value : Bytesize; Amount : Natural) return Bytesize renames Shift_Left;
   function ShR (Value : Bytesize; Amount : Natural) return Bytesize renames Shift_Right;
   function ShRA (Value : Bytesize; Amount : Natural) return Bytesize renames Shift_Right_Arithmetic;
   function RoL (Value : Bytesize; Amount : Natural) return Bytesize renames Rotate_Left;
   function RoR (Value : Bytesize; Amount : Natural) return Bytesize renames Rotate_Right;

   -- Integer <=> Mod_Integer conversions
   function To_Mod (Value : Integer) return Mod_Integer with
      Inline => True;
   function To_Integer (Value : Mod_Integer) return Integer with
      Inline => True;

   -- Suppress_LSB
   function Suppress_LSB (Value : Integer; Order : Integer_Bit_Number) return Integer with
      Inline => True;

   -- Byte_Reverse
   function Byte_Reverse (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 with
      Inline => True;

   -- FirstMSBit
   function FirstMSBit (Value : Interfaces.Unsigned_8) return Integer;

   -- LS/MSBitOn
   function LSBitOn (Value : Interfaces.Unsigned_8) return Boolean with
      Inline => True;
   function LSBitOn (Value : Interfaces.Unsigned_16) return Boolean with
      Inline => True;
   function LSBitOn (Value : Interfaces.Unsigned_32) return Boolean with
      Inline => True;
   function LSBitOn (Value : Interfaces.Unsigned_64) return Boolean with
      Inline => True;
   function MSBitOn (Value : Interfaces.Unsigned_8) return Boolean with
      Inline => True;
   function MSBitOn (Value : Interfaces.Unsigned_16) return Boolean with
      Inline => True;
   function MSBitOn (Value : Interfaces.Unsigned_32) return Boolean with
      Inline => True;
   function MSBitOn (Value : Interfaces.Unsigned_64) return Boolean with
      Inline => True;

   -- LE bit order (bit numbering is always bit0 = LSb, regardless of endianness)
   function Bit0 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 with
      Inline => True;
   function Bit7 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 with
      Inline => True;
   function BitN (Value : Interfaces.Unsigned_8; NBit : Natural) return Boolean with
      Inline => True;
   function BitN (
                  Value : Interfaces.Unsigned_8;
                  NBit  : Natural;
                  Bit   : Boolean
                 ) return Interfaces.Unsigned_8 with
      Inline => True;

   -- Endian-Dependent BitN
   function EDBitN (Value : Interfaces.Unsigned_8; NBit : Natural) return Boolean with
      Inline => True;
   function EDBitN (
                    Value : Interfaces.Unsigned_8;
                    NBit  : Natural;
                    Bit   : Boolean
                   ) return Interfaces.Unsigned_8 with
      Inline => True;

   -- BitX
   function Bit0 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_16 with
      Inline => True;
   function Bit7 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_16 with
      Inline => True;
   function BitN (Value : Interfaces.Unsigned_16; NBit : Natural) return Boolean with
      Inline => True;
   function Bit0 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_32 with
      Inline => True;
   function Bit7 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_32 with
      Inline => True;
   function BitN (Value : Interfaces.Unsigned_32; NBit : Natural) return Boolean with
      Inline => True;
   function Bit0 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_64 with
      Inline => True;
   function Bit7 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_64 with
      Inline => True;
   function BitN (Value : Interfaces.Unsigned_64; NBit : Natural) return Boolean with
      Inline => True;

   -- Bit_Extend
   function Bit_Extend (Value : Interfaces.Unsigned_8; Bit : Natural) return Interfaces.Unsigned_8;
   function Bit_Extend (Value : Interfaces.Unsigned_16; Bit : Natural) return Interfaces.Unsigned_16;
   function Bit_Extend (Value : Interfaces.Unsigned_32; Bit : Natural) return Interfaces.Unsigned_32;
   function Bit_Extend (Value : Interfaces.Unsigned_64; Bit : Natural) return Interfaces.Unsigned_64;

   -- Byte/Word manipulation

   function LByte (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_8 with
      Inline => True;
   function HByte (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_8 with
      Inline => True;

   function LByte (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_8 with
      Inline => True;
   function MByte (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_8 with
      Inline => True;
   function NByte (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_8 with
      Inline => True;
   function HByte (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_8 with
      Inline => True;

   function LByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 with
      Inline => True;
   function MByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 with
      Inline => True;
   function NByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 with
      Inline => True;
   function OByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 with
      Inline => True;
   function PByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 with
      Inline => True;
   function QByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 with
      Inline => True;
   function RByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 with
      Inline => True;
   function HByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 with
      Inline => True;

   function LWord (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_8 with
      Inline => True;
   function HWord (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_8 with
      Inline => True;
   function LWord (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_16 with
      Inline => True;
   function HWord (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_16 with
      Inline => True;
   function LWord (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_32 with
      Inline => True;
   function HWord (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_32 with
      Inline => True;

   function Make_Word (Value_H : Interfaces.Unsigned_8; Value_L : Interfaces.Unsigned_8) return Interfaces.Unsigned_16 with
      Inline => True;
   function Make_Word (
                       Value_H : Interfaces.Unsigned_8;
                       Value_N : Interfaces.Unsigned_8;
                       Value_M : Interfaces.Unsigned_8;
                       Value_L : Interfaces.Unsigned_8
                      ) return Interfaces.Unsigned_32 with
      Inline => True;
   function Make_Word (Value_H : Interfaces.Unsigned_16; Value_L : Interfaces.Unsigned_16) return Interfaces.Unsigned_32 with
      Inline => True;
   function Make_Word (Value_H : Interfaces.Unsigned_32; Value_L : Interfaces.Unsigned_32) return Interfaces.Unsigned_64 with
      Inline => True;

   function Byte_Swap_8 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 with
      Inline => True;
   function Byte_Swap (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 renames Byte_Swap_8;

   function Byte_Swap_16 (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 with
      Inline => True;
   function Byte_Swap (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 renames Byte_Swap_16;

   function Byte_Swap_32 (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 with
      Inline => True;
   function Byte_Swap (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 renames Byte_Swap_32;

   function Byte_Swap_64 (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 with
      Inline => True;
   function Byte_Swap (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 renames Byte_Swap_64;

   function Word_Swap (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 with
      Inline => True;
   function Word_Swap (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 with
      Inline => True;
   function Word_Swap (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 with
      Inline => True;
   function Word_Swap (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 with
      Inline => True;

   function CPUE_To_BE (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 with
      Inline => True;
   function BE_To_CPUE (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 with
      Inline => True;
   function CPUE_To_LE (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 with
      Inline => True;
   function LE_To_CPUE (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 with
      Inline => True;

   function CPUE_To_BE (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 with
      Inline => True;
   function BE_To_CPUE (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 with
      Inline => True;
   function CPUE_To_LE (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 with
      Inline => True;
   function LE_To_CPUE (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 with
      Inline => True;

   function CPUE_To_BE (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 with
      Inline => True;
   function BE_To_CPUE (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 with
      Inline => True;
   function CPUE_To_LE (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 with
      Inline => True;
   function LE_To_CPUE (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 with
      Inline => True;

   function HostToNetwork (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 with
      Inline => True;
   function NetworkToHost (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 with
      Inline => True;
   function HostToNetwork (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 with
      Inline => True;
   function NetworkToHost (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 with
      Inline => True;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   type Null_Object is null record with
      Alignment               => 1,
      Size                    => 0,
      Suppress_Initialization => True;

   type Asm_Entry_Point is new Null_Object with
      Convention => Asm;

end Bits;
