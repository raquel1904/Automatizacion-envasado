# Automatizacion-envasado
La empresa Bayer de México tiene la necesidad de introducir un diseño de lógica de control para el llenado de los botes que contienen pastillas. Esto se requiere hacer a través del uso de sensores y actuadores disponibles del prototipo de una máquina envasadora y además, de FPGA programables en HDL. 

La motivación para resolver este problema es que Bayer es una empresa internacional que necesita agilizar sus procesos debido a que cada día deben envasar grandes cantidades de pastillas con un error mínimo y hacerlo de manera autónoma para poder cumplir con la demanda y evitar pérdidas económicas. 

Este documento presenta el análisis de una posible solución que Bayer puede implementar para resolver esta problemática.

# Documentos
SP_completo : Código completo en VHDL para implementación de la máquina de estados en la tarjeta DE10 Lite

SP_sinPush y TB_SP_sinPush : Código que muestra el funcionamiento de la máquina de estados. (no considera la tarjeta DE10 Lite)

SP y TB_FSM : Código que muestra el funcionamiento de la máquina de estados considerando el push button.

# Propuesta de máquina de estados
![maquina](https://user-images.githubusercontent.com/95587971/144762065-44fcb4b7-0b68-45c8-9323-75865323384c.png)

La variable de Y es una flag que indica si el proceso de llenado, sellado ya está realizado. En este diagrama se aprecian las 3 etapas de llenado, sellado y rotación para automatizar el proceso de envasado. En la de llenado, como se había mencionado, se queda en esa etapa mientras X=0, la cual indica que no se ha llegado a cierta cantidad de gramos; cuando se llega a la cantidad deseada de peso, se prende la flag a X=1. Después, la siguiente etapa es llenado. Se mantiene en esta etapa mientras el sensor ultrasónico siga detectando que no existe la distancia deseada al bote, es decir, que no hay tapa todavía (U=0); una vez que se coloca la tapa, la distancia es más corta y es la deseada, por lo cual U=1. Finalmente en la rotación, se asume que siempre se tendrá un bote sellado y lleno, por lo cual no se mantendrá en esa etapa por ninguna variable. Una vez que se rote, se avanzará a la siguiente etapa de llenado otra vez cuando se tenga un bote vacío de nuevo. 
