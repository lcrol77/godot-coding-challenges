extends Node

enum FunctionName {Wave, MultiWave, Ripple}

var functions: Array[Callable] = [wave, multi_wave, ripple]

func wave(x: float, z: float, t: float) -> float:
	return sin(PI * (x + z + t))

func multi_wave(x: float, z: float, t: float) -> float:
	var y := sin(PI * (x + 0.5*t))
	y += sin(2 * PI *(z+t)) * 0.5
	y += sin(PI * (x +z + 0.25 * t))

	return y * (1.0/2.5)

func ripple(x: float, z: float, t: float) -> float:
	var d = sqrt(x * x + z * z)
	var y = sin(PI*(4*d-t))
	return y / (1 + 10 * d)

func get_function(func_name: FunctionName) -> Callable:
	return functions[func_name]
