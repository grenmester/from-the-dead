extends MarginContainer

var level_instance: Node2D
@onready var level_node = get_parent().get_node("Level")

func _ready():
	for level_box in get_tree().get_nodes_in_group("level_boxes"):
		if !level_box.is_connected("level_clicked", load_level):
			level_box.connect("level_clicked", load_level)


func unload_level():
	if is_instance_valid(level_instance):
		level_instance.queue_free()
	level_instance = null


func load_level(level_num: int):
	unload_level()
	var level_path = "res://Scenes/Levels/Level%s.tscn" % level_num
	var level_resource = load(level_path)
	if level_resource:
		level_instance = level_resource.instantiate()
		level_node.add_child(level_instance)
		level_instance.get_node('Camera2D').make_current()


func _input(event):
	if event.is_action_pressed("ui_home"):
		unload_level()
