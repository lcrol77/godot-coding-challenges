// This shader has been created for educational purposes.
// Some functionalities are not optimized.

shader_type spatial;
render_mode unshaded;

uniform sampler2D _MainTex : source_color;

void vertex()
{
	// Called for every vertex the material is visible on.
}

void fragment()
{
	vec3 main_texture = texture(_MainTex, UV).rgb;
	ALBEDO = main_texture;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
