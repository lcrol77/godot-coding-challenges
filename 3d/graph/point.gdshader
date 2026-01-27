shader_type spatial;

uniform vec3 worldPos;
uniform float smoothness : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	ROUGHNESS = smoothness;
	ALBEDO = worldPos * 0.5 + 0.5;
}