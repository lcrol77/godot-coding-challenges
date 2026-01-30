// This shader has been created for educational purposes.
// Some functionalities are not optimized.

shader_type spatial;
render_mode skip_vertex_transform;
render_mode unshaded;

uniform sampler2D _Pattern;
uniform sampler2D _Specular;
uniform sampler2D _Reflection;

uniform float _Offset : hint_range(-1.0, 0.0);
uniform float _Power : hint_range(0.0, 10.0);

uniform vec3 _LowLight : source_color = vec3(1.0);
uniform vec3 _MidLight : source_color = vec3(1.0);
uniform vec3 _HighLight : source_color = vec3(1.0);

void vertex()
{
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
    NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
    BINORMAL = normalize((MODELVIEW_MATRIX * vec4(BINORMAL, 0.0)).xyz);
    TANGENT = normalize((MODELVIEW_MATRIX * vec4(TANGENT, 0.0)).xyz);
}

vec3 view_to_tangent(vec3 tangent, vec3 bitangent, vec3 normal, vec3 view)
{
	float t = dot(tangent, view);
	float b = dot(bitangent, view);
	float n = dot(normal, view);
	return normalize(vec3(t, b, n));
}

vec3 color_mix(float t, vec3 color01, vec3 color02, vec3 color03)
{
	return (t <= 0.5) ? mix(color01, color02, t * 2.0) : mix(color02, color03, (t - 0.5) * 2.0);
}

float fresnel(vec3 normal, vec3 view, float p)
{
    return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0, 1)), p);
}

vec3 blend_negation(vec3 base, vec3 blend, float opacity)
{
    vec3 v = 1.0 - abs(1.0 - blend - base);
    return mix(base, v, opacity);
}

void fragment()
{
	vec3 n_ws = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
	vec3 t_ws = (INV_VIEW_MATRIX * vec4(TANGENT, 0.0)).xyz;
	vec3 b_ws = (INV_VIEW_MATRIX * vec4(BINORMAL, 0.0)).xyz;

	vec3 v_ws = normalize(CAMERA_POSITION_WORLD - NODE_POSITION_WORLD.xyz);
	vec3 mat_tbn = view_to_tangent(-TANGENT, BINORMAL, NORMAL, VIEW);

	vec3 uv_grad = texture(_Pattern, UV - (mat_tbn.xy * _Offset)).rgb;
	vec3 mat01 = texture(_Specular, vec2(uv_grad.r) - mat_tbn.xy).rgb;

	vec3 fres = vec3(fresnel(VIEW, NORMAL, _Power));
	vec3 fres_color = sin((fres * 10.0) * vec3(0.364, 0.556, 0.789));
	fres_color = clamp(fres_color, 0.0, 1.0);

	vec3 color = color_mix(mat01.r, _LowLight, _MidLight, _HighLight);
	vec3 blend = blend_negation(color, fres_color, 1);

	vec3 view = (VIEW_MATRIX * vec4(-n_ws, 0.0)).xyz;
	view *= 0.5;
	view += 0.5;

	vec3 matcap = texture(_Reflection, view.xy).rgb;
	matcap *= 0.5;
	vec3 render = blend + matcap;

	ALBEDO = render * render;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
