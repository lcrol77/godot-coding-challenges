shader_type spatial;
//render_mode ambient_light_disabled;
render_mode cull_front;

uniform sampler2D _MainTex : source_color;
uniform float _Offset : hint_range(-1.0, 0.0, 0.1);

uniform float _NormalInfluecen : hint_range(-1.0, 1.0, 0.1);
uniform float _SSSPower : hint_range(0.0, 50.0, 0.1);
uniform float _SSSIntensity : hint_range(0.0, 30.0, 0.1);
uniform vec4 _Color : source_color;

varying vec3 normal_os;
varying vec3 bitangent_os;
varying vec3 vertex_os;
varying vec3 tangent_os;

void vertex()
{
	tangent_os = TANGENT;
	normal_os = NORMAL;
	bitangent_os = BINORMAL;
	vertex_os = VERTEX;
}

vec3 matrix_tbn(vec3 tangent, vec3 bitangent, vec3 normal, vec3 view)
{
	float t = dot(tangent, view);
	float b = dot(bitangent, view);
	float n = dot(normal, view);

	return normalize(vec3(t, b, n));
}

void fragment()
{
	vec3 normal_ws = (MODEL_MATRIX * vec4(normal_os, 0.0)).xyz;
	vec3 tangent_ws = (MODEL_MATRIX * vec4(tangent_os, 0.0)).xyz;
	vec3 bitangent_ws = (MODEL_MATRIX * vec4(bitangent_os, 0.0)).xyz;
	vec3 view_ws = normalize((INV_VIEW_MATRIX * vec4(VIEW, 0.0)).xyz);

	vec3 mat_tbn = matrix_tbn(tangent_ws, -bitangent_ws, normal_ws, view_ws);
	vec2 uv_off = vec2(_Offset * mat_tbn.xy);

	vec3 albedo = texture(_MainTex, UV + uv_off).rgb;
	ALBEDO = albedo;
}

void light()
{
	vec3 normal_influence = NORMAL * _NormalInfluecen;
	normal_influence += LIGHT;
	normal_influence = normalize(normal_influence);
	normal_influence = -1.0 * normal_influence;

	float direction = dot(normal_influence, VIEW);
	direction = clamp(direction, 0.0, 1.0);

	float brightness = pow(direction, _SSSPower) * _SSSIntensity;
	vec3 color = _Color.rgb * brightness;
	vec3 render = color;

	vec3 albedo = ALBEDO;
	albedo += render;

	DIFFUSE_LIGHT += albedo;
}
