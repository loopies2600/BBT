extends AnimatedSprite

const GLITTER := preload("res://Data/Particles/Explosion/ExplosionGlitter.tscn")

export (float, 0, 1) var damping = 0.98
export (float) var lifetime := 0.1

var velocity := Vector2(512, 0)

func _ready():
	play()
	
	velocity = velocity.rotated(rotation)
	
	rotation = 0
	
	var _unused = get_tree().create_timer(lifetime).connect("timeout", self, "queue_free")
	
	_glitterLoop()
	
func _glitterLoop():
	yield(get_tree().create_timer(0.05), "timeout")
	
	var newGlitter := GLITTER.instance()
	
	get_parent().add_child(newGlitter)
	
	_glitterLoop()
	
func _physics_process(delta):
	position += velocity * delta
	
	velocity.x *= damping
	
