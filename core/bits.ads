-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bits.ads                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Interfaces;

package Bits
   with Pure       => True,
        SPARK_Mode => On
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

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

   -- XOR Boolean function for pragma No_Direct_Boolean_Operators
   function exor
      (A : Boolean;
       B : Boolean)
      return Boolean
      with Inline => True;

   -- Positive Boolean
   type PBoolean is (PFalse, PTrue);
   for PBoolean'Size use 1;
   for PBoolean use (PFalse => 0, PTrue => 1);

   -- Negative Boolean
   type NBoolean is (NTrue, NFalse);
   for NBoolean'Size use 1;
   for NBoolean use (NTrue => 0, NFalse => 1);

   -- CPU_Integer is a signed type holding generic CPU register values
   type CPU_Integer is range -2**(System.Word_Size - 1) .. +2**(System.Word_Size - 1) - 1
      with Size => System.Word_Size;

   -- CPU_Unsigned is a modular type holding generic CPU register values
   type CPU_Unsigned is mod 2**System.Word_Size
      with Size => System.Word_Size;

   -- Mod_Integer is a modular type same size as the base Integer type
   type Mod_Integer is mod 2**Integer'Size
      with Size => Integer'Size;

   -- canonical bit sizes of memory words
   type Bitsize is (BITNONE, BIT8, BIT16, BIT32, BIT64);

   -- Bytesize is a modular type representing size in bytes of large objects
   type Bytesize is mod 2**Standard'Address_Size;

   ----------------------------------------------------------------------------
   -- Fundamental bit-level types and constants.
   ----------------------------------------------------------------------------
   -- Bits_XX low-level types could be defined as modular types derived from
   -- the unsigned ones in package Interfaces.C.Extensions.
   ----------------------------------------------------------------------------

   type Bits_1  is mod 2**1
      with Size => 1;
   type Bits_2  is mod 2**2
      with Size => 2;
   type Bits_3  is mod 2**3
      with Size => 3;
   type Bits_4  is mod 2**4
      with Size => 4;
   type Bits_5  is mod 2**5
      with Size => 5;
   type Bits_6  is mod 2**6
      with Size => 6;
   type Bits_7  is mod 2**7
      with Size => 7;
   type Bits_8  is mod 2**8
      with Size => 8;
   type Bits_9  is mod 2**9
      with Size => 9;
   type Bits_10 is mod 2**10
      with Size => 10;
   type Bits_11 is mod 2**11
      with Size => 11;
   type Bits_12 is mod 2**12
      with Size => 12;
   type Bits_13 is mod 2**13
      with Size => 13;
   type Bits_14 is mod 2**14
      with Size => 14;
   type Bits_15 is mod 2**15
      with Size => 15;
   type Bits_16 is mod 2**16
      with Size => 16;
   type Bits_17 is mod 2**17
      with Size => 17;
   type Bits_18 is mod 2**18
      with Size => 18;
   type Bits_19 is mod 2**19
      with Size => 19;
   type Bits_20 is mod 2**20
      with Size => 20;
   type Bits_21 is mod 2**21
      with Size => 21;
   type Bits_22 is mod 2**22
      with Size => 22;
   type Bits_23 is mod 2**23
      with Size => 23;
   type Bits_24 is mod 2**24
      with Size => 24;
   type Bits_25 is mod 2**25
      with Size => 25;
   type Bits_26 is mod 2**26
      with Size => 26;
   type Bits_27 is mod 2**27
      with Size => 27;
   type Bits_28 is mod 2**28
      with Size => 28;
   type Bits_29 is mod 2**29
      with Size => 29;
   type Bits_30 is mod 2**30
      with Size => 30;
   type Bits_31 is mod 2**31
      with Size => 31;
   type Bits_32 is mod 2**32
      with Size => 32;
   type Bits_33 is mod 2**33
      with Size => 33;
   type Bits_34 is mod 2**34
      with Size => 34;
   type Bits_35 is mod 2**35
      with Size => 35;
   type Bits_36 is mod 2**36
      with Size => 36;
   type Bits_37 is mod 2**37
      with Size => 37;
   type Bits_38 is mod 2**38
      with Size => 38;
   type Bits_39 is mod 2**39
      with Size => 39;
   type Bits_40 is mod 2**40
      with Size => 40;
   type Bits_41 is mod 2**41
      with Size => 41;
   type Bits_42 is mod 2**42
      with Size => 42;
   type Bits_43 is mod 2**43
      with Size => 43;
   type Bits_44 is mod 2**44
      with Size => 44;
   type Bits_45 is mod 2**45
      with Size => 45;
   type Bits_46 is mod 2**46
      with Size => 46;
   type Bits_47 is mod 2**47
      with Size => 47;
   type Bits_48 is mod 2**48
      with Size => 48;
   type Bits_49 is mod 2**49
      with Size => 49;
   type Bits_50 is mod 2**50
      with Size => 50;
   type Bits_51 is mod 2**51
      with Size => 51;
   type Bits_52 is mod 2**52
      with Size => 52;
   type Bits_53 is mod 2**53
      with Size => 53;
   type Bits_54 is mod 2**54
      with Size => 54;
   type Bits_55 is mod 2**55
      with Size => 55;
   type Bits_56 is mod 2**56
      with Size => 56;
   type Bits_57 is mod 2**57
      with Size => 57;
   type Bits_58 is mod 2**58
      with Size => 58;
   type Bits_59 is mod 2**59
      with Size => 59;
   type Bits_60 is mod 2**60
      with Size => 60;
   type Bits_61 is mod 2**61
      with Size => 61;
   type Bits_62 is mod 2**62
      with Size => 62;
   type Bits_63 is mod 2**63
      with Size => 63;
   type Bits_64 is mod 2**64
      with Size => 64;

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
   Bits_37_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0001_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_38_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0011_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_39_Mask : constant := 2#0000_0000_0000_0000_0000_0000_0111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_40_Mask : constant := 2#0000_0000_0000_0000_0000_0000_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_41_Mask : constant := 2#0000_0000_0000_0000_0000_0001_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_42_Mask : constant := 2#0000_0000_0000_0000_0000_0011_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_43_Mask : constant := 2#0000_0000_0000_0000_0000_0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_44_Mask : constant := 2#0000_0000_0000_0000_0000_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_45_Mask : constant := 2#0000_0000_0000_0000_0001_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_46_Mask : constant := 2#0000_0000_0000_0000_0011_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_47_Mask : constant := 2#0000_0000_0000_0000_0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_48_Mask : constant := 2#0000_0000_0000_0000_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_49_Mask : constant := 2#0000_0000_0000_0001_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_50_Mask : constant := 2#0000_0000_0000_0011_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_51_Mask : constant := 2#0000_0000_0000_0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_52_Mask : constant := 2#0000_0000_0000_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_53_Mask : constant := 2#0000_0000_0001_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_54_Mask : constant := 2#0000_0000_0011_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_55_Mask : constant := 2#0000_0000_0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_56_Mask : constant := 2#0000_0000_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_57_Mask : constant := 2#0000_0001_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_58_Mask : constant := 2#0000_0011_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_59_Mask : constant := 2#0000_0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_60_Mask : constant := 2#0000_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_61_Mask : constant := 2#0001_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_62_Mask : constant := 2#0011_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_63_Mask : constant := 2#0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;
   Bits_64_Mask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111#;

   Bits_1_NMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110#;
   Bits_2_NMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100#;
   Bits_3_NMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000#;
   Bits_4_NMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000#;
   Bits_5_NMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000#;
   Bits_6_NMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000#;
   Bits_7_NMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000#;
   Bits_8_NMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000#;
   Bits_9_NMask  : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000#;
   Bits_10_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000#;
   Bits_11_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000#;
   Bits_12_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000#;
   Bits_13_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000#;
   Bits_14_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000#;
   Bits_15_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000#;
   Bits_16_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000#;
   Bits_17_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000_0000#;
   Bits_18_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000_0000#;
   Bits_19_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000_0000#;
   Bits_20_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000#;
   Bits_21_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000_0000_0000#;
   Bits_22_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000_0000_0000#;
   Bits_23_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000_0000_0000#;
   Bits_24_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000#;
   Bits_25_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000_0000_0000_0000#;
   Bits_26_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000_0000_0000_0000#;
   Bits_27_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000_0000_0000_0000#;
   Bits_28_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000#;
   Bits_29_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000_0000_0000_0000_0000#;
   Bits_30_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000_0000_0000_0000_0000#;
   Bits_31_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_32_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_33_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1110_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_34_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1100_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_35_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_1000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_36_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_37_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1110_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_38_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1100_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_39_NMask : constant := 2#1111_1111_1111_1111_1111_1111_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_40_NMask : constant := 2#1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_41_NMask : constant := 2#1111_1111_1111_1111_1111_1110_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_42_NMask : constant := 2#1111_1111_1111_1111_1111_1100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_43_NMask : constant := 2#1111_1111_1111_1111_1111_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_44_NMask : constant := 2#1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_45_NMask : constant := 2#1111_1111_1111_1111_1110_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_46_NMask : constant := 2#1111_1111_1111_1111_1100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_47_NMask : constant := 2#1111_1111_1111_1111_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_48_NMask : constant := 2#1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_49_NMask : constant := 2#1111_1111_1111_1110_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_50_NMask : constant := 2#1111_1111_1111_1100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_51_NMask : constant := 2#1111_1111_1111_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_52_NMask : constant := 2#1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_53_NMask : constant := 2#1111_1111_1110_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_54_NMask : constant := 2#1111_1111_1100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_55_NMask : constant := 2#1111_1111_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_56_NMask : constant := 2#1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_57_NMask : constant := 2#1111_1110_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_58_NMask : constant := 2#1111_1100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_59_NMask : constant := 2#1111_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_60_NMask : constant := 2#1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_61_NMask : constant := 2#1110_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_62_NMask : constant := 2#1100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_63_NMask : constant := 2#1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;
   Bits_64_NMask : constant := 2#0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000#;

   -- Bitmaps
   type Bitmap_1  is array (0 .. 0) of Boolean
      with Component_Size => 1,
           Size           => 1;
   type Bitmap_2  is array (0 .. 1) of Boolean
      with Component_Size => 1,
           Size           => 2;
   type Bitmap_3  is array (0 .. 2) of Boolean
      with Component_Size => 1,
           Size           => 3;
   type Bitmap_4  is array (0 .. 3) of Boolean
      with Component_Size => 1,
           Size           => 4;
   type Bitmap_5  is array (0 .. 4) of Boolean
      with Component_Size => 1,
           Size           => 5;
   type Bitmap_6  is array (0 .. 5) of Boolean
      with Component_Size => 1,
           Size           => 6;
   type Bitmap_7  is array (0 .. 6) of Boolean
      with Component_Size => 1,
           Size           => 7;
   type Bitmap_8  is array (0 .. 7) of Boolean
      with Component_Size => 1,
           Size           => 8;
   type Bitmap_9  is array (0 .. 8) of Boolean
      with Component_Size => 1,
           Size           => 9;
   type Bitmap_10 is array (0 .. 9) of Boolean
      with Component_Size => 1,
           Size           => 10;
   type Bitmap_11 is array (0 .. 10) of Boolean
      with Component_Size => 1,
           Size           => 11;
   type Bitmap_12 is array (0 .. 11) of Boolean
      with Component_Size => 1,
           Size           => 12;
   type Bitmap_13 is array (0 .. 12) of Boolean
      with Component_Size => 1,
           Size           => 13;
   type Bitmap_14 is array (0 .. 13) of Boolean
      with Component_Size => 1,
           Size           => 14;
   type Bitmap_15 is array (0 .. 14) of Boolean
      with Component_Size => 1,
           Size           => 15;
   type Bitmap_16 is array (0 .. 15) of Boolean
      with Component_Size => 1,
           Size           => 16;
   type Bitmap_17 is array (0 .. 16) of Boolean
      with Component_Size => 1,
           Size           => 17;
   type Bitmap_18 is array (0 .. 17) of Boolean
      with Component_Size => 1,
           Size           => 18;
   type Bitmap_19 is array (0 .. 18) of Boolean
      with Component_Size => 1,
           Size           => 19;
   type Bitmap_20 is array (0 .. 19) of Boolean
      with Component_Size => 1,
           Size           => 20;
   type Bitmap_21 is array (0 .. 20) of Boolean
      with Component_Size => 1,
           Size           => 21;
   type Bitmap_22 is array (0 .. 21) of Boolean
      with Component_Size => 1,
           Size           => 22;
   type Bitmap_23 is array (0 .. 22) of Boolean
      with Component_Size => 1,
           Size           => 23;
   type Bitmap_24 is array (0 .. 23) of Boolean
      with Component_Size => 1,
           Size           => 24;
   type Bitmap_25 is array (0 .. 24) of Boolean
      with Component_Size => 1,
           Size           => 25;
   type Bitmap_26 is array (0 .. 25) of Boolean
      with Component_Size => 1,
           Size           => 26;
   type Bitmap_27 is array (0 .. 26) of Boolean
      with Component_Size => 1,
           Size           => 27;
   type Bitmap_28 is array (0 .. 27) of Boolean
      with Component_Size => 1,
           Size           => 28;
   type Bitmap_29 is array (0 .. 28) of Boolean
      with Component_Size => 1,
           Size           => 29;
   type Bitmap_30 is array (0 .. 29) of Boolean
      with Component_Size => 1,
           Size           => 30;
   type Bitmap_31 is array (0 .. 30) of Boolean
      with Component_Size => 1,
           Size           => 31;
   type Bitmap_32 is array (0 .. 31) of Boolean
      with Component_Size => 1,
           Size           => 32;
   type Bitmap_33 is array (0 .. 32) of Boolean
      with Component_Size => 1,
           Size           => 33;
   type Bitmap_34 is array (0 .. 33) of Boolean
      with Component_Size => 1,
           Size           => 34;
   type Bitmap_35 is array (0 .. 34) of Boolean
      with Component_Size => 1,
           Size           => 35;
   type Bitmap_36 is array (0 .. 35) of Boolean
      with Component_Size => 1,
           Size           => 36;
   type Bitmap_37 is array (0 .. 36) of Boolean
      with Component_Size => 1,
           Size           => 37;
   type Bitmap_38 is array (0 .. 37) of Boolean
      with Component_Size => 1,
           Size           => 38;
   type Bitmap_39 is array (0 .. 38) of Boolean
      with Component_Size => 1,
           Size           => 39;
   type Bitmap_40 is array (0 .. 39) of Boolean
      with Component_Size => 1,
           Size           => 40;
   type Bitmap_41 is array (0 .. 40) of Boolean
      with Component_Size => 1,
           Size           => 41;
   type Bitmap_42 is array (0 .. 41) of Boolean
      with Component_Size => 1,
           Size           => 42;
   type Bitmap_43 is array (0 .. 42) of Boolean
      with Component_Size => 1,
           Size           => 43;
   type Bitmap_44 is array (0 .. 43) of Boolean
      with Component_Size => 1,
           Size           => 44;
   type Bitmap_45 is array (0 .. 44) of Boolean
      with Component_Size => 1,
           Size           => 45;
   type Bitmap_46 is array (0 .. 45) of Boolean
      with Component_Size => 1,
           Size           => 46;
   type Bitmap_47 is array (0 .. 46) of Boolean
      with Component_Size => 1,
           Size           => 47;
   type Bitmap_48 is array (0 .. 47) of Boolean
      with Component_Size => 1,
           Size           => 48;
   type Bitmap_49 is array (0 .. 48) of Boolean
      with Component_Size => 1,
           Size           => 49;
   type Bitmap_50 is array (0 .. 49) of Boolean
      with Component_Size => 1,
           Size           => 50;
   type Bitmap_51 is array (0 .. 50) of Boolean
      with Component_Size => 1,
           Size           => 51;
   type Bitmap_52 is array (0 .. 51) of Boolean
      with Component_Size => 1,
           Size           => 52;
   type Bitmap_53 is array (0 .. 52) of Boolean
      with Component_Size => 1,
           Size           => 53;
   type Bitmap_54 is array (0 .. 53) of Boolean
      with Component_Size => 1,
           Size           => 54;
   type Bitmap_55 is array (0 .. 54) of Boolean
      with Component_Size => 1,
           Size           => 55;
   type Bitmap_56 is array (0 .. 55) of Boolean
      with Component_Size => 1,
           Size           => 56;
   type Bitmap_57 is array (0 .. 56) of Boolean
      with Component_Size => 1,
           Size           => 57;
   type Bitmap_58 is array (0 .. 57) of Boolean
      with Component_Size => 1,
           Size           => 58;
   type Bitmap_59 is array (0 .. 58) of Boolean
      with Component_Size => 1,
           Size           => 59;
   type Bitmap_60 is array (0 .. 59) of Boolean
      with Component_Size => 1,
           Size           => 60;
   type Bitmap_61 is array (0 .. 60) of Boolean
      with Component_Size => 1,
           Size           => 61;
   type Bitmap_62 is array (0 .. 61) of Boolean
      with Component_Size => 1,
           Size           => 62;
   type Bitmap_63 is array (0 .. 62) of Boolean
      with Component_Size => 1,
           Size           => 63;
   type Bitmap_64 is array (0 .. 63) of Boolean
      with Component_Size => 1,
           Size           => 64;

   ----------------------------------------------------------------------------
   -- Array types.
   ----------------------------------------------------------------------------

   type U8_Array is array (Natural range <>) of Interfaces.Unsigned_8
      with Alignment      => 1,
           Component_Size => 8;

   type U16_Array is array (Natural range <>) of Interfaces.Unsigned_16
      with Alignment      => 2,
           Component_Size => 16;

   type U32_Array is array (Natural range <>) of Interfaces.Unsigned_32
      with Alignment      => 4,
           Component_Size => 32;

   type U64_Array is array (Natural range <>) of Interfaces.Unsigned_64
      with Alignment      => 8,
           Component_Size => 64;

   -- useful alias
   subtype Byte_Array is U8_Array;

   -- special versions of U8_Array with high-order alignment
   type Byte_A2Array is array (Natural range <>) of Interfaces.Unsigned_8
      with Alignment      => 2,
           Component_Size => 8;
   type Byte_A4Array is array (Natural range <>) of Interfaces.Unsigned_8
      with Alignment      => 4,
           Component_Size => 8;
   type Byte_A8Array is array (Natural range <>) of Interfaces.Unsigned_8
      with Alignment      => 8,
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

   Unsigned_8_NMask  : constant := 16#FFFF_FFFF_FFFF_FF00#;
   Unsigned_16_NMask : constant := 16#FFFF_FFFF_FFFF_0000#;
   Unsigned_32_NMask : constant := 16#FFFF_FFFF_0000_0000#;
   Unsigned_64_NMask : constant := 16#0000_0000_0000_0000#;

   ----------------------------------------------------------------------------
   -- Types and pointers for low-level interfacing.
   ----------------------------------------------------------------------------

   -- null object
   type Null_Object is limited private;

   -- low-level assembler interfacing
   type Asm_Entry_Point is limited private;

   ----------------------------------------------------------------------------
   -- P/NBooleans
   ----------------------------------------------------------------------------

   function To_B
      (Value : PBoolean)
      return Boolean
      with Inline => True;

   function To_P
      (Value : Boolean)
      return PBoolean
      with Inline => True;

   function To_B
      (Value : NBoolean)
      return Boolean
      with Inline => True;

   function To_N
      (Value : Boolean)
      return NBoolean
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Map_Bitsize
   ----------------------------------------------------------------------------
   function Map_Bitsize
      (Size : Positive)
      return Bitsize
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Bits_1 <=> Boolean conversions
   ----------------------------------------------------------------------------

   function To_B
      (Value : Bits_1)
      return Boolean
      with Inline => True;

   function To_B1
      (Value : Boolean)
      return Bits_1
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Bits_XX <=> Bitmap_XX conversions
   ----------------------------------------------------------------------------

   function To_B8
      (Value : Bitmap_8)
      return Bits_8
      with Inline => True;

   function To_BM8
      (Value : Bits_8)
      return Bitmap_8
      with Inline => True;

   function To_B16
      (Value : Bitmap_16)
      return Bits_16
      with Inline => True;

   function To_BM16
      (Value : Bits_16)
      return Bitmap_16
      with Inline => True;

   function To_B32
      (Value : Bitmap_32)
      return Bits_32
      with Inline => True;

   function To_BM32
      (Value : Bits_32)
      return Bitmap_32
      with Inline => True;

   function To_B64
      (Value : Bitmap_64)
      return Bits_64
      with Inline => True;

   function To_BM64
      (Value : Bits_64)
      return Bitmap_64
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Unsigned_8 <=> Storage_Element conversions
   ----------------------------------------------------------------------------

   function To_U8
      (Value : SSE.Storage_Element)
      return Interfaces.Unsigned_8
      with Inline => True;

   function To_SE
      (Value : Interfaces.Unsigned_8)
      return SSE.Storage_Element
      with Inline => True;

   -- Unsigned_8 <=> Character conversions

   function To_U8
      (C : Character)
      return Interfaces.Unsigned_8
      with Inline => True;

   function To_Ch
      (Value : Interfaces.Unsigned_8)
      return Character
      with Inline => True;

   -- Unsigned_8

   function ShL
      (Value  : Interfaces.Unsigned_8;
       Amount : Natural)
      return Interfaces.Unsigned_8
      renames Interfaces.Shift_Left;

   function ShR
      (Value  : Interfaces.Unsigned_8;
       Amount : Natural)
      return Interfaces.Unsigned_8
      renames Interfaces.Shift_Right;

   function ShRA
      (Value  : Interfaces.Unsigned_8;
       Amount : Natural)
      return Interfaces.Unsigned_8
      renames Interfaces.Shift_Right_Arithmetic;

   function RoL
      (Value  : Interfaces.Unsigned_8;
       Amount : Natural)
      return Interfaces.Unsigned_8
      renames Interfaces.Rotate_Left;

   function RoR
      (Value  : Interfaces.Unsigned_8;
       Amount : Natural)
      return Interfaces.Unsigned_8
      renames Interfaces.Rotate_Right;

   -- Unsigned_16

   function ShL
      (Value  : Interfaces.Unsigned_16;
       Amount : Natural)
      return Interfaces.Unsigned_16
      renames Interfaces.Shift_Left;

   function ShR
      (Value  : Interfaces.Unsigned_16;
       Amount : Natural)
      return Interfaces.Unsigned_16
      renames Interfaces.Shift_Right;

   function ShRA
      (Value  : Interfaces.Unsigned_16;
       Amount : Natural)
      return Interfaces.Unsigned_16
      renames Interfaces.Shift_Right_Arithmetic;

   function RoL
      (Value  : Interfaces.Unsigned_16;
       Amount : Natural)
      return Interfaces.Unsigned_16
      renames Interfaces.Rotate_Left;

   function RoR
      (Value  : Interfaces.Unsigned_16;
       Amount : Natural)
      return Interfaces.Unsigned_16
      renames Interfaces.Rotate_Right;

   -- Unsigned_32

   function ShL
      (Value  : Interfaces.Unsigned_32;
       Amount : Natural)
      return Interfaces.Unsigned_32
      renames Interfaces.Shift_Left;

   function ShR
      (Value  : Interfaces.Unsigned_32;
       Amount : Natural)
      return Interfaces.Unsigned_32
      renames Interfaces.Shift_Right;

   function ShRA
      (Value  : Interfaces.Unsigned_32;
       Amount : Natural)
      return Interfaces.Unsigned_32
      renames Interfaces.Shift_Right_Arithmetic;

   function RoL
      (Value  : Interfaces.Unsigned_32;
       Amount : Natural)
      return Interfaces.Unsigned_32
      renames Interfaces.Rotate_Left;

   function RoR
      (Value  : Interfaces.Unsigned_32;
       Amount : Natural)
      return Interfaces.Unsigned_32
      renames Interfaces.Rotate_Right;

   -- Unsigned_64

   function ShL
      (Value  : Interfaces.Unsigned_64;
       Amount : Natural)
      return Interfaces.Unsigned_64
      renames Interfaces.Shift_Left;

   function ShR
      (Value  : Interfaces.Unsigned_64;
       Amount : Natural)
      return Interfaces.Unsigned_64
      renames Interfaces.Shift_Right;

   function ShRA
      (Value  : Interfaces.Unsigned_64;
       Amount : Natural)
      return Interfaces.Unsigned_64
      renames Interfaces.Shift_Right_Arithmetic;

   function RoL
      (Value  : Interfaces.Unsigned_64;
       Amount : Natural)
      return Interfaces.Unsigned_64
      renames Interfaces.Rotate_Left;

   function RoR
      (Value  : Interfaces.Unsigned_64;
       Amount : Natural)
      return Interfaces.Unsigned_64
      renames Interfaces.Rotate_Right;

   -- CPU_Unsigned

   function Shift_Left
      (Value  : CPU_Unsigned;
       Amount : Natural)
      return CPU_Unsigned
      with Import     => True,
           Convention => Intrinsic;

   function Shift_Right
      (Value  : CPU_Unsigned;
       Amount : Natural)
      return CPU_Unsigned
      with Import     => True,
           Convention => Intrinsic;

   function Shift_Right_Arithmetic
      (Value  : CPU_Unsigned;
       Amount : Natural)
      return CPU_Unsigned
      with Import     => True,
           Convention => Intrinsic;

   function Rotate_Left
      (Value  : CPU_Unsigned;
       Amount : Natural)
      return CPU_Unsigned
      with Import     => True,
           Convention => Intrinsic;

   function Rotate_Right
      (Value  : CPU_Unsigned;
       Amount : Natural)
      return CPU_Unsigned
      with Import     => True,
           Convention => Intrinsic;

   function ShL
      (Value  : CPU_Unsigned;
       Amount : Natural)
      return CPU_Unsigned
      renames Shift_Left;

   function ShR
      (Value  : CPU_Unsigned;
       Amount : Natural)
      return CPU_Unsigned
      renames Shift_Right;

   function ShRA
      (Value  : CPU_Unsigned;
       Amount : Natural)
      return CPU_Unsigned
      renames Shift_Right_Arithmetic;

   function RoL
      (Value  : CPU_Unsigned;
       Amount : Natural)
      return CPU_Unsigned
      renames Rotate_Left;

   function RoR
      (Value  : CPU_Unsigned;
       Amount : Natural)
      return CPU_Unsigned
      renames Rotate_Right;

   -- Bytesize

   function Shift_Left
      (Value  : Bytesize;
       Amount : Natural)
      return Bytesize
      with Import     => True,
           Convention => Intrinsic;

   function Shift_Right
      (Value  : Bytesize;
       Amount : Natural)
      return Bytesize
      with Import     => True,
           Convention => Intrinsic;

   function Shift_Right_Arithmetic
      (Value  : Bytesize;
       Amount : Natural)
      return Bytesize
      with Import     => True,
           Convention => Intrinsic;

   function Rotate_Left
      (Value  : Bytesize;
       Amount : Natural)
      return Bytesize
      with Import     => True,
           Convention => Intrinsic;

   function Rotate_Right
      (Value  : Bytesize;
       Amount : Natural)
      return Bytesize
      with Import     => True,
           Convention => Intrinsic;

   function ShL
      (Value  : Bytesize;
       Amount : Natural)
      return Bytesize
      renames Shift_Left;

   function ShR
      (Value  : Bytesize;
       Amount : Natural)
      return Bytesize
      renames Shift_Right;

   function ShRA
      (Value  : Bytesize;
       Amount : Natural)
      return Bytesize
      renames Shift_Right_Arithmetic;

   function RoL
      (Value  : Bytesize;
       Amount : Natural)
      return Bytesize
      renames Rotate_Left;

   function RoR
      (Value  : Bytesize;
       Amount : Natural)
      return Bytesize
      renames Rotate_Right;

   ----------------------------------------------------------------------------
   -- Integer <=> Mod_Integer conversions
   ----------------------------------------------------------------------------

   function To_Mod
      (Value : Integer)
      return Mod_Integer
      with Inline => True;

   function To_Integer
      (Value : Mod_Integer)
      return Integer
      with Inline => True;

   ----------------------------------------------------------------------------
   -- LS/MSBitOn
   ----------------------------------------------------------------------------

   function LSBitOn
      (Value : Interfaces.Unsigned_8)
      return Boolean
      with Inline => True;

   function LSBitOn
      (Value : Interfaces.Unsigned_16)
      return Boolean
      with Inline => True;

   function LSBitOn
      (Value : Interfaces.Unsigned_32)
      return Boolean
      with Inline => True;

   function LSBitOn
      (Value : Interfaces.Unsigned_64)
      return Boolean
      with Inline => True;

   function MSBitOn
      (Value : Interfaces.Unsigned_8)
      return Boolean
      with Inline => True;

   function MSBitOn
      (Value : Interfaces.Unsigned_16)
      return Boolean
      with Inline => True;

   function MSBitOn
      (Value : Interfaces.Unsigned_32)
      return Boolean
      with Inline => True;

   function MSBitOn
      (Value : Interfaces.Unsigned_64)
      return Boolean
      with Inline => True;

   -- LE bit order (bit numbering is always bit0 = LSb, regardless of endianness)

   function Bit0
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      with Inline => True;

   function Bit7
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      with Inline => True;

   function BitN
      (Value : Interfaces.Unsigned_8;
       NBit  : Natural)
      return Boolean
      with Inline => True;

   function BitN
      (Value : Interfaces.Unsigned_8;
       NBit  : Natural;
       Bit   : Boolean)
      return Interfaces.Unsigned_8
      with Inline => True;

   -- BitX

   function Bit0
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_16
      with Inline => True;

   function Bit7
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_16
      with Inline => True;

   function BitN
      (Value : Interfaces.Unsigned_16;
       NBit  : Natural)
      return Boolean
      with Inline => True;

   function Bit0
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_32
      with Inline => True;

   function Bit7
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_32
      with Inline => True;

   function BitN
      (Value : Interfaces.Unsigned_32;
       NBit  : Natural)
      return Boolean
      with Inline => True;

   function Bit0
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_64
      with Inline => True;

   function Bit7
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_64
      with Inline => True;

   function BitN
      (Value : Interfaces.Unsigned_64;
       NBit  : Natural)
      return Boolean
      with Inline => True;

   ----------------------------------------------------------------------------
   -- L/M/N/O/P/Q/R/HByte
   ----------------------------------------------------------------------------
   -- Extract an Unsigned_8-component from a word.
   -- L is always the LS byte, H is always the MS byte; M comes next to L,
   -- then other letters represent increasing bytes.
   ----------------------------------------------------------------------------

   function LByte
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_8
      with Inline => True;

   function HByte
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_8
      with Inline => True;

   function LByte
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_8
      with Inline => True;

   function MByte
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_8
      with Inline => True;

   function NByte
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_8
      with Inline => True;

   function HByte
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_8
      with Inline => True;

   function LByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      with Inline => True;

   function MByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      with Inline => True;

   function NByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      with Inline => True;

   function OByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      with Inline => True;

   function PByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      with Inline => True;

   function QByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      with Inline => True;

   function RByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      with Inline => True;

   function HByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      with Inline => True;

   function LWord
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_8
      with Inline => True;

   function HWord
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_8
      with Inline => True;

   function LWord
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_16
      with Inline => True;

   function HWord
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_16
      with Inline => True;

   function LWord
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_32
      with Inline => True;

   function HWord
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_32
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Make_Word
   ----------------------------------------------------------------------------
   -- Assemble a 16/32/64-bit word using low-order halves.
   -- L is always the LS byte, H is always the MS byte; M comes next to L,
   -- then other letters represent increasing bytes.
   ----------------------------------------------------------------------------

   function Make_Word
      (Value_H : Interfaces.Unsigned_8;
       Value_L : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_16
      with Inline => True;

   function Make_Word
      (Value_H : Interfaces.Unsigned_8;
       Value_N : Interfaces.Unsigned_8;
       Value_M : Interfaces.Unsigned_8;
       Value_L : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_32
      with Inline => True;

   function Make_Word
      (Value_H : Interfaces.Unsigned_16;
       Value_L : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_32
      with Inline => True;

   function Make_Word
      (Value_H : Interfaces.Unsigned_32;
       Value_L : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_64
      with Inline => True;

   ----------------------------------------------------------------------------
   -- BitMask_XX
   ----------------------------------------------------------------------------

   function BitMask_8
      (MSb    : Bits_3;
       LSb    : Bits_3;
       Negate : Boolean := False)
      return Interfaces.Unsigned_8
      with Inline => True;

   function BitMask_16
      (MSb    : Bits_4;
       LSb    : Bits_4;
       Negate : Boolean := False)
      return Interfaces.Unsigned_16
      with Inline => True;

   function BitMask_32
      (MSb    : Bits_5;
       LSb    : Bits_5;
       Negate : Boolean := False)
      return Interfaces.Unsigned_32
      with Inline => True;

   function BitMask_64
      (MSb    : Bits_6;
       LSb    : Bits_6;
       Negate : Boolean := False)
      return Interfaces.Unsigned_64
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Byte_Swap
   ----------------------------------------------------------------------------

   function Byte_Swap_8
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      with Inline => True;
   function Byte_Swap
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      renames Byte_Swap_8;

   function Byte_Swap_16
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      with Inline => True;
   function Byte_Swap
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      renames Byte_Swap_16;

   function Byte_Swap_32
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      with Inline => True;
   function Byte_Swap
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      renames Byte_Swap_32;

   function Byte_Swap_64
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      with Inline => True;
   function Byte_Swap
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      renames Byte_Swap_64;

   ----------------------------------------------------------------------------
   -- Word_Swap
   ----------------------------------------------------------------------------
   -- Swap two halves of a 16/32/64-bit word.
   ----------------------------------------------------------------------------

   function Word_Swap
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      with Inline => True;

   function Word_Swap
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      with Inline => True;

   function Word_Swap
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      with Inline => True;

   function Word_Swap
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      with Inline => True;

   ----------------------------------------------------------------------------
   -- CPUE to/from BE/LE
   ----------------------------------------------------------------------------

   function CPUE_To_BE
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      with Inline => True;

   function BE_To_CPUE
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      with Inline => True;

   function CPUE_To_LE
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      with Inline => True;

   function LE_To_CPUE
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      with Inline => True;

   function CPUE_To_BE
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      with Inline => True;

   function BE_To_CPUE
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      with Inline => True;

   function CPUE_To_LE
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      with Inline => True;

   function LE_To_CPUE
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      with Inline => True;

   function CPUE_To_BE
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      with Inline => True;

   function BE_To_CPUE
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      with Inline => True;

   function CPUE_To_LE
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      with Inline => True;

   function LE_To_CPUE
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      with Inline => True;

   function HToN
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      renames CPUE_To_BE;

   function NToH
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      renames BE_To_CPUE;

   function HToN
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      renames CPUE_To_BE;

   function NToH
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      renames BE_To_CPUE;

   ----------------------------------------------------------------------------
   -- Byte_Reverse
   ----------------------------------------------------------------------------
   -- Reverse the bit pattern of a byte.
   ----------------------------------------------------------------------------
   function Byte_Reverse
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      with Inline => True;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   type Null_Object is null record
      with Alignment               => 1,
           Size                    => 0,
           Suppress_Initialization => True;

   type Asm_Entry_Point is new Null_Object
      with Convention => Asm;

end Bits;
