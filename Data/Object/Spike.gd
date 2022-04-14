extends Node2D

export (float) var ___tempRot = 0.0

onready var _editorRotate = $Sprite

export (bool) var attached = false

var hurtBox := RectangleShape2D.new()
var t : Transform2D

func _ready():
	_editorRotate.rotation = ___tempRot
	
	if attached: _editorRotate = get_parent()
	
	hurtBox.extents = Vector2(8, 8)
	
func _physics_process(_delta):
	var pos : Vector2 = get_parent().global_position if attached else global_position
	var offs : Vector2 = Vector2(-4, -4) if attached else Vector2(4, 8 * cos(_editorRotate.rotation / 2))
	
	t = Transform2D(Vector2(1, 0), Vector2(0, 1), pos + offs)
	
	var spaceState := get_world_2d().direct_space_state
	var query := Physics2DShapeQueryParameters.new()
	
	query.set_shape(hurtBox)
	query.transform = t
	
	var collision = spaceState.intersect_shape(query)
	
	for c in collision:
		if c.collider.has_method("kill"):
			c.collider.kill()
	
