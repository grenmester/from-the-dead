extends Area2D

signal win

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.shell_type == Enums.ShellType.NORMAL:
			emit_signal("win")
		elif $Label.visible == false:
			$Label.show()
			$Timer.wait_time = 5
			$Timer.start()


func _on_timer_timeout() -> void:
	$Label.hide()
