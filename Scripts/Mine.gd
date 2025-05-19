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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
	elif body.is_in_group("player"):
		if !body.is_hiding():
			body.die()
		queue_free()
	elif body.is_in_group("fish"):
		body.die()
		queue_free()
	elif body.is_in_group("corpses"):
		queue_free()
	elif body.is_in_group("crate_platform"):
		body.queue_free()
		queue_free()
