extends Node2D

@export var follow_node: Node2D
@export var depth_component: OMM_DepthComponent

@export_category("Internal Components")
@export var move_timer: Timer

func _ready():
	depth_component.increment_depth(follow_node.global_position.y)

	# 1 pixel per tick
	#move_timer.timeout.connect(depth_component.increment_depth)

func _process(_delta):
	depth_component.increment_depth(follow_node.global_position.y)
	
	var go_to = Vector2(follow_node.global_position.x, depth_component.get_depth())
	move_camera_to(go_to)

func move_camera_to(global_pos: Vector2):
	var v := get_viewport()
	v.canvas_transform = Transform2D(0.0, -Vector2i(global_pos) + v.size / 2)
