extends CharacterBody2D
class_name Player

# ========================
# CONFIGURAÇÕES
# ========================

@onready var line: Line2D = $Line2D       # Linha que representa o corpo da cobra
@onready var sprite_eye1: Sprite2D = $SnakeEye1 # Sprite da cabeça/olho, rotaciona conforme a direção
@onready var sprite_eye2: Sprite2D = $SnakeEye2


@export var base_speed:= 200.0  #Velocidade de deslocamento em px/s
@export var max_speed:= 500.0
var speed = base_speed

@export var turn_speed:= 3.0 #Suavidade da curva ao mudar de direção (lerp factor)
@export var initial_segments:= 25 #Quantidade de segmentos gerados ao iniciar
@export var segment_spacing:= 15 #Distância em px entre cada segmento inicial
@export var max_length:= 200 #Compimento máximo do corpo em px (cresce com grow())

var direction: Vector2 = Vector2.RIGHT #Direção atual do movimento, sempre normalizada
var points: PackedVector2Array = PackedVector2Array() #Histórico de posições que formam o corpo
var line_gradient: Line2D


# ========================
# READY
# ========================

func _ready(): #Gera o corpo inicial
	randomize()
	initializing_snake()
	setup_line()
	$ColorManager.randomize_appearance()
	update_line()


# ========================
# PROCESSAMENTO
# ========================

func _physics_process(_delta): #Ordem importa: input > move > atualiza corpo > atualiza visual
	input_movement()
	move_and_slide()
	update_body()
	update_line()
	update_eyes_position()
	
# ========================
# FUNÇÕES
# ========================
func update_line(): #converte o histórico de posições globais para local da Line2D e aplica
	var local_points = PackedVector2Array()
	for p in points:
		local_points.append(line.to_local(p))
	
	line.points = local_points
	line_gradient.points = local_points 

func setup_line(): #Configura aparencia da Line2D - roda só uma vez no _ready
	
	# --- LINHA DE BAIXO: corpo com textura ---
	line.width = 23.0
	line.joint_mode =     Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode =   Line2D.LINE_CAP_ROUND
	
	# --- Tile repete a textura ao longo da linha sem distorcer ao crescer
	line.texture_mode = Line2D.LINE_TEXTURE_TILE
	
	# --- LINHA DE CIMA: gradiente de transparência ---
	line_gradient = Line2D.new()
	add_child(line_gradient)
	
	line_gradient.width = 12.0
	line_gradient.joint_mode =     Line2D.LINE_JOINT_ROUND
	line_gradient.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line_gradient.end_cap_mode =   Line2D.LINE_CAP_ROUND
	
	var gradient:= Gradient.new()
	gradient.set_color(0, Color(1, 1, 1, 0.0)) # CABEÇA TRANSPARENTE
	gradient.set_color(1, Color(0, 0, 0, 0.8)) #CAUDA ESCURECE E SOME
	line_gradient.gradient = gradient
	
	# --- CRIANDO DIFERENÇA DE TAMANHO NA SEGMENTAÇÃO DE CABEÇA E CORPO
	var width_curve := Curve.new()
	width_curve.add_point(Vector2(0.0, 1.5)) #cabeça
	width_curve.add_point(Vector2(0.3, 1.0)) #corpo
	width_curve.add_point(Vector2(1.0, 0.4)) #cauda
	line.width_curve = width_curve
	line_gradient.width_curve = width_curve
	
	
	# -- CONFIGURAÇÃO DE SCROLL TEXTURE VIA SHADER
	var shader_mat := ShaderMaterial.new()
	shader_mat.shader = preload("res://Resources/body_scroll.gdshader")
	shader_mat.set_shader_parameter("scroll_speed", -5000.0)
	line.material = shader_mat
	
	#Garante que o Sprite2D fique na frente de tudo
	sprite_eye1.z_index = 1
	sprite_eye2.z_index = 1

func initializing_snake(): #Preenche o array de pontos com segmentos à esquerda da origem
	points.clear()
	
	for i in range(initial_segments):
		points.append(Vector2(-i * segment_spacing, 0))
		
	max_length = initial_segments * segment_spacing
	

func input_movement(): #Rotaciona a direção suavemente com lerp e aplica velocity + rotação do sprite
	
	var input_vector:= Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_vector != Vector2.ZERO:
		direction = direction.lerp(input_vector.normalized(), turn_speed * get_physics_process_delta_time())
		direction = direction.normalized()
	
	#sprite_eye1.rotation = direction.angle()
	#sprite_eye2.rotation = direction.angle()
	
	velocity = direction * speed
		
func update_body(): #Insere posição atual no histórico e corta a cauda que excede max_length
	points.insert(0, global_position)
	
	var total_length := 0.0
	
	for i in range(points.size() - 1):
		total_length += points[i].distance_to(points[i + 1])
		if total_length > max_length:
			points.resize(i + 1)
			break
	
	if points.size() > 0:
		var tail := points[-1]
		if tail.x > 1280 or tail.x < 0 or tail.y > 960 or tail.y < 0:
			points.clear()

func grow(amount: int) -> void:
	max_length += amount
	if speed < max_speed:
		speed += 20
	
func reset_body():
	points.clear()

#func die():
	#queue_free()

func update_eyes_position():
	var forward:= direction.normalized()
	var perpendicular := Vector2(-forward.y, forward.x)
	var offset_forward:= - 15.0 # diminua para afastar da ponta
	var offset_side:= 10.0    # aumente para afastar os olhos entre si
	
	sprite_eye1.position = forward * offset_forward + perpendicular * offset_side
	sprite_eye2.position = forward * offset_forward - perpendicular * offset_side
	
