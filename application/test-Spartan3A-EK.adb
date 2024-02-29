
with CPU;
with Spartan3A;

package body Application
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   LEDOFF renames False;
   LEDON  renames True;

   -- LED D5 = D14 fpga_0_LEDs_4Bit_GPIO_d_out_pin<0> IO_L23N_1/A23
   -- LED D4 = C16 fpga_0_LEDs_4Bit_GPIO_d_out_pin<1> IO_L24P_1/A24
   -- LED D3 = C15 fpga_0_LEDs_4Bit_GPIO_d_out_pin<2> IO_L24N_1/A25
   -- LED D2 = B15 fpga_0_LEDs_4Bit_GPIO_d_out_pin<3> IO_L02P_0/VREF_0
   -- the GPIO port is 4-bit wide (C_GPIO_WIDTH = 4), aligned to the LSb
   -- far-end and with a BIG-endian numbering, so alias this layout with those
   -- bit indexes:
   LEDD5 : constant := 28;
   LEDD4 : constant := 29;
   LEDD3 : constant := 30;
   LEDD2 : constant := 31;

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run
      is
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 1_000_000;
         begin
            Spartan3A.LEDs.GPIO_TRI := [others => False];
            loop
               for LED in LEDD5 .. LEDD2 loop
                  Spartan3A.LEDs.GPIO_DATA (LED) := LEDON;
                  for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
                  Spartan3A.LEDs.GPIO_DATA (LED) := LEDOFF;
               end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
