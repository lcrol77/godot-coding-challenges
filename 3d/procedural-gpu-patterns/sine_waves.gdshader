shader_type spatial;

uniform float displacement : hint_range(-1.0, 1.0) = 0.2;
uniform float frequency = 1.0;

vec3 colorize(float v) {
	if (v >= 0.0) {
		return vec3(v);
	}
	else {
		return vec3(0.0, -v, 0.0);
	}
}

float sample_pattern(vec2 uv) {
	return sin(frequency* TAU * uv.x);
}

void vertex() {
	float pattern_sample = sample_pattern(UV);
	COLOR.rgb = colorize(pattern_sample);
	VERTEX += NORMAL * (pattern_sample * displacement);
}

void fragment() {
	float pattern_sample = sample_pattern(UV);
	ALBEDO = colorize(pattern_sample);
	ALBEDO = COLOR.rgb;
	ALBEDO = NORMAL;
}
