shader_type spatial;
render_mode unshaded;

#define MAX_ITERATIONS 256
#define MAX_DISTANCE 100.0
#define SURFACE_DISTANCE 0.001
#define IOR 2

varying vec3 normal_os;
varying vec3 bitangent_os;
varying vec3 vertex_os;
varying vec3 tangent_os;

uniform sampler2D _Gradient : source_color;
uniform sampler2D _Reflection : source_color;
uniform sampler2D _Matcap : source_color;
uniform sampler2D _Projection : source_color;
uniform sampler2D _Numbers : source_color;

uniform float _Radius : hint_range(0.0, 1.0, 0.01);
uniform float _Offset : hint_range(-1.0, 0.0, 0.01);
uniform float _Power : hint_range(0.0, 10.0, 0.05);
uniform vec3 _Aberration = vec3(0.275, 0.435, 1.0);

uniform vec3 _Lowlight : source_color = vec3(0.0);
uniform vec3 _Midlight : source_color = vec3(0.5);
uniform vec3 _Highlight : source_color = vec3(1.0);

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

vec3 color_mix(float t, vec3 low, vec3 mid, vec3 high)
{
	vec3 color;
	if(t <= 0.5)
	{
		float t_scaled = t * 2.0;
		color = mix(low, mid, t_scaled);
	}
	else
	{
		float t_scaled = (t - 0.5) * 2.0;
		color = mix(mid, high, t_scaled);
	}
	return color;
}

float map(vec3 p)
{
	float sphere_radius = _Radius;
	float sphere = length(p) - sphere_radius;
	return sphere;
}

float render(vec3 origin, vec3 direction)
{
    float ray_distance = 0.0;
    for ( int i = 0; i < MAX_ITERATIONS; i++)
    {
        vec3 p = origin + ray_distance * direction;
        float scene_distance = map(p);
        ray_distance += scene_distance;

        if(scene_distance < SURFACE_DISTANCE || ray_distance > MAX_DISTANCE)
        {
            break;
        }
    }
    return ray_distance;
}

vec3 get_normal(vec3 p)
{
    vec2 h = vec2(0.00001, 0);
    vec3 n = map(p) - vec3(map(p - h.xyy), map(p - h.yxy), map(p - h.yyx));
    return normalize(n);
}

float fresnel(vec3 normal, vec3 view, float power)
{
    return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0, 1)), power);
}

vec3 blend_negation(vec3 base, vec3 blend, float opacity)
{
    vec3 v = 1.0 - abs(1.0 - blend - base);
    return mix(base, v, opacity);
}

void fragment()
{
	// -- reflection --

	vec3 normal_ws = (MODEL_MATRIX * vec4(normal_os, 0.0)).xyz;
	vec3 tangent_ws = (MODEL_MATRIX * vec4(tangent_os, 0.0)).xyz;
	vec3 bitangent_ws = (MODEL_MATRIX * vec4(bitangent_os, 0.0)).xyz;
	vec3 view_ws = normalize((INV_VIEW_MATRIX * vec4(VIEW, 0.0)).xyz);
	vec3 mat_tbn = matrix_tbn(tangent_ws, -bitangent_ws, normal_ws, view_ws);

	// -- color --

	float gradient_color = texture(_Gradient, UV + vec2(_Offset * mat_tbn.xy)).r;
	float reflection_color = texture(_Reflection, gradient_color - mat_tbn.xy).g;
	vec3 color_input = color_mix(reflection_color, _Lowlight, _Midlight, _Highlight);

	// -- ray marching --

	vec3 ray_origin_os = vertex_os; // current mesh size.
	vec3 camera_os = (inverse(MODEL_MATRIX) * vec4(CAMERA_POSITION_WORLD.xyz, 1.0)).xyz;
	vec3 ray_direction_os = normalize(ray_origin_os - camera_os);

	float ray_distance = render(ray_origin_os, ray_direction_os);
	vec3 ray_color;

	if (ray_distance < MAX_DISTANCE)
	{
		vec3 position = ray_origin_os + ray_distance * ray_direction_os;
		vec3 normal = get_normal(position);

		vec3 ray_normal_ws = (MODEL_MATRIX * vec4(normal, 0.0)).xyz;
		vec3 ray_normal_vs = (VIEW_MATRIX  * vec4(ray_normal_ws, 0.0)).xyz;

		ray_normal_vs *= 0.5;
		ray_normal_vs += 0.5;

		vec2 n_factor = vec2(0.1);
		vec2 n_xy = n_factor * normal_os.xy;
		vec2 n_zx = n_factor * normal_os.zx;
		vec2 n_yz = n_factor * normal_os.yz;

		vec3 specular = texture(_Matcap, n_xy + -ray_normal_vs.xy).rgb;
		specular *= 0.25;

		ray_color =  texture(_Projection, n_xy + (position.xy * 0.8 + 0.5)).rgb;
		ray_color += texture(_Projection, n_zx + (position.zx * 0.8 + 0.5)).rgb;
		ray_color += texture(_Projection, n_yz + (position.yz * 0.8 + 0.5)).rgb;

		ray_color = max(ray_color, specular);

		vec3 r = refract(ray_direction_os, normal + normal_os, IOR);
		if(1.0 - length(r) > 0.0)
		{
			ray_color = color_input;
		}
	}
	else
	{
		ray_color = color_input;
	}

	float fresnel_color = fresnel(normal_ws, view_ws, _Power) * 10.0;
	vec3 fresnel_shine = _Aberration * vec3(fresnel_color);
	fresnel_shine = clamp(sin(fresnel_shine), 0.0, 1.0);
	vec3 blend = blend_negation(fresnel_shine, ray_color, 1);

	vec3 number_color = texture(_Numbers, UV).rgb;
	number_color = (1.0 - number_color);
	blend += number_color;

	vec3 normal_vs = NORMAL;
	normal_vs *= 0.5;
	normal_vs += 0.5;
	vec3 matcap = texture(_Matcap, normal_vs.xy).rgb;
	matcap *= 0.25;
	blend += matcap;

	ALBEDO = blend;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
