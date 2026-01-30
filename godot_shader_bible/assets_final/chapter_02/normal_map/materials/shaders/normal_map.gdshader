shader_type spatial;
render_mode diffuse_toon;
render_mode specular_toon;

uniform sampler2D _MainTex : source_color;
uniform sampler2D _NormalMap : hint_normal;
uniform float _Scale : hint_range(-16.0, 16.0, 0.1);

void vertex() 
{
	// Called for every vertex the material is visible on.
}

void fragment() 
{
	vec3 albedo = texture(_MainTex, UV).rgb;
	
	vec3 normal_map = texture(_NormalMap, UV).rgb;
	
	//NORMAL_MAP = normal_map;
	//NORMAL_MAP_DEPTH = 1.0;
	
	normal_map = normal_map * 2.0 - 1.0; 
	normal_map *= _Scale;
	
	float n_z = clamp(dot(normal_map.xy, normal_map.xy), 0.0, 1.0);
    normal_map.z = sqrt(1.0 - n_z);
	
	mat3 TBN = mat3(TANGENT.xyz, BINORMAL.xyz, NORMAL.xyz);
	vec3 normal_vs = normalize(TBN * normal_map);
	
	ALBEDO = albedo;
	NORMAL = normal_vs; 
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
