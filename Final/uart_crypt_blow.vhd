-- FILE NAME : uart_crypt_blow.vhd
-- STATUS    : Cryptography wrapper for BLOWFISH with UART interface.
-- AUTHORS   : Jack Sampford/Chewepe Tsate
-- E-mail    : j.sampford@hotmail.co.uk/chewepe@hotmail.co.uk
--------------------------------------------------------------------------------
-- RELEASE HISTORY
-- VERSION   DATE         DESCRIPTION
-- 1.0       2020-10-30   Initial version
-- 2.0		 2021-03-22	  Modified for Blowfish version
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY uart_crypt_blow_2 IS
    PORT (
        clk       : IN  STD_LOGIC;
        reset_n   : IN  STD_LOGIC;
        uart_rx   : IN  STD_LOGIC;
        state_led : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        uart_tx   : OUT STD_LOGIC
    );
END ENTITY uart_crypt_blow_2;

ARCHITECTURE rtl OF uart_crypt_blow_2 IS

    -- Constants for Digi-Key UART component
    -- Clock speed is undivided OSC[2] board input, which gives perfect baud rate divisions
    CONSTANT clk_freq  : INTEGER   := 24_576_666;
    CONSTANT baud_rate : INTEGER   := 9600;
    CONSTANT os_rate   : INTEGER   := 256;
    CONSTANT d_width   : INTEGER   := 8;
    CONSTANT parity    : INTEGER   := 0;
    CONSTANT parity_eo : STD_LOGIC := '0';

    COMPONENT uart IS
        GENERIC (
            clk_freq  : INTEGER;
            baud_rate : INTEGER;
            os_rate   : INTEGER;
            d_width   : INTEGER;
            parity    : INTEGER;
            parity_eo : STD_LOGIC
        );
        PORT (
            clk      : IN  STD_LOGIC;
            reset_n  : IN  STD_LOGIC;
            tx_ena   : IN  STD_LOGIC;
            tx_data  : IN  STD_LOGIC_VECTOR(d_width - 1 DOWNTO 0);
            rx       : IN  STD_LOGIC;
            rx_busy  : OUT STD_LOGIC;
            rx_error : OUT STD_LOGIC;
            rx_data  : OUT STD_LOGIC_VECTOR(d_width - 1 DOWNTO 0);
            tx_busy  : OUT STD_LOGIC;
            tx       : OUT STD_LOGIC
        );
    END COMPONENT uart;

    COMPONENT Blow_dec IS
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           key : in STD_LOGIC_VECTOR(31 downto 0);
		   Enc_sel : in STD_LOGIC;--0 for encrypt, 1 for decrypt
		   key_sel : in STD_LOGIC_VECTOR(1 downto 0);-- 00 for 128bit, 01 for 192bit, 10 for 256bit & 11bit default 128bit key 
           plain_in : in STD_LOGIC_VECTOR(63 downto 0);
           plain_read : in STD_LOGIC;
		   key_ready : out STD_LOGIC;
           cipher_out : out STD_LOGIC_VECTOR(63 downto 0);
           cipher_ready : out STD_LOGIC
		);
    END COMPONENT Blow_dec;

    -- Signals for interface with UART component
    SIGNAL tx_ena              : STD_LOGIC;
    SIGNAL tx_data             : STD_LOGIC_VECTOR(d_width - 1 DOWNTO 0);
    SIGNAL rx_busy             : STD_LOGIC;
    SIGNAL rx_error            : STD_LOGIC;
    SIGNAL rx_data             : STD_LOGIC_VECTOR(d_width - 1 DOWNTO 0);
    SIGNAL tx_busy             : STD_LOGIC;

    -- Signals for interface with BLOWFISH component
    SIGNAL data_word_in        : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL data_valid          : STD_LOGIC;
    SIGNAL key_length          : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL key_word_in         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL key_word_in_d       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL key_ready           : STD_LOGIC;
    SIGNAL data_word_out       : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL data_ready          : STD_LOGIC;

    -- State register signal
    TYPE ctrl_state_t IS (waiting, key_in, data_in, tx_error, tx_success, enc_dec, tx_block);
    SIGNAL ctrl_state          : ctrl_state_t;

    -- FSM internal control/data signals
    SIGNAL encryption          : STD_LOGIC;
    SIGNAL rx_busy_d           : STD_LOGIC;
    SIGNAL key_byte_cnt        : INTEGER RANGE 0 TO 31;
    SIGNAL key_stored          : STD_LOGIC;
    SIGNAL data_byte_cnt       : INTEGER RANGE 0 TO 7;
    SIGNAL new_data            : STD_LOGIC;
    SIGNAL key_write_done      : STD_LOGIC;
    SIGNAL key_in_ctr          : INTEGER RANGE 0 TO 7;
    SIGNAL key_store           : STD_LOGIC_VECTOR(255 DOWNTO 0);
	SIGNAL enc_dec_key_ctr     : INTEGER RANGE 0 TO 7;
    SIGNAL data_in_store       : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL data_out_store      : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL enc_dec_in_done     : STD_LOGIC;
    SIGNAL tx_byte_cnt         : INTEGER RANGE 0 TO 15;
	SIGNAL send_data_flag	   : STD_LOGIC;

