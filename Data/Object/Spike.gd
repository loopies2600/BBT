extends Node2D

export (float) var ___tempRot = 0.0

onready var _editorRotate = $Sprite

var hurtBox := RectangleShape2D.new()

func _ready():
	_editorRotate.rotation = ___tempRot
	
	hurtBox.extents = Vector2(8, 8)
	
func _physics_process(_delta):
	var spaceState := get_world_2d().direct_space_state
	var query := Physics2DShapeQueryParameters.new()
	
	query.set_shape(hurtBox)
	query.transform = Transform2D(Vector2(1, 0), Vector2(0, 1), self._editorRotate.global_position + Vector2(8, 0))
	
	var collision = spaceState.intersect_shape(query)
	
	if collision && collision[0].collider is Player:
		collision[0].collider.kill()
