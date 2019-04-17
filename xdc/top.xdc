# False path constraints
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *bit_synchronizer*inst/bit_in_meta_reg}]

set_false_path -to [get_pins -filter {REF_PIN_NAME =~   *D} -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/reset_in_meta* }]]
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ *PRE} -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/reset_in_meta* }]]
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ *PRE} -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/reset_in_sync1*}]]
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ *PRE} -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/reset_in_sync2*}]]
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ *PRE} -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/reset_in_sync3*}]]
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ *PRE} -of_objects [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/reset_in_out*  }]]
