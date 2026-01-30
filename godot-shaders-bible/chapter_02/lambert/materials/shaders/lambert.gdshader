shader_type spatial;
//render_mode ambient_light_disabled;

uniform sampler2D _MainTex : source_color;
uniform vec4 _Shadow : source_color;
uniform vec4 _Highlight : source_color;
uniform float _Smoothness : hint_range(0.0, 1.0, 0.05);

void vertex()
{
	// Called for every vertex the material is visible on.
}

void fragment()
{	
	// the k variable in the Lambert equation definition.
	// same as albedo
	vec3 k = texture(_MainTex, UV).rgb;
	ALBEDO = k;
}

void light()
{
	float i = ATTENUATION;
	vec3 l = LIGHT;
	vec3 n = NORMAL;
	float D = max(0.0, dot(n, l)) * i;
	
	D = smoothstep(0.0, _Smoothness, D);
	vec4 a = _Shadow;
	vec4 b = _Highlight;
	vec3 diffuse = mix(a.rgb, b.rgb, D);

	DIFFUSE_LIGHT += diffuse;
}
