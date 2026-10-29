extends CanvasGroup


func _ready():
	if material is ShaderMaterial:
		var bounding_box = get_canvas_group_rect().size
		var texture_pixel_size = Vector2(1.0 / bounding_box.x, 1.0 / bounding_box.y)
		print(texture_pixel_size)
		material.set_shader_parameter("texture_pixel_size", texture_pixel_size)


## Calculates the bounding Rect2 enclosing all visible child nodes
func get_canvas_group_rect() -> Rect2:
	var total_rect = Rect2()
	var first = true

	for child in get_children():
		if "texture" in child:
			var child_rect: Rect2 = Rect2(Vector2.ZERO, child.texture.get_size())

			var child_transform: Transform2D = child.transform

			var c1 = child_transform * child_rect.position
			var c2 = child_transform * Vector2(child_rect.end.x, child_rect.position.y)
			var c3 = child_transform * Vector2(child_rect.position.x, child_rect.end.y)
			var c4 = child_transform * child_rect.end

			if first:
				total_rect = Rect2(c1, Vector2.ZERO)
				first = false

			total_rect = total_rect.expand(c1)
			total_rect = total_rect.expand(c2)
			total_rect = total_rect.expand(c3)
			total_rect = total_rect.expand(c4)

	if not first:
		total_rect = total_rect.grow(fit_margin)

	return total_rect
