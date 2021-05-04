----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2020  01:12:54
-- Design Name: 
-- Module Name: Blow_dec - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 128/192/256-bit key with 64 bit input/output 
-- Encryption using the Blowfish Algorithm
-- 
-- Dependencies: 
-- 
-- Revision: v4.1 - Reduced full enc/dec version with added optimisiation 
-- on some of the for loops where conditions were overlapping 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

--Library declerations
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BlowfishHeader2.ALL;


--Entity definition
entity Blow_dec is
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
end Blow_dec;

--Architecture description
architecture Behavioral of Blow_dec is

--ENC Loop signals
signal dataLP,dataRP : std_logic_vector (31 downto 0) := (others => '0');
signal SS1,SS2,SOUT1,SOUT2 : std_logic_vector (31 downto 0) := (others => '0');
signal delaysig_enc: std_logic := '0'; --Control delay and reading in loop
signal counter : INTEGER RANGE 0 TO 16; --Counting to control loop reading
signal loopnow,Eoddeven : std_logic := '0';
signal loopcntr: INTEGER RANGE 0 TO 522;
signal Subcounter : integer range 0 to 18;
signal conversion_complete: std_logic := '0';
signal keyset,keyread_done: std_logic := '0';
signal ENCFLAG : integer range 0 to 5; 

--DEC Loop signals
signal counterd : INTEGER RANGE 1 TO 17;
signal SSOUT1,SSOUT2 : std_logic_vector (31 downto 0) := (others => '0');

--RAM signals
signal PdataRAM : Pkeys := INITIAL_P;
signal S0: Sboxes := INITAL_S0; signal S1: Sboxes := INITAL_S1;
signal S2: Sboxes := INITAL_S2; signal S3: Sboxes := INITAL_S3;
signal keystore: KEYS := (others => x"00000000");
signal keycount,max_keys: INTEGER RANGE 0 TO 8;

--P subkey signals
signal Pset: std_logic := '0';
-- signal P : Pkeys; 
-- signal Sp1,SP2,SP3,SP4 : Sboxes;
-- constant KEY_SET : std_logic_vector(447 downto 0):= (others => '0');



begin

--Control flag to start encryption
--If plain_READ is set then begin encryption
FLAGSETOUTPUT: process (clk)
begin
if rising_edge(clk) then
  if rst = '0' then
     cipher_out <= (others => '0');
     cipher_ready <= '0';
	 keyread_done <= '0';
	 Pset <= '0';
  else
		if plain_read = '1' then
			keyset <= '1';
			cipher_ready <= '0';
			conversion_complete <= '0';
			keyread_done <= '0';
			key_ready <= '0';
			if keycount >= max_keys then
			keyread_done <= '1'; 
			key_ready <= '1';
			end if;   	
		else
			if keycount >= max_keys and loopcntr < 520 and conversion_complete = '0' then
				Pset <= '1';
				keyset <= '0';
			end if;
			
			if loopcntr = 520 and counter = 15 then
				loopnow <= '1';
			end if;
			
			if loopcntr = 522 then
				if conversion_complete = '1' then
					Pset <= '0';
					loopnow <= '0';
					cipher_ready <= '1';
					if ENC_sel = '0' then
						cipher_out (63 downto 32) <= SOUT1; cipher_out (31 downto 0) <= SOUT2;
					else
						cipher_out (63 downto 32) <= SSOUT2; cipher_out (31 downto 0) <= SSOUT1;
					end if;
				end if;
			end if;
		end if;
		if ((counter > 15 and ENC_SEL = '0') or (counterd < 2 and ENC_SEL = '1'))and loopcntr = 522 then --and pkey flag is low, ensure that it isnt creating output of subkeys
			loopnow <= '0';
			conversion_complete <= '1';
		end if;
  end if;
end if;
end process;

--Set max round of keys
max_keys <= 4 WHEN key_sel = "00" ELSE --128bit
			6 WHEN key_sel = "01" ELSE --192bit
			8 WHEN key_sel = "10" ELSE --256bit
			4; --default 128bit key

KEYREAD: process(clk)
begin
if rising_edge(clk) then
	if rst = '0' then
		keystore <= (others => x"00000000");
		keycount <= 0;
	else
		if plain_read = '1' then
			if keycount > 0 then
				if key_sel = "00" and keycount < max_keys then --128bits (4) Values for Blowfish-128
					keystore(keycount) <= key;
					keycount <= keycount + 1;
				elsif key_sel = "01" and keycount < max_keys then --192bits (6) Values for Blowfish-192
					keystore(keycount) <= key;
					keycount <= keycount + 1;
				elsif key_sel = "10" and keycount < max_keys then --256bits (8) Values for Blowfish-256
					keystore(keycount) <= key;
					keycount <= keycount + 1;
				end if;
			else
				keystore(0) <= key;
				keycount <= keycount + 1;
			end if;
		else
			keycount <= 0;
		end if;
	end if;
end if;
end process;

