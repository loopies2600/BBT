extends State

var _time := 0.0

func enter(_msg := {}):
	_time = 0.0
	
	p._doDust = false
	p.anim.play("Walled")
	p.doGravity = false
	p.velocity = Vector2.ZERO

func physics_update(delta):
	_time += delta
	
	if _time >= p.wallTime:
		emit_signal("finished", "air")
	
	p.velocity.y -= (24 * p.upDirection.y) * delta
	
	if Input.is_action_just_released("jump"):
		p.setState(3, {"jumpHeight" : p.jumpHeight})
		
		p.dir = -p.dir
		p.velocity.x = (p.maxSpd * 2) * p.dir
		
func exit():
	p.doGravity = true
