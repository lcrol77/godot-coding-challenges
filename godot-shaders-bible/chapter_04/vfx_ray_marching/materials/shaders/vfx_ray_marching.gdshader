shader_type spatial;
render_mode unshaded;
// add stencil if needed
//render_mode depth_draw_never, depth_test_disabled;
//stencil_mode read, compare_equal, 1;

#define NUM_STEPS 128
#define STEP_SIZE 0.01
#define NUM_LIGHT_STEPS 6
#define LIGHT_STEP_SIZE 0.05

uniform sampler3D _BaseTex : source_color, repeat_disable;
uniform vec3 _ColorLight : source_color;
uniform vec3 _ColorMid : source_color;
uniform vec3 _ColorShadow : source_color;

void vertex()
{
	// Called for every vertex the material is visible on.
}

vec3 ray_marching(vec3 ray_origin, vec3 ray_direction, vec3 offset, vec3 light_direction, float darkness, float transmittance, float light_absorb)
{
	float density = 0.0;
	float transmission = 0.0;
	float light_accumulation = 0.0;
	float final_light = 0.0;

	for (int i = 0; i < NUM_STEPS; i++)
	{
		ray_origin += (ray_direction * STEP_SIZE);
		vec3 sampled_position = ray_origin + offset;
		sampled_position = vec3(sampled_position.x, 1.0 - sampled_position.y, sampled_position.z);
		float sample_density = texture(_BaseTex, sampled_position).r;
		density += sample_density;
		vec3 light_ray_origin = sampled_position;
		float light_accumulation = 0.0;

		for(int j = 0; j < NUM_LIGHT_STEPS; j++)
		{
			light_ray_origin += (light_direction * LIGHT_STEP_SIZE);
			float light_density = texture(_BaseTex, light_ray_origin).r;
			light_accumulation += light_density;
		}

		float light_transmition = exp(-light_accumulation);
		float shadow = darkness + light_transmition * (1.0 - darkness);
		final_light += density * transmittance * shadow;
		transmittance *= exp(-density * light_absorb);
	}

	transmission = exp(-density * 0.31);

	return vec3(final_light, transmission, transmittance);
}

void fragment()
{
	vec3 ray_origin_ws = (INV_VIEW_MATRIX * vec4(VERTEX.xyz, 1.0)).xyz;
	vec3 ray_direction = normalize(ray_origin_ws - CAMERA_POSITION_WORLD);
	vec4 transform = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0));
	vec3 offset = (vec4(0.5, 0.5, 0.5, 0.0) - transform).xyz;

	const vec3 light_direction = vec3(0.0, -1.0, 0.0);
	const float darkness = 0.19;
	const float transmittance = 1.0;
	const float light_absorb = 2.0;

	vec3 render = ray_marching(ray_origin_ws, ray_direction, offset, light_direction, darkness, transmittance, light_absorb);

	// Mix three colors
	float t = clamp(render.x, 0.0, 1.0);
	vec3 c01  = mix(_ColorShadow, _ColorMid, clamp(t * 2.0, 0.0, 1.0));
    vec3 c02 = mix(_ColorMid, _ColorLight, clamp((t - 0.5) * 2.0, 0.0, 1.0));

	vec3 albedo = mix(c01, c02, step(0.5, t));
	float alpha = (1.0 - render.y);

	ALBEDO = albedo;
	ALPHA = alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
