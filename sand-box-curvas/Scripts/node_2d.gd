extends Node2D

@export_category("Interpolação")

@export var valor_inicial: float = 100.0
@export var valor_final: float = 900.0

@export_range(0.1, 20.0, 0.1)
var duracao: float = 3.0

@export_category("Visual")

@export var altura_entre_cubos: float = 80.0
@export var tamanho_cubo: float = 30.0

@export_category("Controle")

@export var iniciar_automaticamente: bool = true
@export var repetir: bool = true


var tempo: float = 0.0
var rodando: bool = false

var cubos: Array[ColorRect] = []


func _ready() -> void:
	criar_cubos()

	if iniciar_automaticamente:
		rodando = true


func criar_cubos() -> void:
	var nomes = [
		"Linear",
		"Ease In",
		"Ease Out",
		"Ease In-Out"
	]

	for i in range(4):
		var cubo := ColorRect.new()

		cubo.name = nomes[i]
		cubo.size = Vector2(tamanho_cubo, tamanho_cubo)

		match i:
			0:
				cubo.color = Color(0.2, 0.8, 1.0)
			1:
				cubo.color = Color(1.0, 0.4, 0.4)
			2:
				cubo.color = Color(0.4, 1.0, 0.5)
			3:
				cubo.color = Color(1.0, 0.8, 0.2)

		add_child(cubo)
		cubos.append(cubo)

		atualizar_posicao_cubo(cubo, float(i), 0.0)


func _process(delta: float) -> void:
	if not rodando:
		return

	tempo += delta

	var t: float = tempo / duracao

	if t >= 1.0:
		t = 1.0

	atualizar_cubos(t)

	if tempo >= duracao:
		if repetir:
			tempo = 0.0
		else:
			rodando = false


# ============================================================
# ATUALIZA TODOS OS CUBOS
# ============================================================

func atualizar_cubos(t: float) -> void:

	# Linear
	var linear : float = lerp(valor_inicial, valor_final, t)

	# Ease In
	var ease_in : float = lerp(valor_inicial, valor_final, ease_in_curve(t))

	# Ease Out
	var ease_out : float= lerp(valor_inicial, valor_final, ease_out_curve(t))

	# Ease In-Out
	var ease_in_out : float = lerp(valor_inicial, valor_final, ease_in_out_curve(t))

	atualizar_posicao_cubo(cubos[0], 0.0, linear)
	atualizar_posicao_cubo(cubos[1], 1.0, ease_in)
	atualizar_posicao_cubo(cubos[2], 2.0, ease_out)
	atualizar_posicao_cubo(cubos[3], 3.0, ease_in_out)


func atualizar_posicao_cubo(cubo: ColorRect, indice: float, x: float) -> void:
	cubo.position = Vector2(
		x - tamanho_cubo / 2.0,
		100.0 + indice * altura_entre_cubos
	)


func ease_in_curve(t: float) -> float:
	return t * t


func ease_out_curve(t: float) -> float:
	return 1.0 - pow(1.0 - t, 2.0)


func ease_in_out_curve(t: float) -> float:
	if t < 0.5:
		return 2.0 * t * t
	else:
		return 1.0 - pow(-2.0 * t + 2.0, 2.0) / 2.0


func _input(event: InputEvent) -> void:

	if event is InputEventKey and event.pressed:

		if event.keycode == KEY_SPACE:
			rodando = not rodando

		if event.keycode == KEY_R:
			reiniciar()


func reiniciar() -> void:
	tempo = 0.0
	rodando = true
