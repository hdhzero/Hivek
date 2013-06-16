library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 640x480@60Hz at 25 MHz
entity vga_control is
    port (
        clock     : in std_logic;
        reset     : in std_logic;
        hsync     : out std_logic;
        vsync     : out std_logic;
        video_on  : out std_logic;
        pixel_clk : out std_logic;
        pixel_x   : out std_logic_vector(9 downto 0);
        pixel_y   : out std_logic_vector(9 downto 0)
    );
end vga_control;

architecture behavior of vga_control is
    signal vcounter : integer;
    signal hcounter : integer;
begin
    pixel_clk <= clock;

    process (clock, reset)
    begin
        if reset = '1' then
            hcounter <= 0;
            vcounter <= 0;
            hsync   <= '1';
            vsync   <= '1';
        elsif clock'event and clock = '1' then
            if hcounter = 799 then
                hcounter <= 0;
                
                if vcounter = 524 then
                    vcounter <= 0;
                else
                    vcounter <= vcounter + 1;
                end if;    
            else
                hcounter <= hcounter + 1;
            end if;
            
            if hcounter >= 656 and hcounter <= 751 then
                hsync <= '0';
            else
                hsync <= '1';
            end if;
            
            if vcounter >= 490 and vcounter <= 491 then
                vsync <= '0';
            else
                vsync <= '1';
            end if;

            if hcounter < 640 and vcounter < 480 then
                video_on <= '1';
            else
                video_on <= '0';
            end if;

            pixel_x <= std_logic_vector(to_unsigned(hcounter, 10));
            pixel_y <= std_logic_vector(to_unsigned(vcounter, 10));
        end if;
    end process;
end behavior;
