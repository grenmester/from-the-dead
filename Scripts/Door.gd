extends StaticBody2D

@export var id: int
@export var closed = true

func _ready() -> void:
	if !closed:
		configure()
	for button in get_tree().get_nodes_in_group("buttons"):
		if button.id == id:
			if !button.is_connected("toggle", toggle):
				button.connect("toggle", toggle)

func toggle(i):
	if id == i:
		closed = !closed
		configure()

func configure():
		$CollisionShape2D.set_deferred("disabled", !closed)
		$Sprite2D.visible = closed
