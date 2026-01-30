shader_type spatial;
render_mode unshaded;

uniform sampler2D _MainTex : source_color;

void vertex()
{
	// Called for every vertex the material is visible on.
}

void fragment()
{
	vec3 albedo = texture(_MainTex, UV).rgb;
	ALBEDO = albedo;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
