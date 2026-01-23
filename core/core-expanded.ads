-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ core-expanded.ads                                                                                         --
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

with System;

package Core.Expanded
   with Preelaborate => True,
        SPARK_Mode   => On
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   Main_Priority : Integer
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_main_priority";

   Time_Slice_Val : Integer
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_time_slice_val";

   WC_Encoding : Character
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_wc_encoding";

   Locking_Policy : Character
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_locking_policy";

   Queuing_Policy : Character
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_queuing_policy";

   Task_Dispatching_Policy : Character
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_task_dispatching_policy";

   Priority_Specific_Dispatching : System.Address
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_priority_specific_dispatching";

   Num_Specific_Dispatching : Integer
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_num_specific_dispatching";

   Main_CPU : Integer
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_main_cpu";

   Interrupt_States : System.Address
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_interrupt_states";

   Num_Interrupt_States : Integer
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_num_interrupt_states";

   Unreserve_All_Interrupts : Integer
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_unreserve_all_interrupts";

   Detect_Blocking : Integer
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_detect_blocking";

   Bind_Env_Addr : System.Address
      with Export        => True,
           Convention    => C,
           External_Name => "__gl_bind_env_addr";

   procedure Runtime_Initialize
      (Install_Handler : in Integer)
      with Export        => True,
           Convention    => C,
           External_Name => "__gnat_runtime_initialize";

end Core.Expanded;
