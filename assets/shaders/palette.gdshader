shader_type canvas_item;

// 0: background, 1: shadow, 2: foreground, 3: highlight
uniform vec4 input_palette[4];
uniform vec4 output_palette[4];

bool color_match(vec4 color1, vec4 color2) {
    return distance(color1.rgb, color2.rgb) < 0.01;
}

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);

    for (int i = 0; i < 4; i++) {
        vec4 input_color = input_palette[i];
        vec4 output_color = output_palette[i];

        if(color_match(current_color, input_color) && current_color.a > 0.001) {
            COLOR = vec4(output_color.x, output_color.y, output_color.z, 1.0);
        }
    }
}

