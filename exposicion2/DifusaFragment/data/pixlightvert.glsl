uniform mat4 modelview; // translate() en Processing
uniform mat4 transform; // matriz 4x4 que contiene el producto de las matrices projection y modelView
uniform mat3 normalMatrix; // matriz 3x3 para convertir el vector normal del vertice a las coordenadas 
                           // apropiadas para realizar los calculos de iluminacion

uniform vec4 lightPosition; // pointLigth() en Processing
uniform vec3 lightNormal; // no usada

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;

void main() {
  gl_Position = transform * position; // posicion del vector   
  vec3 ecPosition = vec3(modelview * position); // expresa el vertice en eye-coordinates
  
  ecNormal = normalize(normalMatrix * normal); // expresa la normal del vertice en terminos de eye-coordinates
  lightDir = normalize(lightPosition.xyz - ecPosition); // vector normalizado con direccion de la luz 
  vertColor = color;
}