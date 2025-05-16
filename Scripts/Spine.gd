extends Area2D

var flipped = false
var speed
var parent

func start(par, pos, spd):
	parent = par
	position = pos
	speed = spd

func _process(delta: float) -> void:
	position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player" and body.is_hiding) or body.name == "Shell":
		speed *= -1
		$Sprite2D.flip_v = true
		flipped = true
	elif body.is_in_group("doors"):
		queue_free()
