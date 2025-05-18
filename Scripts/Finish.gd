extends Area2D

signal win

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.shell_type == Enums.ShellType.NORMAL:
		emit_signal("win")
