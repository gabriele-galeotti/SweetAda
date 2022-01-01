-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmio.ads                                                                                                  --
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
with Interfaces;

package MMIO is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   ----------------------------------------------------------------------------
   -- "Standard" Read/Write Unsigned_XX
   ----------------------------------------------------------------------------

   function Read_U8 (Memory_Address : System.Address) return Interfaces.Unsigned_8;
   function Read (Memory_Address : System.Address) return Interfaces.Unsigned_8
      renames Read_U8;

   procedure Write_U8 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_8);
   procedure Write (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_8)
      renames Write_U8;

   function Read_U16 (Memory_Address : System.Address) return Interfaces.Unsigned_16;
   function Read (Memory_Address : System.Address) return Interfaces.Unsigned_16
      renames Read_U16;

   procedure Write_U16 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_16);
   procedure Write (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_16)
      renames Write_U16;

   function Read_U32 (Memory_Address : System.Address) return Interfaces.Unsigned_32;
   function Read (Memory_Address : System.Address) return Interfaces.Unsigned_32
      renames Read_U32;

   procedure Write_U32 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_32);
   procedure Write (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_32)
      renames Write_U32;

   function Read_U64 (Memory_Address : System.Address) return Interfaces.Unsigned_64;
   function Read (Memory_Address : System.Address) return Interfaces.Unsigned_64
      renames Read_U64;

   procedure Write_U64 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_64);
   procedure Write (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_64)
      renames Write_U64;

   ----------------------------------------------------------------------------
   -- "Null" Read/Write Unsigned_XX
   ----------------------------------------------------------------------------

   function ReadN_U8 (Memory_Address : System.Address) return Interfaces.Unsigned_8;
   function ReadN (Memory_Address : System.Address) return Interfaces.Unsigned_8
      renames ReadN_U8;

   procedure WriteN_U8 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_8);
   procedure WriteN (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_8)
      renames WriteN_U8;

   function ReadN_U16 (Memory_Address : System.Address) return Interfaces.Unsigned_16;
   function ReadN (Memory_Address : System.Address) return Interfaces.Unsigned_16
      renames ReadN_U16;

   procedure WriteN_U16 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_16);
   procedure WriteN (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_16)
      renames WriteN_U16;

   function ReadN_U32 (Memory_Address : System.Address) return Interfaces.Unsigned_32;
   function ReadN (Memory_Address : System.Address) return Interfaces.Unsigned_32
      renames ReadN_U32;

   procedure WriteN_U32 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_32);
   procedure WriteN (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_32)
      renames WriteN_U32;

   function ReadN_U64 (Memory_Address : System.Address) return Interfaces.Unsigned_64;
   function ReadN (Memory_Address : System.Address) return Interfaces.Unsigned_64
      renames ReadN_U64;

   procedure WriteN_U64 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_64);
   procedure WriteN (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_64)
      renames WriteN_U64;

   ----------------------------------------------------------------------------
   -- "Atomic" Read/Write Unsigned_XX
   ----------------------------------------------------------------------------

   function ReadA_U8 (Memory_Address : System.Address) return Interfaces.Unsigned_8;
   function ReadA (Memory_Address : System.Address) return Interfaces.Unsigned_8
      renames ReadA_U8;

   procedure WriteA_U8 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_8);
   procedure WriteA (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_8)
      renames WriteA_U8;

   function ReadA_U16 (Memory_Address : System.Address) return Interfaces.Unsigned_16;
   function ReadA (Memory_Address : System.Address) return Interfaces.Unsigned_16
      renames ReadA_U16;

   procedure WriteA_U16 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_16);
   procedure WriteA (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_16)
      renames WriteA_U16;

   function ReadA_U32 (Memory_Address : System.Address) return Interfaces.Unsigned_32;
   function ReadA (Memory_Address : System.Address) return Interfaces.Unsigned_32
      renames ReadA_U32;

   procedure WriteA_U32 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_32);
   procedure WriteA (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_32)
      renames WriteA_U32;

   function ReadA_U64 (Memory_Address : System.Address) return Interfaces.Unsigned_64;
   function ReadA (Memory_Address : System.Address) return Interfaces.Unsigned_64
      renames ReadA_U64;

   procedure WriteA_U64 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_64);
   procedure WriteA (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_64)
      renames WriteA_U64;

   ----------------------------------------------------------------------------
   -- "Swap" Read/Write Unsigned_XX
   ----------------------------------------------------------------------------

   function ReadS_U8 (Memory_Address : System.Address) return Interfaces.Unsigned_8;
   function ReadS (Memory_Address : System.Address) return Interfaces.Unsigned_8
      renames ReadS_U8;

   procedure WriteS_U8 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_8);
   procedure WriteS (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_8)
      renames WriteS_U8;

   function ReadS_U16 (Memory_Address : System.Address) return Interfaces.Unsigned_16;
   function ReadS (Memory_Address : System.Address) return Interfaces.Unsigned_16
      renames ReadS_U16;

   procedure WriteS_U16 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_16);
   procedure WriteS (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_16)
      renames WriteS_U16;

   function ReadS_U32 (Memory_Address : System.Address) return Interfaces.Unsigned_32;
   function ReadS (Memory_Address : System.Address) return Interfaces.Unsigned_32
      renames ReadS_U32;

   procedure WriteS_U32 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_32);
   procedure WriteS (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_32)
      renames WriteS_U32;

   function ReadS_U64 (Memory_Address : System.Address) return Interfaces.Unsigned_64;
   function ReadS (Memory_Address : System.Address) return Interfaces.Unsigned_64
      renames ReadS_U64;

   procedure WriteS_U64 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_64);
   procedure WriteS (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_64)
      renames WriteS_U64;

   ----------------------------------------------------------------------------
   -- "Atomic and Swap" Read/Write Unsigned_XX
   ----------------------------------------------------------------------------

   function ReadAS_U8 (Memory_Address : System.Address) return Interfaces.Unsigned_8;
   function ReadAS (Memory_Address : System.Address) return Interfaces.Unsigned_8
      renames ReadAS_U8;

   procedure WriteAS_U8 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_8);
   procedure WriteAS (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_8)
      renames WriteAS_U8;

   function ReadAS_U16 (Memory_Address : System.Address) return Interfaces.Unsigned_16;
   function ReadAS (Memory_Address : System.Address) return Interfaces.Unsigned_16
      renames ReadAS_U16;

   procedure WriteAS_U16 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_16);
   procedure WriteAS (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_16)
      renames WriteAS_U16;

   function ReadAS_U32 (Memory_Address : System.Address) return Interfaces.Unsigned_32;
   function ReadAS (Memory_Address : System.Address) return Interfaces.Unsigned_32
      renames ReadAS_U32;

   procedure WriteAS_U32 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_32);
   procedure WriteAS (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_32)
      renames WriteAS_U32;

   function ReadAS_U64 (Memory_Address : System.Address) return Interfaces.Unsigned_64;
   function ReadAS (Memory_Address : System.Address) return Interfaces.Unsigned_64
      renames ReadAS_U64;

   procedure WriteAS_U64 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_64);
   procedure WriteAS (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_64)
      renames WriteAS_U64;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Inline (Read_U8);
   pragma Inline (Write_U8);
   pragma Inline (Read_U16);
   pragma Inline (Write_U16);
   pragma Inline (Read_U32);
   pragma Inline (Write_U32);
   pragma Inline (Read_U64);
   pragma Inline (Write_U64);

   pragma Inline (ReadN_U8);
   pragma Inline (WriteN_U8);
   pragma Inline (ReadN_U16);
   pragma Inline (WriteN_U16);
   pragma Inline (ReadN_U32);
   pragma Inline (WriteN_U32);
   pragma Inline (ReadN_U64);
   pragma Inline (WriteN_U64);

   pragma Inline (ReadA_U8);
   pragma Inline (WriteA_U8);
   pragma Inline (ReadA_U16);
   pragma Inline (WriteA_U16);
   pragma Inline (ReadA_U32);
   pragma Inline (WriteA_U32);
   pragma Inline (ReadA_U64);
   pragma Inline (WriteA_U64);

   pragma Inline (ReadS_U8);
   pragma Inline (WriteS_U8);
   pragma Inline (ReadS_U16);
   pragma Inline (WriteS_U16);
   pragma Inline (ReadS_U32);
   pragma Inline (WriteS_U32);
   pragma Inline (ReadS_U64);
   pragma Inline (WriteS_U64);

   pragma Inline (ReadAS_U8);
   pragma Inline (WriteAS_U8);
   pragma Inline (ReadAS_U16);
   pragma Inline (WriteAS_U16);
   pragma Inline (ReadAS_U32);
   pragma Inline (WriteAS_U32);
   pragma Inline (ReadAS_U64);
   pragma Inline (WriteAS_U64);

   pragma Inline (Read);
   pragma Inline (Write);
   pragma Inline (ReadN);
   pragma Inline (WriteN);
   pragma Inline (ReadA);
   pragma Inline (WriteA);
   pragma Inline (ReadS);
   pragma Inline (WriteS);
   pragma Inline (ReadAS);
   pragma Inline (WriteAS);

end MMIO;
