library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hivek_pkg.all;

entity hivek_board is
    port (
        clock_50 : in std_logic;
        sw       : in std_logic_vector(9 downto 0);
        key      : in std_logic_vector(2 downto 0);
        ledg     : out std_logic_vector(9 downto 0);
        vga_hs   : out std_logic;
        vga_vs   : out std_logic;
        vga_r    : out std_logic_vector(3 downto 0);
        vga_g    : out std_logic_vector(3 downto 0);
        vga_b    : out std_logic_vector(3 downto 0) 
    );
end hivek_board;

architecture behavior of hivek_board is
    type state_t is (set_x0, set_y0, set_x1, set_y1, draw);
    signal state : state_t;
     
    -- constants
    constant ADDR_WIDTH : integer := 8;
    constant DUAL_ADDR_WIDTH : integer := 12;
    constant DUAL_DATA_WIDTH : integer := 32;
    constant VENDOR : string := "GENERIC";

    -------------
    -- signals --
    -------------

    signal clock : std_logic;
    signal reset : std_logic;
     
    signal hivek_reset  : std_logic;
    signal vgamem_addr  : std_logic_vector(31 downto 0);
    signal vgamem_data  : std_logic_vector(31 downto 0);
    signal vgamem_data0 : std_logic_vector(31 downto 0);
    signal vgamem_data1 : std_logic_vector(31 downto 0);

    signal hivek_i : hivek_in_t;
    signal hivek_o : hivek_out_t;

    signal icache_sel : std_logic_vector(1 downto 0);
    signal dcache_sel : std_logic_vector(1 downto 0);

    signal data_dram_led : std_logic_vector(31 downto 0);

    signal buttons : std_logic_vector(2 downto 0);

    signal input_wren : std_logic;
    signal input_addr : std_logic_vector(31 downto 0);
    signal input_data : std_logic_vector(31 downto 0);

    signal hsync : std_logic;
    signal vsync : std_logic;

    signal hsync_reg : std_logic;
    signal vsync_reg : std_logic;

    signal video_on     : std_logic;
    signal video_on_reg : std_logic;

    signal bit_pos     : std_logic_vector(31 downto 0);
    signal bit_pos_reg : std_logic_vector(31 downto 0);

    signal pixel_x : std_logic_vector(9 downto 0);
    signal pixel_y : std_logic_vector(9 downto 0);

    signal press1 : std_logic;
    signal press2 : std_logic;

    ----------------
    -- components --
    ----------------

    component button_handler is
    port (
        clock : in std_logic;
        reset : in std_logic;
        press : in std_logic;
        dout  : out std_logic
    );
    end component;

    component vga_control is
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
    end component;

    component vga_ram_address_decoder is
    port (
        pixel_x : in std_logic_vector(9 downto 0);
        pixel_y : in std_logic_vector(9 downto 0);
        bit_pos : out std_logic_vector(31 downto 0);
        address : out std_logic_vector(31 downto 0)
    );
    end component;

    component icache_selector is
    generic (
        VENDOR     : string := "GENERIC";
        ADDR_WIDTH : integer := 8
    );
    port (
        clock  : in std_logic;
        sel    : in std_logic_vector(1 downto 0);

        wren_0 : in std_logic;
        addr_0 : in std_logic_vector(31 downto 0);
        din_0  : in std_logic_vector(63 downto 0);
        dout_0 : out std_logic_vector(63 downto 0);

        wren_1 : in std_logic;
        addr_1 : in std_logic_vector(31 downto 0);
        din_1  : in std_logic_vector(63 downto 0);
        dout_1 : out std_logic_vector(63 downto 0);

        wren_2 : in std_logic;
        addr_2 : in std_logic_vector(31 downto 0);
        din_2  : in std_logic_vector(63 downto 0);
        dout_2 : out std_logic_vector(63 downto 0);

        wren_3 : in std_logic;
        addr_3 : in std_logic_vector(31 downto 0);
        din_3  : in std_logic_vector(63 downto 0);
        dout_3 : out std_logic_vector(63 downto 0)
    );
    end component;

    component dcache_selector is
    generic (
        VENDOR     : string  := "GENERIC";
        ADDR_WIDTH : integer := 8 -- 2 ^ ADDR_WIDTH addresses
    );
    port (
        clock    : in std_logic;
        sel      : in std_logic_vector(1 downto 0);

        a_wren_0   : in std_logic;
        a_addr_0   : in std_logic_vector(31 downto 0);
        a_data_i_0 : in std_logic_vector(31 downto 0);
        a_data_o_0 : out std_logic_vector(31 downto 0);

        b_wren_0   : in std_logic;
        b_addr_0   : in std_logic_vector(31 downto 0);
        b_data_i_0 : in std_logic_vector(31 downto 0);
        b_data_o_0 : out std_logic_vector(31 downto 0);

        a_wren_1   : in std_logic;
        a_addr_1   : in std_logic_vector(31 downto 0);
        a_data_i_1 : in std_logic_vector(31 downto 0);
        a_data_o_1 : out std_logic_vector(31 downto 0);

        b_wren_1   : in std_logic;
        b_addr_1   : in std_logic_vector(31 downto 0);
        b_data_i_1 : in std_logic_vector(31 downto 0);
        b_data_o_1 : out std_logic_vector(31 downto 0);

        a_wren_2   : in std_logic;
        a_addr_2   : in std_logic_vector(31 downto 0);
        a_data_i_2 : in std_logic_vector(31 downto 0);
        a_data_o_2 : out std_logic_vector(31 downto 0);

        b_wren_2   : in std_logic;
        b_addr_2   : in std_logic_vector(31 downto 0);
        b_data_i_2 : in std_logic_vector(31 downto 0);
        b_data_o_2 : out std_logic_vector(31 downto 0);

        a_wren_3   : in std_logic;
        a_addr_3   : in std_logic_vector(31 downto 0);
        a_data_i_3 : in std_logic_vector(31 downto 0);
        a_data_o_3 : out std_logic_vector(31 downto 0);

        b_wren_3   : in std_logic;
        b_addr_3   : in std_logic_vector(31 downto 0);
        b_data_i_3 : in std_logic_vector(31 downto 0);
        b_data_o_3 : out std_logic_vector(31 downto 0)
    );
    end component;

