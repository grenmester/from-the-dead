extends CharacterBody2D

@export var rope_id = -1
@export var gravity = 150
var has_gravity = true

func _ready() -> void:
	if rope_id != -1:
		for rope in get_tree().get_nodes_in_group("ropes"):
			if rope.id == rope_id and !rope.is_connected("snap", drop):
				rope.connect("snap", drop)
				has_gravity = false

func _physics_process(delta: float) -> void:
	if has_gravity:
		velocity.y += gravity * delta
		move_and_slide()

func drop() -> void:
	has_gravity = true
