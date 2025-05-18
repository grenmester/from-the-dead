extends MarginContainer

var level_num: int
var level_instance: Node2D
@onready var level_node = get_parent().get_node("Level")

func _ready():
	for level_box in get_tree().get_nodes_in_group("level_boxes"):
		if !level_box.is_connected("level_clicked", load_level):
			level_box.connect("level_clicked", load_level)


func unload_level():
	if is_instance_valid(level_instance):
		level_instance.free()
	level_instance = null


func load_level(num: int):
	level_num = num
	var level_path = "res://Scenes/Levels/Level%s.tscn" % num
	var level_resource = load(level_path)
	if level_resource:
		level_instance = level_resource.instantiate()
		level_node.add_child(level_instance)
		Consts.root = level_instance
		level_instance.get_node('Camera2D').make_current()
		level_instance.get_node('Finish').connect("win", unload_level)


func reload_level():
	unload_level()
	load_level(level_num)
