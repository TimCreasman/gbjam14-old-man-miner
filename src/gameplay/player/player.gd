class_name OMM_Player
extends CharacterBody2D

const SPEED = 60.0
const JUMP_VELOCITY = -200.0

@export var age_component: OMM_AgeComponent

@export_category("Internal Components")
@export var ray_cast: RayCast2D
@export var old_timer: Timer

func _ready():
	old_timer.timeout.connect(age_component.increment_age)

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
	handle_mine()

func handle_mine():
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_dir.is_zero_approx():
		return

	ray_cast.rotation = move_dir.angle()

	var tile = ray_cast.get_collider()
	if tile is OMM_GroundTile:
		tile.do_break()

func pickup(item: OMM_ItemDefinition.ITEM_TYPES):
	print(item)
