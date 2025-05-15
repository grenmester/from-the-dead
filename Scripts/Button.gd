extends Area2D

signal toggle(id)

@export var id: int
var toggled = false
var body_count = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("button_pushers"):
		body_count += 1
		if !toggled:
			on()
			toggled = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("button_pushers"):
		body_count -= 1
		if body_count == 0 and toggled:
			off()
			toggled = false

func on():
	$AnimatedSprite2D.play("default")
	emit_signal("toggle", id)

func off():
	$AnimatedSprite2D.stop()
	emit_signal("toggle", id)
