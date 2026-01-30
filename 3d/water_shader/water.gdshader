shader_type spatial;

// depth colors
uniform vec4 primary_color : source_color;
uniform vec4 secondary_color : source_color;

uniform float roughness = 0.2;

// Wave normal maps
uniform sampler2D normalmap_a: hint_normal;
uniform sampler2D normalmap_b: hint_normal;
uniform float normalmap_a_strength: hint_range(0.0, 1.0, 0.1) = 0.3;
uniform float normalmap_b_strength: hint_range(0.0, 1.0, 0.1) = 0.4;
uniform vec2 movement_direction = vec2(0.1,0.1);
uniform float move_strength = 0.5;

// UV Settings
uniform float uv_scale = 0.4;

uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture;

// Depth Value
uniform float depth_distance : hint_range(0.0, 20, 0.1) = 4.0;
uniform float beers_law : hint_range(0.0, 20, 0.1) = 12.0;
uniform float water_transparancy : hint_range(0.0, 1.0, 0.1) = 0.05;

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0,1.0)),amount);
}

void fragment() {
	float basic_fresnel = fresnel(3.0, NORMAL, VIEW);
	vec2 uv = UV* uv_scale;
	vec2 uv_movement = movement_direction * TIME * move_strength;
	float depth = textureLod(depth_texture, SCREEN_UV, 0.0).r;
	vec3 screen = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	vec3 normalmap = texture(normalmap_a, uv + uv_movement).rgb * normalmap_a_strength;
	normalmap += texture(normalmap_b, uv - uv_movement).rgb * normalmap_b_strength;
	
	vec3 ndc = vec3(SCREEN_UV * 2.0 -1.0, depth);
	vec4 world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	float depth_texture_y = world.y / world.w;
	float vertex_y =  (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).y;

	float depth_blend = clamp((vertex_y- depth_texture_y) / depth_distance, 0.0, 1.0);
	depth_blend = exp(-depth_blend * beers_law);
	vec3 depth_color = mix(secondary_color,primary_color, depth_blend).rgb;
	vec3 final_color = mix(depth_color.rgb, screen, depth_blend * (1.0 -basic_fresnel));
	
	ALBEDO = mix(final_color, screen, depth_blend * (1.0 - basic_fresnel));
	ROUGHNESS = roughness * (1.0 - basic_fresnel);
	NORMAL_MAP = normalmap;
}

