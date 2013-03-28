library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pack.all;

entity instruction_decode is
    port (
        clock   : in std_logic;
        clock2x : in std_logic;
    );
end instruction_decode;

architecture behavior of instruction_decode is
begin
    instruction_decoder_u0 : instruction_decoder
    port map (

    );

    register_bank_u : register_bank
    port map (
        clock   => clock,
        reset   => reset,
        load0   => 
        load1   =>
        reg_a0  =>
        reg_b0  =>
        reg_a1  =>
        reg_b1  =>
        reg_c0  =>
        reg_c1  =>
        din_c0  =>
        din_c1  =>
        dout_a0 =>
        dout_b0 =>
        dout_a1 =>
        dout_b1 =>
        
    );
end behavior;
