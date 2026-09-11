@tool
extends CanvasItem

@export var input_palette: GBPalette 
@export var output_palette: GBPalette 

func _ready():
	input_palette.color_changed.connect(_on_input_palette_changed)
	output_palette.color_changed.connect(_on_output_palette_changed)

	material.set_shader_parameter("input_palette", input_palette.to_vec4())
	material.set_shader_parameter("output_palette", output_palette.to_vec4())

func _on_input_palette_changed():
	material.set_shader_parameter("input_palette", input_palette.to_vec4())

func _on_output_palette_changed():
	material.set_shader_parameter("output_palette", output_palette.to_vec4())

