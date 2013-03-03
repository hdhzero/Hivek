library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity load_decoder is
    port (
        address : in std_logic_vector(3 downto 0);
        loads   : out std_logic_vector(15 downto 0)
    );
end load_decoder;

architecture load_decoder_arch of load_decoder is
begin
    process (address)
    begin
        case address is
            when "0000" =>
                loads <= "0000000000000000";
            when "0001" =>
                loads <= "0000000000000010";
            when "0010" =>
                loads <= "0000000000000100";
            when "0011" =>
                loads <= "0000000000001000";
            when "0100" =>
                loads <= "0000000000010000";
            when "0101" =>
                loads <= "0000000000100000";
            when "0110" =>
                loads <= "0000000001000000";
            when "0111" =>
                loads <= "0000000010000000";
            when "1000" =>
                loads <= "0000000100000000";
            when "1001" =>
                loads <= "0000001000000000";
            when "1010" =>
                loads <= "0000010000000000";
            when "1011" =>
                loads <= "0000100000000000";
            when "1100" =>
                loads <= "0001000000000000";
            when "1101" =>
                loads <= "0010000000000000";
            when "1110" =>
                loads <= "0100000000000000";
            when "1111" =>
                loads <= "1000000000000000";
        end case;
    end process;
end load_decoder_arch;
