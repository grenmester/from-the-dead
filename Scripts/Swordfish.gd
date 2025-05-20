extends CharacterBody2D

signal slash

@export var speed = 150
@export var flipped = false
@onready var sprite = $Sprite2D
@onready var tip = $Tip
var corpse_scene = preload("res://Scenes/Objects/Corpse.tscn")

func _ready() -> void:
	if flipped:
		configure()

func configure() -> void:
	sprite.flip_h = flipped
	tip.scale.x = -1 if flipped else 1

func _physics_process(delta: float) -> void:
	velocity.x = speed if flipped else -speed
	move_and_slide()
	if is_on_wall():
		flipped = !flipped
		configure()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("spines"):
		die()
		area.queue_free()

func die() -> void:
	var corpse = corpse_scene.instantiate()
	corpse.init(Enums.ShellType.SWORDFISH)
	Consts.root.add_child(corpse)
	corpse.position = self.global_position
	corpse.sprite.flip_h = flipped
	queue_free()

func _on_tip_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !body.is_hiding():
		body.die()

func _on_tip_area_entered(area: Area2D) -> void:
	if area.is_in_group("ropes"):
		emit_signal("slash")
