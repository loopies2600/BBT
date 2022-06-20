shader_type canvas_item;

uniform vec4 exclude_color : hint_color = vec4(1.0);

void fragment() {
	vec4 alpha = texture(TEXTURE, UV);
	
	if(alpha.rgb != exclude_color.rgb) {
		discard;
		}
	
	COLOR = alpha;
}