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
		explode()
	elif body.is_in_group("player"):
		if !body.is_hiding():
			body.die()
		explode()
	elif body.is_in_group("fish"):
		body.die()
		explode()
	elif body.is_in_group("corpses"):
		explode()
	elif body.is_in_group("crate_platform"):
		body.queue_free()
		explode()


func explode():
	has_gravity = false
	$AnimatedSprite2D.play("explode")


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "explode":
		queue_free()
