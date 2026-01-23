-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mcf5206.adb                                                                                               --
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

with Ada.Unchecked_Conversion;

package body MCF5206
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   generic function UC renames Ada.Unchecked_Conversion;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- UART MODULES conversion functions

pragma Style_Checks (Off);
   function To_U8 (Value : UMR1_Type) return Unsigned_8 is function Convert is new UC (UMR1_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_UMR1 (Value : Unsigned_8) return UMR1_Type is function Convert is new UC (Unsigned_8, UMR1_Type); begin return Convert (Value); end To_UMR1;
   function To_U8  (Value : UMR2_Type) return Unsigned_8 is function Convert is new UC (UMR2_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_UMR2 (Value : Unsigned_8) return UMR2_Type is function Convert is new UC (Unsigned_8, UMR2_Type); begin return Convert (Value); end To_UMR2;
   function To_U8 (Value : USR_Type) return Unsigned_8 is function Convert is new UC (USR_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_USR (Value : Unsigned_8) return USR_Type is function Convert is new UC (Unsigned_8, USR_Type); begin return Convert (Value); end To_USR;
   function To_U8 (Value : UCSR_Type) return Unsigned_8 is function Convert is new UC (UCSR_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_UCSR (Value : Unsigned_8) return UCSR_Type is function Convert is new UC (Unsigned_8, UCSR_Type); begin return Convert (Value); end To_UCSR;
   function To_U8 (Value : UCR_Type) return Unsigned_8 is function Convert is new UC (UCR_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_UCR (Value : Unsigned_8) return UCR_Type is function Convert is new UC (Unsigned_8, UCR_Type); begin return Convert (Value); end To_UCR;
   function To_U8 (Value : UIPCR_Type) return Unsigned_8 is function Convert is new UC (UIPCR_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_UIPCR (Value : Unsigned_8) return UIPCR_Type is function Convert is new UC (Unsigned_8, UIPCR_Type); begin return Convert (Value); end To_UIPCR;
   function To_U8 (Value : UACR_Type) return Unsigned_8 is function Convert is new UC (UACR_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_UACR (Value : Unsigned_8) return UACR_Type is function Convert is new UC (Unsigned_8, UACR_Type); begin return Convert (Value); end To_UACR;
   function To_U8 (Value : UISR_Type) return Unsigned_8 is function Convert is new UC (UISR_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_UISR (Value : Unsigned_8) return UISR_Type is function Convert is new UC (Unsigned_8, UISR_Type); begin return Convert (Value); end To_UISR;
   function To_U8 (Value : UIMR_Type) return Unsigned_8 is function Convert is new UC (UIMR_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_UIMR (Value : Unsigned_8) return UIMR_Type is function Convert is new UC (Unsigned_8, UIMR_Type); begin return Convert (Value); end To_UIMR;
   function To_U8 (Value : UIP_Type) return Unsigned_8 is function Convert is new UC (UIP_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_UIP (Value : Unsigned_8) return UIP_Type is function Convert is new UC (Unsigned_8, UIP_Type); begin return Convert (Value); end To_UIP;
   function To_U8 (Value : UOP_Type) return Unsigned_8 is function Convert is new UC (UOP_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_UOP (Value : Unsigned_8) return UOP_Type is function Convert is new UC (Unsigned_8, UOP_Type); begin return Convert (Value); end To_UOP;
pragma Style_Checks (On);

end MCF5206;
