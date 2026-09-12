shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec4 fog_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float tile_size : hint_range(-10, 10) = 8.0;

const vec2 OFFSETS[8] = {
    vec2(-1, 0), vec2(0, -1), vec2(0, 1), vec2(1, 0),
    vec2(-1, -1), vec2(1, 1), vec2(1, -1), vec2(-1, 1)
};

void fragment() {
    vec2 size = SCREEN_PIXEL_SIZE * tile_size;
    float neighbor_obscurity_level = 0.0;

    for(int i = 0; i < OFFSETS.length(); i++) {
        // TODO We need to figure out how to consider the neighbor obscured
        // If outside the shader - maybe a cascading affect on neighboring 0 hardness blocks?
        neighbor_obscurity_level += texture(screen_texture, SCREEN_UV + size * OFFSETS[i]).a;
    }

    vec4 color = textureLod(screen_texture, SCREEN_UV, 0.0);

    // All neighbors are obscured
    if (neighbor_obscurity_level == 8.0) {
        COLOR = mix(color, fog_color, color.a);
    } else {
        COLOR = color;
    }
}
