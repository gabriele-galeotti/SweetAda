-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmio-reada_u64.adb                                                                                        --
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

separate (MMIO)
function ReadA_U64
   (Memory_Address : System.Address)
   return Interfaces.Unsigned_64
   is
begin
   if System.Word_Size = 64 then
      declare
         Result : aliased Interfaces.Unsigned_64
            with Address    => Memory_Address,
                 Atomic     => True,
                 Import     => True,
                 Convention => Ada;
      begin
         return Result;
      end;
   else
      raise Program_Error;
      return 0;
   end if;
end ReadA_U64;
