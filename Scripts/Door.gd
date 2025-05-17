extends StaticBody2D

@export var closed = true
@export_enum("red", "green", "yellow") var color = "red"
var openDoor
var closedDoor

func _ready():
	match color:
		"red":
			openDoor = $OpenRedDoor
			closedDoor = $ClosedRedDoor
		"green":
			openDoor = $OpenGreenDoor
			closedDoor = $ClosedGreenDoor
		"yellow":
			openDoor = $OpenYellowDoor
			closedDoor = $ClosedYellowDoor

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
		openDoor.hide()
		closedDoor.show()
	else:
		openDoor.show()
		closedDoor.hide()
