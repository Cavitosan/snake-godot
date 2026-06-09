extends Node
class_name ScoreManager

@onready var player: Player = get_parent().get_node("Player")

var score             := 0.0
var points_per_second := 10.0
var planet_bonus      := 400.0

func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	#Pontos por segundo multiplicados pela velocidade atual
	var speed_multiplier = player.speed / player.base_speed
	score += points_per_second * speed_multiplier * delta

func add_planet_bonus() -> void:
	score += planet_bonus

func get_score() -> int:
	return int(score)

func get_speed_level() -> int:
	if not is_instance_valid(player):
		return 1
		
	var t = (player.speed - player.base_speed) / (player.max_speed - player.base_speed)
	return clampi(int(t * 5) + 1, 1, 5)
