-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmio.adb                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

package body MMIO
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- "Standard" Read/Write Unsigned_XX
   ----------------------------------------------------------------------------

   -- Unsigned_8
   function Read_U8
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_8
      is
   separate;
   procedure Write_U8
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_8)
      is
   separate;

   -- Unsigned_16
   function Read_U16
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_16
      is
   separate;
   procedure Write_U16
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_16)
      is
   separate;

   -- Unsigned_32
   function Read_U32
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_32
      is
   separate;
   procedure Write_U32
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_32)
      is
   separate;

   -- Unsigned_64
   function Read_U64
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_64
      is
   separate;
   procedure Write_U64
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_64)
      is
   separate;

   ----------------------------------------------------------------------------
   -- "Null" Read/Write Unsigned_XX
   ----------------------------------------------------------------------------

   -- Unsigned_8
   function ReadN_U8
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_8
      is
   separate;
   procedure WriteN_U8
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_8)
      is
   separate;

   -- Unsigned_16
   function ReadN_U16
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_16
      is
   separate;
   procedure WriteN_U16
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_16)
      is
   separate;

   -- Unsigned_32
   function ReadN_U32
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_32
      is
   separate;
   procedure WriteN_U32
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_32)
      is
   separate;

   -- Unsigned_64
   function ReadN_U64
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_64
      is
   separate;
   procedure WriteN_U64
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_64)
      is
   separate;

   ----------------------------------------------------------------------------
   -- "Atomic" Read/Write Unsigned_XX
   ----------------------------------------------------------------------------

   -- Unsigned_8
   function ReadA_U8
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_8
      is
   separate;
   procedure WriteA_U8
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_8)
      is
   separate;

   -- Unsigned_16
   function ReadA_U16
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_16
      is
   separate;
   procedure WriteA_U16
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_16)
      is
   separate;

   -- Unsigned_32
   function ReadA_U32
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_32
      is
   separate;
   procedure WriteA_U32
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_32)
      is
   separate;

   -- Unsigned_64
   function ReadA_U64
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_64
      is
   separate;
   procedure WriteA_U64
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_64)
      is
   separate;

   ----------------------------------------------------------------------------
   -- "Swap" Read/Write Unsigned_XX
   ----------------------------------------------------------------------------

   -- Unsigned_8
   function ReadS_U8
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_8
      is
   separate;
   procedure WriteS_U8
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_8)
      is
   separate;

   -- Unsigned_16
   function ReadS_U16
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_16
      is
   separate;
   procedure WriteS_U16
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_16)
      is
   separate;

   -- Unsigned_32
   function ReadS_U32
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_32
      is
   separate;
   procedure WriteS_U32
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_32)
      is
   separate;

   -- Unsigned_64
   function ReadS_U64
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_64
      is
   separate;
   procedure WriteS_U64
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_64)
      is
   separate;

   ----------------------------------------------------------------------------
   -- "Atomic and Swap" Read/Write Unsigned_XX
   ----------------------------------------------------------------------------

   -- Unsigned_8
   function ReadAS_U8
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_8
      is
   separate;
   procedure WriteAS_U8
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_8)
      is
   separate;

   -- Unsigned_16
   function ReadAS_U16
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_16
      is
   separate;
   procedure WriteAS_U16
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_16)
      is
   separate;

   -- Unsigned_32
   function ReadAS_U32
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_32
      is
   separate;
   procedure WriteAS_U32
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_32)
      is
   separate;

   -- Unsigned_64
   function ReadAS_U64
      (Memory_Address : System.Address)
      return Interfaces.Unsigned_64
      is
   separate;
   procedure WriteAS_U64
      (Memory_Address : in System.Address;
       Value          : in Interfaces.Unsigned_64)
      is
   separate;

end MMIO;
