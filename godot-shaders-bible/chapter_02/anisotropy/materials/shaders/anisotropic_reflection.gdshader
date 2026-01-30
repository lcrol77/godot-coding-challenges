shader_type spatial;
render_mode ambient_light_disabled;

uniform sampler2D _MainTex;
uniform float _AU : hint_range(0.0, 256.0, 0.1);
uniform float _AV : hint_range(0.0, 256.0, 0.1);
uniform float _ReflectionFactor : hint_range(0.0, 1.0, 0.1);

varying vec3 _tangent;
varying vec3 _binormal;

void vertex()
{
	// Called for every vertex the material is visible on.
}

void fragment()
{
	_tangent = TANGENT;
	_binormal = BINORMAL;

	vec3 albedo = texture(_MainTex, UV).rgb;
	ALBEDO = albedo;
}

float ashikhmin_shirley(float rs, float au, float av, vec3 n, vec3 l, vec3 v, vec3 t, vec3 b)
{
	vec3 h = normalize(l + v);
	float NdotL = max(dot(n, l), 0.0001);
	float NdotV = max(dot(n, v), 0.0001);
	float NdotH = max(dot(n, h), 0.0001);
	float VdotH = max(dot(n, h), 0.0001);

	float HdotT = dot(h, t);
	float HdotB = dot(h, b);

	float exponent = au * pow(HdotT, 2.0) + av * pow(HdotB, 2.0);
	exponent /= 1.0 - pow(NdotH, 2.0);

	float specular = sqrt((au + 1.0) * (av + 1.0)) * pow(NdotH, exponent);
	specular /= (8.0 * PI) * VdotH * max(NdotL, NdotV);

	float f = rs + (1.0 - rs) * pow(1.0 - VdotH, 5.0);
	specular *= f;

	return specular;
}

float lambert(float i, vec3 l, vec3 n)
{
	return max(0.0, dot(n, l)) * i;
}

void light()
{
	float aniso = ashikhmin_shirley(_ReflectionFactor, _AU, _AV,
	NORMAL, LIGHT, VIEW, _tangent, _binormal);

	vec3 albedo = ALBEDO;
	aniso *= albedo.r * albedo.g * albedo.b;
	aniso = smoothstep(0.0, 0.1, aniso);
	aniso *= lambert(ATTENUATION, LIGHT, NORMAL);

	DIFFUSE_LIGHT+= albedo;
	SPECULAR_LIGHT += aniso;
}