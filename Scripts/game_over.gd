extends Node2D
class_name GameOver

@onready var final_score_label: Label = $CanvasLayer/VBoxContainer/FinalScoreLabel
@onready var retry_button: Button = $CanvasLayer/VBoxContainer/Retry
@onready var quit_button: Button = $CanvasLayer/VBoxContainer/Quit
@onready var highscore_label: Label = $CanvasLayer/VBoxContainer/HighScoreLabel

var final_score: int = 0

func _ready() -> void:
	#Exibe o score final
	final_score_label.text = "SCORE: " + str(final_score)
	show_highscore()

	#Conecta os buttons
	retry_button.pressed.connect(_on_retry_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_retry_pressed():
	#Reinicia a cena do game
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func show_highscore() -> void:
	var scores := HighscoreManager.get_scores()
	var text := "---HIGHSCORES---\n"
	
	for i in range(scores.size()):
		text += str(i + 1) + ". " + str(scores[i]) + "\n"
		
	highscore_label.text = text
