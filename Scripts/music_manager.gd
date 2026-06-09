extends Node
class_name SoundManager

@onready var music_player: AudioStreamPlayer = $BG_Music
@onready var pickup_sound: AudioStreamPlayer = $PickUp_Sound
@onready var speed_down_sound: AudioStreamPlayer = $SpeedDown

# Array com as músicas — adicione quantas quiser
var tracks : Array = [
	preload("res://Assets/Musics/01 - Genesis - Soma Animus.wav"),
	preload("res://Assets/Musics/MainMenu.wav")
]
var current_track := 0 # índice da faixa atual


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player.finished.connect(_on_music_finished)
	play_current_track()

func play_current_track() -> void:
	# Define a música atual e toca
	music_player.stream = tracks[current_track]
	music_player.play()

func _on_music_finished() -> void:
	# Avança para a próxima faixa em loop circular
	current_track = (current_track + 1) % tracks.size()
	play_current_track()

func play_pickup() -> void:
	#Toca o som de coleta
	pickup_sound.play()

func play_speed_down() -> void:
	speed_down_sound.play()
