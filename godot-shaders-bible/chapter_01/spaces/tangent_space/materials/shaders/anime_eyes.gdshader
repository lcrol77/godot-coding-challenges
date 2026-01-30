shader_type spatial;
render_mode unshaded;

uniform sampler2D _MainTex : source_color, repeat_disable;
uniform sampler2D _Depth : source_color, repeat_disable;
uniform sampler2D _Border : source_color, repeat_disable;
uniform sampler2D _Shine : source_color, repeat_disable;
uniform float _Offset : hint_range(0.0, 0.3, 0.05);

void vertex()
{
	// Called for every vertex the material is visible on.
}

vec3 view_to_tangent(vec3 tangent, vec3 bitangent, vec3 normal, vec3 view)
{
	float t = dot(tangent, view);
	float b = dot(bitangent, view);
	float n = dot(normal, view);
	return normalize(vec3(t, b, n));
}

void fragment()
{
	float depth = texture(_Depth, UV).r;
	float offset = _Offset * depth;
	vec3 view_tangent_space = view_to_tangent(-TANGENT, BINORMAL, NORMAL, VIEW);
	view_tangent_space *= offset;

	vec3 albedo = texture(_MainTex, UV + view_tangent_space.xy).rgb;
	vec4 border = texture(_Border, UV);
	vec4 shine = texture(_Shine, UV);

	vec3 lerp_ab = mix(albedo, border.rgb, border.a);
	vec3 lerp_abs = mix(lerp_ab, lerp_ab + shine.rgb, shine.a);

	ALBEDO = lerp_abs;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
