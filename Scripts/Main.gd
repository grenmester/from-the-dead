extends Node2D

@onready var level = $Level4

func _ready() -> void:
	level.get_node("Camera2D").make_current()
	$Player.position = level.get_node("Marker2D").position

#func _on_room_body_entered(body: Node2D) -> void:
	#if body.name == "Player":
		#$Camera2D.position = body.get_position()
		#$Camera2D.make_current()
		#var tween = create_tween()
		#tween.tween_property($Camera2D, "position", $Room/CollisionShape2D.position, 2)

#func _on_room_body_exited(body: Node2D) -> void:
	#if body.name == "Player":
		#var tween = create_tween()
		#tween.tween_property($Camera2D, "position", body.get_position(), 2)
		#tween.finished.connect($Player/Camera2D.make_current)

func _on_player_hit():
	$Player.position = level.get_node("Marker2D").position
