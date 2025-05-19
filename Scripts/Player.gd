extends CharacterBody2D

signal slash

var corpse_scene = preload("res://Scenes/Objects/Corpse.tscn")
var spine_scene = preload("res://Scenes/Objects/Spine.tscn")

@export var speed = 120
@export var gravity = 500
@export var jump_force = -275
@export var shell_type = Enums.ShellType.NORMAL

var action_in_progress = false
var direction = 1
var nearby_corpse = null
var spawnpoint: Marker2D


func _ready():
	spawnpoint = get_parent().get_node("Spawnpoint")
	update_corpse_collision(shell_type)


func _physics_process(delta: float):
	velocity.y += gravity * delta
	update_direction()
	handle_x_movement()
	play_animation()
	move_and_slide()


func _input(event):
	if event.is_action_pressed("ui_up") and can_jump():
		velocity.y = jump_force
	if event.is_action_pressed("ui_select"):
		handle_action()
	if Input.is_key_pressed(KEY_U):
		change_shell(Enums.ShellType.NORMAL)
	if Input.is_key_pressed(KEY_I):
		change_shell(Enums.ShellType.NONE)
	if Input.is_key_pressed(KEY_O):
		change_shell(Enums.ShellType.PUFFERFISH)
	if Input.is_key_pressed(KEY_P):
		change_shell(Enums.ShellType.SWORDFISH)


func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "pufferfish_action" and $AnimatedSprite2D.frame == 1:
		var spine = spine_scene.instantiate()
		Consts.root.add_child(spine)
		spine.init(self, position, direction)

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "swordfish_action":
		emit_signal("slash")
	if $AnimatedSprite2D.animation == "pufferfish_action" or $AnimatedSprite2D.animation == "swordfish_action":
		action_in_progress = false
		play_animation()


func _on_area_2d_area_entered(area: Area2D):
	if !area.is_in_group("spines") or is_hiding():
		return

	if shell_type == Enums.ShellType.PUFFERFISH and !area.flipped and area.parent == self:
		return

	die()
	area.queue_free()

func die():
	if shell_type != Enums.ShellType.NONE:
		var corpse = corpse_scene.instantiate()
		corpse.init(shell_type)
		Consts.root.add_child(corpse)
		corpse.position = global_position
		corpse.sprite.flip_h = direction == -1

	respawn()


func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("corpses"):
		nearby_corpse = body


func _on_area_2d_body_exited(_body: Node2D):
	nearby_corpse = null


func update_direction():
	if Input.is_action_pressed("ui_right"):
		direction = 1
		$AnimatedSprite2D.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		direction = -1
		$AnimatedSprite2D.flip_h = true


func handle_x_movement():
	if is_hiding():
		velocity.x = 0
	else:
		var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		velocity.x = horizontal_input * speed


func play_animation():
	var anim_prefix = ""
	match shell_type:
		Enums.ShellType.NONE:
			anim_prefix += "naked_"
		Enums.ShellType.PUFFERFISH:
			anim_prefix += "pufferfish_"
		Enums.ShellType.SWORDFISH:
			anim_prefix += "swordfish_"

	var anim_type = "walk" if abs(velocity.x) > 0.1 else "idle"
	if action_in_progress:
		anim_type = "action"
	$AnimatedSprite2D.play(anim_prefix + anim_type)


func can_jump() -> bool:
	return is_on_floor() and !is_hiding()


func is_hiding() -> bool:
	return shell_type == Enums.ShellType.NORMAL and action_in_progress

func handle_action():
	match shell_type:
		Enums.ShellType.NORMAL:
			action_in_progress = !action_in_progress
		Enums.ShellType.NONE:
			if nearby_corpse:
				nearby_corpse.queue_free()
				change_shell(nearby_corpse.type)
		Enums.ShellType.PUFFERFISH:
			action_in_progress = true
		Enums.ShellType.SWORDFISH:
			action_in_progress = true


func change_shell(_shell_type: Enums.ShellType):
	shell_type = _shell_type
	action_in_progress = false
	update_corpse_collision(shell_type)


func update_corpse_collision(_shell_type: Enums.ShellType):
	# No collisions with corpses for naked crabs
	set_collision_layer_value(1, _shell_type != Enums.ShellType.NONE)
	set_collision_mask_value(1, _shell_type != Enums.ShellType.NONE)


func respawn():
	global_position = spawnpoint.global_position
	change_shell(Enums.ShellType.NONE)


func _on_box_collision_underfoot_body_entered(body: Node2D) -> void:
	if body.is_in_group("crate_platform"):
		body.set_collision_layer_value(2, true)


func _on_box_collision_underfoot_body_exited(body: Node2D) -> void:
	if body.is_in_group("crate_platform"):
		body.set_collision_layer_value(2, false)
