#define RX(a) mat3(				\
	vec3(1, 0, 0), 				\
	vec3(0, cos(a), -sin(a)), 	\
	vec3(0, sin(a), cos(a)))

#define RY(a) mat3(				\
	vec3(cos(a), 0, sin(a)), 	\
	vec3(0, 1, 0), 				\
	vec3(-sin(a), 0, cos(a)))

#define RZ(a) mat3(				\
	vec3(cos(a), -sin(a), 0), 	\
	vec3(sin(a), cos(a), 0), 	\
	vec3(0, 0, 1))

vec3 to_sRGB(vec3 linearRGB)
{
    vec3 a = vec3(1.055) * pow(linearRGB.rgb, vec3(1.0/2.4)) - vec3(0.055);
    vec3 b = linearRGB.rgb * vec3(12.92);
	bvec3 c = lessThan(linearRGB, vec3(0.0031308));
    return vec3(mix(a, b, c));
}

float fresnel(vec3 n, vec3 v, float m, float s)
{
	float f = 1.0 - max(0.0, dot(n, v));
	return s * pow(f, m);
}

float lambert(float attenuation, vec3 light, vec3 normal)
{
	float i = attenuation;
	vec3 l = light;
	vec3 n = normal;
	return max(0.0, dot(n, l)) * i;
}

vec3 hue_radians_float(vec3 input, float offset)
{
    vec4 k = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(input.bg, k.wz), vec4(input.gb, k.xy), step(input.b, input.g));
    vec4 q = mix(vec4(p.xyw, input.r), vec4(input.r, p.yzx), step(p.x, input.r));
    float d = q.x - min(q.w, q.y);
    float e = 0.0000000001;
    vec3 hsv = vec3(abs(q.z + (q.w - q.y)/(6.0 * d + e)), d / (q.x + e), q.x);

    float hue = hsv.x + offset;
    hsv.x = (hue < 0.0) ? hue + 1.0 : (hue > 1.0) ? hue - 1.0 : hue;

    // HSV to RGB
    vec4 k2 = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p2 = abs(fract(hsv.xxx + k2.xyz) * 6.0 - k2.www);
    return hsv.z * mix(k2.xxx, clamp(p2 - k2.xxx, 0.0, 1.0), hsv.y);
}