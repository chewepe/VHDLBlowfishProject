onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_crypt_blow_tb/clk
add wave -noupdate /uart_crypt_blow_tb/reset_n
add wave -noupdate /uart_crypt_blow_tb/state_led
add wave -noupdate /uart_crypt_blow_tb/DUT/ctrl_state
add wave -noupdate -label key_store -radix hexadecimal /uart_crypt_blow_tb/DUT/key_store
add wave -noupdate -label data_in_store -radix hexadecimal /uart_crypt_blow_tb/DUT/data_in_store
add wave -noupdate -label data_out_store -radix hexadecimal /uart_crypt_blow_tb/DUT/data_out_store
add wave -noupdate /uart_crypt_blow_tb/DUT/blow_inst/clk
add wave -noupdate /uart_crypt_blow_tb/DUT/blow_inst/reset_n
add wave -noupdate /uart_crypt_blow_tb/DUT/blow_inst/encryption
add wave -noupdate /uart_crypt_blow_tb/DUT/blow_inst/key_length
add wave -noupdate /uart_crypt_blow_tb/DUT/blow_inst/key_valid
add wave -noupdate -radix hexadecimal /uart_crypt_blow_tb/DUT/blow_inst/key_word_in
add wave -noupdate /uart_crypt_blow_tb/DUT/blow_inst/data_valid
add wave -noupdate -radix hexadecimal /uart_crypt_blow_tb/DUT/blow_inst/data_word_in
add wave -noupdate /uart_crypt_blow_tb/DUT/blow_inst/crypt_busy_out
add wave -noupdate -radix hexadecimal /uart_crypt_blow_tb/DUT/blow_inst/ciphertext_word_out
add wave -noupdate /uart_crypt_blow_tb/DUT/blow_inst/ciphertext_ready
add wave -noupdate /uart_crypt_blow_tb/DUT/blow_inst/counter
add wave -noupdate /uart_crypt_blow_tb/DUT/enc_dec_in_ctr
add wave -noupdate /uart_crypt_blow_tb/DUT/blow_inst/st
add wave -noupdate -radix unsigned /uart_crypt_blow_tb/DUT/blow_inst/st_cnt
add wave -noupdate -radix unsigned /uart_crypt_blow_tb/DUT/blow_inst/st_stage
add wave -noupdate /uart_crypt_blow_tb/DUT/blow_inst/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37447916427 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {37447884427 ps} {37447948427 ps}
