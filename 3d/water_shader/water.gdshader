shader_type spatial;

uniform vec4 primary_color : source_color;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = primary_color.rgb;
}
