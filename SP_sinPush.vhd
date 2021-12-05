library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FSM is

port(

	CLK, RESET, X, U: in STD_LOGIC;  --X representa el peso mayor a cierta cantidad, U medida ultrasonico para altura tapa
	Y: out STD_LOGIC		 --Y es igual a 1 cuando se termino un ciclo de trabajo
);

end FSM;

architecture Behavior of FSM is

type State is (Llenado,Sellado,Rotacion);

signal CurrentState, NextState: State;

begin


	--PRIMER PROCESO ---- Cambios de estado en los registros
	registers: process(CLK, RESET)
	begin
		if RESET='1' then
			CurrentState <=Llenado;
		elsif Rising_edge(CLK) then
			CurrentState<=NextState;
		end if;
	end process registers;


	--SEGUNDO PROCESO--  Switch case para los estados
	combinational: process (CurrentState,X,U)
	begin

		--Inicializar valores
		NextState <= CurrentState;
		Y<= '0';

		--Case
		case CurrentState is
	
	-- Llenado
		when Llenado =>				
        	Y <= '0';
		if X='1' then
			NextState <= Sellado;		-- si X = 1, se termino de llenar y pasa a sellado
            	else
            		NextState <= Llenado;		-- si X = 0, no se ha llegado al peso, sigue en llenado
		end if;
		
	--Sellado
		when Sellado =>				
        	Y <= '0';
		if U='1' then
			NextState <= Rotacion;		-- si U = 1, ya se puso tapa y pasa a rotacion
            	else
            		NextState <= Sellado;		-- si U = 0, todavia no se pone tapa y sigue en sellado
		end if;

	-- Rotación	
		when Rotacion =>						
        	Y <= '1';				-- Se marca salida de ciclo terminado		
		if X='1' then
			NextState <= Rotacion;		-- si X = 1, todavia no se retira el frasco, sigue en rotacion
            	else
            		NextState <= Llenado;		-- si X = 0, ya se retiro el frasco se reinicia el ciclo y se pasa a siguiente frasco
		end if;

	-- Otros
		when others =>				-- Cualquier otro caso para CurrentState
			Y <= '0';
			NextState <= Llenado;
		end case;
		
end process combinational;

end architecture Behavior;
		
