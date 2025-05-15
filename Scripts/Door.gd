extends StaticBody2D

@export var id: int
@export var offset: Vector2
var toggled = false

func _ready() -> void:
	for button in get_tree().get_nodes_in_group("buttons"):
		if button.id == id:
			if !button.is_connected("toggle", toggle):
				button.connect("toggle", toggle)

func toggle(i):
	if id == i:
		if !toggled:
			position += offset
			toggled = true
		else:
			position -= offset
			toggled = false