begin
    buttons(0) <= not key(0);
    press1     <= sw(9); --not key(1);
    press2     <= sw(8); --not key(2);

    reset <= buttons(0);

    icache_sel <= "00";

    process (clock_50, reset)
    begin
        if reset = '1' then
            clock <= '0';
        elsif clock_50'event and clock_50 = '1' then
            clock <= not clock;
        end if;
    end process;

    vgamem_data <= vgamem_data0 when dcache_sel = "00" else vgamem_data1;

    process (clock, reset)
    begin
        if reset = '1' then
            hsync_reg    <= '0';
            vsync_reg    <= '0';
            video_on_reg <= '0';
            bit_pos_reg  <= (others => '0');

            vga_hs <= '0';
            vga_vs <= '0';

            vga_r <= "0000";
            vga_g <= "0000";
            vga_b <= "0000";  
        elsif clock'event and clock = '1' then
            hsync_reg    <= hsync;
            vsync_reg    <= vsync;
            video_on_reg <= video_on;
            bit_pos_reg  <= bit_pos;

            vga_hs <= hsync_reg;
            vga_vs <= vsync_reg;

            if (bit_pos_reg and vgamem_data) /= x"00000000" or video_on_reg = '0' then
                vga_r <= "0000";
                vga_g <= "0000";
                vga_b <= "0000";
            else
                vga_r <= "1111";
                vga_g <= "1111";
                vga_b <= "1111";
            end if;
        end if;
    end process;

    process (clock, reset)
    begin
        if reset = '1' then
            state       <= set_x0;
            input_data  <= (others => '0');
            input_wren  <= '0';
            input_addr  <= (others => '0');
            dcache_sel  <= "01";
            hivek_reset <= '1';
            ledg <= "0000000000";
        elsif clock'event and clock = '1' then
            case state is
                when set_x0 =>
                    ledg <= "0000000001";
                    dcache_sel  <= "01";
                    hivek_reset <= '1';

                    input_data <= "000000000000000000000000" & sw(7 downto 0);
                    input_addr <= x"000007D0";

                    if buttons(1) = '1' then
                        input_wren <= '1';
                    else
                        input_wren <= '0';
                    end if;
                   
                    if buttons(2) = '1' then
                        state <= set_y0;
                    else
                        state <= set_x0;
                    end if;

                when set_y0 =>
                    ledg <= "0000000010";
                    dcache_sel  <= "01";
                    hivek_reset <= '1';

                    input_data <= "000000000000000000000000" & sw(7 downto 0);
                    input_addr <= x"000007D1";

                    if buttons(1) = '1' then
                        input_wren <= '1';
                    else
                        input_wren <= '0';
                    end if;
                   
                    if buttons(2) = '1' then
                        state <= set_x1;
                    else
                        state <= set_y0;
                    end if;

                when set_x1 =>
                    ledg <= "0000000100";
                    dcache_sel  <= "01";
                    hivek_reset <= '1';

                    input_data <= "000000000000000000000000" & sw(7 downto 0);
                    input_addr <= x"000007D2";

                    if buttons(1) = '1' then
                        input_wren <= '1';
                    else
                        input_wren <= '0';
                    end if;
                   
                    if buttons(2) = '1' then
                        state <= set_y1;
                    else
                        state <= set_x1;
                    end if;

                when set_y1 =>
                    ledg <= "0000001000";
                    dcache_sel  <= "01";
                    hivek_reset <= '1';

                    input_data <= "000000000000000000000000" & sw(7 downto 0);
                    input_addr <= x"000007D3";

                    if buttons(1) = '1' then
                        input_wren <= '1';
                    else
                        input_wren <= '0';
                    end if;
                   
                    if buttons(2) = '1' then
                        state <= draw;
                    else
                        state <= set_y1;
                    end if;

                when draw =>
                    ledg <= "0000001111";
                    dcache_sel  <= "00";
                    hivek_reset <= '0';

                    if buttons(2) = '1' then
                        state <= set_x0;
                    else
                        state <= draw;
                    end if;

            end case;
        end if;
    end process;


    button_1 : button_handler
    port map (
        clock => clock,
        reset => reset,
        press => press1,
        dout  => buttons(1)
    );
        
    button_2 : button_handler
    port map (
        clock => clock,
        reset => reset,
        press => press2,
        dout  => buttons(2)
    );

    vga_control_u : vga_control
    port map (
        clock     => clock,
        reset     => reset,
        hsync     => hsync,
        vsync     => vsync,
        video_on  => video_on,
        pixel_clk => open, --pixel_clk,
        pixel_x   => pixel_x,
        pixel_y   => pixel_y
    );


    vga_ram_address_decoder_u : vga_ram_address_decoder
    port map (
        pixel_x => pixel_x,
        pixel_y => pixel_y,
        bit_pos => bit_pos,
        address => vgamem_addr
    );

    hivek_u : hivek
    port map (
        clock => clock,
        reset => hivek_reset,
        din   => hivek_i,
        dout  => hivek_o
    );

    icache_selector_u : icache_selector
    generic map (
        VENDOR => VENDOR, 
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
        clock   => clock,
        sel     => icache_sel,

        wren_0  => '0',
        addr_0  => hivek_o.icache_addr,
        din_0   => (others => '0'),
        dout_0  => hivek_i.icache_data,

        wren_1  => '0',
        addr_1  => (others => '0'),
        din_1   => (others => '0'),
        dout_1  => open,

        wren_2  => '0',
        addr_2  => (others => '0'),
        din_2   => (others => '0'),
        dout_2  => open,

        wren_3  => '0',
        addr_3  => (others => '0'),
        din_3   => (others => '0'),
        dout_3  => open
    );

    dcache_selector_u : dcache_selector
    generic map (
        VENDOR => VENDOR,
        ADDR_WIDTH => DUAL_ADDR_WIDTH
    )
    port map (
        clock    => clock,
        sel      => dcache_sel,

        a_wren_0   => hivek_o.op0.dcache_wren,
        a_addr_0   => hivek_o.op0.dcache_addr,
        a_data_i_0 => hivek_o.op0.dcache_data,
        a_data_o_0 => hivek_i.op0.dcache_data,

        b_wren_0   => hivek_o.op1.dcache_wren,
        b_addr_0   => hivek_o.op1.dcache_addr,
        b_data_i_0 => hivek_o.op1.dcache_data,
        b_data_o_0 => hivek_i.op1.dcache_data,

        --b_wren_0   => '0',             --hivek_o.op1.dcache_wren,
        --b_addr_0   => vgamem_addr,     --hivek_o.op1.dcache_addr,
        --b_data_i_0 => (others => '0'), --hivek_o.op1.dcache_data,
        --b_data_o_0 => vgamem_data0,     --hivek_i.op1.dcache_data,

        a_wren_1   => input_wren,
        a_addr_1   => input_addr,
        a_data_i_1 => input_data,
        a_data_o_1 => data_dram_led,

        b_wren_1   => '0', 
        b_addr_1   => vgamem_addr,
        b_data_i_1 => (others => '0'),
        b_data_o_1 => vgamem_data1,

        a_wren_2   => '0',
        a_addr_2   => (others => '0'),
        a_data_i_2 => (others => '0'),
        a_data_o_2 => open,

        --a_wren_2   => hivek_o.op1.dcache_wren,--'0',
        --a_addr_2   => hivek_o.op1.dcache_addr,--(others => '0'),
        --a_data_i_2 => hivek_o.op1.dcache_data,--(others => '0'),
        --a_data_o_2 => hivek_i.op1.dcache_data, --open,

        b_wren_2   => '0',
        b_addr_2   => (others => '0'),
        b_data_i_2 => (others => '0'),
        b_data_o_2 => open,

        a_wren_3   => '0',
        a_addr_3   => (others => '0'),
        a_data_i_3 => (others => '0'),
        a_data_o_3 => open,

        b_wren_3   => '0',
        b_addr_3   => (others => '0'),
        b_data_i_3 => (others => '0'),
        b_data_o_3 => open
    ); 

end behavior;

