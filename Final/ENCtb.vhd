----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2020  `12:52:42
-- Design Name: 
-- Module Name: ENCtb
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

--Library declerations
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BlowfishHeader2.ALL;

entity ENCtb is
--  Port ( );
end ENCtb;

architecture Testbench of ENCtb is

component Blow_dec is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           key : in STD_LOGIC_VECTOR(31 downto 0);
		   Enc_sel : in STD_LOGIC;--0 for encrypt, 1 for decrypt
		   key_sel : in STD_LOGIC_VECTOR(1 downto 0);-- 00 for 128bit, 01 for 192bit, 10 for 256bit & 11bit default 128bit key 
           plain_in : in STD_LOGIC_VECTOR(63 downto 0);
           plain_read : in STD_LOGIC;
		   key_ready : out STD_LOGIC;
           cipher_out : out STD_LOGIC_VECTOR(63 downto 0);
           cipher_ready : out STD_LOGIC);
end component;

--input signals
signal CLK,RESET : std_logic := '0';
signal KEY : std_logic_vector(31 downto 0) := (others => '0');
signal KEY_SEL : std_logic_vector(1 downto 0):= (others => '0');
signal ENC_SEL,PLAIN_READ : std_logic := '0';
signal PLAIN_IN: std_logic_vector (63 downto 0) := x"0000000000000000";

--output signals
signal CIPHER_READY,KEY_READY : std_logic;
signal CIPHER_OUT : std_logic_vector (63 downto 0);

--clock definition
--constant clk_period: time:= 2000ms;
constant clk_period : time := 20ns;
constant KEY_IN : std_logic_vector(447 downto 0):= x"00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF";

begin
    UUT: Blow_dec port map(
                                clk           => CLK,
                                rst           => RESET,
                                key     	  => KEY,
                                Enc_sel       => ENC_SEL,
                                key_sel       => KEY_SEL,
								plain_in	  => PLAIN_IN,
                                plain_read    => PLAIN_READ,
                                key_ready     => KEY_READY,
                                cipher_out    => CIPHER_OUT,
                                cipher_ready  => CIPHER_READY 
                               );
                        
clk_process :process
      begin
         CLK <= '0';
         wait for clk_period/2;
         CLK <= '1';
         wait for clk_period/2;
      end process;
      
STIM :process
begin

    RESET <= '0';
    wait for clk_period;
	ENC_SEL <= '0'; --Set to Encryption 
	KEY_SEL <= "01"; --Set to 128bit key therefore 4 key inputs (4x 32 bit words)
    RESET <= '1';
    wait for clk_period;
	PLAIN_READ <= '1';
	-- wait for clk_period;
    KEY <= x"DEADBEEF";
	wait for clk_period;
	KEY <= x"01234567";
	wait for clk_period;
	KEY <= x"89ABCDEF";
	wait for clk_period;
	KEY <= x"DEADBEEF";
	wait for clk_period;
	KEY <= x"89ABCDEF";
	wait for clk_period;
	KEY <= x"DEADBEEF";
	wait for clk_period;
	PLAIN_READ <= '0';
    wait for clk_period;
    PLAIN_IN <= x"A5A5A5A501234567"; --Helloche from ASCII to HEX 
	-----------------------------------------------------------------
	wait until cipher_ready = '1';
	wait for clk_period;
	RESET <= '0';
    wait for clk_period;
	ENC_SEL <= '1'; --Set to Decryption 
	KEY_SEL <= "00"; --Set to 128bit key therefore 4 key inputs (4x 32 bit words)
    RESET <= '1';
    wait for clk_period;
	PLAIN_READ <= '1';
	-- wait for clk_period;
    KEY <= x"DEADBEEF";
	wait for clk_period;
	KEY <= x"01234567";
	wait for clk_period;
	KEY <= x"89ABCDEF";
	wait for clk_period;
	KEY <= x"DEADBEEF";
	wait for clk_period;
	PLAIN_READ <= '0';
    wait for clk_period;
    PLAIN_IN <= x"24B9C5E1B06FBF71"; --Helloche from ASCII to HEX 
    WAIT;
	-----------------------------------------------------------------	
	-- wait until cipher_ready = '1';
	-- wait for clk_period;
	-- RESET <= '0';
    -- wait for clk_period;
	-- ENC_SEL <= '0'; --Set to Encryption 
	-- KEY_SEL <= "00"; --Set to 128bit key therefore 4 key inputs (4x 32 bit words)
    -- RESET <= '1';
    -- wait for clk_period;
	-- PLAIN_READ <= '1';
	 -- wait for clk_period;
    -- KEY <= x"FFFFFFF0";
	-- wait for clk_period;
	-- KEY <= x"FFFFFFF1";
	-- wait for clk_period;
	-- KEY <= x"FFFFFFF2";
	-- wait for clk_period;
	-- KEY <= x"FFFFFFF3";
	-- wait for clk_period;
	-- PLAIN_READ <= '0';
    -- wait for clk_period;
    -- PLAIN_IN <= x"0000000000000000"; --Helloche from ASCII to HEX 
    -- WAIT;
     
end process;

end Testbench;
