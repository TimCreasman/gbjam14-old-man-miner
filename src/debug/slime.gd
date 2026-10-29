extends Node2D

@export var follow_me: Node2D

@export_group("Internal Components")
@export var soft_body: SoftBody2D
@export var player_coordinate: OMM_Coordinate
@export var mining_component: OMM_MiningComponent


func _physics_process(delta):
	mining_component.handle_mine()
	handle_move()
	handle_jump()
	follow_me.global_position = soft_body.get_bones_center_position()
	player_coordinate.coordinate = soft_body.get_bones_center_position()
	

func handle_move():
	var direction = Input.get_axis("move_left", "move_right")

	if direction:
		soft_body.apply_impulse(Vector2(direction, 0))


func handle_jump():
	if Input.is_action_pressed("jump"):
		soft_body.apply_impulse(Vector2(0, 1))
	if Input.is_action_just_released("jump"):
		soft_body.apply_impulse(Vector2(0, -30))
