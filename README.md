# VHDLBlowfishProject

Files
-------------
**Blowfish_C** - C implementation of Blowfish as reference\
**Blowfish_BRAM** - Blowfish implementation with BRAM\
**Final** - contains the Blowfish Algorithm implementation without BRAM\


Structure
------------
|--Blowfish_C\
|&nbsp
|--README.txt\
|   |   |--C implementation of Blowfish used to verify results\
|   |--Pi_create.c\
|   |--blowfish.c\
|   |--blowfish.h\
|   |--blowfish_test.c\
|--Blowfish_BRAM\
|   |--blowfish_top.vhd\
|   |--bram_key.vhd\
|   |--bram_p.vhd\
|   |--bram_s0.vhd\
|   |--bram_s1.vhd\
|   |--bram_s2.vhd\
|   |--bram_s3.vhd\
|   |--sim.do\
|   |--tb.vhd\
|   |--uart.vhd\
|   |--uart_crypt_blow.vhd\
|   |--uart_crypt_blow_tb.vhd\
|   |--wavev1.do\
|--Final\
|   |--Blow_dec.vhd\
|   |--BlowfishHeader2.vhd\
|   |--ENCtb.vhd\
|   |--uart.vhd\
|   |--uart_crypt_blow.vhd\
|   |--uart_crypt_blow_tb.vhd\

