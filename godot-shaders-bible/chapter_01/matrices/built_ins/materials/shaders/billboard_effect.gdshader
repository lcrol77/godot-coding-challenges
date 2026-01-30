shader_type spatial;
render_mode unshaded;
render_mode skip_vertex_transform;

uniform sampler2D _MainTex : source_color;

varying vec3 vertex_os;

void vertex()
{
	vertex_os = VERTEX;

	mat4 BILLBOARD_MATRIX = mat4(
        INV_VIEW_MATRIX[0],
        INV_VIEW_MATRIX[1],
        INV_VIEW_MATRIX[2],
        MODEL_MATRIX[3]
    );

    vec4 vertex_ws = BILLBOARD_MATRIX * vec4(vertex_os, 1.0);
    vec4 vertex_vs = VIEW_MATRIX * vertex_ws;
    vec4 vertex_proj = PROJECTION_MATRIX * vertex_vs;
    POSITION = vertex_proj;
}

void fragment()
{
	vec4 albedo = texture(_MainTex, UV);
	ALBEDO = albedo.rgb;
	ALPHA = albedo.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
