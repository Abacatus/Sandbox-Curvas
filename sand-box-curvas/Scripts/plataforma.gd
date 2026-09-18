extends AnimatableBody2D

enum CurveType {
	LINEAR,
	EASE_IN,
	EASE_OUT,
	EASE_IN_OUT
}

@export_category("Movimento")

@export var deslocamento: Vector2 = Vector2(0, -250)

@export_range(0.1, 10.0, 0.1)
var duracao: float = 2.0

@export var curva: CurveType = CurveType.EASE_IN_OUT

@export_category("Configuração")

@export var voltar: bool = false

var posicao_inicial: Vector2

var tempo: float = 0.0
var movendo: bool = false
var sentido: float = 1.0


func _ready() -> void:
	posicao_inicial = position


func _physics_process(delta: float) -> void:
	if not movendo:
		return

	tempo += delta

	var t: float = tempo / duracao
	t = clampf(t, 0.0, 1.0)

	var progresso: float = aplicar_curva(t)

	if sentido < 0:
		progresso = 1.0 - progresso

	position = posicao_inicial.lerp(
		posicao_inicial + deslocamento,
		progresso
	)

	if t >= 1.0:
		if voltar:
			sentido *= -1.0
			tempo = 0.0
		else:
			movendo = false


func aplicar_curva(t: float) -> float:
	match curva:

		CurveType.LINEAR:
			return t

		CurveType.EASE_IN:
			return t * t

		CurveType.EASE_OUT:
			return 1.0 - pow(1.0 - t, 2.0)

		CurveType.EASE_IN_OUT:
			if t < 0.5:
				return 2.0 * t * t
			else:
				return 1.0 - pow(-2.0 * t + 2.0, 2.0) / 2.0

	return t


func ativar() -> void:
	tempo = 0.0
	sentido = 1.0
	movendo = true
