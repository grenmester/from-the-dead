extends CharacterBody2D

enum ShellType {
	NORMAL,
	NONE,
	PUFFERFISH,
	SWORDFISH,
}

var corpse_scene = preload("res://Scenes/Objects/Corpse.tscn")
var spine_scene = preload("res://Scenes/Objects/Spine.tscn")

@export var speed = 150
@export var gravity = 150
@export var jump_force = -150

var shell_type = ShellType.NORMAL
var action_in_progress = false
var direction = 1
var nearby_corpse = null
var spawnpoint: Marker2D


func _ready():
	spawnpoint = get_parent().get_node("Spawnpoint")


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
		change_shell(ShellType.NORMAL)
	if Input.is_key_pressed(KEY_I):
		change_shell(ShellType.NONE)
	if Input.is_key_pressed(KEY_O):
		change_shell(ShellType.PUFFERFISH)
	if Input.is_key_pressed(KEY_P):
		change_shell(ShellType.SWORDFISH)


func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "pufferfish_action" and $AnimatedSprite2D.frame == 2:
		var spine = spine_scene.instantiate()
		get_tree().root.add_child(spine)
		spine.init(self, position, direction)
	# TODO: handle swordfish action consequence


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "pufferfish_action" or $AnimatedSprite2D.animation == "swordfish_action":
		action_in_progress = false
		play_animation()


func _on_area_2d_area_entered(area: Area2D):
	if !area.is_in_group("spines") or is_hiding():
		return

	if shell_type == ShellType.PUFFERFISH and !area.flipped and area.parent == self:
		return

	if shell_type != ShellType.NONE:
		var corpse = corpse_scene.instantiate()
		corpse.init(shell_type)
		get_tree().root.add_child(corpse)
		corpse.position = global_position
		corpse.sprite.flip_h = direction == -1

	area.queue_free()
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
		ShellType.NONE:
			anim_prefix += "naked_"
		ShellType.PUFFERFISH:
			anim_prefix += "pufferfish_"
		ShellType.SWORDFISH:
			anim_prefix += "swordfish_"

	var anim_type = "walk" if abs(velocity.x) > 0.1 else "idle"
	if action_in_progress:
		anim_type = "action"
	$AnimatedSprite2D.play(anim_prefix + anim_type)


func can_jump() -> bool:
	return is_on_floor() and !is_hiding()


func is_hiding() -> bool:
	return shell_type == ShellType.NORMAL and action_in_progress

func handle_action():
	match shell_type:
		ShellType.NORMAL:
			action_in_progress = !action_in_progress
		ShellType.NONE:
			if nearby_corpse:
				change_shell(nearby_corpse.type)
				nearby_corpse.queue_free()
		ShellType.PUFFERFISH:
			if !action_in_progress:
				action_in_progress = true
		ShellType.SWORDFISH:
			if !action_in_progress:
				action_in_progress = true


func change_shell(_shell_type: ShellType):
	shell_type = _shell_type
	action_in_progress = false
	update_corpse_collision(shell_type)


func update_corpse_collision(_shell_type: ShellType):
	# No collisions with corpses for naked crabs
	set_collision_layer_value(1, _shell_type != ShellType.NONE)
	set_collision_mask_value(1, _shell_type != ShellType.NONE)


func respawn():
	global_position = spawnpoint.global_position
	change_shell(ShellType.NONE)
