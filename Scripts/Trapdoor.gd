extends StaticBody2D

@export var closed = true
@export var color = Enums.TrapdoorColor.RED

var open_trapdoor
var closed_trapdoor


func _ready():
	match color:
		Enums.TrapdoorColor.RED:
			open_trapdoor = $OpenRedTrapdoor
			closed_trapdoor = $ClosedRedTrapdoor
		Enums.TrapdoorColor.GREEN:
			open_trapdoor = $OpenGreenTrapdoor
			closed_trapdoor = $ClosedGreenTrapdoor
		Enums.DoorColor.YELLOW:
			open_trapdoor = $OpenYellowTrapdoor
			closed_trapdoor = $ClosedYellowTrapdoor

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
		open_trapdoor.hide()
		closed_trapdoor.show()
	else:
		open_trapdoor.show()
		closed_trapdoor.hide()
