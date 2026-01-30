shader_type spatial;
render_mode unshaded;
stencil_mode write, 1;

uniform sampler2D _BaseTex : source_color;

void fragment()
{
	vec4 base_tex = texture(_BaseTex, UV);
	if(base_tex.r < 1.0) discard;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
