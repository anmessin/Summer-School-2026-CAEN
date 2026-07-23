set proj_dir "."
set ip_name "mcahp_test_KHCTRIYF"
set source_name "mcahp_test.cpp"
set top_func "HLSDPP"
set part_name "xc7s25csga225-1"
set ip_clock_period "15"

# Change to the directory where the TCL script resides
set script_dir [file dirname [info script]]
set proj_dir [file normalize [file join $script_dir ../..]]

if {[file exists "$ip_name/"]} {
    file delete -force "$ip_name/"
}

# Apro il progetto
#puts "Opening $ip_name project..."
cd $proj_dir/HLS/
open_project $ip_name

# Aggiungo il file sorgente
add_files $proj_dir/HLS/$ip_name/$source_name

# Apro la solution
open_solution "solution1"

# Setto il Board ID
set_part $part_name

# Setto il Clock period
create_clock -period $ip_clock_period -name default

# Rinomino il nome della funzione per non creare sovrapposizioni nel top
set_directive_top -name $ip_name $top_func

# Set della funzione top 
set_top $ip_name

# Lancio la sintesi del C/C++
puts "Running C Synthesis..."
csynth_design

# Esporto il file DCP
#puts "Exporting DCP file..."
#export_design -flow syn -rtl vhdl -format syn_dcp

#Copying dcp file
#puts "Checkpoint file available in $proj_dir/HDL/pcores/$ip_name.dcp"
# file copy "$proj_dir/HLS/$ip_name/solution1/impl/vhdl/project.runs/synth_1/$ip_name.dcp" "$proj_dir/HDL/pcores/$ip_name.dcp"

# Define file paths
#set synth_path "$proj_dir/HLS/$ip_name/solution1/impl/vhdl/project.runs/synth_1/$ip_name.dcp"
set vhdloutput_path "$proj_dir/HLS/$ip_name/solution1/syn/vhdl/"
set destination_path "$proj_dir/HDL/pcores/"


if {[file exists $vhdloutput_path]} {
    puts "DCP not found. Merging all VHDL files from $vhdloutput_path into $destination_path..."

    # Create the destination folder if it doesn't exist
    file mkdir [file dirname $destination_path]

    # Open the destination file for writing
    set output_file [open $destination_path/$ip_name.vhd "w"]

    # Get all VHDL files from the fallback path
    foreach file_path [glob -directory $vhdloutput_path *.vhdl *.vhd] {
        # Read each file and append its content to the output file
        set input_file [open $file_path "r"]
        set content [read $input_file]
        close $input_file

        # Write content to the output file
        puts $output_file $content
        puts $output_file "\n" ;# Add a newline between files
    }

    # Close the output file
    close $output_file

    puts "Merged VHDL files written to: $destination_path"
} else {
    puts "Error: Ip code has not been generated."
    exit 1
}


puts "Files in destination path:"
puts [glob -directory $destination_path *.*]
exit