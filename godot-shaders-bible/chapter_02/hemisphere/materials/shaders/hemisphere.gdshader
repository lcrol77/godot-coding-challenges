shader_type spatial;
render_mode ambient_light_disabled;

#include "res://assets/chapter_02/include/functions.gdshaderinc"

uniform sampler2D _MainTex : source_color;
uniform vec3 _GroundColor : source_color;
uniform vec3 _SkyColor : source_color;
uniform float _Smoothness: hint_range(0.0, 0.5, 0.01);

void vertex()
{
	// Called for every vertex the material is visible on.
}

void fragment()
{
	vec3 main_texture = texture(_MainTex, UV).rgb;
	ALBEDO = main_texture;
}

float hemisphere(vec3 n, float s)
{
	float t = n.y * 0.5 + 0.5; // remap [-1, 1] -> [0, 1]
	float l = mix(0.0, 1.0, t);
	return smoothstep(0.0 + s, 1.0 - s, l);
}

void light()
{
	vec3 normal_ws = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;

	float gradient = hemisphere(normal_ws, _Smoothness);
	vec3 custom_ambient = mix(_GroundColor, _SkyColor, gradient);
	custom_ambient = to_sRGB(custom_ambient);

	DIFFUSE_LIGHT += custom_ambient;
}