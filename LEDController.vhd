-- LEDController.VHD
-- 2025.03.09
--
-- This SCOMP peripheral drives ten outputs high or low based on
-- a value from SCOMP.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY LEDController IS
PORT(
	 Clk         : IN  STD_LOGIC; -- 10kHz clock
    CS          : IN  STD_LOGIC; -- chip sel
    WRITE_EN    : IN  STD_LOGIC;
    RESETN      : IN  STD_LOGIC;
    LEDs        : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    IO_DATA     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END LEDController;

ARCHITECTURE a OF LEDController IS
	 -- variables
    SIGNAL counter   : INTEGER RANGE 0 TO 100 := 0;  -- PWM counter
    SIGNAL pwm_rate  : INTEGER RANGE 0 TO 100 := 0;  -- duty cycle
BEGIN
	 -- Process to update pwm_rate as needed
    PROCESS (RESETN, CS)
    BEGIN
        IF (RESETN = '0') THEN  -- reset all
				pwm_rate <= 0;
        ELSIF (RISING_EDGE(CS)) THEN  -- set pwm_rate
            IF WRITE_EN = '1' THEN
					pwm_rate <= CONV_INTEGER(IO_DATA(6 DOWNTO 0));
            END IF;
        END IF;
    END PROCESS;
	 
    -- Process to generate PWM signal
    PROCESS (Clk)
    BEGIN
        IF rising_edge(Clk) THEN  -- assuming the inside takes <1 clock cycle, this will have a period of 20 ms
            IF counter < 199 THEN  -- check if counter has reached max count. PWM_Period * Clock_Freq - 1 -> clock_freq = 10kHz, PWM_Period = 20 ms
                counter <= counter + 1;
            ELSE
                counter <= 0;
            END IF;

            IF counter < (pwm_rate*2) THEN  -- if counter < pwm_rate*multiplier, output high. PWM_rate*(max_counter/100)
					LEDs <= "1111111111";
            ELSE
					LEDs <= "0000000000";
            END IF;
        END IF;
    END PROCESS;
				
END a;