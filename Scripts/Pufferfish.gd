extends CharacterBody2D

@export var flipped = false

var spine_scene = preload("res://Scenes/Objects/Spine.tscn")
var corpse_scene = preload("res://Scenes/Objects/Corpse.tscn")

const initial_shoot_interval = 2
const shoot_interval = 5


func _ready():
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.flip_h = flipped
	$Timer.wait_time = initial_shoot_interval
	$Timer.start()


func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "shoot" and $AnimatedSprite2D.frame == 2:
		var spine = spine_scene.instantiate()
		Consts.root.add_child(spine)
		var direction = 1 if flipped else -1
		var offset = Vector2(16 * direction, 0)
		spine.init(self, position + offset, direction)
		$Timer.wait_time = shoot_interval
		$Timer.start()


func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("idle")


func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("spines") and (area.flipped or area.parent != self):
		die()
		area.queue_free()


func die():
		var corpse = corpse_scene.instantiate()
		corpse.init(Enums.ShellType.PUFFERFISH)
		Consts.root.add_child(corpse)
		corpse.position = self.global_position
		corpse.sprite.flip_h = flipped
		queue_free()


func _on_timer_timeout():
	$AnimatedSprite2D.play("shoot")
