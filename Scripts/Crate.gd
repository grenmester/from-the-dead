extends RigidBody2D

@export var rope_id = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if rope_id != -1:
		for rope in get_tree().get_nodes_in_group("ropes"):
			if rope.id == rope_id and !rope.is_connected("snap", drop):
				rope.connect("snap", drop)
				freeze = true
				set_collision_layer_value(1, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func drop() -> void:
	freeze = false
	set_collision_layer_value(1, false)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		set_collision_layer_value(1, true)
