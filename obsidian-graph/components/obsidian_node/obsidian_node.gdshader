shader_type canvas_item;

uniform float smoothing;

void fragment() {
	float radius = 2.0 * distance(UV, vec2(0.5));
	COLOR.a = smoothstep(1.0, 1.0 - fwidth(smoothing * radius), radius);
}
