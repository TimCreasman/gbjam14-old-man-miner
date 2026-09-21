extends Node2D

@export var follow_node: Node2D
@export var coordinate_component: OMM_Coordinate

var offset := Vector2(0, 32)

func _ready():
	coordinate_component.coordinate_changed.connect(_on_coordinate_change)

func _process(_delta):
	move_camera_to(follow_node.global_position - offset)

func move_camera_to(global_pos: Vector2):
	var v := get_viewport()
	v.canvas_transform = Transform2D(0.0, -Vector2i(global_pos) + v.size / 2)

func _on_coordinate_change(coordinate: Vector2i):

	if offset == Vector2.ZERO:
		return

	if coordinate.y > 144:
		offset = Vector2.ZERO
