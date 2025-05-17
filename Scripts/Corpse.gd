extends CharacterBody2D

@export var gravity = 100
@export_enum("shell", "pufferfish", "swordfish") var type: String
var sprite
var collider


func init(_type):
	type = _type

	match type:
		"shell":
			sprite = $Shell
			collider = $ShellCollider
		"pufferfish":
			sprite = $Pufferfish
			collider = $PufferfishCollider
		"swordfish":
			sprite = $Swordfish
			collider = $SwordfishCollider

	sprite.show()
	collider.set_deferred("disabled", false)


func _physics_process(delta: float):
	velocity.y += gravity * delta
	move_and_slide()
