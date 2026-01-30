shader_type spatial;
render_mode depth_draw_never, unshaded, depth_test_disabled;
stencil_mode read, compare_equal, 1;

uniform sampler2D _BaseColor : source_color, repeat_disable;

void fragment()
{
	vec3 albedo = texture(_BaseColor, UV).rgb;
	ALBEDO = albedo;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
