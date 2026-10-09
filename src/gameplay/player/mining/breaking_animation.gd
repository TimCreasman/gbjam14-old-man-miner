class_name OMM_BreakingAnimation
extends AnimatedSprite2D


func start_breaking(pos: Vector2, dir: Vector2):
	rotation = dir.angle()
	global_position = pos
	show()
	play("breaking")


func stop_breaking():
	hide()
	stop()
