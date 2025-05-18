extends CharacterBody2D

enum ShellType {
	NORMAL,
	NONE,
	PUFFERFISH,
	SWORDFISH,
}

@export var gravity = 100
@export var type: ShellType

var sprite
var collider


func _ready():
	init(type)


func _physics_process(delta: float):
	velocity.y += gravity * delta
	move_and_slide()


func init(_type: ShellType):
	type = _type

	match type:
		ShellType.NORMAL:
			sprite = $Shell
			collider = $ShellCollider
		ShellType.PUFFERFISH:
			sprite = $Pufferfish
			collider = $PufferfishCollider
		ShellType.SWORDFISH:
			sprite = $Swordfish
			collider = $SwordfishCollider

	sprite.show()
	collider.set_deferred("disabled", false)
