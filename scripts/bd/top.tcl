################################################################
# CREATE BLOCK DESIGN
################################################################
create_bd_design -dir $bdDir top

################################################################
# DESIGN PROCEDURES
################################################################

################################################################
# EXPORT BLOCK DESIGN
################################################################
create_root_design ""

make_wrapper -top [get_files top.bd]

generate_target {synthesis implementation} [get_files top.bd]
