extends CPUParticles2D
class_name Particles_explosion

func _ready() -> void:
	emitting = false
	# Aguarda o tempo de vida das partículas e se auto-destrói
	
func activate() -> void:
	$".".emitting = true
	$SmallParticles.emitting = true
	AudioManager.play_explosion() # Acessa o singleton diretamente
	await get_tree().create_timer(lifetime + 0.4).timeout
	queue_free()
