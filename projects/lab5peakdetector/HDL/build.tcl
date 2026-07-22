puts "SciCompiler: Starting vivado builder"



set script_path [ file dirname [ file normalize [ info script ] ] ]
set outputDir $script_path/vivado
set artDir $script_path/output
file mkdir $outputDir
file mkdir $artDir

set outfile1 [open "${artDir}/content.xml" w+]   

puts $outfile1 "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
puts $outfile1 "<OPENHARDWARE>"
puts $outfile1 "   <SUPPORTED_PLATFORM>"
puts $outfile1 "       <GUID0>36F7FF8D-4166-4517-81D2-60182B95C7C3</GUID0>"
puts $outfile1 "       <MODEL>A</MODEL>"
puts $outfile1 "   </SUPPORTED_PLATFORM>"
puts $outfile1 "   <FPGA>"
puts $outfile1 "       <version>2026.7.22.5</version>"
puts $outfile1 "       <filename>top_lab5peakdetector.bin</filename>"
puts $outfile1 "   </FPGA>"
puts $outfile1 "   <HWJSON>"
puts $outfile1 "       <filename>RegisterFile.json</filename>"
puts $outfile1 "   </HWJSON>"
puts $outfile1 "</OPENHARDWARE>"

close $outfile1


create_project lab5peakdetector $outputDir -part XC7S25CSGA225-1 -force
set_property source_mgmt_mode None [current_project]
set_property target_language VHDL [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY XPM_FIFO} [current_project]



add_files -force ./pcores/clk_125MHZ.xci
add_files -force ./pcores/FTDI_FIFOs.xcix
add_files -force ./pcores/main_clk_gen.xci
add_files -force ./subpage_subdesign_1.vhd
add_files -force ./top_lab5peakdetector.vhd
add_files -force ./pcores/arbiter_round_robbins_fifop.vhd
add_files -force ./pcores/BASELINE_RESTORERp.vhd
add_files -force ./pcores/BinaryToInteger.vhd
add_files -force ./pcores/ftdi245.vhd
add_files -force ./pcores/ftdi245_cdc.vhd
add_files -force ./pcores/i2c_master_scidk_config.vhd
add_files -force ./pcores/ICAPDNA.vhd
add_files -force ./pcores/listmodule.vhd
add_files -force ./pcores/md5.vhd
add_files -force ./pcores/PK_STRETCHERp.vhd
add_files -force ./pcores/scidk_internal_i2c_manager.vhd
add_files -force ./pcores/security.vhd
add_files -force ./pcores/spi93lc56_16bit.vhd
add_files -force ./pcores/subdesign_1_pmc.vhd
add_files -force ./pcores/subtractor.vhd
add_files -force ./pcores/SYNC_DELAYp.vhd
add_files -force ./pcores/SYNC_FIX_DELAYp.vhd
add_files -force ./pcores/TimestampGenerator.vhd
add_files -force ./pcores/trigger_le_delta.vhd
add_files -force ./pcores/xlx_oscilloscope_sync.vhd
add_files -force ./pcores/xlx_spectrum.vhd
add_files -force -fileset constrs_1 ./SCIDK_constraints.xdc
import_files -force -norecurse
import_files -fileset constrs_1 -force -norecurse ./SCIDK_constraints.xdc


foreach ip [get_ips] {
    upgrade_ip [get_ips $ip]
    set ip_filename [get_property IP_FILE $ip]
    set ip_dcp [file rootname $ip_filename]
    append ip_dcp ".dcp"
    set ip_xml [file rootname $ip_filename]
    append ip_xml ".xml"
    if {([file exists $ip_dcp] == 0) || [expr {[file mtime $ip_filename ] > [file mtime $ip_dcp ]}]} {
        reset_target all $ip
        file delete $ip_xml
        generate_target all $ip
        synth_ip $ip
    }
}

update_ip_catalog -rebuild



set_property Top top_lab5peakdetector [current_fileset]

set obj [get_runs impl_1]
set obj_s [get_runs synth_1]
set_property -name "steps.write_bitstream.args.bin_file" -value "1" -objects $obj



if {[catch {
launch_runs synth_1 -jobs 32
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 32
wait_on_run impl_1
} errorstring]} {
Error "ABBA: $errorstring "
exit
}

set_property source_mgmt_mode All [current_project]
set utilisation_file $outputDir/report.csv
if {[catch {
tclapp::install designutils -quiet
namespace import ::tclapp::xilinx::designutils::report_failfast
open_run [current_run -implementation -quiet]
report_failfast -csv -transpose -file ${utilisation_file}
} errorstring]} {
}
file copy -force ${utilisation_file} $artDir/report.csv

file copy -force $outputDir/lab5peakdetector.runs/impl_1/top_lab5peakdetector.bin $artDir/top_lab5peakdetector.bin
file copy -force $script_path/RegisterFile.json $artDir/RegisterFile.json

if { [catch { exec rm $artDir/lab5peakdetector.niu  } msg] } {
puts "No niu file present to be deleted"
}

exec zip -j $artDir/lab5peakdetector.niu $artDir/RegisterFile.json $artDir/top_lab5peakdetector.bin $artDir/content.xml



exit





