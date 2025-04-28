extends Node

enum FunctionName {Wave, MultiWave, Ripple}

var functions: Array[Callable] = [wave, multi_wave, ripple]

func wave(x: float, t: float) -> float:
	return sin(PI * (x + t))

func multi_wave(x: float, t: float) -> float:
	var y := sin(PI * (x + 0.5*t))
	y += sin(2 * PI *(x+t)) * 0.5
	return y * (2.0/3.0)

func ripple(x: float, t: float) -> float:
	var d = abs(x)
	var y = sin(PI*(4*d-t))
	return y / (1 + 10 * d)

func get_function(func_name: FunctionName) -> Callable:
	return functions[func_name]
