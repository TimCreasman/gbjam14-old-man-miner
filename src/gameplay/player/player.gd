class_name OMM_Player
extends CharacterBody2D

const SPEED = 60.0
const JUMP_VELOCITY = -200.0

@export var age_component: OMM_AgeResource
@export var item_container: Node2D
@export var death_container: Node2D
@export var world_generator: OMM_WorldGenerator
@export var spawn_point: Node2D

@export_category("Internal Components")
@export var sprite: Sprite2D
@export var old_timer: Timer
@export var dash_timer: Timer
@export var dash_area: Area2D
@export var midas_area: Area2D
@export var midas_timer: Timer

@export var mining_component: OMM_MiningComponent
@export var death_component: OMM_DeathComponent

# TODO Add this as a component
@export var player_coordinate: OMM_Coordinate

var dashing = false
var has_midas = false
var bomb_scene: PackedScene = preload("res://src/gameplay/interactables/bomb_dropped.tscn")
var none_item: OMM_ItemDefinition = preload("res://src/resources/item_definitions/none_definition.tres")

@export var current_item : OMM_CurrentItemResource

func _ready():
	SignalBus.restarted.connect(_on_restarted)

	midas_area.body_entered.connect(on_body_entered)
	StateManager.state_changed.connect(_on_state_changed)

	age_component.aged.connect(on_aged)
	age_component.died.connect(on_died)
	old_timer.timeout.connect(age_component.increment_age)
	dash_timer.timeout.connect(stop_dashing)
	midas_timer.timeout.connect(stop_midas_touch)

	death_component.set_up(death_container, age_component)

func _on_restarted():
	position = spawn_point.position

func on_body_entered(body: Node2D) -> void:
	if body is OMM_GroundTile:
		if has_midas:
			body.turn_to_gold()

func _physics_process(delta):
	if not is_on_floor() and !dashing:
		velocity += get_gravity() * delta

	if !age_component.is_dead:
		handle_jump()
		handle_move()
		mining_component.handle_mine()
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
				velocity.x = velocity.x*10
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		player_coordinate.coordinate = global_position

func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func on_aged(age: OMM_AgeResource.AGES):
	if age > sprite.hframes:
		return
	sprite.frame = age

func on_died():
	old_timer.stop()

func pickup(item_definition: OMM_ItemDefinition):
	current_item.definition = item_definition

func dash():
	
	dashing = true
	dash_timer.start()

func stop_dashing():
	dashing = false

func midas_touch() -> void:
	has_midas = true
	midas_area.monitoring = true
	midas_timer.start()

func stop_midas_touch() -> void:
	midas_area.monitoring = false
	has_midas = false

func handle_use_item():
	if Input.is_action_just_pressed("use_item"):
		match current_item.definition.type:
			OMM_ItemDefinition.ITEM_TYPES.BOMB:
				var bomb = bomb_scene.instantiate()
				bomb.position = position
				bomb.apply_force(velocity*200)
				item_container.add_child(bomb)
			OMM_ItemDefinition.ITEM_TYPES.DASH:
				dash()
			OMM_ItemDefinition.ITEM_TYPES.MIDAS:
				midas_touch()
				
		current_item.definition = none_item 

func _on_state_changed(new_state, old_state) -> void:
	if old_state != StateManager.STATE.MINE and new_state == StateManager.STATE.MINE:
		old_timer.start()

func make_young():
	age_component.make_young()

func do_kill(death_reason: OMM_AgeResource.DEATH_REASON):
	age_component.do_die(death_reason)
