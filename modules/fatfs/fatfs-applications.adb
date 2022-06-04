-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-applications.adb                                                                                    --
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

with FATFS;
with FATFS.Directory;
with FATFS.Rawfile;
with FATFS.Textfile;
with Memory_Functions;
with Console;

package body FATFS.Applications is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use FATFS;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Test
   ----------------------------------------------------------------------------
   procedure Test is
      DCB     : DCB_Type;
      DE      : Directory_Entry_Type;
      Success : Boolean;
      procedure Print_File_Name (F : Directory_Entry_Type);
      procedure Print_File_Name (F : Directory_Entry_Type) is
      begin
         Console.Print (F.Filename);
         Console.Print (".");
         Console.Print (F.Extension);
         Console.Print ("   ");
         Console.Print (Integer (F.Size));
         Console.Print (" ");
         if F.File_Attributes.Read_Only then
            Console.Print ("R");
         end if;
         if F.File_Attributes.Hidden_File then
            Console.Print ("H");
         end if;
         if F.File_Attributes.System_File then
            Console.Print ("S");
         end if;
         if F.File_Attributes.Subdirectory then
            Console.Print ("D");
         end if;
         if F.File_Attributes.Archive then
            Console.Print ("A");
         end if;
         Console.Print_NewLine;
      end Print_File_Name;
   begin
      Directory.Open_Root (DCB, Success);
      if Success then
         Directory.Get_Entry (DCB, DE, Success);
         if Success then
            Print_File_Name (DE);
         end if;
         -------------------------------------------
         loop
            Directory.Next_Entry (DCB, DE, Success);
            if Success then
               Print_File_Name (DE);
            else
               exit;
            end if;
         end loop;
         -------------------------------------------
      end if;
   end Test;

   ----------------------------------------------------------------------------
   -- Load_AUTOEXECBAT
   ----------------------------------------------------------------------------
   procedure Load_AUTOEXECBAT is
      DCB     : DCB_Type;
      DE      : Directory_Entry_Type;
      Success : Boolean;
   begin
      Directory.Open_Root (DCB, Success);
      if not Success then
         return;
      end if;
      loop
         Directory.Next_Entry (DCB, DE, Success);
         exit when not Success;
         if DE.Filename = "AUTOEXEC" and then DE.Extension = "BAT" then
            declare
               F    : TFCB_Type;
               L    : Natural;
               Line : String (1 .. 80);
            begin
               Console.Print ("Loading AUTOEXEC.BAT ...", NL => True);
               Textfile.Open (F, DE, Success);
               if Success then
                  Line := (others => ' ');
                  Textfile.Read_Line (F, Line, L, Success);
                  Console.Print (Line);
                  Console.Print_NewLine;
                  Line := (others => ' ');
                  Textfile.Read_Line (F, Line, L, Success);
                  Console.Print (Line);
                  Console.Print_NewLine;
                  Line := (others => ' ');
                  Textfile.Read_Line (F, Line, L, Success);
                  Console.Print (Line);
                  Console.Print_NewLine;
               end if;
            end;
         end if;
      end loop;
   end Load_AUTOEXECBAT;

   ----------------------------------------------------------------------------
   -- Load_PROVA02PYC
   ----------------------------------------------------------------------------
   -- Load PROVA.PYC in the Python code array.
   ----------------------------------------------------------------------------
   procedure Load_PROVA02PYC (Destination_Address : System.Address) is
      DCB     : DCB_Type;
      DE      : Directory_Entry_Type;
      Success : Boolean;
   begin
      Directory.Open_Root (DCB, Success);
      if not Success then
         return;
      end if;
      loop
         Directory.Next_Entry (DCB, DE, Success);
         exit when not Success;
         if DE.Filename = "PROVA02 " and then DE.Extension = "PYC" then
            declare
               F : FCB_Type;
               B : Block_Type (0 .. 511);
               C : Unsigned_16;
            begin
               Console.Print ("Loading PROVA02.PYC ...", NL => True);
               Rawfile.Open (F, DE, Success);
               if Success then
                  Rawfile.Read (F, B, C, Success);
                  Console.Print (C, Prefix => "Size: ", NL => True);
                  Memory_Functions.Cpymem (B'Address, Destination_Address, Bytesize (C));
               end if;
            end;
         end if;
      end loop;
   end Load_PROVA02PYC;

end FATFS.Applications;
