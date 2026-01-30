shader_type spatial;

#include "res://assets/chapter_02/include/functions.gdshaderinc"

uniform sampler2D _MainTex : source_color;

void vertex()
{
	// Called for every vertex the material is visible on.
}

void fragment()
{
	vec3 k = texture(_MainTex, UV).rgb;
	ALBEDO = k;
}

float lambert(float i, vec3 l, vec3 n)
{
	return max(0.0, dot(n, l)) * i;
}

float phong(vec3 v, vec3 l, vec3 n, float m)
{
	vec3 r = reflect(-l, n);
	return pow(max(0.0, dot(r, v)), m);
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
	float i = ATTENUATION;
	vec3 l = LIGHT;
	vec3 n = NORMAL;
	vec3 v = VIEW;

	vec3 d = vec3(lambert(i, l, n));
	vec3 s = vec3(blinn_phong(v, l, n, 64.0));
	s = to_sRGB(s);

	DIFFUSE_LIGHT += d;
	SPECULAR_LIGHT += s;
}