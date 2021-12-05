library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Sitprob is

port(

-- Reset = switch 1, X = switch 2, U = switch 3 

	CLK, RESET, X, U: in STD_LOGIC;  --X representa el peso mayor a cierta cantidad, U medida ultrasonico para altura tapa
	Y, rw ,en, rs: out STD_LOGIC;    --Y es igual a 1 cuando se termino un ciclo de trabajo
	data: out std_logic_vector(7 downto 0)
	
);

end Sitprob;

architecture Behavior of Sitprob is

type State is (Llenado,Sellado,Rotacion);

signal CurrentState, NextState: State;

constant N: integer := 39;
 type arr is array (1 to N) of std_logic_vector(7 downto 0);
 constant info1: arr := (X"38",X"0c",X"06",X"01",X"80",X"4c",x"6c",x"65",x"6e",x"61",x"64",x"6f",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"C0",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",X"53"); --command and data to display
 constant info2: arr := (X"38",X"0c",X"06",X"01",X"80",X"53",x"65",x"6c",x"6c",x"61",x"64",x"6f",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"C0",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",X"53");
 constant info3: arr := (X"38",X"0c",X"06",X"01",X"80",X"52",x"6f",x"74",x"61",x"63",x"69",x"6f",x"6e",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"C0",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",X"53");
 
 
begin
 rw <= '0';  --lcd write

	--PRIMER PROCESO ---- Cambios de estado en los registros
	registers: process(CLK, RESET)
	variable info: arr;

	begin
	
		if RESET='1' then
			CurrentState <=Llenado;
		--	while RESET='1' loop
			--end loop;
--	   elsif  RESET'event and RESET = '0' then
	--		if (U='1' or X='1') then
		--		info := info4; 
		--	end if; 
			
		elsif Rising_edge(CLK) then
			CurrentState<=NextState;
		end if;
	end process registers;


	--SEGUNDO PROCESO--  Switch case para los estados
	combinational: process (CurrentState,X,U,CLK)
variable info: arr;
variable i: integer := 0;
variable j: integer := 1;
	begin

		--Inicializar valores
		NextState <= CurrentState;
		Y<= '0';

		--Case
		case CurrentState is
	
	-- Llenado
		when Llenado =>				
        	Y <= '0';
			info := info1;
		if X='0' then
			NextState <= Sellado;		-- si X = 1, se termino de llenar y pasa a sellado
            	else
            		NextState <= Llenado;		-- si X = 0, no se ha llegado al peso, sigue en llenado
		end if;
		
	--Sellado
		when Sellado =>				
        	Y <= '0';
			info := info2;
		if U='0' then
			NextState <= Rotacion;		-- si U = 1, ya se puso tapa y pasa a rotacion
            	else
            		NextState <= Sellado;		-- si U = 0, todavia no se pone tapa y sigue en sellado
		
		end if;

	-- Rotación	
		when Rotacion =>						
        	Y <= '1';				-- Se marca salida de ciclo terminado
			info := info3;
		if X='0' then
			NextState <= Rotacion;		-- si X = 1, todavia no se retira el frasco, sigue en rotacion
            	else
            		NextState <= Llenado;		-- si X = 0, ya se retiro el frasco se reinicia el ciclo y se pasa a siguiente frasco
		end if;

	-- Otros
		when others =>				-- Cualquier otro caso para CurrentState
			Y <= '0';
			NextState <= Llenado;
		end case;
		
	if  CLK'event and CLK = '1' then
   if i <= 10000 then
	 i := i + 1;
	 en <= '1';
    data <= info(j)(7 downto 0);
	elsif i > 10000 and i < 20000 then
    i := i + 1;
    en <= '0';
   elsif i = 20000 then
    j := j + 1;
    i := 0;
   end if;
	
	 if j <= 5 then
    rs <= '0';    --command signal
	 elsif j = 22 then
	  rs <= '0';
    else
    rs <= '1';   --data signal
   end if;
	
	 if j = 39 then  --repeated display of data
    j := 5;
	end if;
end if;
		
end process combinational;

end architecture Behavior;