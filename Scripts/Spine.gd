extends Area2D

var flipped = false
var parent
const speed = 100
var direction


func init(_parent, _position, _direction):
	parent = _parent
	position = _position
	direction = _direction


func _process(delta: float):
	position.x += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body: Node2D):
	if can_reflect(body):
		$Sprite2D.flip_h = true
		flipped = true
		direction *= -1
	elif can_destroy(body):
		queue_free()


func can_reflect(body: Node2D):
	return (body.name == "Player" and body.is_hiding) or (body.is_in_group("corpses") and body.type == "shell")


func can_destroy(body: Node2D):
	return body.is_in_group("doors")
