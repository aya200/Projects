proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir {H:/ENEL 384/Project/project_new/project_new.cache/wt} [current_project]
  set_property parent.project_path {H:/ENEL 384/Project/project_new/project_new.xpr} [current_project]
  set_property ip_output_repo {{H:/ENEL 384/Project/project_new/project_new.cache/ip}} [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  add_files -quiet {{H:/ENEL 384/Project/project_new/project_new.runs/synth_1/project_384.dcp}}
  read_xdc {{I:/ENEL 384/Project/Nexys4 DDR - Documentation and Files-20181126/Vivado_Nexys4DDR_Demo/Vivado_Nexys4DDR_Demo/Nexys4DDR_Master.xdc}}
  link_design -top project_384 -part xc7a100tcsg324-1
  write_hwdef -file project_384.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force project_384_opt.dcp
  report_drc -file project_384_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force project_384_placed.dcp
  report_io -file project_384_io_placed.rpt
  report_utilization -file project_384_utilization_placed.rpt -pb project_384_utilization_placed.pb
  report_control_sets -verbose -file project_384_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force project_384_routed.dcp
  report_drc -file project_384_drc_routed.rpt -pb project_384_drc_routed.pb -rpx project_384_drc_routed.rpx
  report_methodology -file project_384_methodology_drc_routed.rpt -rpx project_384_methodology_drc_routed.rpx
  report_timing_summary -warn_on_violation -max_paths 10 -file project_384_timing_summary_routed.rpt -rpx project_384_timing_summary_routed.rpx
  report_power -file project_384_power_routed.rpt -pb project_384_power_summary_routed.pb -rpx project_384_power_routed.rpx
  report_route_status -file project_384_route_status.rpt -pb project_384_route_status.pb
  report_clock_utilization -file project_384_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force project_384_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force project_384.mmi }
  write_bitstream -force -no_partial_bitfile project_384.bit 
  catch { write_sysdef -hwdef project_384.hwdef -bitfile project_384.bit -meminfo project_384.mmi -file project_384.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

