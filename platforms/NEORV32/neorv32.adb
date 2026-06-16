-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ neorv32.adb                                                                                               --
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

package body NEORV32
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function CLINT_MTIMECMPx_Read
      (hart : HART_Type)
      return Unsigned_64;

   procedure CLINT_MTIMECMPx_Write
      (Value : in Unsigned_64;
       hart  : in HART_Type);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- CLINT_MTIMECMPx_Read
   ----------------------------------------------------------------------------
   function CLINT_MTIMECMPx_Read
      (hart : HART_Type)
      return Unsigned_64
      is
      Hart_Address_0   : constant Address := System'To_Address (CLINT_MTIMECMP0_ADDRESS);
      Hart_Address_1   : constant Address := System'To_Address (CLINT_MTIMECMP1_ADDRESS);
      Register_Address : Address;
   begin
      case hart is
         when HART0 => Register_Address := Hart_Address_0;
         when HART1 => Register_Address := Hart_Address_1;
      end case;
      declare
         mtime_mmap : aliased RISCV.mtime_Type
            with Address    => Register_Address,
                 Import     => True,
                 Convention => Ada;
         L          : Unsigned_32;
         H          : Unsigned_32;
      begin
         loop
            H := mtime_mmap.H;
            L := mtime_mmap.L;
            exit when H = mtime_mmap.H;
         end loop;
         return Bits.Make_Word (H, L);
      end;
   end CLINT_MTIMECMPx_Read;

   ----------------------------------------------------------------------------
   -- CLINT_MTIMECMPx_Write
   ----------------------------------------------------------------------------
   procedure CLINT_MTIMECMPx_Write
      (Value : in Unsigned_64;
       hart  : in HART_Type)
      is
      Hart_Address_0   : constant Address := System'To_Address (CLINT_MTIMECMP0_ADDRESS);
      Hart_Address_1   : constant Address := System'To_Address (CLINT_MTIMECMP1_ADDRESS);
      Register_Address : Address;
   begin
      case hart is
         when HART0 => Register_Address := Hart_Address_0;
         when HART1 => Register_Address := Hart_Address_1;
      end case;
      declare
         mtimecmp_mmap : aliased RISCV.mtime_Type
            with Address    => Register_Address,
                 Import     => True,
                 Convention => Ada;
      begin
         mtimecmp_mmap.H := 16#FFFF_FFFF#;
         mtimecmp_mmap.L := Bits.LWord (Value);
         mtimecmp_mmap.H := Bits.HWord (Value);
      end;
   end CLINT_MTIMECMPx_Write;

   ----------------------------------------------------------------------------
   -- CLINT_MTIMECMP0_Read
   ----------------------------------------------------------------------------
   function CLINT_MTIMECMP0_Read
      return Unsigned_64
      is
   begin
      return CLINT_MTIMECMPx_Read (HART0);
   end CLINT_MTIMECMP0_Read;

   ----------------------------------------------------------------------------
   -- CLINT_MTIMECMP0_Write
   ----------------------------------------------------------------------------
   procedure CLINT_MTIMECMP0_Write
      (Value : in Unsigned_64)
      is
   begin
      CLINT_MTIMECMPx_Write (Value, HART0);
   end CLINT_MTIMECMP0_Write;

   ----------------------------------------------------------------------------
   -- CLINT_MTIMECMP1_Read
   ----------------------------------------------------------------------------
   function CLINT_MTIMECMP1_Read
      return Unsigned_64
      is
   begin
      return CLINT_MTIMECMPx_Read (HART1);
   end CLINT_MTIMECMP1_Read;

   ----------------------------------------------------------------------------
   -- CLINT_MTIMECMP1_Write
   ----------------------------------------------------------------------------
   procedure CLINT_MTIMECMP1_Write
      (Value : in Unsigned_64)
      is
   begin
      CLINT_MTIMECMPx_Write (Value, HART1);
   end CLINT_MTIMECMP1_Write;

   ----------------------------------------------------------------------------
   -- CLINT_MTIME_Read
   ----------------------------------------------------------------------------
   function CLINT_MTIME_Read
      return Unsigned_64
      is
      mtime_mmap : aliased RISCV.mtime_Type
         with Address    => System'To_Address (CLINT_MTIME_ADDRESS),
              Import     => True,
              Convention => Ada;
      L          : Unsigned_32;
      H          : Unsigned_32;
   begin
      loop
         H := mtime_mmap.H;
         L := mtime_mmap.L;
         exit when H = mtime_mmap.H;
      end loop;
      return Bits.Make_Word (H, L);
   end CLINT_MTIME_Read;

   ----------------------------------------------------------------------------
   -- SPI_CS
   ----------------------------------------------------------------------------
   function SPI_CS
      (Enable : Boolean;
       CS     : SPI_CS_Type := SPI_CS0)
      return Unsigned_8
      is
   begin
      return CS or (if Enable then 2#1000# else 0);
   end SPI_CS;

   ----------------------------------------------------------------------------
   -- mie_Read
   ----------------------------------------------------------------------------
   function mie_Read
      return mie_Type
      is
      function CSRR is new RISCV.CSR_Read ("mie", mie_Type);
   begin
      return CSRR;
   end mie_Read;

   ----------------------------------------------------------------------------
   -- mie_Write
   ----------------------------------------------------------------------------
   procedure mie_Write
      (mie : in mie_Type)
      is
      procedure CSRW is new RISCV.CSR_Write ("mie", mie_Type);
   begin
      CSRW (mie);
   end mie_Write;

   ----------------------------------------------------------------------------
   -- mip_Read
   ----------------------------------------------------------------------------
   function mip_Read
      return mip_Type
      is
      function CSRR is new RISCV.CSR_Read ("mip", mip_Type);
   begin
      return CSRR;
   end mip_Read;

end NEORV32;
