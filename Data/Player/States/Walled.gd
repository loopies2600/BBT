extends State

var _time := 0.0

func enter(_msg := {}):
	_time = 0.0
	
	owner._doDust = false
	owner.anim.play("Walled")
	owner.doGravity = false
	owner.velocity.y = 0.0

func physics_update(delta):
	_time += delta
	
	if _time >= owner.wallTime:
		emit_signal("finished", "air")
	
	owner.velocity.y += 24 * delta
	
	if Input.is_action_just_released("jump"):
		emit_signal("finished", "air", {"jumpHeight" : owner.jumpHeight})
		owner.dir = -owner.dir
		owner.velocity.x = (owner.maxSpd * 2) * owner.dir
	
func exit():
	owner.doGravity = true
