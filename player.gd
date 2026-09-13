extends CharacterBody2D

const SPEED = 60.0
const JUMP_VELOCITY = -200.0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	# TODO fix the mining going off collisions and not direction (ray cast?)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is OMM_GroundTile:
			handle_mine(collision.get_collider(), collision.get_normal())

func handle_mine(tile: OMM_GroundTile, dir: Vector2):
	var move_dir = Input.get_vector("move_right", "move_left", "move_down", "move_up")
	if dir == move_dir:
		tile.do_break()
