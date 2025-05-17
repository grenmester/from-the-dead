extends Area2D

signal toggle(color)

@export_enum("red", "green", "yellow") var color = "red"
var toggled = false
var disabled_button
var enabled_button
var body_count = 0


func _ready():
	configure()
	disabled_button.show()


func _on_body_entered(body: Node2D):
	if body.is_in_group("button_pushers"):
		body_count += 1
		if !toggled:
			disabled_button.hide()
			enabled_button.show()
			emit_signal("toggle", color)
			toggled = true


func _on_body_exited(body: Node2D):
	if body.is_in_group("button_pushers"):
		body_count -= 1
		if body_count == 0 and toggled:
			enabled_button.hide()
			disabled_button.show()
			emit_signal("toggle", color)
			toggled = false


func configure():
	match color:
		"red":
			disabled_button = $DisabledRedButton
			enabled_button = $EnabledRedButton
		"green":
			disabled_button = $DisabledGreenButton
			enabled_button = $EnabledGreenButton
		"yellow":
			disabled_button = $DisabledYellowButton
			enabled_button = $EnabledYellowButton
