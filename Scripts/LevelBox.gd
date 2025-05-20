extends PanelContainer

signal level_clicked(int)

@export var level_num: int

func _ready():
	$Label.text = str(level_num)


func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("level_clicked", level_num)
