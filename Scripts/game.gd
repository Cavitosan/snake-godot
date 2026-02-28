extends Node2D
class_name Game

const GRID_SIZE  := 30
const GRID_WIDTH := 30
const GRID_HEIGTH:= 30

@onready var bg: Sprite2D = $Background
@onready var player: Player = $Player

@export var food_scene: PackedScene

var food
var scroll_speed:= 100

func _ready():
	randomize()
	spawn_food()

func spawn_food():
	food = food_scene.instantiate()
	add_child(food)
	food.eaten.connect(_on_food_eaten)
	
	var random_x = randi_range(0, GRID_WIDTH - 1)
	var random_y = randi_range(0, GRID_HEIGTH - 1)
		
	var	new_position = Vector2i(random_x, random_y)
		
	food.grid_position = new_position
	food.update_position()

func _process(delta: float):
	var rect = bg.region_rect
	rect.position.y += scroll_speed * delta
	
	if rect.position.y >= bg.texture.get_height():
		rect.position.y = 0
		
	bg.region_rect = rect

func _on_food_eaten():
	spawn_food()
	player.grow_tail()
