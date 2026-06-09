extends Area2D
class_name Asteroide

@onready var sprite: Sprite2D = $Sprite2D

@export var min_speed_y      := 30.0
@export var max_speed_y      := 120.0
@export var min_speed_x      := -60.0
@export var max_speed_x      := 60.0
@export var rotation_speed := 1.5
@export var textures: Array[Texture2D] = []
@export var explosion_scene: PackedScene

var fall_speed := 0.0
var velocity   := Vector2.ZERO

const SCREEN_HEIGHT:= 960.0
const SCREEN_WIDTH := 1280.0

func _ready() -> void:
	setup_asteroid()
	randomize()
	
	
func _process(delta: float) -> void:
	asteroid_movement(delta)

func setup_asteroid():
	
	if textures.size() > 0:
		sprite.texture = textures[randi() % textures.size()]
	
	var random_scale := randf_range(1.5, 3.0)
	scale = Vector2(random_scale, random_scale)
	
	velocity = Vector2(
		randf_range(min_speed_x, max_speed_x),
		randf_range(min_speed_y, max_speed_y)
	)

func asteroid_movement(delta):
	position += velocity * delta
	rotation += rotation_speed * delta
	
	if position.x > SCREEN_WIDTH:
		position.x = 0
	if position.x < 0:
		position.x = SCREEN_WIDTH
	
	if global_position.y > SCREEN_HEIGHT + 80:
		self.queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Asteroide:
		explode()
		queue_free()
	
	if area.get_parent() is Player:
		explode()
		queue_free()
	
	if area is Food:
		explode()
		queue_free()
		
		var explosion = explosion_scene.instantiate()
		get_tree().current_scene.add_child(explosion)
		explosion.global_position = area.global_position
		explosion.activate()
		
		area.destroyed.emit() # emite o sinal em vez de queue_free direto
		area.queue_free()
		queue_free()
		
	

func explode() -> void:
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
	explosion.activate()
