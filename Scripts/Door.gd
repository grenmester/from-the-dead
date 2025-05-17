extends StaticBody2D

@export var closed = true
@export_enum("red", "green", "yellow") var color = "red"
var open_door
var closed_door


func _ready():
	match color:
		"red":
			open_door = $OpenRedDoor
			closed_door = $ClosedRedDoor
		"green":
			open_door = $OpenGreenDoor
			closed_door = $ClosedGreenDoor
		"yellow":
			open_door = $OpenYellowDoor
			closed_door = $ClosedYellowDoor

	configure()

	for button in get_tree().get_nodes_in_group("buttons"):
		if button.color == color and !button.is_connected("toggle", toggle):
			button.connect("toggle", toggle)


func toggle(button_color):
	if button_color == color:
		closed = !closed
		configure()


func configure():
	$CollisionShape2D.set_deferred("disabled", !closed)

	if closed:
		open_door.hide()
		closed_door.show()
	else:
		open_door.show()
		closed_door.hide()
