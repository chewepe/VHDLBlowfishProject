if {[file isdirectory work]} { vdel -all -lib work }
vlib work
vmap work work

vcom -work work bram_key.vhd
vcom -work work bram_p.vhd
vcom -work work bram_s0.vhd
vcom -work work bram_s1.vhd
vcom -work work bram_s2.vhd
vcom -work work bram_s3.vhd
vcom -work work blowfish_top.vhd
vcom -work work tb.vhd

vsim -voptargs=+acc=lprn -t ns work.tb

set StdArithNoWarnings 1
set StdVitalGlitchNoWarnings 1

do wavev1.do 

run 1500 us
