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
@export var midas_area: Area2D
@export var dig_timer: Timer
@export var midas_timer: Timer
# TODO Add this as a component
@export var player_coordinate: OMM_Coordinate

var dashing = false
var has_midas = false
var dig_speed: float = 1.0
var bomb_scene: PackedScene = preload("res://src/gameplay/interactables/bomb_dropped.tscn")
@export var current_item : OMM_CurrentItemResource

var shopping=false

func _ready():
	midas_area.body_entered.connect(on_body_entered)
	StateManager.state_changed.connect(_on_state_changed)
	current_item.type = OMM_ItemDefinition.ITEM_TYPES.DASH

	age_component.aged.connect(on_aged)
	age_component.died.connect(on_died)
	old_timer.timeout.connect(age_component.increment_age)
	dash_timer.timeout.connect(stop_dashing)
	midas_timer.timeout.connect(stop_midas_touch)

func on_body_entered(body: Node2D) -> void:
	if body is OMM_GroundTile:
		if !body._is_gold and has_midas:
			print("midas")
			body.turn_to_gold()

func _physics_process(delta):
	if not is_on_floor() and !dashing:
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

	if (!shopping):
		move_and_slide()

func handle_move():
		var direction = Input.get_axis("move_left", "move_right")
		if abs(direction) > 0:
			sprite.flip_h = direction < 0
		if direction:
			velocity.x = direction * SPEED
			if dashing:
				velocity.x = velocity.x*10
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		player_coordinate.coordinate = position

func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_mine():
	if (!shopping):
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
	old_timer.stop()
	StateManager.change_state("hub")
	z_index = 100

# func pickup(item_type: OMM_ItemDefinition.ITEM_TYPES):
	# current_item.type = item_type

func dash():
	
	dashing = true
	dash_timer.start()

func stop_dashing():
	dashing = false

func midas_touch() -> void:
	has_midas = true
	midas_timer.start()

func stop_midas_touch() -> void:
	has_midas = false

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
			OMM_ItemDefinition.ITEM_TYPES.MIDAS:
				midas_touch()
				
		# current_item.type = OMM_ItemDefinition.ITEM_TYPES.NONE
func _on_state_changed(new_state, old_state) -> void:
	if old_state != "mine" and new_state == "mine":
		old_timer.start()
