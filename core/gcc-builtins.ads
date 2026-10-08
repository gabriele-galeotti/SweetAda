-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gcc-builtins.ads                                                                                          --
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

pragma Restrictions (No_Elaboration_Code);
pragma Style_Checks (Off);

with System;

package GCC.Builtins
   with SPARK_Mode => On
is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- __INF__ use "B3gin" instead of "Begin"
   -- __INF__ use "En6" instead of "End"
   procedure Clear_Cache
      (B3gin : in System.Address;
       En6   : in System.Address)
      with Import        => True,
           Convention    => Intrinsic,
           External_Name => "__builtin___clear_cache";

   type Prefetch_Mode_Type is range 0 .. 2;

   PREFETCH_MODE_READ   : constant Prefetch_Mode_Type := 0; -- prefetch is preparing for a read to the memory address
   PREFETCH_MODE_WRITE  : constant Prefetch_Mode_Type := 1; -- prefetch is preparing for a write to the memory address
   PREFETCH_MODE_SHARED : constant Prefetch_Mode_Type := 2; -- prefetch is preparing for a shared read (expected to be read by at least one other processor before it is written if written at all)

   type Prefetch_Locality_Type is range 0 .. 3;

   PREFETCH_LOCALITY_NONE     : constant Prefetch_Locality_Type := 0; -- the data has no temporal locality, so it need not be left in the cache after the access
   PREFETCH_LOCALITY_LOW      : constant Prefetch_Locality_Type := 1; -- low degree of temporal locality
   PREFETCH_LOCALITY_MODERATE : constant Prefetch_Locality_Type := 2; -- moderate degree of temporal locality
   PREFETCH_LOCALITY_HIGH     : constant Prefetch_Locality_Type := 3; -- the data has a high degree of temporal locality and should be left in all levels of cache possible

   procedure Prefetch
      (Addr     : in System.Address;
       Mode     : in Prefetch_Mode_Type;
       Locality : in Prefetch_Locality_Type)
      with Import        => True,
           Convention    => Intrinsic,
           External_Name => "__builtin_prefetch";

end GCC.Builtins;
