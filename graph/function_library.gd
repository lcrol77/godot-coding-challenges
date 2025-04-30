extends Node

enum FunctionName {Wave, MultiWave, Ripple, ScalingSphere, VerticalBandsSphere}

var functions: Array[Callable] = [wave, multi_wave, ripple, scaling_sphere,vertical_bands_sphere]

func get_function(func_name: FunctionName) -> Callable:
	return functions[func_name]

func wave(u: float, v: float, t: float) -> Vector3:
	var p = Vector3()
	p.x =u
	p.y = sin(PI * (u + v + t))
	p.z = v
	return p

func multi_wave(u: float, v: float, t: float) -> Vector3:
	var p = Vector3()
	p.x = u
	p.y = sin(PI * (u + 0.5*t))
	p.y += sin(2 * PI *(v+t)) * 0.5
	p.y += sin(PI * (u +v + 0.25 * t))
	p.y *= (1.0/2.5)
	p.z = v
	return p

func ripple(u: float, v: float, t: float) -> Vector3:
	var d = sqrt(u * u + v * v)
	var p = Vector3()
	p.x = u
	p.y = sin(PI*(4*d-t))
	p.y /= 1 + 10 * d
	p.z = v
	return p

func scaling_sphere(u: float, v: float, t: float) -> Vector3:
	var r = 0.5 + 0.5 *sin(PI* t)
	var s = r * cos(.5 * PI *v)
	var p = Vector3()
	p.x = s * sin(PI * u)
	p.y = r * sin(PI * .5 * v)
	p.z = s * cos(PI*u)
	return p

func vertical_bands_sphere(u: float, v: float, t: float) -> Vector3:
	var r = 0.9 + 0.1 *sin(PI* (6 * u +t))
	var s = r * cos(.5 * PI *v)
	var p = Vector3()
	p.x = s * sin(PI * u)
	p.y = r * sin(PI * .5 * v)
	p.z = s * cos(PI*u)
	return p
