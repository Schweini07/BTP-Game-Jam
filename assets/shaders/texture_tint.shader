shader_type canvas_item;

uniform vec4 tint_color : hint_color = vec4(1.0);
uniform float mix_weight : hint_range(0, 1) = 0.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, tint_color.rgb, mix_weight);
	COLOR = color;
}