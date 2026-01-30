shader_type spatial;
//render_mode ambient_light_disabled;
render_mode blend_add;

uniform sampler2D _MainTex : source_color;
uniform sampler2D _Pattern : source_color;

uniform float _Divergence : hint_range(0.0, 0.1, 0.001);
uniform float _Glitter : hint_range(100.0, 500.0, 1.0);

void vertex()
{

}

vec2 matcap(vec3 p, vec3 n, )
{
	vec3 position = normalize(p);
	vec3 k = cross(position, n);
	vec2 uv = vec2(-k.y, -k.x);
	uv *= 0.5;
	uv += 0.5;
	return uv;
}

vec3 hash33(vec3 p)
{
    uvec3 v = uvec3(round(p)); // Convert float3 to uvec3 by rounding and casting

    v.x ^= 1103515245U;
    v.y ^= v.x + v.z;
    v.y *= 134775813U;
    v.z += v.x ^ v.y;
    v.y += v.x ^ v.z;
    v.x += v.y * v.z;
    v.x *= 0x27d4eb2dU;
    v.z ^= v.x << 3U;
    v.y += v.z << 3U;

    return vec3(v) * (1.0 / float(0xffffffffU)); // Normalize by dividing with max uint value
}

vec3 random_value(vec3 Seed, float Min, float Max)
{
    float u1 = hash33(Seed).x; // Use only one component for the random float
    float u2 = hash33(Seed + vec3(123.234, 823.234, 434.234)).x; // Same here

    float radius = sqrt(-2.0 * log(u1)) * 4.0;
    float theta = 2.0 * 3.1415 * u2;

    float x = radius * cos(theta);
    float y = radius * sin(theta);

    vec2 result;
    result.x = x * (Max - Min) + Min;
    result.y = y * (Max - Min) + Min;

    return vec3(result.xy, 1.0); // Return vec3 with result.xy and z set to 1
}

vec3 normal_blend(vec3 A, vec3 B)
{
    return normalize(vec3(A.rg + B.rg, A.b * B.b));
}

void fragment()
{
	vec3 normal_vs = -NORMAL;
	vec3 normal_ws = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
	vec3 view_ws = normalize((INV_VIEW_MATRIX * vec4(VIEW, 0.0)).xyz);

	vec3 seed = floor(UV.xyx * _Glitter);
	float minimum = -1.0 * _Divergence;
	float maximum = _Divergence;

	vec3 normal_noise = random_value(seed, minimum, maximum);
	vec3 normal_out = normal_blend(normal_vs, normal_noise);

	normal_out *= 0.5;
	normal_out += 0.5;

	float pattern = texture(_Pattern, UV).r;
	vec2 uv = matcap(VERTEX * pattern, NORMAL);
	vec3 albedo = texture(_MainTex, uv).rgb;
	vec3 glitter = texture(_MainTex, normal_out.xy).rgb;

	glitter *= 0.5;
	glitter *= pattern;
	albedo *= pattern;
	albedo += glitter;

	ALBEDO = albedo;
}

float blinn_phong(vec3 v, vec3 l, vec3 n, float m)
{
	vec3 h = normalize(l + v);
	float s = pow(max(0.0, dot(n, h)), m);
	s *= float(dot(n, l) > 0.0);
	return s;
}

void light()
{
	vec3 albedo = ALBEDO;
	float specular = blinn_phong(VIEW, LIGHT, NORMAL, 128.0);

	DIFFUSE_LIGHT += albedo;
	SPECULAR_LIGHT += specular;
}
