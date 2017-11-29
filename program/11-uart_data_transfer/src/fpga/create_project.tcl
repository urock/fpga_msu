
set part "xc7z010clg400-1"
set project_name "uart_regs"
set top_entity	$project_name
set top_entity_tb	${project_name}_tb

set orgDir "."
set srcDir	"$orgDir/src"

if {[file exists $srcDir]} {
   set srcDir [file normalize $srcDir]
   puts "Source Dir:\t $srcDir"
} else {
   error "ERROR: No valid location found for required Src Dir"
}


# create source files list
set src_files [list \
	"$srcDir/counter_mod_m.vhd"\
	"$srcDir/debounce.vhd"\
	"$srcDir/protocol_stm.vhd"\
	"$srcDir/regs.vhd"\
	"$srcDir/uart_loopback_top.vhd"\
	"$srcDir/uart_regs_top.vhd"\
	"$srcDir/uart_rx.vhd"\
	"$srcDir/uart_top.vhd"\
	"$srcDir/uart_tx.vhd"\
	"$srcDir/user.vhd"\
]


# create testbench files list
set tb_files [list \
 ]

# create xdc files list
set xdc_files [list \
	"$srcDir/top.xdc"\
]

set ip_list [list \
	"$srcDir/uart_fifo"\
]





# Create project
create_project -force $project_name ./$project_name

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects $project_name]
set_property "default_lib" "xil_defaultlib" $obj
set_property "part" $part $obj
set_property "sim.ip.auto_export_scripts" "1" $obj
set_property "simulator_language" "Mixed" $obj
set_property target_language VHDL [current_project]

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set file_set [get_filesets sources_1]
add_files -norecurse -fileset $file_set $src_files


foreach f $src_files {
	puts -nonewline "$f"
	if [regexp {.*\.vhd$} $f tmp ] {
	
		puts "\t\t is VHD file"
		set file_obj [get_files -of_objects $file_set [list "*$f"]]
		set_property "file_type" "VHDL" $file_obj
	
	} elseif [regexp {.*\.v$} $f tmp ] {
		puts "\t\t is Verilog file"
	} elseif [regexp {.*\.sv$} $f tmp ] {
		puts "\t\t is System Verilog file"
	}	
}
set_property "top" $top_entity $file_set



if {[llength $xdc_files] > 0} {
	# Create 'constrs_1' fileset (if not found)
	if {[string equal [get_filesets -quiet constrs_1] ""]} {
	  create_fileset -constrset constrs_1
	}


	# Set 'constrs_1' fileset object
	set file_set [get_filesets constrs_1]
	add_files -norecurse -fileset $file_set $xdc_files

	foreach file $xdc_files {
		puts "$file"
		set file_obj [get_files -of_objects $file_set [list "*$file"]]
		set_property "file_type" "XDC" $file_obj	
	}
}


if {[llength $tb_files] > 0} {

	# Create 'sim_1' fileset (if not found)
	if {[string equal [get_filesets -quiet sim_1] ""]} {
	  create_fileset -simset sim_1
	}

	# Set 'sim_1' fileset object
	set file_set [get_filesets sim_1]
	add_files -norecurse -fileset $file_set $tb_files

	foreach f $tb_files {
		puts -nonewline "$f"
		if [regexp {.*\.vhd$} $f tmp ] {
		
			puts "\t\t is VHD file"
			set file_obj [get_files -of_objects $file_set [list "*$f"]]
			set_property "file_type" "VHDL" $file_obj
		
		} elseif [regexp {.*\.v$} $f tmp ] {
			puts "\t\t is Verilog file"
		} elseif [regexp {.*\.sv$} $f tmp ] {
			puts "\t\t is System Verilog file"
		}	

	}




	# Set 'sim_1' fileset file properties for local files
	# None

	# Set 'sim_1' fileset properties
	set obj [get_filesets sim_1]
	set_property "top" $top_entity_tb $obj
	set_property "xelab.nosort" "1" $obj
	set_property "xelab.unifast" "" $obj

}

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
  create_run -name synth_1 -part $part -flow {Vivado Synthesis 2015} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2015" [get_runs synth_1]
}


set obj [get_runs synth_1]
set_property "part" $part $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
  create_run -name impl_1 -part $part -flow {Vivado Implementation 2014} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2015" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property "part" $part $obj

# set the current impl run
current_run -implementation [get_runs impl_1]



foreach ip $ip_list {
	source $ip.tcl
}




puts "INFO: Project created: $project_name"
