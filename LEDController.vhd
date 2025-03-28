-- LEDController.VHD
--
-- This SCOMP peripheral controls ten LEDs based on values received from SCOMP.
-- It allows individual LED selection and PWM control while keeping previous settings intact.
--
-- PWM rate is in periods of 20 ms, and is based on a 10kHz clock.
-- Changes in clock frequency should refer to equations noted to update values accordingly
--
-- To use, the user will output to the peripheral in cycles of 2.
-- 	First out states which LEDs will have their rates changed
-- 	Second out states the new rate for selected LEDs
-- Putting 1 in the MSB of the data will result in a state reset to LED selection

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY LEDController IS
PORT(
    Clk         : IN  STD_LOGIC; -- 10kHz clock signal
    CS          : IN  STD_LOGIC; -- Chip select
    WRITE_EN    : IN  STD_LOGIC; -- Write enable signal
    RESETN      : IN  STD_LOGIC; -- Active-low reset signal
    LEDs        : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- LED output control
    IO_DATA     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0) -- Input data
    );
END LEDController;

ARCHITECTURE a OF LEDController IS
    TYPE state_type IS (LED_select, rate_define); -- State machine
    SIGNAL state 		: state_type;
    SIGNAL LED_mask 	: STD_LOGIC_VECTOR(9 DOWNTO 0); -- LED select
    SIGNAL counter   : INTEGER RANGE 0 TO 200 := 0; -- PWM counter
    TYPE pwm_array_t   IS ARRAY (9 DOWNTO 0) OF INTEGER RANGE 0 TO 127;
    SIGNAL pwm_rates	: pwm_array_t := (OTHERS => 0); -- Stores PWM rate for each LED
	 
BEGIN
    PROCESS (RESETN, CS) -- Update LED_mask and pwm_rate
    BEGIN
        IF (RESETN = '0') THEN
            LED_mask <= "1111111111";
            pwm_rates <= (OTHERS => 0); -- Reset all LED PWM rates to 0
            state <= LED_select;
        ELSIF (RISING_EDGE(CS)) THEN
            IF WRITE_EN = '1' THEN
                IF IO_DATA(15) = '0' THEN -- If normal or go to reset
                    CASE state IS
                        WHEN LED_select =>
                            LED_mask <= IO_DATA(9 DOWNTO 0); -- Select LEDs to be updated
                            state <= rate_define;
                        WHEN rate_define =>
                            FOR i IN 0 TO 9 LOOP -- Apply new PWM rate only to selected LEDs
                                IF LED_mask(i) = '1' THEN
                                    pwm_rates(i) <= CONV_INTEGER(IO_DATA(6 DOWNTO 0));
                                END IF;
                            END LOOP;
                            state <= LED_select;
                    END CASE;
                ELSE
                    state <= LED_select; -- Return to LED selection state if user is lost
                END IF;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (Clk) -- Generate PWM signals for LEDs
    BEGIN
        IF RISING_EDGE(Clk) THEN
            IF counter < 199 THEN -- check if counter has reached max count. PWM_Period * Clock_Freq - 1 -> clock_freq = 10kHz, PWM_Period = 20 ms
                counter <= counter + 1;
            ELSE
                counter <= 0;
            END IF;
            
            FOR i IN 0 TO 9 LOOP
                IF counter < (pwm_rates(i) * 2) THEN -- if counter < pwm_rate*multiplier, output high. PWM_rate*(max_counter/100)
                    LEDs(i) <= '1';
                ELSE
                    LEDs(i) <= '0';
                END IF;
            END LOOP;
        END IF;
    END PROCESS;

END a;