extends Area2D

signal win

enum ShellType {
	NORMAL,
	NONE,
	PUFFERFISH,
	SWORDFISH,
}

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.shell_type == ShellType.NORMAL:
		emit_signal("win")
