extends Node
class_name Spawner_Asteroide

@export var asteroid_scene: PackedScene
@export var min_spawn_interval:= 3.0
@export var max_spawn_interval:= 6.5

@onready var score_manager: ScoreManager = get_parent().get_node("ScoreManager")

var spawn_timer:= 0.0

const SCREEN_WIDTH:= 1280.0

func _process(delta):
	update_difficulty()
	timer_asteroid_spawn(delta)
	
func timer_asteroid_spawn(delta):
	spawn_timer += delta
	if spawn_timer >= randf_range(min_spawn_interval, max_spawn_interval):
		spawn_timer = 0.0
		spawn_asteroid()
		
func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	get_parent().add_child(asteroid)
	asteroid.global_position = Vector2(randf_range(0, SCREEN_WIDTH), -50)

func update_difficulty() -> void:
	var score:= score_manager.get_score()
	
	if score >= 8500:
		min_spawn_interval = 1.0
		max_spawn_interval = 1.5
	elif score >= 5500:
		min_spawn_interval = 1.5 #muito rápido
		max_spawn_interval = 2.5	
	elif score >= 3500:
		min_spawn_interval = 2.5
		max_spawn_interval = 4.5
	elif score >= 1500:
		min_spawn_interval = 3.0
		max_spawn_interval = 6.5
	
	
