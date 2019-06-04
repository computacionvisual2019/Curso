| INTEGRANTES DEL GRUPO                     |USUARIO GITHUB       |USUARIO UNAL|
|-------------------------------------------|---------------------|------------|
| Juan Sebastian Castelblanco Hernandez  | jscastelblancoh | jscastelblancoh |
| Nicolas Ricardo Enciso                 | nicolasenciso   | nricardoe |
| Hernan Camilo Rodriguez León           | UNhcrodriguezl  | hcrodriguezl |


# Taller 1

El trabajo se divide en tres carpetas de la siguiente forma: 
- punto1_3_4: Corresponde a la implementación de la escala de grises utilizando la configuración LUMA para la preservación del brillo de la imagen; el histograma con la segmentación interactiva reflejada en la imagen, al hacer click sobre el histograma y mover el mouse se selecciona el único segmento de pixeles que se quiere pintar de la imagen.
- punto2: La aplicación de las máscaras desenfoque, enfoque, bordes y realce. 
- punto5: La medición de los fps para 4 videos simultaneos con dos de las máscaras mencionadas anteriormente además de la escala de grises utilizando LUMA.

# Taller 2

Implementación de seis ilusiones ópticas distribuidas de la siguiente manera:

| Ilusión         | Categoria | Referencia | Tipo de interactividad (si aplica) | URL código base (si aplica) |
|-----------------|-----------|------------|------------------------------------|-----------------------------|
|Hering illusion|Geométrica|Autor: Greg Wittmann|Al presionar la tecla espacio, se desdibujan las lineas del fondo para revelar la ilusión| https://www.openprocessing.org/sketch/168636/|
|Point illusion|Psicológica|Autor: Femto-physique|Al presionar espacio se dibujan las lineas sobre las cuales se desplazan los puntos|https://www.openprocessing.org/sketch/707417|
|Structures illusion|Geométrica de movimiento|Autor: Connor|No hay interactividad|https://www.openprocessing.org/sketch/413457|
|Steeping feet|Psicologica|Autor: Greg Wittmann|Con la tecla espacio se eliminan los rectangulos que dan vida a la ilusión|https://www.openprocessing.org/sketch/168574|
|Imposible object|Ambigua||No hay interactividad|https://www.imagenesmi.com/im%C3%A1genes/impossible-objects-illusions-fa.html|
|Vanishing point|Psicológica|Autor: Shane Solari|El movimiento del mouse indica el sentido hacia el cual se dirigen las lineas desde el punto de origen|https://www.openprocessing.org/sketch/523058|

# Taller 3

Para el anti-aliasing se empleo una tecnica, donde primero se identificaban los pixelex que conforman los limites del triangulo es decir el borde, luego se identifica el vector que pasa sobre esos pixeles, se subdivide cada pixel y mediante la misma tecnica usada para rasterizar el triangulo, se identifica la cantidad de sub-pixeles que estan dentro del triangulo y se obtiene un valor que corresponde a el porcentaje del valor actual del color del pixel y ese color se usara para que el pixel sea pintado nuevamente. Este proceso se lleva acabo con todos los pixeles pertenecientes al borde del triangulo.   
