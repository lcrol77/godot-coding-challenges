@tool
extends Node

@onready var light = $DirectionalLight3D
@onready var mesh = $Crypt 
@onready var shader_mat := mesh.material_override as ShaderMaterial
	
func _process(_delta):
	if Engine.is_editor_hint():
		shader_mat.set_shader_parameter("_LightPosition", light.position)
		shader_mat.set_shader_parameter("_LightRotation", light.rotation)
