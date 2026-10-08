class_name OMM_Player
extends CharacterBody2D

const SPEED = 60.0
const JUMP_VELOCITY = -200.0

@export var item_container: Node2D
@export var death_container: Node2D
@export var spawn_point: Node2D

@export_group("Internal Components")
@export var sprite: Sprite2D
@export var mining_component: OMM_MiningComponent
@export var midas_component: OMM_MidasComponent
@export var dash_component: OMM_DashComponent
@export var death_component: OMM_DeathComponent
# TODO Add this as a component
@export var player_coordinate: OMM_Coordinate

var bomb_scene: PackedScene = preload("res://src/gameplay/interactables/bomb_dropped.tscn")
var none_item: OMM_ItemDefinition = preload("res://src/resources/item_resources/item_definitions/none_definition.tres")
var inf_bomb_item: OMM_ItemDefinition = preload("res://src/resources/item_resources/item_definitions/inf_bomb_definition.tres")

@export var current_item : OMM_CurrentItemResource

func _ready():
	SignalBus.restarted.connect(_on_restarted)
	
	death_component.aged.connect(on_aged)
	death_component.died.connect(_on_player_died)

	if death_container:
		death_component.set_death_container(death_container)

func _on_restarted():
	death_component.reset_age()
	position = spawn_point.position

func _on_player_died(death_reason: OMM_DeathComponent.DEATH_REASON):
	SignalBus.player_died.emit(OMM_DeathComponent.get_death_message(death_reason))

func _physics_process(delta):
	if not is_on_floor() and !dash_component.is_dashing:
		velocity += get_gravity() * delta

	if !death_component.is_dead():
		handle_jump()
		handle_move()
		mining_component.handle_mine()
		handle_use_item()
	else:
		velocity.x = 0

	move_and_slide()

func handle_move():
		var direction = Input.get_axis("move_left", "move_right")
		if abs(direction) > 0:
			sprite.flip_h = direction < 0
		if direction:
			velocity.x = direction * SPEED
			if dash_component.is_dashing:
				velocity.x = velocity.x*5
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		player_coordinate.coordinate = global_position

func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func on_aged(age: OMM_DeathComponent.AGES):
	if age > sprite.hframes:
		return
	sprite.frame = age

func pickup(item_definition: OMM_ItemDefinition):
	current_item.definition = item_definition

func handle_use_item():
	if Input.is_action_just_pressed("use_item"):
		match current_item.definition.type:
			OMM_ItemDefinition.ITEM_TYPES.BOMB:
				var bomb = bomb_scene.instantiate()
				bomb.position = position
				bomb.apply_force(velocity*200)
				if item_container:
					item_container.add_child(bomb)
			OMM_ItemDefinition.ITEM_TYPES.DASH:
				dash_component.start_dash()
			OMM_ItemDefinition.ITEM_TYPES.MIDAS:
				midas_component.start_midas()
				
		if inf_bomb_item.is_unlocked:
			current_item.definition = inf_bomb_item 
		else:
			current_item.definition = none_item

func make_young():
	death_component.reset_age()

func do_kill(death_reason: OMM_DeathComponent.DEATH_REASON):
	death_component.do_die(death_reason)
