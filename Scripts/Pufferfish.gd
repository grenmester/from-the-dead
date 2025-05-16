extends CharacterBody2D

@export var flipped = false
var spine_scene = preload("res://Scenes/Spine.tscn")
var pufferfish_corpse_scene = preload("res://Scenes/PufferfishCorpse.tscn")

func _ready() -> void:
	if flipped:
		$AnimatedSprite2D.flip_h = true
	$Timer.wait_time = 1
	$Timer.start()

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play("shoot")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("spines") and (area.flipped or area.parent != self):
		var corpse = pufferfish_corpse_scene.instantiate()
		get_tree().root.add_child(corpse)
		corpse.position = self.global_position
		if flipped:
			corpse.get_node("Sprite2D").flip_h = true
		queue_free()
		area.queue_free()

func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.frame == 2:
		var spine = spine_scene.instantiate()
		get_tree().root.add_child(spine)
		spine.start(self, $Marker2D.global_position, 500 if flipped else -500)
		$Timer.wait_time = 5
		$Timer.start()
