shader_type spatial;
render_mode unshaded;

/*
	source : https://www.desmos.com/calculator/7yigivseou
	All the functions you see here are a representation of
	the figure we created in Desmos, translated into GDSL
	so they can be rendered directly in our shader.
*/

void vertex()
{
	// Called for every vertex the material is visible on.
}

float circle(vec2 p, vec2 o, vec2 h, float r)
{
	float u = p.x + o.x;
	float v = p.y + o.y;
	vec2 uv = vec2(u, v);
	return float(dot(uv/h, uv/h) < r * r);
}

float segment(vec2 p, vec2 m, vec2 o, float r)
{
	float u = min(m.x - abs(p.x + o.x), 0.0);
	float v = min(m.y - abs(p.y + o.y), 0.0);
	vec2 uv = vec2(u, v);
	return float(dot(uv, uv) < r * r);
}

float segment_02(vec2 p, vec2 m, vec2 o, float r)
{
	float u = min(m.x - abs(p.x + o.x), 0.0);
	float v = min(m.y - abs(p.y + o.y), 0.0);
	return float(pow(u, 4.0) + pow(v, 4.0) < pow(r, 4.0));
}

vec2 rotation(float x, float y, float a)
{
	float ru = cos(a) * x + sin(a) * y;
	float rv = -sin(a) * x + cos(a) * y;
	return vec2(ru, rv);
}

void fragment()
{
	float t1 = TIME;
	float t2 = TIME;

	float s1 = ceil(abs(sin(PI + t2)) - 0.1);
	float s2 = sin(t1 * PI) * 0.1;

	float u = UV.x - 0.5;
	float v = (1.0 - UV.y) - 0.5 + s2;

	vec2 uv = vec2(u, v);

	float body = circle(uv, vec2(0.0), vec2(1.0, 1.0), 0.2);
	float eye = circle(uv, vec2(0.05, 0.0), vec2(1.0, 1.0), 0.1);
	float pupil = circle(uv, vec2(0.07, 0.0), vec2(1.0, 1.0 * s1 + 0.2), 0.01);
	float screw_r = circle(uv, vec2(-0.06, 0.15), vec2(1.0, 1.0), 0.05);
	float screw_l = circle(uv, vec2(0.15, 0.15), vec2(1.0, 1.0), 0.05);
	float screws = screw_l + screw_r;

	float cube_red = segment_02(uv, vec2(0.0, 0.0), vec2(-0.4, 0.1), 0.05);
	float cube_blue = segment_02(uv, vec2(0.0, 0.0), vec2(-0.4,- 0.1), 0.05);

	float magnet_r = segment(uv, vec2(0.1, 0.0), vec2(-0.4, 0.0), 0.15);
	magnet_r *= float((pow(min(0.1 - abs(u - 0.35), 0.0), 2.0)) / 0.7 + pow(v, 2.0) > 0.05 * 0.05);
	magnet_r *= float(UV.x < 0.9);
	float magnet_l = segment(uv, vec2(0.1, 0.0), vec2(0.4, 0.0), 0.15);
	magnet_l *= 1.0 - body;
	magnet_l *= 1.0 - segment(uv, vec2(0.1, 0.0), vec2(0.4, 0.0), 0.05);
	magnet_l *= float(UV.x > 0.05);
	float magnet_m = float(pow(min(0.1 - abs(u - 0.55), 0.0), 2.0) + pow(v, 2.0) > 0.15 * 0.15);
	magnet_m *= float(pow(min(0.1 - abs(u - 0.35), 0.0), 2.0) + pow(v, 2.0) < 0.05 * 0.05);
	float magnets = magnet_l + magnet_r;

	float red_l = float(UV.x < 0.15);
	red_l *= float(v < 0.45);
	red_l *= magnets;
	float red_r = float(UV.x > 0.8);
	red_r *= float(v > -0.45);
	red_r *= magnets;
	float red = red_l + red_r;
	float blue_l = float(UV.x < 0.15);
	blue_l *= float(v < 0.0);
	blue_l *= magnets;
	float blue_r = float(UV.x > 0.8);
	blue_r *= float(v > 0.0);
	blue_r *= magnets;
	float blue = blue_l + blue_r;

	float a1 = 45.0 * (PI / 180.0);
	vec2 p1 = rotation(abs(u + 0.16), abs(v + 0.15), a1);
	vec2 p2 = rotation(abs(u - 0.06), abs(v + 0.15), a1);
	float cross_r = segment(p1, vec2(0.025, 0.0), vec2(0.0), 0.01);
	float cross_l = segment(p2, vec2(0.025, 0.0), vec2(0.0), 0.01);

	float screw_base = float(abs(u) < 0.04 );
	screw_base *= 1.0 - body;
	screw_base *= float(v > 0.0);
	screw_base *= float(v < 0.3);
	float screw_top = float(pow(u, 2.0)/1.0 + pow(v - 0.3, 2.0)/0.2 < pow(0.1, 2.0));
	screw_top *= float(v > 0.3);
	screws += magnets;
	screws += screw_top;
	float crosses = cross_l + cross_r + magnet_m + screw_base;

	vec3 render_rgb = vec3(0.0);
	float alpha = 0.0;

	float c = 255.0;
	vec3 red_color_l = vec3(255.0/c, 50.0/c, 50.0/c);
	red_color_l *= red;
	vec3 red_color_d = vec3(200.0/c, 14.0/c, 22.0/c);
	red_color_d *= cube_red;
	vec3 blue_color_l = vec3(98.0/c, 172.0/c, 255.0/c);
	blue_color_l *= blue;
	vec3 blue_color_d = vec3(10.0/c, 85.0/c, 150.0/c);
	blue_color_d *= cube_blue;
	vec3 gray_color_l = vec3(150.0/c, 150.0/c, 150.0/c);
	gray_color_l *= screws;
	vec3 gray_color_d = vec3(70.0/c, 70.0/c, 70.0/c);
	gray_color_d *= crosses;
	vec3 body_color_l = vec3(111.0/c, 139.0/c, 220.0/c);
	body_color_l *= body;

	render_rgb += body_color_l;
	render_rgb = mix(render_rgb, vec3(1, 1, 1), eye);
	render_rgb *= 1.0 - pupil;
	render_rgb = mix(render_rgb, gray_color_l, screws);
	render_rgb = mix(render_rgb, gray_color_d, crosses);
	render_rgb = mix(render_rgb, red_color_l, red);
	render_rgb = mix(render_rgb, blue_color_l, blue);
	render_rgb = mix(render_rgb, red_color_d, cube_red);
	render_rgb = mix(render_rgb, blue_color_d, cube_blue);

	alpha += body;
	alpha += magnets;
	alpha += screws;
	alpha += screw_base;
	alpha += magnet_m;
	alpha += cube_red;
	alpha += cube_blue;
	alpha = clamp(alpha, 0.0, 1.0);

	ALBEDO = vec3(render_rgb);
	ALPHA = alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
