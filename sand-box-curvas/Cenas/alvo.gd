extends Area2D

@export var plataforma: NodePath


func atingir() -> void:
	var plataforma_node = get_node_or_null(plataforma)

	if plataforma_node:
		plataforma_node.ativar()
