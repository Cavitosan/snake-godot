extends CharacterBody2D
class_name Player

# ========================
# CONFIGURAÇÕES
# ========================

const MAX_SEGMENTS:= 10

@export var cell_size: int = 32
@export var segment_scene: PackedScene
@onready var body_container = $BodyContainer
@onready var snake_head = $SnakeHead

# ========================
# ESTADO
# ========================

var speed:= 200

var direction: Vector2 = Vector2.RIGHT
var next_direction: Vector2 = Vector2.RIGHT
var old_direction: Vector2
var position_spacing: int = 16
var rotation_spacing: int = 2

var snake_body_parts: Array = []
var position_history: Array = []
var rotation_history: Array = []



# ========================
# READY
# ========================

func _ready():
	
	pass


# ========================
# PROCESSAMENTO
# ========================

func _physics_process(delta):
	input_movement()
	movement_rotation(delta)
	
	move_and_slide()

	snake_movement_history()
	update_segments(delta)

# ========================
# FUNÇÕES
# ========================

func input_movement():
	#Pega um Vector2 para movimentação
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#Se o Vector2 for diferente de zero, a direction fica com o valor do último Vector2
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		
		#impede girada de 180º
		if input_vector != -direction:
			direction = input_vector
	#Velocity recebe o valor do Vector multiplicado por speed
	velocity = direction * speed

func movement_rotation(delta):
	#Se o objeto estiver se movimentando pegamos seu ângulo em radianos
	#Usamos seu ângulo na propriedade rotation
	if velocity.length() > 0:
		var target_angle = velocity.angle()
		snake_head.rotation = lerp_angle(snake_head.rotation, target_angle, 5 * delta)

func snake_movement_history():
	position_history.insert(0, snake_head.global_position)
	rotation_history.insert(0, snake_head.rotation)
	
	if position_history.size() > 1000:
		position_history.pop_back()
	
	if rotation_history.size() > 1000:
		rotation_history.pop_back()

func update_segments(delta):
	for i in range(snake_body_parts.size()):
		
		var position_index = (i + 1) * position_spacing #cada segmento ficaria na posição 16 frames anterior ao atual
		var rotation_index = (i + 1) * rotation_spacing
		
		if position_index < position_history.size():
			snake_body_parts[i].global_position = position_history[position_index]
			
		if rotation_index < rotation_history.size():
			snake_body_parts[i].rotation = lerp_angle(
				snake_body_parts[i].rotation,
				rotation_history[rotation_index],
				10 * delta
			)
	
func grow_tail():
	
	if snake_body_parts.size() >= MAX_SEGMENTS:
		return
	
	var new_segment = segment_scene.instantiate()
	body_container.add_child(new_segment)
	
	#se já existe pelo menos 1 segment
	if snake_body_parts.size() > 0:
		new_segment.global_position = snake_body_parts[-1].global_position
	else:
		new_segment.global_position = snake_head.global_position
	
	snake_body_parts.append(new_segment)
	
	
		
		
		
		
