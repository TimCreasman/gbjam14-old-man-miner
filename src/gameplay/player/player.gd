class_name OMM_Player
extends CharacterBody2D

const SPEED = 60.0
const JUMP_VELOCITY = -200.0

@export var age_component: OMM_AgeComponent
@export var item_container: Node2D

@export_category("Internal Components")
@export var sprite: Sprite2D
@export var ray_cast: RayCast2D
@export var old_timer: Timer
@export var dash_timer: Timer
@export var dash_area: Area2D
@export var dig_timer: Timer
var dashing = false
var dig_speed: float = 1.0
var bomb_scene: PackedScene = preload("res://src/gameplay/interactables/bomb_dropped.tscn")

@export var current_item : OMM_CurrentItemResource

func _ready():
	current_item.type = OMM_ItemDefinition.ITEM_TYPES.BOMB

	age_component.aged.connect(on_aged)
	age_component.died.connect(on_died)
	old_timer.timeout.connect(age_component.increment_age)
	dash_timer.timeout.connect(stop_dashing)

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if !age_component.is_dead:
		handle_jump()
		handle_move()
		handle_mine()
		handle_use_item()
	else:
		velocity.x = 0
	if dashing:
		for tile in dash_area.get_overlapping_bodies():
			if tile is OMM_GroundTile:
				tile.on_destroy()
	move_and_slide()

func handle_move():
	var direction = Input.get_axis("move_left", "move_right")
	if abs(direction) > 0:
		sprite.flip_h = direction < 0
	if direction:
		velocity.x = direction * SPEED
		if dashing:
			velocity.x = velocity.x*3
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_mine():
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_dir.is_zero_approx():
		return

	ray_cast.rotation = move_dir.angle()

	var tile = ray_cast.get_collider()
	if tile is OMM_GroundTile:
		tile.do_break(dig_speed)

func on_aged(age: OMM_AgeComponent.AGES):
	sprite.frame = age
func on_died():
	z_index = 100

func pickup(item_type: OMM_ItemDefinition.ITEM_TYPES):
	current_item.type = item_type

func dash():
	dashing = true
	dash_timer.start()

func stop_dashing():
	dashing = false

func handle_use_item():
	if Input.is_action_just_pressed("use_item"):
		match current_item.type:
			OMM_ItemDefinition.ITEM_TYPES.BOMB:
				var bomb = bomb_scene.instantiate()
				bomb.position = position
				bomb.apply_force(velocity*200)
				item_container.add_child(bomb)
			OMM_ItemDefinition.ITEM_TYPES.DASH:
				dash()
				
		#item_picked_up = OMM_ItemDefinition.ITEM_TYPES.NONE
