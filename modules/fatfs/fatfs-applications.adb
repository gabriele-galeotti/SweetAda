-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-applications.adb                                                                                    --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with FATFS.Directory;
with FATFS.Rawfile;
with FATFS.Textfile;
with Console;

package body FATFS.Applications
   is

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
   procedure Test
      (D : in Descriptor_Type)
      is
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
      Directory.Open_Root (D, DCB, Success);
      if Success then
         Directory.Get_Entry (D, DCB, DE, Success);
         if Success then
            Print_File_Name (DE);
         end if;
         -------------------------------------------
         loop
            Directory.Next_Entry (D, DCB, DE, Success);
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
   procedure Load_AUTOEXECBAT
      (D : in Descriptor_Type)
      is
      DCB     : DCB_Type;
      DE      : Directory_Entry_Type;
      Success : Boolean;
   begin
      Directory.Open_Root (D, DCB, Success);
      if not Success then
         return;
      end if;
      loop
         Directory.Next_Entry (D, DCB, DE, Success);
         exit when not Success;
         if DE.Filename = "AUTOEXEC" and then DE.Extension = "BAT" then
            declare
               F    : TFCB_Type;
               L    : Natural;
               Line : String (1 .. 80);
            begin
               Console.Print ("Loading AUTOEXEC.BAT ...", NL => True);
               Textfile.Open (D, F, DE, Success);
               if Success then
                  Line := [others => ' '];
                  Textfile.Read_Line (D, F, Line, L, Success);
                  Console.Print (Line);
                  Console.Print_NewLine;
                  Line := [others => ' '];
                  Textfile.Read_Line (D, F, Line, L, Success);
                  Console.Print (Line);
                  Console.Print_NewLine;
                  Line := [others => ' '];
                  Textfile.Read_Line (D, F, Line, L, Success);
                  Console.Print (Line);
                  Console.Print_NewLine;
               end if;
            end;
         end if;
      end loop;
   end Load_AUTOEXECBAT;

end FATFS.Applications;
