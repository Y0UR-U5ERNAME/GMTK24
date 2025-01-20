shader_type canvas_item;

uniform float size = 50.;
uniform vec2 pos = vec2(0.0, 0.0);
const vec2 screen_size = vec2(480., 320.);
const vec4 color = vec4(51., 57., 65., 255.) / 255.;

void fragment() {
	vec4 col = color;
	if (distance(UV * screen_size, pos) < size) {col.a = 0.0;}
	COLOR = col;
}