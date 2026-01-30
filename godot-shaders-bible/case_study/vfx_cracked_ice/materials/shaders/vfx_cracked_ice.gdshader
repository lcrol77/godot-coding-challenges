shader_type spatial;
render_mode diffuse_toon;

uniform sampler2D _MainTex : source_color;
uniform float _Samples : hint_range(1.0, 30.0, 1.0);
uniform float _Offset : hint_range(0.0, 0.3, 0.01);
uniform float _Detail : hint_range(0.0, 6.0, 1.0);
uniform vec4 _Color : source_color;

void vertex() 
{
	// Called for every vertex the material is visible on.
}

void fragment() 
{
	vec3 albedo = texture(_MainTex, UV).rgb;	
	vec3 parallax = vec3(0.0);
	vec3 view_ws = (INV_VIEW_MATRIX * vec4(VIEW, 0.0)).rgb;
	
	for (int i = 0; i < int(_Samples); i++)
	{
		float ratio = float(i) / _Samples;
		parallax += textureLod(_MainTex, UV + mix(0.0, _Offset, ratio) * -view_ws.xz, _Detail).rgb  * mix(1.0, 0.0, ratio);
	}
	
	parallax /= _Samples;
	parallax += albedo;
	parallax *= _Color.rgb;
	
	ALBEDO = parallax;
	RIM = 0.1;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
