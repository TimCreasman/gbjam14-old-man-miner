extends Node2D

@export var soft_body: SoftBody2D


func _process(_delta):
	position = soft_body.get_bones_center_position()
