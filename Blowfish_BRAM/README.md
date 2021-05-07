File breakdown:\
blowfish_top.vhd - Top level struct instantiating Blowfish encryption/decryption loop with sub-key generation\
bram_key.vhd - BRAM Component to store input key values\
bram_p.vhd - BRAM Component to store initial values and new values for P-Box \
bram_s0.vhd - BRAM Component to store initial values and new values for S-Box 0\
bram_s1.vhd - BRAM Component to store initial values and new values for S-Box 1\
bram_s2.vhd - BRAM Component to store initial values and new values for S-Box 2\
bram_s3.vhd - BRAM Component to store initial values and new values for S-Box 3\
tb.vhd - Testbench for blowfish_top, testing different sets of data for encryption/decryption

Operation steps:\
First reset the device by setting synchronous active-low reset signal reset_n to '0' for at least 1 clock cycle.\
Key length is selected using input key_length, setting to 00 for 128, 01 for 192 or 10 for 256 bit keys.

Key input:
1. Begin inputting 128-bit key by setting input key_valid to '1' and key_word_in to the most significant 32 bits of the key.
2. Repeat on subsequent clock cycles with the next most significant 32 bits of the key.
3. After all 128 bits have been input set key_word_in back to 0 and key_valid to '0', triggering the beginning of key expansion.
4. Wait for the output signal key_ready to be set to '1', indicating completion of key expansion.

Data input:
1. Begin inputting data by setting input data_valid to '1' and data_word_in to the most significant 32 bits of the data.
2. Repeat on subsequent clock cycles with the next most significant 32 bits of the key.
3. After all 64 bits have been input set data_word_in back to 0 and key_valid to '0', triggering the beginning of the encryption/decryption.

Data encryption/decryption:
1. Once key and data have been entered the encryption/decryption will begin.
2. Wait for the output signal cipher_ready to be set to '1', indicating the completion of data encryption.
4. Ciphertext output will begin 32 bits at a time, most significant 32 bits first, on output signal cipher_out.

Other notes:

Testbench operation:
The provided testbench tests the Blowfish implementation by encrypting several blocks of data with different keys and decrypting these blocks with the same keys,
ensuring that the result matches the initial plaintext input. By adjusting signals such key_word_in and key_length more test vectors can be added to the testbench
to test different scenarios.

Hardware implementation:
According to Quartus Prime analysis tools, maximum achievable frequency for the design is 52.93 MHz using a worst-case four corner analysis.
The design also uses 2,806 ALMs (adaptive logic modules), 3,113 registers and 32,768 BRAM bits, representing approximately 3% of the available resources
on the Cyclone V 5CEBA9F31C8 FPGA on the ARM MPS2+ board.
