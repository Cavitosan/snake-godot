extends Node2D
class_name Borders

@onready var left: Area2D   = $Left
@onready var right: Area2D  = $Right
@onready var top: Area2D    = $Top
@onready var bottom: Area2D = $Bottom

@export var player: Player

const SCREEN_WIDTH:=  1280.0
const SCREEN_HEIGHT:= 960.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signals_connect()

func signals_connect():
	
	left.body_exited.connect(_on_border_exited)
	right.body_exited.connect(_on_border_exited)
	top.body_exited.connect(_on_border_exited)
	bottom.body_exited.connect(_on_border_exited)

func _on_border_entered(body: CharacterBody2D, border: String):
	if not body is Player:
		return
	
	if player.wrapping:
		return
	
	player.wrapping = true
	_disconnect_entered()	
	
	match border:
		"left": player.global_position.x = SCREEN_WIDTH
		"right": player.global_position.x = 0
		"top": player.global_position.y = SCREEN_HEIGHT
		"bottom": player.global_position.y = 0

func _on_border_exited(body: CharacterBody2D):
	if not body is Player:
		return	
	if not player.wrapping:
		return
	
	player.points.clear()
	player.wrapping = false
	_connect_entered()
	
func _disconnect_entered():
	left.body_entered.disconnect(_on_border_entered)
	right.body_entered.disconnect(_on_border_entered)
	top.body_entered.disconnect(_on_border_entered)
	bottom.body_entered.disconnect(_on_border_entered)

func _connect_entered():
	left.body_entered.connect(_on_border_entered.bind("left"))
	right.body_entered.connect(_on_border_entered.bind("right"))
	top.body_entered.connect(_on_border_entered.bind("top"))
	bottom.body_entered.connect(_on_border_entered.bind("bottom"))
