extends Node2D

@export var soft_body: SoftBody2D


func _physics_process(delta):
	handle_move()
	handle_jump()


func handle_move():
	var direction = Input.get_axis("move_left", "move_right")

	for body in soft_body.get_rigid_bodies():
		pass

	if direction:
		soft_body.apply_impulse(Vector2(direction, 0))

	# player_coordinate.coordinate = global_position


func handle_jump():
	if Input.is_action_pressed("jump"):
		soft_body.apply_impulse(Vector2(0, 10))
	if Input.is_action_just_released("jump"):
		soft_body.apply_impulse(Vector2(0, -30))
