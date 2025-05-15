extends CharacterBody2D

signal hit

@export var speed = 100
@export var gravity = 100
@export var jump_height = -150
var is_hiding = false
var shell_scene = preload("res://Scenes/Shell.tscn")
var pufferfish_corpse_scene = preload("res://Scenes/PufferfishCorpse.tscn")
var spine_scene = preload("res://Scenes/Spine.tscn")
var nearby_corpse = null
var inhabiting = "Shell"
var direction = 1;

func _physics_process(delta: float) -> void:
	if inhabiting == null or inhabiting == "Shell":
		velocity.y += gravity * delta
	if !is_hiding:
		horizontal_movement()
		player_animations()
	if inhabiting == "Pufferfish":
		vertical_movement()
	move_and_slide()

func horizontal_movement():
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = horizontal_input * speed

func vertical_movement():
	var vertical_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity.y = vertical_input * speed

func player_animations() -> void:
	if inhabiting == "Shell":
		$AnimatedSprite2D.play("shelled")
	elif inhabiting == "Pufferfish":
		$AnimatedSprite2D.play("pufferfish")
	else:
		$AnimatedSprite2D.play("shellless")
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.flip_h = true

func _input(event):
	if event.is_action_pressed("ui_up") and is_on_floor() and !is_hiding and (inhabiting == null or inhabiting == "Shell"):
		velocity.y = jump_height
	if event.is_action_pressed("ui_down"):
		if is_hiding:
			is_hiding = false
			$AnimatedSprite2D.stop()
		elif inhabiting == "Shell":
			is_hiding = true
			$AnimatedSprite2D.play("hide")
	if event.is_action_pressed("ui_select"):
		if inhabiting == null:
			if nearby_corpse != null:
				if nearby_corpse.name == "Shell":
					inhabiting = "Shell"
					$AnimatedSprite2D.play("shelled")
				elif nearby_corpse.name == "PufferfishCorpse":
					inhabiting = "Pufferfish"
					$AnimatedSprite2D.play("pufferfish")
				nearby_corpse.queue_free()
				set_collision_layer_value(1, true)
				set_collision_mask_value(1, true)
		elif inhabiting == "Pufferfish":
			var spine = spine_scene.instantiate()
			get_tree().root.add_child(spine)
			spine.start($Marker2D.global_position, direction * 100)
	if event.is_action_pressed("ui_left"):
		direction = -1
	if event.is_action_pressed("ui_right"):
		direction = 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("spines") and !is_hiding and (inhabiting != "Pufferfish" or area.flipped):
		if inhabiting != null:
			var corpse
			if inhabiting == "Shell":
				corpse = shell_scene.instantiate()
			elif inhabiting == "Pufferfish":
				corpse = pufferfish_corpse_scene.instantiate()
			get_tree().root.add_child(corpse)
			corpse.position = self.global_position
			inhabiting = null
			set_collision_layer_value(1, false)
			set_collision_mask_value(1, false)
		hit.emit()
		area.queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("corpses"):
		nearby_corpse = body

func _on_area_2d_body_exited(_body: Node2D) -> void:
	nearby_corpse = null
