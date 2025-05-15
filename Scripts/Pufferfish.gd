extends CharacterBody2D

var spine_scene = preload("res://Scenes/Spine.tscn")
var pufferfish_corpse_scene = preload("res://Scenes/PufferfishCorpse.tscn")

func _ready() -> void:
	$Timer.wait_time = 1
	$Timer.start()

func _on_timer_timeout() -> void:
	var spine = spine_scene.instantiate()
	get_tree().root.add_child(spine)
	spine.start($Marker2D.global_position, -500)
	$Timer.wait_time = 5
	$Timer.start()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("spines") and area.flipped:
		var corpse = pufferfish_corpse_scene.instantiate()
		get_tree().root.add_child(corpse)
		corpse.position = self.global_position
		queue_free()
		area.queue_free()
