library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CHORD_Encoder is
    port(clk, rst: in std_logic;
    a: in std_logic_vector(7 downto 0);
    data_valid: out std_logic;
    z: out std_logic_vector(7 downto 0));
end entity;

architecture behaviour of CHORD_Encoder is
    signal output_print: std_logic_vector(255 downto 0) := (others => '0');
    signal process_done: boolean := false;

    signal C: std_logic_vector(7 downto 0) := "01000011";
    signal dsml: std_logic_vector(7 downto 0) := "01100100";
    signal D: std_logic_vector(7 downto 0) := "01000100";
    signal esml: std_logic_vector(7 downto 0) := "01100101";
    signal E: std_logic_vector(7 downto 0) := "01000101";
    signal fsml: std_logic_vector(7 downto 0) := "01100110";
    signal F: std_logic_vector(7 downto 0) := "01000110";
    signal gsml: std_logic_vector(7 downto 0) := "01100111";
    signal G: std_logic_vector(7 downto 0) := "01000111";
    signal asml: std_logic_vector(7 downto 0) := "01100001";
    signal Acap: std_logic_vector(7 downto 0) := "01000001";
    signal bsml: std_logic_vector(7 downto 0) := "01100010";
    signal B: std_logic_vector(7 downto 0) := "01000010";
    signal csml: std_logic_vector(7 downto 0) := "01100011";
    signal M: std_logic_vector(7 downto 0) := "01001101";
    signal msml: std_logic_vector(7 downto 0) := "01101101";
    signal seven: std_logic_vector(7 downto 0) := "00110111";
    signal s: std_logic_vector(7 downto 0) := "01110011";
    signal sharp: std_logic_vector(7 downto 0) := "00011111";

    function std_logic_vector_to_string(input_vector: std_logic_vector) return string is
        variable result_string: string(0 to (input_vector'length-1));
    begin
        for i in 0 to (input_vector'length-1) loop
            case input_vector(i) is
                when '0' =>
                    result_string(i) := '0';  
                when '1' =>
                    result_string(i) := '1';  
                when others =>
                    result_string(i) := '?';  
            end case;
        end loop;
        return result_string;
    end function; 

    begin
        process(clk, rst)
        variable input_count: integer:=0;
        variable state3: std_logic_vector(23 downto 0) := (others => '0');
        variable state4: std_logic_vector(31 downto 0) := (others => '0');
        variable state5: std_logic_vector(39 downto 0) := (others => '0');
        variable state6: std_logic_vector(47 downto 0) := (others => '0');
        variable state7: std_logic_vector(55 downto 0) := (others => '0');
        variable state8: std_logic_vector(63 downto 0) := (others => '0');
        variable state: std_logic_vector(255 downto 0) := (others => '0');
        
        variable output_7: std_logic := '0';
        variable output_M: std_logic := '0';
        variable output_msml: std_logic := '0';
        variable output_s: std_logic := '0';
        
        variable print_z: std_logic_vector(7 downto 0) := (others => '0');
        variable my_op: std_logic_vector(255 downto 0) := (others => '0');
        begin
            if rising_edge(clk) and rst = '1' then
                if input_count /= 32 then
                    state := state(247 downto 0) & a;
                    input_count := input_count + 1;
                end if;

            elsif rising_edge(clk) and rst = '0' and process_done = false then
                    -- data_valid <= '0';
                    -- report "Test= " & std_logic'image(state(1));
                    if (input_count >= 3) then
                        state3 := state((input_count*8)-1 downto (input_count*8)-24);
                    else 
                        state3 := (others => '0');
                    end if;
                    if (input_count >= 4) then
                        state4 := state((input_count*8)-1 downto (input_count*8)-32);
                    else 
                        state4 := (others => '0');
                    end if;
                    if (input_count >= 5) then
                        state5 := state((input_count*8)-1 downto (input_count*8)-40);
                    else 
                        state5 := (others => '0');
                    end if;
                    if (input_count >= 6) then
                        state6 := state((input_count*8)-1 downto (input_count*8)-48);
                    else 
                        state6 := (others => '0');
                    end if;
                    if (input_count >= 7) then
                        state7 := state((input_count*8)-1 downto (input_count*8)-56);
                    else 
                        state7 := (others => '0');
                    end if;
                    if (input_count >= 8) then
                        state8 := state((input_count*8)-1 downto (input_count*8)-64);
                    else 
                        state8 := (others => '0');
                    end if;

                    if (state4 = (C & fsml & G & bsml)) or (state4 = (C & E & G & bsml)) then
                        output_7 := '1';
                        print_z := C;
                        -- report "Hello = " & integer'image(input_count) severity note;
                        input_count := input_count-4;
                        -- report "Hello = " & integer'image(input_count) severity note;

                    elsif state5 = C & fsml & G & Acap & sharp or state5 = C & E & G & Acap & sharp or state5 = B & sharp & fsml & G & bsml or state5 = B & sharp & E & G & bsml then
                        output_7 := '1';
                        print_z := C;
                        input_count :=  input_count-5;
                    elsif state6 = B & sharp & fsml & G & Acap & sharp or state6 = B & sharp & E & G & Acap & sharp then
                        output_7 := '1';
                        print_z := C;
                        input_count :=  input_count-6;
                    elsif state4 = dsml & F & asml & csml or state4 = dsml & F & asml & B then
                        output_7 := '1';
                        print_z := dsml;
                        input_count :=  input_count-4;
                    elsif state5 = dsml & F & G & sharp & csml or state5 = dsml & F & G & sharp & B then
                        output_7 := '1';
                        print_z := dsml;
                        input_count :=  input_count-5;
                    elsif state5 = C & sharp & F & asml & csml or state5 = C & sharp & F & asml & B then
                        output_7 := '1';
                        print_z := dsml;
                        input_count :=  input_count-5;
                    elsif state6 = C & sharp & F & G & sharp & csml or state6 = C & sharp & F & G & sharp & B then
                        output_7 := '1';
                        print_z := dsml;
                        input_count :=  input_count-6;
                    elsif state4 = D & gsml & Acap & C then
                        output_7 := '1';
                        print_z := D;
                        input_count :=  input_count-4;
                    elsif state5 = D & gsml & Acap & B & sharp or state5 = D & F & sharp & Acap & C then
                        output_7 := '1';
                        print_z := D;
                        input_count :=  input_count-5;
                    elsif state6 = D & F & sharp & Acap & B & sharp then
                        output_7 := '1';
                        print_z := D;
                        input_count :=  input_count-6;
                    elsif state4 = esml & G & bsml & dsml then
                        output_7 := '1';
                        print_z := esml;
                        input_count :=  input_count-4;
                    elsif state5 = esml & G & bsml & C & sharp  or state5 = esml & G & Acap & sharp & dsml or state5 = D & sharp & G & bsml & dsml then
                        output_7 := '1';
                        print_z := esml;
                        input_count :=  input_count-5;
                    elsif state6 = esml & G & Acap & sharp & C & sharp or state6 = D & sharp & G & Acap & sharp & dsml or state6 = D & sharp & G & bsml & C & sharp then
                        output_7 := '1';
                        print_z := esml;
                        input_count :=  input_count-6;
                    elsif state7 = D & sharp & G & Acap & sharp & C & sharp then
                        output_7 := '1';
                        print_z := esml;
                        input_count :=  input_count-7;
                    elsif state4 = E & asml & B & D or state4 = E & asml & csml & D or state4 = fsml & asml & B & D or state4 = fsml & asml & csml & D then
                        output_7 := '1';
                        print_z := E;
                        input_count :=  input_count-4;
                    elsif state5 = E & G & sharp & B & D or state5 = E & G & sharp & csml & D or state5 = fsml & G & sharp & B & D or state5 = fsml & G & sharp & csml & D then
                        output_7 := '1';
                        print_z := E;
                        input_count :=  input_count-5;
                    elsif state4 = F & Acap & C & esml then
                        output_7 := '1';
                        print_z := F;
                        input_count :=  input_count-4;
                    elsif state5 = F & Acap & B & sharp & esml or state5 = F & Acap & C & D & sharp then
                        output_7 := '1';
                        print_z := F;
                        input_count :=  input_count-5;
                    elsif state6 = F & Acap & B & sharp & D & sharp then
                        output_7 := '1';
                        print_z := F;
                        input_count :=  input_count-6;
                    elsif state4 = gsml & bsml & dsml & fsml or state4 = gsml & bsml & dsml & E then
                        output_7 := '1';
                        print_z := gsml;
                        input_count :=  input_count-4;
                    elsif state5 = gsml & bsml & C & sharp & fsml or state5 = gsml & bsml & C & sharp & E or state5 = gsml & Acap & sharp & dsml & fsml or state5 = gsml & Acap & sharp & dsml & E or state5 = F & sharp & bsml & dsml & E or state5 = F & sharp & bsml & dsml & fsml then
                        output_7 := '1';
                        print_z := gsml;
                        input_count :=  input_count-5;
                    elsif state6 = gsml & Acap & sharp & C & sharp & fsml or state6 = gsml & Acap & sharp & C & sharp & E or state6 = F & sharp & Acap & sharp & dsml & fsml or state6 = F & sharp & Acap & sharp & dsml & E or state6 = F & sharp & bsml & C & sharp & E or state6 = F & sharp & bsml & C & sharp & fsml then
                        output_7 := '1';
                        print_z := gsml;
                        input_count :=  input_count-6;
                    elsif state7 = F & sharp & Acap & sharp & C & sharp & fsml or state7 = F & sharp & Acap & sharp & C & sharp & E then
                        output_7 := '1';
                        print_z := gsml;
                        input_count :=  input_count-7;
                    elsif state4 = G & B & D & F or state4 = G & csml & D & F then
                        output_7 := '1';
                        print_z := G;
                        input_count :=  input_count-4;
                    elsif state4 = asml & C & esml & gsml then
                        output_7 := '1';
                        print_z := asml;
                        input_count :=  input_count-4;
                    elsif state5 = asml & C & esml & F & sharp or state5 = asml & C & D & sharp & gsml or state5 = asml & B & sharp & esml & gsml or state5 = G & sharp & C & esml & gsml then
                        output_7 := '1';
                        print_z := asml;
                        input_count :=  input_count-5;
                    elsif state6 = asml & C & D & sharp & F & sharp or state6 = asml & B & sharp & esml & F & sharp or state6 = G & sharp & C & esml & F & sharp or state6 = asml & B & sharp & D & sharp & gsml or state6 = G & sharp & C & D & sharp & gsml or state6 = G & sharp & B & sharp & esml & gsml then
                        output_7 := '1';
                        print_z := asml;
                        input_count :=  input_count-6;
                    elsif state7 = asml & B & sharp & D & sharp & F & sharp or state7 = G & sharp & C & D & sharp & F & sharp or state7 = G & sharp & B & sharp & esml & F & sharp or state7 = G & sharp & B & sharp & D & sharp & gsml then
                        output_7 := '1';
                        print_z := asml;
                        input_count :=  input_count-7;
                    elsif state8 = G & sharp & B & sharp & D & sharp & F & sharp then
                        output_7 := '1';
                        print_z := asml;
                        input_count :=  input_count-8;
                    elsif state4 = Acap & dsml & E & G or state4 = Acap & dsml & fsml & G then
                        output_7 := '1';
                        print_z := Acap;
                        input_count :=  input_count-4;
                    elsif state5 = Acap & C & sharp & E & G or state5 = Acap & C & sharp & fsml & G then
                        output_7 := '1';
                        print_z := Acap;
                        input_count :=  input_count-5;
                    elsif state4 = bsml & D & F & asml then
                        output_7 := '1';
                        print_z := bsml;
                        input_count :=  input_count-4;
                    elsif state5 = bsml & D & F & G & sharp or state5 = Acap & sharp & D & F & asml then
                        output_7 := '1';
                        print_z := bsml;
                        input_count :=  input_count-5;
                    elsif state6 = Acap & sharp & D & F & G & sharp then
                        output_7 := '1';
                        print_z := bsml;
                        input_count :=  input_count-6;
                    elsif state4 = B & esml & gsml & Acap or state4 = csml & esml & gsml & Acap then
                        output_7 := '1';
                        print_z := B;
                        input_count :=  input_count-4;
                    elsif state5 = B & D & sharp & gsml & Acap or state5 = csml & D & sharp & gsml & Acap or state5 = B & esml & F & sharp & Acap or state5 = csml & esml & F & sharp & Acap then
                        output_7 := '1';
                        print_z := B;
                        input_count :=  input_count-5;
                    elsif state6 = B & D & sharp & F & sharp & Acap or state6 = csml & D & sharp & F & sharp & Acap then
                        output_7 := '1';
                        print_z := B;
                        input_count :=  input_count-6;
                    elsif state3 = dsml & F & asml then
                        output_M := '1';
                        print_z := dsml;
                        input_count :=  input_count-3;
                    elsif state4 = C & sharp & F & asml or state4 = dsml & F & G & sharp then
                        output_M := '1';
                        print_z := dsml;
                        input_count :=  input_count-4;
                    elsif state5 = C & sharp & F & G & sharp then
                        output_M := '1';
                        print_z := dsml;
                        input_count :=  input_count-5;
                    elsif state3 = D & gsml & Acap then
                        output_M := '1';
                        print_z := D;
                        input_count :=  input_count-3;
                    elsif state4 = D & F & sharp & Acap then
                        output_M := '1';
                        print_z := D;
                        input_count :=  input_count-4;
                    elsif state3 = esml & G & bsml then
                        output_M := '1';
                        print_z := esml;
                        input_count :=  input_count-3;
                    elsif state4 = esml & G & Acap & sharp or state4 = D & sharp & G & bsml then
                        output_M := '1';
                        print_z := esml;
                        input_count :=  input_count-4;
                    elsif state5 = D & sharp & G & Acap & sharp then
                        output_M := '1';
                        print_z := esml;
                        input_count :=  input_count-5;
                    elsif state3 = E & asml & B or state3 = E & asml & csml or state3 = fsml & asml & B or state3 = fsml & asml & csml then
                        output_M := '1';
                        print_z := E;
                        input_count :=  input_count-3;
                    elsif state4 = E & G & sharp & B or state4 = E & G & sharp & csml or state4 = fsml & G & sharp & B or state4 = fsml & G & sharp & csml then
                        output_M := '1';
                        print_z := E;
                        input_count :=  input_count-4;
                    elsif state3 = F & Acap & C then
                        output_M := '1';
                        print_z := F;
                        input_count :=  input_count-3;
                    elsif state4 = F & Acap & B & sharp then
                        output_M := '1';
                        print_z := F;
                        input_count :=  input_count-4;
                    elsif state3 = gsml & bsml & dsml then
                        output_M := '1';
                        print_z := gsml;
                        input_count :=  input_count-3;
                    elsif state4 = gsml & bsml & C & sharp or state4 = gsml & Acap & sharp & dsml or state4 = F & sharp & bsml & dsml then
                        output_M := '1';
                        print_z := gsml;
                        input_count :=  input_count-4;
                    elsif state5 = gsml & Acap & sharp & C & sharp or state5 = F & sharp & Acap & sharp & dsml or state5 = F & sharp & bsml & C & sharp then
                        output_M := '1';
                        print_z := gsml;
                        input_count :=  input_count-5;
                    elsif state6 = F & sharp & Acap & sharp & C & sharp then
                        output_M := '1';
                        print_z := gsml;
                        input_count :=  input_count-6;
                    elsif state3 = G & B & D or state3 = G & csml & D then
                        output_M := '1';
                        print_z := G;
                        input_count :=  input_count-3;
                    elsif state3 = asml & C & esml then
                        output_M := '1';
                        print_z := asml;
                        input_count :=  input_count-3;
                    elsif state4 = asml & C & D & sharp or state4 = asml & B & sharp & esml or state4 = G & sharp & csml & esml then
                        output_M := '1';
                        print_z := asml;
                        input_count :=  input_count-4;
                    elsif state5 = asml & B & sharp & D & sharp or state5 = G & sharp & B & sharp & esml or state5 = G & sharp & C & D & sharp then
                        output_M := '1';
                        print_z := asml;
                        input_count :=  input_count-5;
                    elsif state6 = G & sharp & B & sharp & D & sharp then
                        output_M := '1';
                        print_z := asml;
                        input_count :=  input_count-6;
                    elsif state3 = Acap & dsml & E or state3 = Acap & dsml & fsml then
                        output_M := '1';
                        print_z := Acap;
                        input_count :=  input_count-3;
                    elsif state4 = Acap & C & sharp & E or state4 = Acap & C & sharp & fsml then
                        output_M := '1';
                        print_z := Acap;
                        input_count :=  input_count-4;
                    elsif state3 = bsml & D & F then
                        output_M := '1';
                        print_z := bsml;
                        input_count :=  input_count-3;
                    elsif state4 = Acap & sharp & D & F then
                        output_M := '1';
                        print_z := bsml;
                        input_count :=  input_count-4;
                    elsif state3 = B & esml & gsml or state3 = csml & esml & gsml then
                        output_M := '1';
                        print_z := B;
                        input_count :=  input_count-3;
                    elsif state4 = B & D & sharp & gsml or state4 = csml & D & sharp & F & sharp or state4 = B & esml & gsml or state4 = csml & esml & F & sharp then
                        output_M := '1';
                        print_z := B;
                        input_count :=  input_count-4;
                    elsif state5 = B & D & sharp & F & sharp or state4 = csml & D & sharp & F & sharp then
                        output_M := '1';
                        print_z := B;
                        input_count :=  input_count-5;
                    elsif state3 = C & E & G or state3 = C & fsml & G then
                        output_M := '1';
                        print_z := C;
                        input_count :=  input_count-3;
                    elsif state4 = B & sharp & E & G or state4 = B & sharp & fsml & G then
                        output_M := '1';
                        print_z := C;
                        input_count :=  input_count-4;
                    elsif state3 = dsml & E & asml or state3 = dsml & fsml & asml then
                        output_msml:= '1';
                        print_z := dsml;
                        input_count :=  input_count-3;
                    elsif state4 = C & sharp & fsml & asml or state4 = dsml & fsml & G & sharp or state4 = C & sharp & E & asml or state4 = dsml & E & G & sharp then
                        output_msml:= '1';
                        print_z := dsml;
                        input_count :=  input_count-4;
                    elsif state5 = C & sharp & E & G & sharp or state5 = C & sharp & fsml & G & sharp then
                        output_msml:= '1';
                        print_z := dsml;
                        input_count :=  input_count-5;
                    elsif state3 = D & F & Acap then
                        output_msml:= '1';
                        print_z := D;
                        input_count :=  input_count-3;
                    elsif state3 = esml & gsml & bsml then
                        output_msml:= '1';
                        print_z := esml;
                        input_count :=  input_count-3;
                    elsif state4 = esml & gsml & Acap & sharp or state4 = D & sharp & gsml & bsml or state4 = esml & F & sharp & bsml then
                        output_msml:= '1';
                        print_z := esml;
                        input_count :=  input_count-4;
                    elsif state5 = D & sharp & gsml & Acap & sharp or state5 = D & sharp & F & sharp & bsml or state5 = esml & F & sharp & Acap & sharp then
                        output_msml:= '1';
                        print_z := esml;
                        input_count :=  input_count-5;
                    elsif state6 = D & sharp & F & sharp & Acap & sharp then
                        output_msml:= '1';
                        print_z := esml;
                        input_count :=  input_count-6;
                    elsif state3 = E & G & B or state3 = E & G & csml or state3 = fsml & G & B or state3 = fsml & G & csml then
                        output_msml:= '1';
                        print_z := E;
                        input_count :=  input_count-3;
                    elsif state3 = F & asml & C then
                        output_msml:= '1';
                        print_z := F;
                        input_count :=  input_count-3;
                    elsif state4 = F & asml & B & sharp or state4 = F & G & sharp & C then
                        output_msml:= '1';
                        print_z := F;
                        input_count :=  input_count-4;
                    elsif state5 = F & G & sharp & B & sharp then
                        output_msml:= '1';
                        print_z := F;
                        input_count :=  input_count-5;
                    elsif state3 = gsml & Acap & dsml then
                        output_msml:= '1';
                        print_z := gsml;
                        input_count :=  input_count-3;
                    elsif state4 = gsml & Acap & C & sharp or state4 = F & sharp & Acap & dsml then
                        output_msml:= '1';
                        print_z := gsml;
                        input_count :=  input_count-4;
                    elsif state5 = F & sharp & Acap & C & sharp then
                        output_msml:= '1';
                        print_z := gsml;
                        input_count :=  input_count-5;
                    elsif state3 = G & bsml & D then
                        output_msml:= '1';
                        print_z := G;
                        input_count :=  input_count-3;
                    elsif state4 = G & Acap & sharp & D then
                        output_msml:= '1';
                        print_z := G;
                        input_count :=  input_count-4;
                    elsif state3 = asml & B & esml or state3 = asml & csml & esml then
                        output_msml:= '1';
                        print_z := asml;
                        input_count :=  input_count-3;
                    elsif state4 = asml & B & D & sharp or state4 = asml & csml & D & sharp then
                        output_msml:= '1';
                        print_z := asml;
                        input_count :=  input_count-4;
                    elsif state5 = G & sharp & B & D & sharp or state5 = G & sharp & csml & D & sharp then
                        output_msml:= '1';
                        print_z := asml;
                        input_count :=  input_count-5;
                    elsif state3 = Acap & C & E or state3 = Acap & C & fsml then
                        output_msml:= '1';
                        print_z := Acap;
                        input_count :=  input_count-3;
                    elsif state4 = Acap & B & sharp & E or state4 = Acap & B & sharp & fsml then
                        output_msml:= '1';
                        print_z := Acap;
                        input_count :=  input_count-4;
                    elsif state3 = bsml & dsml & F then
                        output_msml:= '1';
                        print_z := bsml;
                        input_count :=  input_count-3;
                    elsif state4 = Acap & sharp & D & F or state4 = bsml & C & sharp & F then
                        output_msml:= '1';
                        print_z := bsml;
                        input_count :=  input_count-4;
                    elsif state5 = Acap & sharp & C & sharp & F then
                        output_msml:= '1';
                        print_z := bsml;
                        input_count :=  input_count-5;
                    elsif state3 = B & D & gsml or state3 = csml & D & g then
                        output_msml:= '1';
                        print_z := B;
                        input_count :=  input_count-3;
                    elsif state4 = csml & D & F & sharp or state4 = B & D & F & sharp then
                        output_msml:= '1';
                        print_z := B;
                        input_count :=  input_count-4;
                    elsif state3 = C & esml & G then
                        output_msml:= '1';
                        print_z := C;
                        input_count :=  input_count-3;
                    elsif state4 = B & sharp & esml & G or state4 = C & D & sharp & G then
                        output_msml:= '1';
                        print_z := C;
                        input_count :=  input_count-4;
                    elsif state5 = B & sharp & D & sharp & G then
                        output_msml:= '1';
                        print_z := C;
                        input_count :=  input_count-5;
                    elsif state3 = dsml & gsml & asml then
                        output_s := '1';
                        print_z := dsml;
                        input_count :=  input_count-3;
                    elsif state4 = C & sharp & gsml & asml or state4 = dsml & gsml & G & sharp or state4 = dsml & F & sharp & asml then
                        output_s := '1';
                        print_z := dsml;
                        input_count :=  input_count-4;
                    elsif state5 = C & sharp & gsml & G & sharp or state5 = C & sharp & F & sharp & asml or state5 = dsml & F & sharp & sharp & G & sharp then
                        output_s := '1';
                        print_z := dsml;
                        input_count :=  input_count-5;
                    elsif state6 = C & sharp & F & sharp & G & sharp then
                        output_s := '1';
                        print_z := dsml;
                        input_count :=  input_count-6;
                    elsif state3 = D & G & Acap then
                        output_s := '1';
                        print_z := D;
                        input_count :=  input_count-3;
                    elsif state3 = esml & asml & bsml then
                        output_s := '1';
                        print_z := dsml;
                        input_count :=  input_count-3;
                    elsif state4 = D & sharp & asml & bsml or state4 = esml & asml & Acap & sharp or state4 = esml & G & sharp & bsml then
                        output_s := '1';
                        print_z := dsml;
                        input_count :=  input_count-4;
                    elsif state5 = D & sharp & asml & Acap & sharp or state5 = D & sharp & G & sharp & bsml or state5 = esml & G & sharp & Acap & sharp then
                        output_s := '1';
                        print_z := dsml;
                        input_count :=  input_count-5;
                    elsif state6 = D & sharp & G & sharp & Acap & sharp then
                        output_s := '1';
                        print_z := dsml;
                        input_count :=  input_count-6;
                    elsif state3 = E & Acap & B or state3 = E & Acap & csml or state3 = fsml & Acap & B or state3 = fsml & Acap & csml then
                        output_s := '1';
                        print_z := E;
                        input_count :=  input_count-3;
                    elsif state3 = F & bsml & C then
                        output_s := '1';
                        print_z := F;
                        input_count :=  input_count-3;
                    elsif state4 = F & bsml & B & sharp or state4 = F & Acap & sharp & C then
                        output_s := '1';
                        print_z := F;
                        input_count :=  input_count-4;
                    elsif state5 = F & Acap & sharp & B & sharp then
                        output_s := '1';
                        print_z := F;
                        input_count :=  input_count-5;
                    elsif state3 = gsml & B & dsml or state3 = gsml & csml & dsml then
                        output_s := '1';
                        print_z := gsml;
                        input_count :=  input_count-3;
                    elsif state4 = gsml & B & C & sharp or state4 = gsml & csml & C & sharp or state4 = F & sharp & csml & dsml or state4 = F & sharp & B & dsml then
                        output_s := '1';
                        print_z := gsml;
                        input_count :=  input_count-4;
                    elsif state5 = F & sharp & B & C & sharp or state5 = F & sharp & csml & C & sharp then
                        output_s := '1';
                        print_z := gsml;
                        input_count :=  input_count-5;
                    elsif state3 = G & C & D then
                        output_s := '1';
                        print_z := G;
                        input_count :=  input_count-3;
                    elsif state4 = G & B & sharp & D then
                        output_s := '1';
                        print_z := G;
                        input_count :=  input_count-4;
                    elsif state3 = asml & dsml & esml then
                        output_s := '1';
                        print_z := asml;
                        input_count :=  input_count-3;
                    elsif state4 = asml & dsml & D & sharp or state4 = asml & csml & sharp & esml or state4 = G & sharp & dsml & esml then
                        output_s := '1';
                        print_z := asml;
                        input_count :=  input_count-4;
                    elsif state5 = asml & C & sharp & D & sharp or state5 = G & sharp & C & sharp & esml or state5 = G & sharp & dsml & D & sharp then
                        output_s := '1';
                        print_z := asml;
                        input_count :=  input_count-5;
                    elsif state6 = G & sharp & C & sharp & D & sharp then
                        output_s := '1';
                        print_z := asml;
                        input_count :=  input_count-6;
                    elsif state3 = Acap & D & E or state3 = Acap & D & fsml then
                        output_s := '1';
                        print_z := Acap;
                        input_count :=  input_count-3;
                    elsif state3 = bsml & esml & F then
                        output_s := '1';
                        print_z := bsml;
                        input_count :=  input_count-3;
                    elsif state4 = Acap & sharp & esml & F or state4 = bsml & D & sharp & F then
                        output_s := '1';
                        print_z := bsml;
                        input_count :=  input_count-4;
                    elsif state5 = Acap & sharp & D & sharp & F then
                        output_s := '1';
                        print_z := bsml;
                        input_count :=  input_count-5;
                    elsif state3 = B & E & gsml or state3 = csml & E & gsml or state3 = B & fsml & gsml or state3 = csml & fsml & gsml then
                        output_s := '1';
                        print_z := B;
                        input_count :=  input_count-3;
                    elsif state4 = B & E & F & sharp or state4 = csml & E & F & sharp or state4 = B & fsml & F & sharp or state4 = csml & fsml & F & sharp then
                        output_s := '1';
                        print_z := B;
                        input_count :=  input_count-4;
                    elsif state3 = C & F & G then
                        output_s := '1';
                        print_z := C;
                        input_count :=  input_count-3;
                    elsif state4 = B & sharp & F & G then
                        output_s := '1';
                        print_z := C;
                        input_count :=  input_count-4;
                    end if;

                    if output_7 = '1' then
                        my_op := my_op(247 downto 0) & print_z;
                        my_op := my_op(247 downto 0) & seven;
                        output_7 := '0';
                    elsif output_M = '1' then
                        my_op := my_op(247 downto 0) & print_z;
                        my_op := my_op(247 downto 0) & M;
                        output_M := '0';
                    elsif output_msml = '1' then
                        my_op := my_op(247 downto 0) & print_z;
                        my_op := my_op(247 downto 0) & msml;
                        output_msml:= '0';
                    elsif output_s = '1' then
                        my_op := my_op(247 downto 0) & print_z;
                        my_op := my_op(247 downto 0) & s;
                        output_s := '0';
                    else
                        if input_count > 0 then
                            my_op := my_op(247 downto 0) & state((input_count*8)-1 downto (input_count*8)-8);
                            -- report "Input_var = " & integer'image(input_count) severity note;
                            input_count :=  input_count- 1;
                        else
                            process_done <= true;  
                            -- data_valid <= '1';
                            -- report "Input_var = " & std_logic_vector_to_string(state) severity note;
                        end if;
                    end if;

                    if input_count <= 0 then
                        process_done <= true;
                        -- report "input count = " & 
                        -- report "output = " & std_logic_vector_to_string(my_op) severity note;
                        -- report std_logic_vector'image(state4) severity note;
                    end if;
                end if;
                output_print <= my_op;
        end process;

        process(clk, rst)
        variable output_buffer: std_logic_vector(7 downto 0) := (others => '0');
        variable opi: integer := 32;
        begin
            if rst = '1' then
                -- output_buffer := (others => '0');
                -- output_index <= 32;
                -- z <= (others => '0');
                -- data_valid <= '0';
            elsif rising_edge(clk) and process_done = true then
                if opi > 0 then  -- Corrected condition
                    
                    data_valid <= '0';
                    output_buffer := output_print((8 * opi) - 1 downto (8 * opi) - 8);
                    z <= output_buffer;
                    opi := opi - 1;
                    data_valid <= '1';
                else
                    z <= "00000000";
                end if;
            end if;
        end process;
end architecture;