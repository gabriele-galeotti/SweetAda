
with Interfaces;
with TOD;
with Time;
with X3270;

package body Application
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run
      is
      T  : Interfaces.Unsigned_64;
      TM : Time.TM_Time;
   begin
      -------------------------------------------------------------------------
      -- This fragment of code waits for "Attn" to be pressed on the X3270
      -- terminal keypad, then writes a message. Loops over 10 times.
      -------------------------------------------------------------------------
      X3270.Clear_Screen;
      for R in 1 .. 10 loop
         -- X3270.Write_Message ("Welcome to SweetAda S/390 ...", R, 0);
         X3270.Write_Message ("Welcome to SweetAda S/390 ...");
         T := TOD.Read;
         -- X3270.Write_Message (Interfaces.Unsigned_64'Image (T));
         TOD.To_Epoch (T, TM);
         X3270.Write_Message (Natural'Image (Natural (TM.Year) + 1_900));
         X3270.Write_Message (Natural'Image (Natural (TM.Mon) + 1));
         X3270.Write_Message (Natural'Image (Natural (TM.MDay)));
         X3270.Write_Message (Natural'Image (Natural (TM.Hour)));
         X3270.Write_Message (Natural'Image (Natural (TM.Min)));
         X3270.Write_Message (Natural'Image (Natural (TM.Sec)));
      end loop;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
