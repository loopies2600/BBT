extends Sprite

onready var anim := $Animator

var targetPos := Vector2.ZERO
var snap := true

var velocity := Vector2()
var _time := 0.0

var shape := RectangleShape2D.new()
var colLayer : int

func _ready():
	shape.extents = Vector2(8, 8)
	
func resetState():
	queue_free()
	
func _physics_process(delta):
	if snap: 
		global_position = lerp(global_position, targetPos, 16 * delta)
		return
		
	anim.play("Attack")
	
	_time += delta
	
	if _time > 4.0:
		queue_free()
		
	position += velocity * delta
	
	var spaceState := get_world_2d().direct_space_state
	var query := Physics2DShapeQueryParameters.new()
	
	query.set_shape(shape)
	query.collision_layer = colLayer
	query.transform = Transform2D(Vector2(1, 0), Vector2(0, 1), self.global_position + Vector2(8, 8))
	
	var result := spaceState.intersect_shape(query)
	
	if result:
		for r in result:
			var col = r.collider
			
			if col is Player:
				col.kill()
				
				queue_free()
