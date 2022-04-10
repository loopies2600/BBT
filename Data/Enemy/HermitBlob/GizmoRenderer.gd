extends Node2D

func _ready():
	set_as_toplevel(true)
	
func _process(_delta):
	update()
	
func _draw():
	if !Main.editing: return
	if !get_parent().drawGizmos: return
	
	var rot : float = get_parent()._editorRotate.rotation
	var sPos : Vector2 = get_parent()._editorRotate.global_position
	
	draw_line(sPos + Vector2(0, -8).rotated(rot), sPos + Vector2(0, -get_parent().jumpHeight).rotated(rot), Color.red, 2)
	draw_line(sPos + Vector2(0, -8).rotated(rot), sPos + Vector2(0, -get_parent().ray.shape.length).rotated(rot), Color.green, 2)
