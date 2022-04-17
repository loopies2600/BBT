extends Node2D

onready var ci = VisualServer.canvas_item_create()

func _ready():
	set_as_toplevel(true)
	
func _physics_process(_delta):
	VisualServer.canvas_item_clear(ci)
	
	if !get_parent().drawGizmos: return
	if !Main.editing: return
	
	VisualServer.canvas_item_set_parent(ci, get_canvas_item())
	
	var t = get_parent().t
	t.origin -= get_parent().hurtBox.extents
	
	VisualServer.canvas_item_add_rect(ci, Rect2(Vector2(), (get_parent().hurtBox.extents * 2)), Color.tomato)
	VisualServer.canvas_item_set_transform(ci, t)
