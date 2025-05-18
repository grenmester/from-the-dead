extends Control

func _on_exit_button_pressed() -> void:
	$LevelMenu.unload_level()