SETKEYS: process (clk) 
begin
if rising_edge(clk) then
	if rst = '0' then
		loopcntr <= 0;
		Subcounter <= 0;
		PdataRAM <= INITIAL_P;
		S0 <= INITAL_S0; S1 <= INITAL_S1;
		S2 <= INITAL_S2; S3 <= INITAL_S3;
	else
		if Pset = '1' then		
			if Subcounter < 18 then --To have longer keys need to change how flags declare end of this section using arrays to store key
				PdataRAM(Subcounter) <= INITIAL_P(Subcounter) xor keystore(Subcounter mod max_keys);
				Subcounter <= Subcounter + 1;
			end if;
			
			if (counter > 15 and ENCFLAG > 1) then
				if delaysig_enc = '1' then
					if loopcntr < 9 then
						PdataRAM(2*loopcntr) <= SOUT1; PdataRAM((2*loopcntr)+1) <= SOUT2;--save as Pval
					 elsif (loopcntr >= 9 and loopcntr <= 136) then
						S0(2*((loopcntr - 9) mod 128)) <= SOUT1; S0((2*((loopcntr - 9) mod 128))+1) <= SOUT2; --needs to be for 9 to 136
					 elsif (loopcntr >= 137 and loopcntr <= 264) then
						S1(2*((loopcntr - 9) mod 128)) <= SOUT1; S1((2*((loopcntr - 9) mod 128))+1) <= SOUT2; --needs to be for 137 to 264
					 elsif (loopcntr >= 265 and loopcntr <= 392) then
						S2(2*((loopcntr - 9) mod 128)) <= SOUT1; S2((2*((loopcntr - 9) mod 128))+1) <= SOUT2; --needs to be for 265 to 392
					 elsif (loopcntr >= 393 and loopcntr <= 520) then
						S3(2*((loopcntr - 9) mod 128)) <= SOUT1; S3((2*((loopcntr - 9) mod 128))+1) <= SOUT2; --needs to be for 393 to 520
					end if;
					loopcntr <= loopcntr + 1;
				end if;
			end if;
			
		 else
			if conversion_complete = '1' then
				loopcntr <= 0;
				Subcounter <= 0;
				PdataRAM <= INITIAL_P;
				S0 <= INITAL_S0; S1 <= INITAL_S1;
				S2 <= INITAL_S2; S3 <= INITAL_S3;
			end if;
		end if;
	end if;
end if;
end process;

--Process delay for encryption loop
ENC_FLAG_CONTROL: process(clk)
begin
if rising_edge(clk) then 
	if rst = '0' then
	  delaysig_enc <= '0';
	else
		if loopnow = '1' or Pset = '1' then
		delaysig_enc <= not delaysig_enc;
		else
		  delaysig_enc <= '0';
		end if;
	end if;
end if;
end process;

--3 step flag to step through encryption stages
TOENC: process(clk)
begin
if rising_edge(clk) then
	if rst = '0' then
		ENCFLAG <= 0;
	else
		if (Pset = '1' or loopnow = '1') and Subcounter >= 18 then
			if ENCFLAG <= 2 then
				ENCFLAG <= ENCFLAG + 1;
			else
				if counter = 16 then --FOR ENCRYPTION ADD A EXTRA IF TO COUNT DOWN FOR DECRYPTION
					ENCFLAG <= ENCFLAG + 1;
				else
					ENCFLAG <= 0;
				end if;
			end if;
		else
		ENCFLAG <= 0;
		end if;
	end if;
end if;
end process;

--Process the blowfish encryption rounds
EncryptionRound: process (clk)
begin
if rising_edge(clk) then
	if rst = '0' then
		counter <= 0;	
		counterd <= 17;	
		Eoddeven <= '0';
		SOUT1 <= (others => '0');
		SOUT2 <= (others => '0');
	else
	
		if counter <= 15 then
			if ENCFLAG = 0 then
				if (loopcntr < 521 or ENC_SEL = '0') then
					dataLP <= SS1 xor PdataRAM(counter);
				elsif (loopcntr = 521 and ENC_SEL = '1')then
					dataLP <= SS1 xor PdataRAM(counterd);
				end if;
				Eoddeven <= not Eoddeven;
			elsif ENCFLAG = 1 then
				dataRP <= SS2 xor std_logic_vector(unsigned(std_logic_vector(((unsigned(S0(to_integer(unsigned(dataLP(31 downto 24))))))+(unsigned(S1(to_integer(unsigned(dataLP(23 downto 16)))))))) xor (S2(to_integer(unsigned(dataLP(15 downto 8))))))+(unsigned(S3(to_integer(unsigned(dataLP(7 downto 0)))))));
					counter <= counter + 1;
					counterd <= counterd - 1;
				Eoddeven <= not Eoddeven;
			end if;
		else
			SOUT1 <= dataLP xor PdataRAM(17);--left
			SOUT2 <= dataRP xor PdataRAM(16);--right
			SSOUT1 <= dataRP xor PdataRAM(1);--RIGHT
			SSOUT2 <= dataLP xor PdataRAM(0);--LEFT 
			if ENCFLAG = 4 then
				counter <= 0;
				counterd <= 17;
			end if;
		end if;
			
		if ENCFLAG = 5 then
			SOUT1 <= (others => '0'); SOUT2 <= (others => '0');
			SSOUT1 <= (others => '0'); SSOUT2 <= (others => '0');
		end if;
	end if;
end if;
end process;


--Control blowfish encryption inputs
BLOWFISH_ENCRYPTION: process (clk) 
begin
if rising_edge(clk) then

	if rst = '0' then
		SS1 <= (others => '0');
		SS2 <= (others => '0');
	else
		if loopcntr < 521 or (loopcntr = 521) then
			if counter <= 15 and ENCFLAG = 3 then
				SS1 <= dataRP;
				SS2 <= dataLP;
			elsif counter = 0 and ENCFLAG = 3 then
				SS1 <= SOUT1;
				SS2 <= SOUT2;
			elsif ENCFLAG = 4 then
				if loopcntr < 521 then
					SS1 <= SOUT1;
					SS2 <= SOUT2;
				else
					SS1 <= plain_in(63 downto 32);
					SS2 <= plain_in(31 downto 0);
				end if;
			end if;
		else
		SS1 <= (others => '0');
		SS2 <= (others => '0');
		end if;	
	end if;
end if;
end process;


end Behavioral;