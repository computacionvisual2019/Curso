uniform mat4 modelview; // translate
uniform mat4 transform; // proyeccion x modelView
uniform mat3 normalMatrix; // (ModelView^-1)^T
uniform vec4 lightPosition; // pointLigth() 

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;

//retorna el vector normalizado reflejado
vec3 manualReflect(vec3 incidentVector, vec3 normalVector){
  return incidentVector - 2.0 * dot(normalVector, incidentVector) * normalVector;
}

void main() {
  gl_Position = transform * position; // posiciona el vertice
  vec3 ecPosition = vec3(modelview * position); // vertice en eye-coordinates
  vec3 ecNormal = normalize(normalMatrix * normal); // normal en eye-coordinates

  vec3 lightDirection = normalize(lightPosition.xyz - ecPosition); // direccion de la luz
  vec3 cameraDirection = normalize(0 - ecPosition); // Direccion de la camara
  // vec3 lightDirectionReflected = reflect(-lightDirection, ecNormal); // reflejo de la luz que impacta
  vec3 lightDirectionReflected = manualReflect(-lightDirection, ecNormal);

  float intensity = max(0.0, pow(dot(lightDirectionReflected, cameraDirection), 1));
  vertColor = vec4(intensity, intensity, intensity, 1) * color;             
}


