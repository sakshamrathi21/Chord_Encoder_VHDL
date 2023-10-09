library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity ASCII_Read_test is
end entity;

architecture reader of ASCII_Read_test is
	component CHORD_Encoder
	    port(clk, rst: in std_logic;
	    a: in std_logic_vector(7 downto 0);
	    data_valid: out std_logic;
	    z: out std_logic_vector(7 downto 0));
	end component;
	signal input_sig, output_sig: std_logic_vector (7 downto 0);
	signal clk, rst, data_valid : std_logic;

    -- function std_logic_vector_to_string(input_vector: std_logic_vector) return string is
    --     variable result_string: string(0 to (input_vector'length-1));
    -- begin
    --     for i in 0 to (input_vector'length-1) loop
    --         case input_vector(i) is
    --             when '0' =>
    --                 result_string(i) := '0';  -- Adjust the index to start from 1
    --             when '1' =>
    --                 result_string(i) := '1';  -- Adjust the index to start from 1
    --             when others =>
    --                 result_string(i) := '?';  -- Handle other cases as needed
    --         end case;
    --     end loop;
    --     return result_string;
    -- end function;    
    

begin
	dut_instance: CHORD_Encoder
		port map (a => input_sig, clk => clk, z => output_sig, data_valid => data_valid, rst => rst);
	
	process
		file input_file: text open read_mode is "test.txt";
		file output_file: text open write_mode is "out.txt";
		variable input_line, output_line: line;
		variable input_var, output_var, input_rev : std_logic_vector (7 downto 0);
        constant empty_line: string := ""; -- Define an empty line as a line feed character
	begin
        rst <= '1';
		while not endfile(input_file) loop  
            -- rst <= '1';
            -- report "Hello";
			readline (input_file, input_line);
            if input_line.all /= empty_line then
                read (input_line, input_var);
                input_sig <= input_var;
                clk <= '0';
                wait for 1 ns;
                clk <= '1';
                wait for 1 ns;
            end if;
            
        end loop;
            
        -- report "Input_var = " & std_logic_vector_to_string(state) severity note;
        clk <= '0';
        rst <= '0';
        for i in 1 to 2000 loop
			clk <= '0';
            wait for 1 ns;
			clk <= '1';
			wait for 1 ns;
            if data_valid = '1' then
                output_var := output_sig;
                -- report std_logic_vector_to_string(output_sig) severity note;
                if (output_var /= "00000000") then
                    write (output_line, output_var);
                    writeline (output_file, output_line);
                end if;
            end if;
			
		end loop;
	wait;
	end process;
end architecture;