extends Node2D

export (float) var ___tempRot = 0.0

onready var _editorRotate = $Sprite

var baseTrans : Node2D = self
var drawGizmos := false

var hurtBox := RectangleShape2D.new()
var t : Transform2D
var _sOffset := Vector2(0, 0)

func _ready():
	_editorRotate.rotation = ___tempRot
	
	hurtBox.extents = Vector2(3, 3)
	
func _physics_process(_delta):
	t = baseTrans.get_global_transform()
	t.origin += Vector2(8, 8) + (Vector2(5, 6) * (baseTrans.get_scale() - Vector2.ONE)) + (baseTrans._sOffset.rotated(baseTrans._editorRotate.rotation) * baseTrans.get_scale())
	
	var spaceState := get_world_2d().direct_space_state
	var query := Physics2DShapeQueryParameters.new()
	
	query.set_shape(hurtBox)
	query.transform = t
	
	var collision = spaceState.intersect_shape(query)
	
	for c in collision:
		if c.collider.has_method("kill"):
			c.collider.kill()
	
