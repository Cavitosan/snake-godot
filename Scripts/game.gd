extends Node2D
class_name Game

const GRID_SIZE  := 30
const GRID_WIDTH := 30
const GRID_HEIGTH:= 30

const SCREEN_WIDTH  := 1280
const SCREEN_HEIGHT := 960

@onready var score_manager: ScoreManager = $ScoreManager
@onready var bg: Sprite2D = $Background
@onready var player: Player = $Player
@onready var sound_manager: SoundManager = $SoundManager

@export var food_scene: PackedScene

var food
var scroll_speed:= 100


func _ready():
	randomize()
	spawn_food()

func _process(delta: float):
	scroll_bg(delta)
	wraparound()

func spawn_food():
	food = food_scene.instantiate()
	add_child(food)
	food.eaten.connect(_on_food_eaten)
	food.destroyed.connect(_on_food_destroyed)
	
	var random_x = randi_range(0, GRID_WIDTH - 1)
	var random_y = randi_range(0, GRID_HEIGTH - 1)
		
	var	new_position = Vector2i(random_x, random_y)
		
	food.grid_position = new_position
	food.update_position()

func _on_food_eaten():
	call_deferred("spawn_food")
	if is_instance_valid(player):
		player.grow(40)
	score_manager.add_planet_bonus()
	sound_manager.play_pickup()
	

func scroll_bg(delta):
	var rect = bg.region_rect
	rect.position.y += scroll_speed * delta
	
	if rect.position.y >= bg.texture.get_height():
		rect.position.y = 0
		
	bg.region_rect = rect

func wraparound():
	if not is_instance_valid(player):
		return
	
	var pos := player.global_position
	
	if pos.x > SCREEN_WIDTH:
		player.global_position.x = 0
		player.points.clear()
		apply_wrap_penalty()
		
	elif pos.x < 0:
		player.global_position.x = SCREEN_WIDTH
		player.points.clear()
		apply_wrap_penalty()
		
		
	if pos.y > SCREEN_HEIGHT:
		player.global_position.y = 0
		player.points.clear()
		apply_wrap_penalty()
		
	elif pos.y < 0:
		player.global_position.y = SCREEN_HEIGHT
		player.points.clear()
		apply_wrap_penalty()
		
func apply_wrap_penalty():
	player.speed -= 80
	if player.speed < player.base_speed:
		player.speed = player.base_speed
	sound_manager.play_speed_down()

func _on_food_destroyed() -> void:
	#Spawna nova food mas sem som, sem grow e sem bonus de score
	call_deferred("spawn_food")
