extends Node2D

@export var follow_node: Node2D
@export var player_coordinate: OMM_Coordinate

@export_category("Internal Components")
@export var move_timer: Timer

func _process(_delta):
	# TODO change this to only allow going down?
	# var go_to = Vector2(follow_node.global_position.x, player_coordinate.coordinate.y)
	move_camera_to(follow_node.global_position)

# func _physics_process(_delta: float) -> void:
# 	depth_component.increment_depth(floor(follow_node.global_position.y))

func move_camera_to(global_pos: Vector2):
	var v := get_viewport()
	v.canvas_transform = Transform2D(0.0, -Vector2i(global_pos) + v.size / 2)
