extends Control

func _on_exit_button_pressed() -> void:
	$LevelMenu.unload_level()

func _on_reset_button_pressed() -> void:
	$LevelMenu.reload_level()
