shader_type canvas_item;

uniform sampler2D body_texture : source_color, repeat_enable;
uniform float scroll_speed : hint_range(0.0, 500.0) = 100.0;
uniform vec4 snake_color : source_color = vec4(1.0);

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	uv.x += TIME * scroll_speed * 0.001;
	//COLOR = texture(body_texture, uv);
	COLOR = texture(body_texture, uv) * snake_color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
