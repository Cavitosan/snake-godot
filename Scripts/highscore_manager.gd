extends Node


#Caminho do arquivo onde os scores serão salvos
const SAVE_PATH := "user://highscores.save"
const MAX_SCORES := 5

var scores: Array[int] = []

func _ready() -> void:
	load_scores() # carrega os scores ao iniciar o jogo

func load_scores() -> void:
	# Verifica se o arquivo existe antes de tentar abrir
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	scores = file.get_var() #lê o arquivo salvo
	file.close()

func save_scores() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(scores) #salva o array no arquivo
	file.close()

func add_score(new_score: int) -> void:
	scores.append(new_score)
	#Ordena do maior para o menor
	scores.sort()
	scores.reverse()
	#Mantém só os 5 melhores
	if scores.size() > MAX_SCORES:
		scores.resize(MAX_SCORES)
	save_scores()

func get_scores() -> Array[int]:
	return scores
