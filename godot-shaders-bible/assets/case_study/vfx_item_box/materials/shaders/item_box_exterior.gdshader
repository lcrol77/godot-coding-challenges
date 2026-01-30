shader_type spatial;
render_mode unshaded;
render_mode blend_add;

uniform sampler2D _Matcap;

void vertex() 
{
	
}

void fragment() 
{
	vec3 normal_vs = -NORMAL;
	normal_vs *= 0.5;
	normal_vs += 0.5;	
	
	vec3 color_a = vec3(0.2, 0.0, 1.0);
	vec3 color_b = vec3(0.2, 0.8, 0.0);	
	vec3 color = mix(color_a, color_b, sin(TIME * 2.0) * 0.5 + 0.5);
	
	vec3 matcap = texture(_Matcap, normal_vs.xy).rgb;
	matcap += color;
	
	ALBEDO = matcap;
	ALPHA = matcap.r;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
