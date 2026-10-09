class_name OMM_DeathComponent
extends Node2D

signal aged(current_age: AGES)
signal died(death_reason: DEATH_REASON)

enum AGES {
	BABY,
	YOUNG,
	MIDDLE,
	OLD,
	ANCIENT,
	HISTORY,
}
enum DEATH_REASON {
	OLD_AGE,
	EXPLOSION,
	SELF_EXPLOSION,
}

const DEATH_REASON_READABLE = ["u got old", "u blew up", "u blew urself up"]

@export var death_scream: AudioStreamPlayer2D
@export var aging_timer: Timer
@export var ages: Array[int] = [0, 25, 50, 75, 100, 150]
@export var death_count: OMM_ValueResource

var death_container: Node2D
var sprite_scene = preload("res://src/gameplay/player/player_sprite.tscn")

var _max_age = ages.max()
var _death_reason: DEATH_REASON
var _is_dead = false
var _age := 0


static func get_death_message(death_reason: DEATH_REASON):
	return DEATH_REASON_READABLE[death_reason]


func _ready():
	StateManager.state_changed.connect(_on_state_changed)
	aging_timer.timeout.connect(increment_age)


func set_death_container(_death_container):
	death_container = _death_container


func is_dead():
	if StateManager.is_state(StateManager.STATE.WIN):
		return false

	return _is_dead


func increment_age():
	if _is_dead:
		return
	_age += 1
	aged.emit(int(remap(_age, 0, _max_age, 0, ages.size())) as AGES)
	if _age >= ages[ages.size() - 1]:
		_die()


func reset_age():
	_is_dead = false
	_age = 0


func do_die(death_reason: DEATH_REASON = DEATH_REASON.OLD_AGE):
	_die(death_reason)


func _on_state_changed(new_state, old_state) -> void:
	if old_state != StateManager.STATE.MINE and new_state == StateManager.STATE.MINE:
		aging_timer.start()


func _die(death_reason: DEATH_REASON = DEATH_REASON.OLD_AGE):
	aging_timer.stop()
	death_count.increment()
	_death_reason = death_reason
	_is_dead = true

	_place_body()

	death_scream.play()
	await death_scream.finished

	died.emit(death_reason)


func _place_body():
	var sprite = sprite_scene.instantiate() as Sprite2D
	sprite.frame = 5
	sprite.position = global_position
	death_container.add_child(sprite)
