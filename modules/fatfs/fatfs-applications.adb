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
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Print_File_Name
      (F : Directory_Entry_Type);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Print_File_Name
      (F : Directory_Entry_Type)
      is
   begin
      Console.Print (F.File_Name);
      Console.Print (".");
      Console.Print (F.Extension);
      Console.Print ("   ");
      Console.Print (Natural (F.Size));
      Console.Print (" ");
      pragma Style_Checks (Off);
      if F.File_Attributes.Read_Only    then Console.Print ("R"); end if;
      if F.File_Attributes.Hidden_File  then Console.Print ("H"); end if;
      if F.File_Attributes.System_File  then Console.Print ("S"); end if;
      if F.File_Attributes.Subdirectory then Console.Print ("D"); end if;
      if F.File_Attributes.Archive      then Console.Print ("A"); end if;
      pragma Style_Checks (On);
      Console.Print (" ");
      Console.Print (Natural (F.Ctime_YMD.Year) + 1980);
      Console.Print ("-");
      Console.Print (Natural (F.Ctime_YMD.Month));
      Console.Print ("-");
      Console.Print (Natural (F.Ctime_YMD.Day));
      Console.Print (" ");
      Console.Print (Natural (F.Ctime_HMS.Hour));
      Console.Print (":");
      Console.Print (Natural (F.Ctime_HMS.Minute));
      Console.Print (":");
      Console.Print (Natural (F.Ctime_HMS.Second));
      Console.Print_NewLine;
   end Print_File_Name;

   ----------------------------------------------------------------------------
   -- Test
   ----------------------------------------------------------------------------
   procedure Test
      (D : in Descriptor_Type)
      is
      DCB     : DCB_Type;
      DE      : Directory_Entry_Type;
      Success : Boolean;
   begin
      Directory.Open_Root (D, DCB, Success);
      if not Success then
         Console.Print ("*** Error: Open_Root failed.", NL => True);
         return;
      end if;
      Directory.Entry_Get (D, DCB, DE, Success);
      loop
         exit when not Success;
         Print_File_Name (DE);
         Directory.Entry_Next (D, DCB, DE, Success);
      end loop;
      Directory.Close (DCB);
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
         Console.Print ("*** Error: Open_Root failed.", NL => True);
         return;
      end if;
      Directory.Entry_Get (D, DCB, DE, Success);
      loop
         exit when not Success;
         if DE.File_Name = "AUTOEXEC" and then DE.Extension = "BAT" then
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
            return;
         else
            Directory.Entry_Next (D, DCB, DE, Success);
            exit when not Success;
         end if;
      end loop;
      Directory.Close (DCB);
   end Load_AUTOEXECBAT;

end FATFS.Applications;
