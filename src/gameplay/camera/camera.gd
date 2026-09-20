extends Node2D

@export var follow_node: Node2D

func _process(_delta):
	move_camera_to(follow_node.global_position)

func move_camera_to(global_pos: Vector2):
	var v := get_viewport()
	v.canvas_transform = Transform2D(0.0, -Vector2i(global_pos) + v.size / 2)
