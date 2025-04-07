-- ENGENHEIRO RESPONSÁVEL: Eder Nonato Machado
-- RU/CREA DO ENGENHEIRO: 3881863

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EDER_NALOTO_MACHADO_RU_3881863 is
  port (
    input_clock     : in  std_logic;  -- Sinal de clock principal do sistema
    input_enable    : in  std_logic;  -- Habilita operações no contador
    input_control   : in  std_logic;  -- Controle de atualização do contador
    input_mode      : in  std_logic;  -- Seletor de modo (0 = Incremento, 1 = Decremento)
    output_led0     : out std_logic;  -- Saída conectada ao bit menos significativo
    output_led1     : out std_logic;  -- Saída intermediária 1
    output_led2     : out std_logic;  -- Saída intermediária 2
    output_led3     : out std_logic   -- Saída conectada ao bit mais significativo
  );
end entity EDER_NALOTO_MACHADO_RU_3881863;

architecture arch of EDER_NALOTO_MACHADO_RU_3881863 is
  -- Registradores internos para controle de estado
  signal previous_control_state : std_logic := '0';  -- Armazena o estado anterior de "input_control"
  signal previous_mode_state    : std_logic := '0';  -- Armazena o estado anterior de "input_mode"
  signal counter_value          : unsigned(3 downto 0) := (others => '0');  -- Contador principal

begin

  -- Processo Sequencial Síncrono
  process(input_clock)
    variable detect_mode_rising_edge : boolean := false;  -- Detecta borda de subida no seletor de modo
    variable detect_control_falling_edge : boolean := false;  -- Detecta borda de descida no sinal de controle
  begin
    if rising_edge(input_clock) then
      -- Atualiza os estados anteriores das entradas
      previous_control_state <= input_control;
      previous_mode_state <= input_mode;

      -- Detecta borda de subida no seletor de modo
      detect_mode_rising_edge := (previous_mode_state = '0' and input_mode = '1');

      -- Detecta borda de descida no sinal de controle
      detect_control_falling_edge := (previous_control_state = '1' and input_control = '0');

      -- Executa a lógica com base nas detecções
      if detect_mode_rising_edge then
        counter_value <= not counter_value;  -- Inverte todos os bits do contador

      elsif detect_control_falling_edge then
        -- Lógica de operação baseada no modo selecionado
        if input_mode = '0' then  -- MODO INCREMENTAL
          if input_enable = '1' then
            if counter_value = "1111" then
              counter_value <= "0000";  -- Reinicia em caso de overflow
            else
              counter_value <= counter_value + 1;  -- Incrementa o contador
            end if;
          else
            counter_value <= "0000";  -- Zera o contador quando desabilitado
          end if;

        else  -- MODO DECREMENTAL
          if counter_value = "0000" then
            counter_value <= "1111";  -- Satura em caso de underflow
          else
            counter_value <= counter_value - 1;  -- Decrementa o contador
          end if;
        end if;
      end if;
    end if;
  end process;

  -- Conexão direta dos bits do contador às saídas de LED
  output_led0 <= counter_value(0);  -- Bit menos significativo
  output_led1 <= counter_value(1);
  output_led2 <= counter_value(2);
  output_led3 <= counter_value(3);  -- Bit mais significativo

end architecture arch;
