extends Area2D

signal snap

@export var id: int
var is_on_player = false

func _ready() -> void:
	get_tree().get_nodes_in_group("player")[0].connect("slash", slash)
	for rope in get_tree().get_nodes_in_group("ropes"):
		if rope != self and rope.id == id and !rope.is_connected("snap", queue_free):
			rope.connect("snap", queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_on_player = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_on_player = false

func slash() -> void:
	if is_on_player:
		emit_snap()

func emit_snap() -> void:
	emit_signal("snap")
	queue_free()
