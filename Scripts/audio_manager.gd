extends Node

var explosion_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Cria o AudioStreamPlayer via código pois não temos cena
	explosion_player = AudioStreamPlayer.new()
	add_child(explosion_player)
	
	#Carrega o som de explosão
	explosion_player.stream = preload("res://Assets/Sounds/explosion.wav")
	
	#Volume um pouco mais baixo para não sobrepor a música
	explosion_player.volume_db = -5.0

func play_explosion() -> void:
	#Toca o som - se já estiver tocando, reinícia do inicio
	explosion_player.stop()
	explosion_player.play()
