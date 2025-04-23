shader_type spatial;

uniform vec3 worldPos;
uniform float smoothness : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	ROUGHNESS = smoothness;
	ALBEDO.rg = worldPos.xy * 0.5 + 0.5;
	ALBEDO.b = 0.0;
}