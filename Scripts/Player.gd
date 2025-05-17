extends CharacterBody2D

signal hit

@export var speed = 100
@export var gravity = 100
@export var jump_height = -150
var is_hiding = false
var corpse_scene = preload("res://Scenes/Objects/Corpse.tscn")
var spine_scene = preload("res://Scenes/Objects/Spine.tscn")
var nearby_corpse = null
var inhabiting = "shell"
var direction = 1;
var is_shooting = false


func _ready():
	$AnimatedSprite2D.play("shelled")


func _physics_process(delta: float):
	if inhabiting == null or inhabiting == "shell":
		velocity.y += gravity * delta
	if !is_hiding:
		horizontal_movement()
		player_animations()
	if inhabiting == "pufferfish":
		vertical_movement()
	move_and_slide()


func horizontal_movement():
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = horizontal_input * speed


func vertical_movement():
	var vertical_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity.y = vertical_input * speed


func player_animations():
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.flip_h = false


func _input(event):
	if event.is_action_pressed("ui_up") and is_on_floor() and !is_hiding and (inhabiting == null or inhabiting == "shell"):
		velocity.y = jump_height
	if event.is_action_pressed("ui_select"):
		handle_capture()
	if event.is_action_pressed("ui_left"):
		direction = -1
	if event.is_action_pressed("ui_right"):
		direction = 1


func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("spines") and !is_hiding and (inhabiting != "pufferfish" or area.flipped or area.parent != self):
		if inhabiting != null:
			var corpse = corpse_scene.instantiate()
			corpse.init(inhabiting)
			get_tree().root.add_child(corpse)
			corpse.position = self.global_position
			if direction == 1:
				corpse.sprite.flip_h = true
			$AnimatedSprite2D.play("shellless")
			inhabiting = null
			set_collision_layer_value(1, false)
			set_collision_mask_value(1, false)
		hit.emit()
		area.queue_free()


func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("corpses"):
		nearby_corpse = body


func _on_area_2d_body_exited(_body: Node2D):
	nearby_corpse = null


func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "shoot" and $AnimatedSprite2D.frame == 2:
		var spine = spine_scene.instantiate()
		get_tree().root.add_child(spine)
		spine.init(self, position, direction)


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "shoot":
		is_shooting = false
		$AnimatedSprite2D.play("pufferfish")


func handle_capture():
	match inhabiting:
		"shell":
			if is_hiding:
				$AnimatedSprite2D.stop()
			else:
				$AnimatedSprite2D.play("hide")
			is_hiding = !is_hiding
		"pufferfish":
			if !is_shooting:
				is_shooting = true
				$AnimatedSprite2D.play("shoot")
		"swordfish":
			pass
		null:
			if nearby_corpse:
				inhabiting = nearby_corpse.type
				match nearby_corpse.type:
					"shell":
						$AnimatedSprite2D.play("shelled")
					"pufferfish":
						$AnimatedSprite2D.play("pufferfish")
					"swordfish":
						pass

				nearby_corpse.queue_free()
				set_collision_layer_value(1, true)
				set_collision_mask_value(1, true)
