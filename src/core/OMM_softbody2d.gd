@tool
class_name OMM_SoftBody2D
extends SoftBody2D


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if Input.is_action_pressed("left_click"):
		for child in get_rigid_bodies():
			var body := child.rigidbody as RigidBody2D
			body.apply_central_impulse(Vector2(0, -5))
			var to_mouse := get_global_mouse_position() - body.global_position
			body.apply_central_force((to_mouse * 220.0 - body.linear_velocity * 12.0) * body.mass)
	# if Input.is_action_pressed("left_click"):
	# 	var to_mouse := get_global_mouse_position() - global_position
	# 	apply_force((to_mouse * 220.0) * mass)
	# apply_central_force((to_mouse * 220.0 - linear_velocity * 12.0) * mass)

# func handle_move():
# 	var direction = Input.get_axis("move_left", "move_right")
# 	if abs(direction) > 0:
# 		# sprite.flip_h = direction < 0
# 	if direction:
# 		# velocity.x = direction * SPEED
# 		# if dash_component.is_dashing:
# 		# 	velocity.x = velocity.x * 5
# 	else:
# 		# velocity.x = move_toward(velocity.x, 0, SPEED)
#
