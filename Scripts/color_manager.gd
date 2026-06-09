extends Node
class_name ColorManager

@onready var player: Player = get_parent()

var textures: Array = [
	preload("res://Assets/texturebody3.png"),
	preload("res://Assets/texturebody4.png")
]

func randomize_appearance() -> void:
	var random_texture = textures[randi() % textures.size()]
	var random_color := Color(randf(), randf(), randf())

	#Acessa o material do Shader já configurado na line
	var shader_mat = player.line.material as ShaderMaterial
	shader_mat.set_shader_parameter("body_texture", random_texture)
	shader_mat.set_shader_parameter("snake_color", random_color)
	
