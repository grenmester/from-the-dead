extends CharacterBody2D

@export var gravity = 100
@export var type: Enums.ShellType

var sprite
var collider


func _ready():
	init(type)


func _physics_process(delta: float):
	velocity.y += gravity * delta
	move_and_slide()


func init(_type: Enums.ShellType):
	type = _type

	match type:
		Enums.ShellType.NORMAL:
			sprite = $Shell
			collider = $ShellCollider
		Enums.ShellType.PUFFERFISH:
			sprite = $Pufferfish
			collider = $PufferfishCollider
		Enums.ShellType.SWORDFISH:
			sprite = $Swordfish
			collider = $SwordfishCollider

	sprite.show()
	collider.set_deferred("disabled", false)
