shader_type spatial;
render_mode unshaded;

// source : https://www.desmos.com/calculator/bvccatrkgb

uniform float _EyebrowRotation : hint_range(0.0, 45.0, 0.1); 	// A1
uniform float _BackBoneRotation : hint_range(17.0, 45.0, 0.1); 	// A2
uniform float _HeadSize : hint_range(0.30, 0.38, 0.01);			// S
uniform float _FacePosition : hint_range(0.0, 0.1, 0.01);		// P
uniform float _EyeSize : hint_range(0.04, 0.1, 0.01);			// T

uniform vec3 _HeadColor : source_color;
uniform vec3 _EyeColor : source_color;
uniform vec3 _BackBoneColor : source_color;
uniform vec3 _BandanaColor : source_color;
uniform vec3 _EyebrowColor : source_color;

void vertex()
{
	// Called for every vertex the material is visible on.
}

float eyes_shape(vec2 uv, float p, float r, float s)
{
	float u_coord = abs(uv.x) - 0.15;
	float v_coord = uv.y + p;
	return float(u_coord * u_coord + v_coord * v_coord > (r * r) * s);
}

float eyebrow_shape(vec2 p)
{
	float r = 0.03;
	float u = min(0.05 - abs(p.x), 0.0);
	float v = p.y;
	vec2 uv = vec2(u, v);
	return float(dot(uv, uv) < r * r);
}

float back_bone_shape(vec2 p)
{
	float r = 0.06;
	float u = min(0.42 - abs(p.x), 0.04);
	float v = abs(p.y) - 0.04;
	vec2 uv = vec2(u, v);
	return float(dot(uv, uv) < r * r);
}

float head_shape(vec2 uv, float s)
{
	return float(dot(uv, uv) < pow(s, 2.0));
}

vec2 rotation(float x, float y, float a)
{
	float ru = cos(a) * x + sin(a) * y;
	float rv = -sin(a) * x + cos(a) * y;
	return vec2(ru, rv);
}

void fragment()
{
	float u = UV.x - 0.5;
	float v = (1.0 - UV.y) - 0.5;
	vec2 uv = vec2(u, v);

	float head = head_shape(uv, _HeadSize);
	float jaw = float(pow(min(_HeadSize - 0.23 - abs(u), 0.0), 4.0) +
		pow(min(0.12 - abs(v + (_HeadSize - 0.15)), 0.0), 4.0) < pow(0.05, 4.0));
	float eyes = 1.0 - eyes_shape(uv, _FacePosition, _EyeSize, 0.5);
	float nose = 1.0 - float(-_FacePosition - v > 2.0 * abs(u) + 0.05) *
		float(-_FacePosition - v < 0.15);
	float bandana = float(sqrt(UV.x) < 1.0 - UV.y);

	float to_radians = PI / 180.0;
	float r1 = _EyebrowRotation * to_radians;
	float r2 = _BackBoneRotation * to_radians;

	vec2 p0 = rotation(u - 0.1, v - 0.15 + _FacePosition, r1);
	vec2 p1 = rotation(-u - 0.1, v - 0.15 + _FacePosition, r1);
	vec2 p2 = rotation(u, v, r2);
	vec2 p3 = rotation(-u, v, r2);

	float eyebrow_r = eyebrow_shape(p0);
	float eyebrow_l = eyebrow_shape(p1);
	float eyebrows = eyebrow_l + eyebrow_r;

	float back_bone_l = back_bone_shape(p2);
	float back_bone_r = back_bone_shape(p3);
	float back_bones = clamp(back_bone_l + back_bone_r, 0.0, 1.0);

	head = clamp(head + jaw, 0.0, 1.0);
	head *= eyes_shape(uv, _FacePosition, 0.1, 1.0);
	head *= nose;
	bandana *= head;
	back_bones *= 1.0 - head_shape(uv, _HeadSize + 0.03);

	vec3 render_rgb = vec3(0.0);
	float alpha = 0.0;

	vec3 head_color = _HeadColor * head;
	vec3 eyes_color = _EyeColor * eyes;
	vec3 bandana_color = _BandanaColor * bandana;
	vec3 eyebrows_color = _EyebrowColor * eyebrows;
	vec3 back_bone_color = _BackBoneColor * back_bones;

	render_rgb += head_color;
	render_rgb += eyes_color;
	render_rgb = mix(render_rgb, bandana_color, bandana);
	render_rgb = mix(render_rgb, eyebrows_color, eyebrows);
	render_rgb += back_bone_color;

	alpha += head;
	alpha += eyes;
	alpha += back_bones;

	float back = back_bone_shape(p2);

	ALBEDO = render_rgb;
	ALPHA = alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}