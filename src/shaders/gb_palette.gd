@tool
class_name GBPalette
extends Resource

signal color_changed()

var colors: Array[Color] = [Color(), Color(), Color(), Color()]

@export() var background = Color8(82, 82, 82):
	set(new_value):
		background = new_value
		colors[0] = new_value
		color_changed.emit()

@export() var shadow = Color8(0, 0, 0):
	set(new_value):
		shadow = new_value
		colors[1] = new_value
		color_changed.emit()

@export() var foreground = Color8(165, 165, 165):
	set(new_value):
		foreground = new_value
		colors[2] = new_value
		color_changed.emit()

@export() var highlight = Color8(255, 255, 255):
	set(new_value):
		highlight = new_value
		colors[3] = new_value
		color_changed.emit()

func to_vec4() -> Array:
	var vec4_array = [background, shadow, foreground, highlight].map(func(color: Color):
		return Vector4(color.r, color.g, color.b, color.a)
	)
	return vec4_array

func set_palette(other: GBPalette):
	background = other.background
	shadow = other.shadow
	foreground = other.foreground
	highlight = other.highlight
