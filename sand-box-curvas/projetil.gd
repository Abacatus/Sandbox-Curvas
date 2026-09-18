extends Area2D

@export var velocidade: float = 600.0
@export var tempo_de_vida: float = 3.0

var direcao: Vector2 = Vector2.RIGHT
var jogador: Node = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

	await get_tree().create_timer(tempo_de_vida).timeout

	if is_inside_tree():
		queue_free()


func iniciar(nova_direcao: Vector2, novo_jogador: Node = null) -> void:
	direcao = nova_direcao.normalized()
	jogador = novo_jogador


func _physics_process(delta: float) -> void:
	position += direcao * velocidade * delta


func _on_body_entered(body: Node) -> void:
	if body == jogador:
		return

	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Alvos"):
		area.atingir()
		queue_free()
