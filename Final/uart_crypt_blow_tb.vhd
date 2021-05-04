LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY uart_crypt_blow_tb IS
END ENTITY uart_crypt_blow_tb;

ARCHITECTURE tb OF uart_crypt_blow_tb IS

    CONSTANT clk_speed : INTEGER := 24_576_666;
    CONSTANT clk_period : TIME := 1 sec/clk_speed;

    CONSTANT uart_speed : INTEGER := 9600;
    CONSTANT uart_period : TIME := 1 sec/uart_speed;

    TYPE tv_type IS ARRAY(0 TO 34) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT uart_tv : tv_type := (x"02", x"20", x"DE", x"AD", x"BE", x"EF", x"01", x"23", x"45", x"67",
                                   x"89", x"AB", x"CD", x"EF", x"DE", x"AD", x"BE", x"EF", x"40", x"A5",
                                   x"A5", x"A5", x"A5", x"01", x"23", x"45", x"67", x"ff", x"ff", x"ff",
                                   x"ff", x"ff", x"ff", x"ff", x"ff");
								       -- CONSTANT uart_tv : tv_type := (x"01", x"20", x"DE", x"AD", x"ff", x"ff", x"ff", x"ff", x"ff", x"ff",
                                   -- x"ff", x"ff", x"ff", x"ff", x"ff", x"ff", x"ff", x"ff", x"40", x"ff",
                                   -- x"ff", x"ff", x"ff", x"ff", x"ff", x"ff", x"ff", x"ff", x"ff", x"ff",
                                   -- x"ff", x"ff", x"ff", x"ff", x"ff");

    COMPONENT uart_crypt_blow IS
        PORT(
            clk       : IN  STD_LOGIC;
            reset_n   : IN  STD_LOGIC;
            uart_rx   : IN  STD_LOGIC;
            state_led : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            uart_tx   : OUT STD_LOGIC
        );
    END COMPONENT uart_crypt_blow;

    -- UART crypt interface signals
    SIGNAL clk       : STD_LOGIC;
    SIGNAL reset_n   : STD_LOGIC;
    SIGNAL uart_rx   : STD_LOGIC;
    SIGNAL state_led : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL uart_tx   : STD_LOGIC;

    -- UART data generation signals
    TYPE msg_type IS ARRAY(0 TO 34) OF STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL uart_msg :msg_type;
    SIGNAL uart_clk : STD_LOGIC;

BEGIN

    DUT : uart_crypt_blow
    PORT MAP(
        clk       => clk,
        reset_n   => reset_n,
        uart_rx   => uart_rx,
        state_led => state_led,
        uart_tx   => uart_tx
    );

    clk_gen : PROCESS IS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS clk_gen;

    uart_clk_gen : PROCESS IS
    BEGIN
        uart_clk <= '0';
        WAIT FOR uart_period/2;
        uart_clk <= '1';
        WAIT FOR uart_period/2;
    END PROCESS uart_clk_gen;

    test_proc : PROCESS IS
        PROCEDURE reset_inputs IS
        BEGIN
            reset_n  <= '0';
            uart_rx  <= '1';
            FOR i IN 0 TO 34 LOOP
                uart_msg(i) <= '1' & uart_tv(i) & '0';
            END LOOP;
            WAIT FOR clk_period*10;
            reset_n  <= '1';
        END PROCEDURE reset_inputs;

        PROCEDURE tc_1 IS
        BEGIN
            reset_inputs;
            FOR i IN 0 TO uart_msg'LENGTH - 1 LOOP
                FOR j IN 0 TO uart_msg(i)'LENGTH - 1 LOOP
                    WAIT UNTIL RISING_EDGE(uart_clk);
                    uart_rx <= uart_msg(i)(j);
                END LOOP;
            END LOOP;
            WAIT FOR uart_period*10;
        END PROCEDURE tc_1;
    BEGIN
        tc_1;
        ASSERT FALSE REPORT "Test Complete" SEVERITY FAILURE;
    END PROCESS test_proc;

END tb;
