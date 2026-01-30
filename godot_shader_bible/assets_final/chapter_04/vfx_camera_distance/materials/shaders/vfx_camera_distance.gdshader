shader_type spatial;
render_mode diffuse_toon;
render_mode cull_disabled;
render_mode depth_prepass_alpha;

uniform sampler2D _MainTexRGB : source_color;
uniform sampler2D _MainTexA : source_color;
uniform float _Distance : hint_range(0.0, 10.0, 0.1);
uniform vec3 _EdgeColor : source_color;

varying vec3 vertex_ws;

void vertex()
{
	vertex_ws = (MODEL_MATRIX * vec4(VERTEX, 1.0)).rgb;
}

float hash21 (vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment()
{
	vec3 albedo = texture(_MainTexRGB, UV).rgb;
	float alpha = texture(_MainTexA, UV).r;

	float distance_color = clamp(distance(vertex_ws, CAMERA_POSITION_WORLD) / _Distance, 0.0, 1.0);
	float focus = pow(distance_color, 2.0);

	float noise = hash21(SCREEN_UV);
	noise = mix(noise, 1.0, focus) * focus;

	albedo = mix(_EdgeColor, albedo, focus);

	ALBEDO = albedo;
	ALPHA = alpha * noise;
	ALPHA_ANTIALIASING_EDGE = 0.5;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
