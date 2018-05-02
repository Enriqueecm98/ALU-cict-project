library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;    -- needed for +/- operations

-- Input/output description
entity top is
port (
        		BTN0: in std_logic;     -- button 0
        		BTN1: in std_logic;     -- button 1
       		    SW0: in std_logic;      -- switch 0
        		SW1: in std_logic;      -- switch 1
        		D_POS: out std_logic_vector(3 downto 0);    -- display positions
        		D_SEG: out std_logic_vector(6 downto 0)     -- display segments
 	);
end top;

-- Internal structure description
architecture Behavioral of top is
    -- internal signal definitions
    signal variable1: std_logic_vector(3 downto 0) :="0000";
    signal inp_a: std_logic_vector(3 downto 0) :="0000";
    signal inp_b: std_logic_vector(3 downto 0) :="0000";
    signal inp_alu: std_logic_vector(3 downto 0) :="0000";

    
begin
    process(SW1,SW0,BTN0,BTN1)
    begin
        if SW1='0' then 
            if SW0='0' then                
                if BTN0='0' then 
                    inp_a <= "0000";
                end if;
                if BTN1='0' then
                    inp_a <= inp_a + 1;
                end if;
            else 
                if BTN0 = '0' then 
                    inp_b <= "0000";
                end if;
                if BTN1 = '0' then
                    inp_b <= inp_b + 1;
                end if;
            end if;
        else
            if SW0='1' then 
                if BTN0 = '0' then
                    inp_alu <= inp_a - inp_b;
                else
                    inp_alu <= inp_a  + inp_b;               
                end if;
            else 
                if BTN0='0' then
                    inp_alu <= inp_a or inp_b;
                    if BTN1='0' then
                        inp_alu <= inp_a nand inp_b;
                    end if;
                end if;
                if BTN1='0' then 
                    inp_alu <= inp_a and inp_b;
                else 
                    inp_alu <= inp_a xor inp_b;
                end if;	
            end if;
        end if; 
    end process;
    
    process(SW1,SW0)
    begin
        if SW1 = '0' then 
            if SW0 = '0' then
                variable1 <= inp_a;
            else
                variable1 <= inp_b;
            end if;
        else 
            variable1 <= inp_alu;
        end if;
    end process;


with variable1 select 
		D_SEG <= "1111001" when "0001", 
                 "0100100" when "0010",
                 "0110000" when "0011",
                 "0011001" when "0100",   
                 "0010010" when "0101",
                 "0000010" when "0110",
                 "1111000" when "0111", 
                 "0000000" when "1000",
                 "0011000" when "1001",
                 "0001000" when "1010",   
                 "0000011" when "1011",
                 "1000110" when "1100",
                 "0100001" when "1101",
                 "0000110" when "1110",			             
                 "1000000" when others;   

    D_POS <= "1110";
end Behavioral;