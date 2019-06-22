uniform mat4 modelview; // translate() en Processing
uniform mat4 transform; // matriz 4x4 que contiene el producto de las matrices projection y modelView
uniform mat3 normalMatrix; // matriz 3x3 para convertir el vector normal del vertice a las coordenadas 
                           // apropiadas para realizar los calculos de iluminacion
uniform mat4 projection;

uniform vec4 lightPosition; // pointLigth() en Processing

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;

void main() {
  gl_Position = transform * position; // posiciona el vertice en su lugar (position indica el vertice)   
  vec3 ecPosition = vec3(modelview * position);  // expresa el vertice en eye-coordinates
  vec3 ecNormal = normalize(normalMatrix * normal); // expresa la normal del vertice en terminos de eye-coordinates

  vec3 direction = normalize(lightPosition.xyz - ecPosition); // vector normalizado con direccion de la luz    
  float intensity = max(0.0, dot(direction, ecNormal));
  vertColor = vec4(intensity, intensity, intensity, 1) * color;             
}