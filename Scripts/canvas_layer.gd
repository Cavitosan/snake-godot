extends CanvasLayer
class_name HUD

@onready var score_label: Label = $ScoreLabel
@onready var speed_label: Label = $SpeedLabel
@onready var score_manager: ScoreManager = get_parent().get_node("ScoreManager")

func _process(_delta: float) -> void:
	if is_instance_valid(score_manager):
		score_label.text = "SCORE: " + str(score_manager.get_score())
		speed_label.text = "SPEED: " + str(int(score_manager.get_speed_level()))
