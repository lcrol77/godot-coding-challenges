shader_type spatial;

#include "res://assets/chapter_02/include/functions.gdshaderinc"

uniform sampler2D _MainTex : source_color;

vec3 hash33(vec3 p)
{
    p = fract(p * 0.4567);
    p += dot(p, p.yzx + 1.3456);
	p.x *= p.x;
	p.y *= p.y;
	p.z *= p.z;
    return fract(p);
}

void vertex()
{	
	vec3 vertex_os = VERTEX;
	vec3 vertex_ws = (MODEL_MATRIX * vec4(vertex_os, 1.0)).xyz;
	float gradient_ws = clamp(0.0, 1.0, vertex_ws.y - NODE_POSITION_WORLD.y);

	float angle_map = hash33(floor(NODE_POSITION_WORLD)).y; 
	angle_map *= gradient_ws;
	float st = (sin(TIME + angle_map * 2.0) * 0.05 + 0.05);
	float ct = (cos(TIME + angle_map * 2.0) * 0.05 + 0.05);	

	mat3 EULER_ZXY = 
		RY(angle_map * TAU) * 
		RX((angle_map * 0.1345) - st) * 
		RZ((angle_map * 0.1567) - ct);
		
	float clamp_value = clamp(angle_map, 0.4, 1.0);
	
	VERTEX = EULER_ZXY * vertex_os * clamp_value;
	NORMAL = EULER_ZXY * NORMAL * clamp_value;
}

void fragment()
{	
	vec3 angle_map = hash33(floor(NODE_POSITION_WORLD));
	vec4 color = texture(_MainTex, UV);
	ALBEDO = hue_radians_float(color.xyz, angle_map.z);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
