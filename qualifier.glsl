#ifdef GL_ES
precision mediump float;
#endif

//  Function from Iñigo Quiles
//  https://www.shadertoy.com/view/MsS3Wc
vec3 hsb2rgb(in vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
  rgb = rgb * rgb * (3.0 - 2.0 * rgb);
  return c.z * mix(vec3(1.0), rgb, c.y);
}

void plus(vec3 col) {
  col += col + .5;
}

void main() {
  vec3 col = vec3(.0);
  plus(col);
  gl_FragColor = vec4(col, 1.);
}