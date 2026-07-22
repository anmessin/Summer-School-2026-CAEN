file mkdir HDL
file mkdir HDL/pcores

set script_path [ file dirname [ file normalize [ info script ] ] ]


set outputDir $script_path/output_sim
file mkdir $outputDir
file mkdir $script_path/sim_results
create_project lab6simulation $outputDir -part XC7S25CSGA225-1 -force
set_property source_mgmt_mode None [current_project]
set_property target_language VHDL [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY XPM_FIFO} [current_project]
set_property SIMULATOR_LANGUAGE Mixed [current_project]
set_property sim.use_ip_compiled_libs 0 [current_project]






proc merge_vhdl_files {input_folder output_file} {
    set out [open $output_file "w"]
    
    set vhdl_files [glob -nocomplain -directory $input_folder *.{vhd,vhdl}]
    
    if {[llength $vhdl_files] == 0} {
        puts "No vhdl files found in $input_folder"
        close $out
        return
    }

    foreach file $vhdl_files {
        set in [open $file "r"]
        while {[gets $in line] >= 0} {
            puts $out $line
        }
        puts $out "\n"  ;# Aggiunge una nuova riga per separare i file
        close $in
    }
    
    # Chiudi il file di output
    close $out
    
    puts "Files merged in $output_file"
}


add_files -force $script_path/HDL_SIM/top_lab6simulation.vhd
add_files -force $script_path/HDL_SIM/pcores/comparator.vhd
add_files -force $script_path/HDL_SIM/pcores/COUNTER_RISINGp.vhd
import_files -force -norecurse



foreach ip [get_ips] {
	upgrade_ip [get_ips $ip]
}

update_ip_catalog -rebuild



# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Import local files from the original project
set files [list \
"[file normalize "$script_path/SIM_TB/tb_clockgen.vhd"]" \
"[file normalize "$script_path/SIM_TB/tb_lab6simulation.vhd"]" \
"[file normalize "$script_path/SIM_TB/tb_readfile.vhd"]" \
"[file normalize "$script_path/SIM_TB/tb_readfile_tm.vhd"]" \

]
set imported_files [import_files -fileset sim_1 $files]

# Set 'sim_1' fileset file properties for remote files
# None


# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "testbench" -objects $obj
set_property -name "xsim.simulate.runtime" -value "100 us" -objects $obj

file mkdir $outputDir/lab6simulation.sim/sim_1/behav/xsim
file copy -force $script_path/SIM_TB/A0.txt $outputDir/lab6simulation.sim/sim_1/behav/xsim/A0.txt


launch_simulation
restart
open_vcd $script_path/sim_results/xsim_dump.vcd
log_vcd /testbench
run 100 us
close_vcd
stop
file rename -force $outputDir/lab6simulation.sim/sim_1/behav/xsim/compile.log $script_path/sim_results/compile.log
 
