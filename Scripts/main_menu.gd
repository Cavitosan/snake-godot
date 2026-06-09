extends Node2D
class_name MainMenu

@onready var background: Sprite2D = $Background
@onready var start_button: Button = $CanvasLayer/VBoxContainer/Start
@onready var quit_button: Button = $CanvasLayer/VBoxContainer/Quit
@onready var music: AudioStreamPlayer = $BG_Music
@onready var hover_sound: AudioStreamPlayer = $HoverSound

var scroll_speed := 100.0

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	#Conecta o hover nos dois botões
	start_button.mouse_entered.connect(_on_button_hover)
	quit_button.mouse_entered.connect(_on_button_hover)
	
	background.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_background(delta)

func scroll_background(delta: float):
	var rect = background.region_rect
	rect.position.y += scroll_speed * delta
	
	if rect.position.y >= background.texture.get_height():
		rect.position.y = 0
	background.region_rect = rect

func _on_start_button_pressed():
	music.stop() #para a música antes de trocar de cena
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_button_hover() -> void:
	#Toca o som de hover
	hover_sound.play()
