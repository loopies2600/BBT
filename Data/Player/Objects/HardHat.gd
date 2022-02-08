extends Sprite

export (float) var gravity = 25.0
export (float) var lifetime = 2.0

var velocity := Vector2()
var upDirection := Vector2.UP

func _ready():
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()
	
func _physics_process(delta):
	velocity.y -= gravity * upDirection.y
	
	position += velocity * delta
