extends Area2D

enum ShellType {
	NORMAL,
	NONE,
	PUFFERFISH,
	SWORDFISH,
}

const speed = 100
var flipped = false
var parent
var direction


func _process(delta: float):
	position.x += direction * speed * delta


func _on_body_entered(body: Node2D):
	if can_reflect(body):
		$Sprite2D.flip_h = !$Sprite2D.flip_h
		flipped = true
		direction *= -1
	elif can_destroy(body):
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func init(_parent, _position, _direction):
	parent = _parent
	position = _position
	direction = _direction
	$Sprite2D.flip_h = direction == 1


func can_reflect(body: Node2D):
	var is_player_in_shell = body.name == "Player" and body.shell_type == ShellType.NORMAL and body.action_in_progress
	var is_empty_shell = body.is_in_group("corpses") and body.type == ShellType.NORMAL
	return is_player_in_shell or is_empty_shell


func can_destroy(body: Node2D):
	# TODO: add collision for terrain
	return body.is_in_group("doors")
