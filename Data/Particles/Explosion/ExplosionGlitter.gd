extends AnimatedSprite

export (float) var lifetime := 0.075

var velocity := Vector2(768, 0)

func _ready():
	velocity.x = rand_range(512, 768)
	
	velocity = velocity.rotated(rand_range(0, TAU))
	
	var _unused = get_tree().create_timer(lifetime).connect("timeout", self, "queue_free")
	
func _physics_process(delta):
	position += velocity * delta
	
	velocity *= 0.89
