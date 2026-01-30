shader_type canvas_item;

uniform sampler2D _Palette : source_color;
uniform int _PixelSize : hint_range(1, 10, 1);
uniform sampler2D _ScreenTexture : hint_screen_texture, repeat_disable, filter_nearest;

void vertex()
{
	// Called for every vertex the material is visible on.
}

float luma(vec3 c)
{
    return max(0.0, dot(c, vec3(0.2126, 0.7152, 0.0722)));
}

vec3 palette_fetch(int i)
{
	i = clamp(i, 0, 3);
	float v = 0.125 + 0.25 * float(i);
	return texture(_Palette, vec2(0.5, 1.0 - v)).rgb;
}

vec3 gameboy_color(vec3 color)
{
    float t = luma(color);
	t = smoothstep(0.1, 0.9, t);
	int idx = int(floor(t * 4.0));
	if(idx == 4) idx = 3;
	return palette_fetch(idx);
}

vec2 to_pixel(vec2 screen_uv, vec2 screen_pixel, float pixel_size)
{
    vec2 px = screen_uv * screen_pixel;
    px = floor(px / pixel_size) * pixel_size + pixel_size;
    return px / screen_pixel;
}

void fragment()
{
	float size = float(_PixelSize);
	
	vec2 screen_uv = to_pixel(SCREEN_UV, 1.0 / SCREEN_PIXEL_SIZE, size);
	vec4 screen_texture = texture(_ScreenTexture, screen_uv);
	screen_texture.rgb = gameboy_color(screen_texture.rgb);
	
	vec2 pos = floor((SCREEN_UV / SCREEN_PIXEL_SIZE) / size);
	float pattern_mask = mod(pos.x  + mod(pos.y, 2.0), 2.0);
	
	screen_texture.rgb *= pattern_mask;	
	COLOR = screen_texture;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
