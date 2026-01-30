shader_type spatial;

#define TRANSFORMATION_MATRIX(s) mat3(vec3(s, 0, 0), vec3(1, s, 0), vec3(0, 0, s))

void vertex() 
{
	VERTEX = VERTEX * TRANSFORMATION_MATRIX(1);
}

void fragment() 
{
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
