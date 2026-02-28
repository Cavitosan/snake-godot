extends Area2D
class_name Food

signal eaten

const GRID_SIZE:= 30 #Um a menos para que não fique colado nos cantos da tela

var grid_position: Vector2i
var pulse_tween: Tween

func update_position():
	position = grid_position * GRID_SIZE

func _ready():
	body_entered.connect(_on_body_entered)
	start_pulse()

func _on_body_entered(body):
	if body is Player:
		play_eat_animation()

func start_pulse():
	var tween = create_tween()
	tween.set_loops()
	
	tween.tween_property(self, "modulate", Color(1.5, 1.5, 1.5), 0.5)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.5)
	

func play_eat_animation():
	set_deferred("monitoring", false) #evita múltiplas colisões
	if pulse_tween:
		pulse_tween.kill()
	
	var tween = create_tween()	
	tween.tween_property(self, "scale", Vector2(2.4, 2.4), 0.4)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.4)
	
	tween.finished.connect(_on_animation_finished)


func _on_animation_finished():
	eaten.emit()
	queue_free()
