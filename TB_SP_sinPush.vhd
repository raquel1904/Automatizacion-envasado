library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity FSM_tb is
end entity FSM_tb;

architecture verify of FSM_tb is

  signal Clk, RESET, X,U: STD_LOGIC := '0';
  signal Y: STD_LOGIC;

begin

  DUT: entity work.FSM(Behavior) port map (CLK=>Clk, RESET=> RESET, X=>X,U=>U,Y=>Y);

  Clk_gen: process
  begin
    while Now < 600 ns loop
      Clk <= '0';
      wait for 5 ns;
      Clk <= '1';
      wait for 5 ns;
    end loop;
    wait;
  end process Clk_gen;

  Entries: process
  begin
    	Reset <= '1';
   	X <= '0';
    
    	wait until falling_edge(Clk);
	Reset <= '0';
    	X <= '0';
    
    	wait until rising_edge(Clk);
    	wait until rising_edge(Clk);
	X<='1';
	wait until falling_edge(Clk);
	
	wait until falling_edge(Clk);
   	U<='1';
    	wait until rising_edge(Clk);
    	wait until rising_edge(Clk);
	X<='0';
	wait until rising_edge(Clk);
	wait until rising_edge(Clk);

  end process Entries;

end architecture verify;
