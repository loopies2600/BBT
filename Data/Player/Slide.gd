extends State

var time := 0.0

func enter(_msg := {}):
	owner.velocity = Vector2.ZERO
	owner.anim.play("Slide")
	
func physics_update(delta):
	var spdCalc : float = 1.0 - (time / owner.slideDuration)
	
	owner.velocity.x = ((owner.slideStrength / owner.slideDuration) * owner.dir) * spdCalc
	
	time += delta
	
	if time >= owner.slideDuration:
		emit_signal("finished", "idle")
		
	if sign(owner.velocity.y) == -sign(owner.upDirection.y):
		emit_signal("finished", "air")
		
	if owner.is_on_wall():
		emit_signal("finished", "idle")
		
func exit():
	time = 0.0
