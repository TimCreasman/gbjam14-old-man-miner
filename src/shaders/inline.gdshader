shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec4 fog_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float tile_size : hint_range(-10, 10) = 8.0;

uniform float line_thickness : hint_range(0, 10) = 1.0;
uniform vec4 line_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

const vec2 OFFSETS[8] = {
    vec2(-1, 0), vec2(0, -1), vec2(0, 1), vec2(1, 0),
    vec2(-1, -1), vec2(1, 1), vec2(1, -1), vec2(-1, 1)
};

float calculate_obscurity(vec2 screen_uv, vec2 size) {
    float obscurity = 0.0;
    for(int i = 0; i < OFFSETS.length(); i++) {
        obscurity += texture(screen_texture, screen_uv + size * OFFSETS[i]).a;
    }
    return obscurity;
}

vec4 fog_of_war(vec2 screen_pixel_size, vec2 screen_uv) {
    vec4 color = textureLod(screen_texture, screen_uv, 0.0);

    // All neighbors are obscured
    float obscurity = calculate_obscurity(screen_uv, screen_pixel_size * tile_size);
    if (obscurity == 8.0) {
        return mix(color, fog_color, color.a);
    } else {
        return color;
    }
}

vec4 outline(vec2 screen_pixel_size, vec2 screen_uv) {
    float obscurity = calculate_obscurity(screen_uv, screen_pixel_size * line_thickness);
    float outline = min(obscurity, 1.0);

    vec4 color = textureLod(screen_texture, screen_uv, 0.0);

    return mix(color, line_color, outline - color.a);
}

void fragment() {
    vec4 fog = fog_of_war(SCREEN_PIXEL_SIZE, SCREEN_UV);
    vec4 outline = outline(SCREEN_PIXEL_SIZE, SCREEN_UV);
    if (fog.a == 1.0) {
        COLOR = fog;
    } else {
        COLOR = outline;
    }
}
