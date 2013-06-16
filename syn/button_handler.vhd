library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity button_handler is
    port (
        clock : in std_logic;
        reset : in std_logic;
        press : in std_logic;
        dout  : out std_logic
    );
end button_handler;

architecture behavior of button_handler is
    type state_t is (idle, pressed, released);
    signal state : state_t;
    signal counter : integer;
begin

    process (clock, reset)
    begin
        if reset = '1' then
            dout  <= '0';
            state <= idle;
            counter <= 0;
        elsif clock'event and clock = '1' then
            case state is
                when idle =>
                    dout <= '0';
                    counter <= 0;

                    if press = '1' then
                        state <= pressed;
                    end if;

                when pressed =>
                    dout <= '0';
                    counter <= counter + 1;

                    if press = '0' then
                        state <= released;
                    end if;

                when released =>
                    dout <= '1';
                    state <= idle;

                when others =>
                    dout <= '0';
                    state <= idle;
            
            end case;
        end if;
    end process;
end behavior;