BEGIN

    -- Instantiation of UART component
    uart_inst : uart
    GENERIC MAP (
        clk_freq  => clk_freq,
        baud_rate => baud_rate,
        os_rate   => os_rate,
        d_width   => d_width,
        parity    => parity,
        parity_eo => parity_eo
    )
    PORT MAP (
        clk      => clk,
        reset_n  => reset_n,
        tx_ena   => tx_ena,
        tx_data  => tx_data,
        rx       => uart_rx,
        rx_busy  => rx_busy,
        rx_error => rx_error,
        rx_data  => rx_data,
        tx_busy  => tx_busy,
        tx       => uart_tx
    );

    -- Instantiation of BLOWFISH component
    blowfish_inst : Blow_dec
    PORT MAP (
        clk                 => clk,
        rst		            => reset_n,
        key             	=> key_word_in,
		Enc_sel				=> encryption,
		key_sel				=> key_length,
        plain_in       		=> data_word_in,
        plain_read          => data_valid,
		key_ready           => key_ready,
        cipher_out       	=> data_word_out,
        cipher_ready        => data_ready
    );

    -- Control the reading/writing of data to/from the encryption core
    -- UART messages are 8 bit, being either control or data messages
    -- Control messages will only be interpreted whilst in waiting state (before/after encryption)
    -- Valid control messages to input are:
    -- 00000001 : Set mode to encryption
    -- 00000010 : Set mode to decryption
    -- 00000100 : Set key size to BLOWFISH-128
    -- 00001000 : Set key size to BLOWFISH-192
    -- 00010000 : Set key size to BLOWFISH-256
    -- 00100000 : Enter new encryption key, followed by 16-32 data messages consisting of new key
    -- 01000000 : Enter new data for encryption/decryption, followed by 16 data messages consisting of data block
    -- Valid control messages received on output are:
    -- 10000000 : Confirm receipt of data/key or key expansion completion
    -- 11111111 : Indicate error in received data
    -- Sequence is:
    -- Restart into waiting state
    -- (Optional) Set mode, default is encryption
    -- (Optional) Set encryption key size, default is BLOWFISH-128
    -- Set encryption key
    -- Await confirmation of receipt and key expansion completion
    -- Enter data for encryption
    -- Await confirmation of receipt
    -- Read encrypted/decrypted output
    -- (Optional) Set mode, previous mode will be retained
    -- (Optional) Set key size, previous key size will be retained
    -- (Optional) Set key, previous key will be retained
    -- Enter new data for encryption/decryption
    -- Etc.
    ctrl_fsm : PROCESS(clk) IS
    BEGIN
        IF RISING_EDGE(clk) THEN
            IF reset_n = '0' THEN
                tx_ena             <= '0';
                tx_data            <= (OTHERS => '0');
                encryption         <= '1';
                data_valid         <= '0';
                data_word_in       <= (OTHERS => '0');
                key_length         <= (OTHERS => '0');
                key_word_in        <= (OTHERS => '0');
                ctrl_state         <= waiting;
                rx_busy_d          <= '0';
                key_byte_cnt       <= 15;
                key_stored         <= '0';
                key_in_ctr         <= 3;
                data_byte_cnt      <= 7;
                new_data           <= '0';
                key_store          <= (OTHERS => '0');
                data_in_store      <= (OTHERS => '0');
                data_out_store     <= (OTHERS => '0');
                enc_dec_in_done    <= '0';
				send_data_flag	   <= '0';
                tx_byte_cnt        <= 7;
            ELSE
                -- Create delayed version of rx_busy flag to detect falling edge indicating new data
                rx_busy_d <= rx_busy;
                CASE ctrl_state IS
                    WHEN waiting =>
                        -- Check for new data
                        IF rx_busy = '0' AND rx_busy_d = '1' THEN
                            -- Check for error
                            IF rx_error = '0' THEN
                                -- Interpret received message
                                CASE rx_data IS
                                    WHEN "00000001" =>
                                        -- Select encryption
                                        encryption <= '0';
                                        ctrl_state <= waiting;
                                    WHEN "00000010" =>
                                        -- Select decryption
                                        encryption <= '1';
                                        ctrl_state <= waiting;
                                    WHEN "00000100" =>
                                        -- Select BLOWFISH-128
                                        key_length <= "00";
                                        ctrl_state <= waiting;
                                    WHEN "00001000" =>
                                        -- Select BLOWFISH-192
                                        key_length <= "01";
                                        ctrl_state <= waiting;
                                    WHEN "00010000" =>
                                        -- Select BLOWFISH-256
                                        key_length <= "10";
                                        ctrl_state <= waiting;
                                    WHEN "00100000" =>
                                        -- Encryption key input
                                        IF key_length = "00" THEN
                                            key_byte_cnt <= 15;
                                        ELSIF key_length = "01" THEN
                                            key_byte_cnt <= 23;
                                        ELSE
                                            key_byte_cnt <= 31;
                                        END IF;
                                        key_stored   <= '0';
                                        ctrl_state   <= key_in;
                                    WHEN "01000000" =>
                                        -- Check if key is stored
                                        IF key_stored = '1' THEN
                                            -- Data input
                                            data_byte_cnt <= 7;
                                            new_data      <= '0';
                                            ctrl_state    <= data_in;
                                        ELSE
                                            -- No key input/expanded yet, report error
                                            ctrl_state    <= tx_error;
                                        END IF;
                                    WHEN OTHERS =>
                                        -- Incorrect control message received
                                        ctrl_state <= tx_error;
                                END CASE;
                            ELSE
                                -- Error in received message, report error
                                ctrl_state <= tx_error;
                            END IF;
                        END IF;
                    WHEN key_in =>
                        -- Check for new data
                        IF rx_busy = '0' AND rx_busy_d = '1' THEN
                            -- Check for error
                            IF rx_error = '0' THEN
                                -- Store received data value
                                key_store((key_byte_cnt*8)+7 DOWNTO (key_byte_cnt*8)) <= rx_data;
                                -- Check if entire key has been received
                                IF key_byte_cnt <= 0 THEN
                                    -- If entire key correctly received then move to success state and set flag
                                    IF key_length = "00" THEN
                                        key_byte_cnt <= 15;
                                        key_in_ctr   <= 3;
                                    ELSIF key_length = "01" THEN
                                        key_byte_cnt <= 23;
                                        key_in_ctr <= 5;
                                    ELSE
                                        key_byte_cnt <= 31;
                                        key_in_ctr <= 7;
                                    END IF;
                                    key_stored     <= '1';
                                    ctrl_state     <= tx_success;
                                ELSE
                                    -- Full key not yet received, move to next byte and remain in key_in state
                                    key_byte_cnt <= key_byte_cnt - 1;
                                    ctrl_state   <= key_in;
                                END IF;
                            ELSE
                                -- Error in received message, report error
                                ctrl_state <= tx_error;
                            END IF;
                        END IF;
                    WHEN data_in =>
                        -- Check for new data
                        IF rx_busy = '0' AND rx_busy_d = '1' THEN
                            -- Check for error
                            IF rx_error = '0' THEN
                                -- Store received data value
                                data_in_store((data_byte_cnt*8)+7 DOWNTO (data_byte_cnt*8)) <= rx_data;
                                -- Check if entire plaintext/ciphertext has been received
                                IF data_byte_cnt <= 0 THEN
                                    -- Reset byte counter
                                    data_byte_cnt <= 7;
                                    -- If entire plaintext/ciphertext received correctly then report success and set flag
                                    ctrl_state    <= tx_success;
                                    new_data      <= '1';
                                ELSE
                                    -- Full plaintext/ciphertext not yet received, move to next byte and remain in data_in state
                                    data_byte_cnt <= data_byte_cnt - 1;
                                    ctrl_state    <= data_in;
                                END IF;
                            ELSE
                                -- Error in received message, report error
                                ctrl_state <= tx_error;
                            END IF;
                        END IF;
                    WHEN tx_error =>
                        -- Check if Tx is already transmitting different data
                        IF tx_busy = '0' THEN
                            -- Set enable and set data to be transmitted
                            tx_ena     <= '1';
                            tx_data    <= (OTHERS => '1');
                            -- Remain in same state to deassert enable flag once transmission begins
                            ctrl_state <= tx_error;
                        ELSIF tx_ena = '1' THEN
                            -- Deassert enable flag and reset data register after 1 clock cycle
                            tx_ena     <= '0';
                            tx_data    <= (OTHERS => '0');
                            -- Move back to waiting state
                            ctrl_state <= waiting;
                        END IF;
                    WHEN tx_success =>
                        -- Check if Tx is already transmitting different data
                        IF tx_busy = '0' THEN
                            -- Set enable and set data to be transmitted
                            tx_ena     <= '1';
                            tx_data    <= "10000000";
                            -- Remain in same state to deassert enable flag once transmission begins
                            ctrl_state <= tx_success;
                        ELSIF tx_ena = '1' THEN
                            -- Deassert enable flag and reset data register after 1 clock cycle
                            tx_ena <= '0';
                            tx_data <= (OTHERS => '0');
                            -- Check whether data was just written in
                            IF new_data = '1' THEN
                                -- Begin encryption/decryption process
                                enc_dec_in_done <= '0';
                                ctrl_state      <= enc_dec;
                            ELSE
                                -- No new data, return to waiting state
                                ctrl_state <= waiting;
                            END IF;
                        END IF;
                    WHEN enc_dec =>
                        -- Check if key/data input is complete
                        IF enc_dec_in_done = '1' THEN
                            -- Deassert input valid flag
							IF key_ready = '1' THEN
								data_valid       <= '0';
							END IF;
                            -- Check if encryption/decryption has completed
                            IF data_ready = '1' THEN
								data_out_store <= data_word_out;
                                -- Next state when output is ready
                                    enc_dec_in_done <= '0';
                                    -- Move to data output state
                                    tx_byte_cnt     <= 7;
									send_data_flag 	<= '0';
                                    ctrl_state      <= tx_block;
                            END IF;
                        ELSE
							-- Assert valid flag and write in data word
							data_valid   <= '1';
							ctrl_state     <= enc_dec;
							data_word_in <= data_in_store;
							key_word_in    <= key_store((key_in_ctr*32)+31 DOWNTO (key_in_ctr*32));
							IF key_in_ctr <= 0 THEN
								IF key_length = "00" THEN
									key_in_ctr <= 3;
								ELSIF key_length = "01" THEN
									key_in_ctr <= 5;
								ELSE
									key_in_ctr <= 7;
								END IF;
								enc_dec_in_done <= '1';
							ELSE
								-- Move to next input word, remain in same state
								key_in_ctr <= key_in_ctr - 1;
							END IF;
                        END IF;
                    WHEN tx_block =>
                        -- Check if Tx is already transmitting data
                        IF tx_busy = '0' THEN
                            -- Check if input is already set and waiting to be registered
                            IF tx_ena = '0' THEN
                                -- Transmit next byte
                                tx_ena    <= '1';
                                tx_data   <= data_out_store((tx_byte_cnt*8)+7 DOWNTO (tx_byte_cnt*8));
                            ELSE
                                -- Check if all bytes transmitted
                                IF tx_byte_cnt <= 0 THEN
                                    tx_ena      <= '0';
                                    tx_data     <= (OTHERS => '0');
                                    tx_byte_cnt <= 7;
                                    new_data    <= '0';
                                    -- Transmission complete, return to waiting state
                                    ctrl_state  <= waiting;
                                ELSE
                                    -- Move to next byte
                                    tx_byte_cnt <= tx_byte_cnt - 1;
                                    -- Deassert enable flag and data one cycle after setting
                                    tx_ena  <= '0';
                                    tx_data <= (OTHERS => '0');
                                END IF;
                            END IF;
                        ELSE
                            -- Deassert enable flag and data when already transmitting
                            tx_ena  <= '0';
                            tx_data <= (OTHERS => '0');
                        END IF;
                    WHEN OTHERS =>
                        ctrl_state <= waiting;
                END CASE;
            END IF;
        END IF;
    END PROCESS ctrl_fsm;

    -- State register value output to LEDs for debug
    state_led <= "00" WHEN ctrl_state = waiting ELSE
                 "01" WHEN ctrl_state = key_in ELSE
                 "10" WHEN ctrl_state = data_in ELSE
                 "11";

END rtl;
