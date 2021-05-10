File breakdown:\
blow_dec.vhd - Top level struct instantiating Blowfish encryption/decryption loop with sub-key generation\
BlowfisHeader2.vhd -Header file containing inital values for the P-box and 4X S-box's\
Enctb.vhd - Testbench for blow_dec, testing different sets of data for encryption/decryption

Operation steps:\
First reset the device by setting synchronous active-low reset signal reset_n to '0' for at least 1 clock cycle.\
Key length is selected using input key_sel, setting to 00 for 128, 01 for 192 or 10 for 256 bit keys.

Key input:
1. Begin inputting 128-bit key by setting input plain_read to '1' and key to the most significant 32 bits of the key.
2. Repeat on subsequent clock cycles with the next most significant 32 bits of the key.
3. After all 128 bits have been input set key back to 0 and plain_read to '0', triggering the beginning of key expansion.

Data input:
1. Begin inputting data by setting plain_in signal to all 64 bits of the input data.
3. Leave the data value for the total encryption/decryption process and change the value once complete.

Data encryption/decryption:
1. Once key and data have been entered the encryption/decryption will begin.
2. Wait for the output signal cipher_ready to be set to '1', indicating the completion of data encryption.
4. Ciphertext output will begin with the full 64 bits on output signal cipher_out.

Other notes:

Testbench operation:
The provided testbench tests the Blowfish implementation by encrypting several blocks of data with different keys and decrypting these blocks with the same keys,
ensuring that the result matches the initial plaintext input. By adjusting signals such key and key_sel more test vectors can be added to the testbench
to test different scenarios.

Hardware implementation:
According to Quartus Prime analysis tools, maximum achievable frequency for the design is 63.65 MHz using a worst-case four corner analysis.
The design also uses 29,734 ALMs (adaptive logic modules), 35,343 registers representing approximately 26% of the available resources
on the Cyclone V 5CEBA9F31C8 FPGA on the ARM MPS2+ board.
