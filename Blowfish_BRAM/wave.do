onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/DUT/reset_n
add wave -noupdate /tb/DUT/clk
add wave -noupdate /tb/DUT/encryption
add wave -noupdate /tb/DUT/key_length
add wave -noupdate /tb/DUT/key_valid
add wave -noupdate -radix hexadecimal /tb/DUT/key_word_in
add wave -noupdate /tb/DUT/crypt_busy_out
add wave -noupdate /tb/DUT/data_valid
add wave -noupdate -radix hexadecimal /tb/DUT/data_word_in
add wave -noupdate -radix hexadecimal /tb/DUT/ciphertext_word_out
add wave -noupdate /tb/DUT/ciphertext_ready
add wave -noupdate -color Cyan -radix hexadecimal -radixshowbase 0 /tb/data_bkp
add wave -noupdate -divider {Internal Signals}
add wave -noupdate -color Cyan /tb/DUT/st
add wave -noupdate -color Cyan -radix unsigned /tb/DUT/st_cnt
add wave -noupdate -color Cyan -radix unsigned /tb/DUT/st_stage
add wave -noupdate -color Orange -radix unsigned /tb/DUT/counter
add wave -noupdate -color Orange -radix unsigned /tb/DUT/counterd
add wave -noupdate -color Orange -radix unsigned /tb/DUT/max_keys
add wave -noupdate -color Orange -radix unsigned /tb/DUT/key_cnt
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb/DUT/data_rp
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb/DUT/data_lp
add wave -noupdate -color {Medium Orchid} -radix hexadecimal -radixshowbase 0 /tb/DUT/ciphertext_word_low
add wave -noupdate -color {Medium Orchid} -radix hexadecimal -radixshowbase 0 /tb/DUT/ciphertext_word_high
add wave -noupdate -color {Medium Orchid} /tb/DUT/bram_cleaned
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb/DUT/bram_addr
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb/DUT/ss1
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb/DUT/ss2
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb/DUT/sout1
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb/DUT/sout2
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb/DUT/s_sout1
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb/DUT/s_sout2
add wave -noupdate -color {Medium Orchid} -radix hexadecimal -childformat {{/tb/DUT/p_data_ram(0) -radix hexadecimal} {/tb/DUT/p_data_ram(1) -radix hexadecimal} {/tb/DUT/p_data_ram(2) -radix hexadecimal} {/tb/DUT/p_data_ram(3) -radix hexadecimal} {/tb/DUT/p_data_ram(4) -radix hexadecimal} {/tb/DUT/p_data_ram(5) -radix hexadecimal} {/tb/DUT/p_data_ram(6) -radix hexadecimal} {/tb/DUT/p_data_ram(7) -radix hexadecimal} {/tb/DUT/p_data_ram(8) -radix hexadecimal} {/tb/DUT/p_data_ram(9) -radix hexadecimal} {/tb/DUT/p_data_ram(10) -radix hexadecimal} {/tb/DUT/p_data_ram(11) -radix hexadecimal} {/tb/DUT/p_data_ram(12) -radix hexadecimal} {/tb/DUT/p_data_ram(13) -radix hexadecimal} {/tb/DUT/p_data_ram(14) -radix hexadecimal} {/tb/DUT/p_data_ram(15) -radix hexadecimal} {/tb/DUT/p_data_ram(16) -radix hexadecimal} {/tb/DUT/p_data_ram(17) -radix hexadecimal}} -subitemconfig {/tb/DUT/p_data_ram(0) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(1) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(2) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(3) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(4) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(5) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(6) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(7) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(8) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(9) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(10) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(11) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(12) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(13) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(14) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(15) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(16) {-color {Medium Orchid} -height 17 -radix hexadecimal} /tb/DUT/p_data_ram(17) {-color {Medium Orchid} -height 17 -radix hexadecimal}} /tb/DUT/p_data_ram
add wave -noupdate -color {Medium Orchid} -radix hexadecimal -childformat {{/tb/DUT/key_addr(2) -radix unsigned} {/tb/DUT/key_addr(1) -radix unsigned} {/tb/DUT/key_addr(0) -radix unsigned}} -radixshowbase 0 -subitemconfig {/tb/DUT/key_addr(2) {-color {Medium Orchid} -radix unsigned -radixshowbase 0} /tb/DUT/key_addr(1) {-color {Medium Orchid} -radix unsigned -radixshowbase 0} /tb/DUT/key_addr(0) {-color {Medium Orchid} -radix unsigned -radixshowbase 0}} /tb/DUT/key_addr
add wave -noupdate -color {Medium Orchid} -radix hexadecimal -childformat {{/tb/DUT/key_data_o(31) -radix hexadecimal} {/tb/DUT/key_data_o(30) -radix hexadecimal} {/tb/DUT/key_data_o(29) -radix hexadecimal} {/tb/DUT/key_data_o(28) -radix hexadecimal} {/tb/DUT/key_data_o(27) -radix hexadecimal} {/tb/DUT/key_data_o(26) -radix hexadecimal} {/tb/DUT/key_data_o(25) -radix hexadecimal} {/tb/DUT/key_data_o(24) -radix hexadecimal} {/tb/DUT/key_data_o(23) -radix hexadecimal} {/tb/DUT/key_data_o(22) -radix hexadecimal} {/tb/DUT/key_data_o(21) -radix hexadecimal} {/tb/DUT/key_data_o(20) -radix hexadecimal} {/tb/DUT/key_data_o(19) -radix hexadecimal} {/tb/DUT/key_data_o(18) -radix hexadecimal} {/tb/DUT/key_data_o(17) -radix hexadecimal} {/tb/DUT/key_data_o(16) -radix hexadecimal} {/tb/DUT/key_data_o(15) -radix hexadecimal} {/tb/DUT/key_data_o(14) -radix hexadecimal} {/tb/DUT/key_data_o(13) -radix hexadecimal} {/tb/DUT/key_data_o(12) -radix hexadecimal} {/tb/DUT/key_data_o(11) -radix hexadecimal} {/tb/DUT/key_data_o(10) -radix hexadecimal} {/tb/DUT/key_data_o(9) -radix hexadecimal} {/tb/DUT/key_data_o(8) -radix hexadecimal} {/tb/DUT/key_data_o(7) -radix hexadecimal} {/tb/DUT/key_data_o(6) -radix hexadecimal} {/tb/DUT/key_data_o(5) -radix hexadecimal} {/tb/DUT/key_data_o(4) -radix hexadecimal} {/tb/DUT/key_data_o(3) -radix hexadecimal} {/tb/DUT/key_data_o(2) -radix hexadecimal} {/tb/DUT/key_data_o(1) -radix hexadecimal} {/tb/DUT/key_data_o(0) -radix hexadecimal}} -radixshowbase 0 -subitemconfig {/tb/DUT/key_data_o(31) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(30) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(29) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(28) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(27) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(26) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(25) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(24) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(23) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(22) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(21) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(20) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(19) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(18) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(17) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(16) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(15) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(14) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(13) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(12) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(11) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(10) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(9) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(8) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(7) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(6) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(5) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(4) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(3) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(2) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(1) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0} /tb/DUT/key_data_o(0) {-color {Medium Orchid} -height 17 -radix hexadecimal -radixshowbase 0}} /tb/DUT/key_data_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1448170 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1575 us}
