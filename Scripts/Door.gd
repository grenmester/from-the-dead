extends StaticBody2D

@export var closed = true
@export var color = Enums.DoorColor.RED

var open_door
var closed_door
var body_count = 0


func _ready():
	match color:
		Enums.DoorColor.RED:
			open_door = $OpenRedDoor
			closed_door = $ClosedRedDoor
		Enums.DoorColor.GREEN:
			open_door = $OpenGreenDoor
			closed_door = $ClosedGreenDoor
		Enums.DoorColor.YELLOW:
			open_door = $OpenYellowDoor
			closed_door = $ClosedYellowDoor

	configure()

	for button in get_tree().get_nodes_in_group("buttons"):
		if button.color == color and !button.is_connected("toggle", toggle):
			button.connect("toggle", toggle)


func toggle(button_color):
	if button_color == color:
		closed = !closed
		if body_count == 0:
			configure()


func configure():
	$CollisionShape2D.set_deferred("disabled", !closed)

	if closed:
		open_door.hide()
		closed_door.show()
	else:
		open_door.show()
		closed_door.hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("door_blockers"):
		body_count += 1


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("door_blockers"):
		body_count -= 1
		if body_count == 0:
			configure()
