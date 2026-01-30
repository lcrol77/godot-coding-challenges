shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;

uniform sampler2D _NoiseTex : source_color;
uniform vec3 _OutlineColor : source_color;
uniform float _Speed : hint_range(0.0, 3.0, 1.0);
uniform float _FrameRate : hint_range(1.0, 10.0, 1.0);
uniform float _NoisePower : hint_range(0.0, 0.1, 0.01);

void vertex()
{
	float t = TIME * _Speed;
	t = fract(t);
	t *= _FrameRate;
	t = floor(t);
	t *= 1.0 / _FrameRate; // <- frame rate

	float noise = texture(_NoiseTex, UV + t).r;
	noise *= _NoisePower;
	VERTEX += noise * normalize(NORMAL);
}

void fragment()
{
	ALBEDO = _OutlineColor;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
