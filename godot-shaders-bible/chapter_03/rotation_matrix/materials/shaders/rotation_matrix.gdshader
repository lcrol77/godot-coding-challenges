shader_type spatial;

#include "res://assets/chapter_02/include/functions.gdshaderinc"

uniform sampler2D _BaseMap : source_color;
uniform vec3 _Angles;

void vertex() 
{	
    vec3 angles = _Angles * (PI / 180.0);    
    mat3 EULER_XZY = RY(angles.y) * RX(angles.x) * RZ(angles.z); 
    VERTEX = EULER_XZY * VERTEX;
    NORMAL = normalize(EULER_XZY * NORMAL);   
}

void fragment() 
{
	vec3 albedo = texture(_BaseMap, UV).rgb;
	ALBEDO = albedo;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
