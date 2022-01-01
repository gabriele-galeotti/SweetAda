-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fifo.ads                                                                                                  --
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

with Interfaces;
with Bits;

package FIFO is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   QUEUE_SIZE : constant := 10;

   type Queue_Index_Type is mod QUEUE_SIZE;

   type Queue_Array is new Bits.Byte_Array (0 .. QUEUE_SIZE - 1) with
      Suppress_Initialization => True;

   type Queue_Type is
   record
      Queue : Queue_Array;
      Head  : Queue_Index_Type := 0;
      Tail  : Queue_Index_Type := 0;
      Count : Natural range 0 .. QUEUE_SIZE := 0;
   end record with
      Volatile => True;

   procedure Put (
                  Q       : access Queue_Type;
                  Data    : in     Interfaces.Unsigned_8;
                  Success : out    Boolean
                 );
   procedure Get (
                  Q       : access Queue_Type;
                  Data    : out    Interfaces.Unsigned_8;
                  Success : out    Boolean
                 );

end FIFO;
