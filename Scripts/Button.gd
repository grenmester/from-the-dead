extends Area2D

signal toggle(color)

@export_enum("red", "green", "yellow") var color = "red"
var toggled = false
var disabledButton
var enabledButton
var body_count = 0

func _ready():
	configure()
	disabledButton.show()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("button_pushers"):
		body_count += 1
		if !toggled:
			disabledButton.hide()
			enabledButton.show()
			emit_signal("toggle", color)
			toggled = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("button_pushers"):
		body_count -= 1
		if body_count == 0 and toggled:
			enabledButton.hide()
			disabledButton.show()
			emit_signal("toggle", color)
			toggled = false


func configure():
	match color:
		"red":
			disabledButton = $DisabledRedButton
			enabledButton = $EnabledRedButton
		"green":
			disabledButton = $DisabledGreenButton
			enabledButton = $EnabledGreenButton
		"yellow":
			disabledButton = $DisabledYellowButton
			enabledButton = $EnabledYellowButton
