extends CharacterBody2D

@export_category("Movimento")

@export var velocidade: float = 250.0
@export var aceleracao: float = 1200.0
@export var desaceleracao: float = 1500.0

@export var forca_pulo: float = -450.0
@export var gravidade: float = 1200.0

@export_category("Tiro")

@export var projetil_scene: PackedScene
@export var tempo_entre_tiros: float = 0.25

var pode_atirar: bool = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravidade * delta

	var direcao: float = Input.get_axis("ui_left", "ui_right")

	if direcao != 0.0:
		velocity.x = move_toward(
			velocity.x,
			direcao * velocidade,
			aceleracao * delta
		)
	else:
		velocity.x = move_toward(
			velocity.x,
			0.0,
			desaceleracao * delta
		)

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = forca_pulo

	if Input.is_action_just_pressed("Atirar") and pode_atirar:
		atirar()

	move_and_slide()


func atirar() -> void:
	if projetil_scene == null:
		return

	var projetil = projetil_scene.instantiate()

	get_tree().current_scene.add_child(projetil)

	var origem: Vector2 = $Mira.global_position
	var mouse: Vector2 = get_global_mouse_position()

	var direcao: Vector2 = (mouse - origem).normalized()

	projetil.global_position = origem
	projetil.iniciar(direcao, self)

	pode_atirar = false

	await get_tree().create_timer(tempo_entre_tiros).timeout

	pode_atirar = true
