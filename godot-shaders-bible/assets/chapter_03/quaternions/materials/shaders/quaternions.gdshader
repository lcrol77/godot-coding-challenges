shader_type spatial;
render_mode unshaded;

uniform sampler2D _FrontMap : source_color, repeat_disable;
uniform sampler2D _BackMap : source_color, repeat_disable;
uniform sampler2D _SpotMap : source_color, repeat_disable;

uniform vec3 _LightRotation;
uniform vec3 _LightPosition;

void vertex()
{

}

struct quaternion
{
	float x;
	float y;
	float z;
	float w;
};

quaternion create(float angle, vec3 axis)
{
	float s = sin(angle/2.0);
	float c = cos(angle/2.0);
	vec3 v = normalize(axis) * s;

	quaternion q = quaternion(v.x, v.y, v.z, c);
	return q;
}

quaternion conjugate(quaternion q)
{
	float s = q.w;
	vec3 v = vec3(-q.x, -q.y, -q.z);

	quaternion cq = quaternion(v.x, v.y, v.z, s);
	return cq;
}

quaternion multiplication(quaternion q1, quaternion q2)
{
	float s1 = q1.w;
	float s2 = q2.w;

	vec3 v1 = vec3(q1.x, q1.y, q1.z);
	vec3 v2 = vec3(q2.x, q2.y, q2.z);

	float s = s1 * s2 - dot(v1, v2);
	vec3 v = s1 * v2 + s2 * v1 + cross(v1, v2);

	quaternion q = quaternion(v.x, v.y, v.z, s);
	return q;
}

void fragment()
{
	vec3 vertex_ws = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).rgb;
	vec3 position_ws = vertex_ws - _LightPosition;

	float x = -_LightRotation.x;
	float y = -_LightRotation.y;
	float z = -_LightRotation.z;

	vec3 axis_i = vec3(1, 0, 0);	// x
	vec3 axis_j = vec3(0, 1, 0);	// y
	vec3 axis_k = vec3(0, 0, 1);	// z

	quaternion qx = create(x, axis_i);
	quaternion qy = create(y, axis_j);
	quaternion qz = create(z, axis_k);

	quaternion q_YXZ = multiplication(qz, multiplication(qx, qy));
	quaternion _q = conjugate(q_YXZ);

	quaternion p = quaternion(position_ws.x, position_ws.y, position_ws.z, 0.0);
	quaternion pr = multiplication(q_YXZ, p);
	pr = multiplication(pr, _q);

	vec3 position_ws_rot = vec3(pr.x, pr.y, pr.z);
	vec2 uv_ws = position_ws_rot.xy + vec2(0.5);

	vec3 front_map = texture(_FrontMap, UV).rgb;
	vec3 back_map = texture(_BackMap, UV).rgb;
	float spot_map = texture(_SpotMap, uv_ws.xy).r;

	vec3 color = mix(front_map, back_map, spot_map);

	ALBEDO = color;
}

//void light()
//{
	 //
//}
