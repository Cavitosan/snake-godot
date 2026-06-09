extends Node
class_name PlayerCollisionManager

@onready var player: Player = get_parent()
@onready var hitbox: Area2D = get_parent().get_node("Area2D")
@export  var explosion_scene: PackedScene
@export  var explosion_count := 5
@export  var self_collision_radius := 10.0
@export var self_collision_skip := 15
@export var game_over_scene: PackedScene

var is_dying := false

func _ready():
	pass

func _physics_process(_delta: float) -> void:
	if is_dying:
		return
	check_self_collision()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Asteroide:
		die()

func check_self_collision() -> void:
	if player.points.size() < self_collision_skip + 5:
		return
	
	var head := player.points[0]
	
	for i in range(self_collision_skip, player.points.size()):
		if head.distance_to(player.points[i]) < self_collision_radius:
			die()
			return

func die() -> void:
	#evita chamadas múltiplas
	if is_dying:
		return
	is_dying = true
	# para o movimento e física do player
	player.set_physics_process(false)

	#Aguarda a animação para mostrar o GameOver
	await explode_body()
	
	var score_manager = get_tree().current_scene.get_node("ScoreManager")
	HighscoreManager.add_score(score_manager.get_score())	
	
	var game_over = game_over_scene.instantiate()
	game_over.final_score = score_manager.get_score()

	get_tree().current_scene.add_child(game_over)
	
	#Passa o score para o GameOver	
	player.queue_free()

func explode_body() -> void:
	
	for i in range(explosion_count):
		var random_index := randi() % player.points.size()
		var explosion = explosion_scene.instantiate()
		
		#Adiciona na cena raiz para não ser destruída junto com o player
		get_tree().current_scene.add_child(explosion)
		explosion.global_position = player.points[random_index]
		explosion.activate()
		
		await get_tree().create_timer(0.2).timeout
	
	await get_tree().create_timer(0.3).timeout
