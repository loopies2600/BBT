shader_type canvas_item;

uniform vec4 disabled_color : hint_color = vec4(1.0);
uniform bool reverse = false;
uniform vec4 replaceWith : hint_color = vec4(1.0);

void fragment() {
	vec4 alpha = texture(TEXTURE, UV);
	
	if(reverse)
	{
		if(alpha.rgb != disabled_color.rgb)
		{
			discard;
		}
	}
	else
	{
		if(alpha.rgb == disabled_color.rgb) {
			discard;
		}
	}
	
	COLOR = alpha;
}