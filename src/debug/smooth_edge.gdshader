shader_type canvas_item;
render_mode unshaded;

uniform float thickness = 1.0;
uniform vec4 clr : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

const vec2[4] DIRECTIONS = {
	vec2(1.0, 0.0),
	vec2(0.0, 1.0),
	vec2(-1.0, 0.0),
	vec2(0.0, -1.0)
};

bool is_outside_uv(vec2 input) { return any(lessThan(input, vec2(0.0))) || any(greaterThan(input, vec2(1.0))); }

float gtz(float input) { return max(0, sign(input)); }
// returns 1 if input > 0, else 0

float check_jaggedness(sampler2D tex, vec2 from, vec2 size) {
	float result = 0.0;
    if(textureLod(tex, from, 0.0).a == 0.0) {
        return 0.0;
    }

    for (int i = 0; i < 4; i++) {
        vec2 point_to_check = from + DIRECTIONS[i] * size;
        if (!is_outside_uv(point_to_check)) {
            // treat any amount of alpha as 1
            result += step(0.0001, textureLod(tex, from + DIRECTIONS[i] * size, 0.0).a) ;
            // result += textureLod(tex, from + DIRECTIONS[i] * size, 0.0).a;
        }
    }

    // Returns 1.0 if x is exactly 0.0 or 1.0, and 0.0 otherwise
	return step(0.0, result) * step(result, 1.0) * step(fract(result), 0.0);
}


float check_outline(sampler2D tex, vec2 from, vec2 size) {
	float result = 0.0;
	for (int i = 0; i < 4; i++) {
        float is_neighbor_jagged = check_jaggedness(tex, from + DIRECTIONS[i] * size, size);
        vec4 neighbor_color = textureLod(tex, from + DIRECTIONS[i] * size * thickness, 0.0);
        result += neighbor_color.a * (1.0 - is_neighbor_jagged); // Omit this value if the neighbor is jagged
	}
	return gtz(result);
}

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);

    bool is_jagged = check_jaggedness(screen_texture, SCREEN_UV, SCREEN_PIXEL_SIZE) == 1.0;

    if(is_jagged) {
        c = clr;
    } else {
	    c = mix(c, clr, check_outline(screen_texture, SCREEN_UV, SCREEN_PIXEL_SIZE) * (1.0 - gtz(c.a)) );
    }

	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}

	COLOR *= c;
}
