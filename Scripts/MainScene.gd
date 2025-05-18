extends Control

var started = false

func _on_exit_button_pressed() -> void:
	$LevelMenu.unload_level()

func _on_reset_button_pressed() -> void:
	$LevelMenu.reload_level()

func _input(event) -> void:
	if event.is_pressed() and !started:
		$TitleScreen.hide()
		$LevelMenu.show()
		started = true
