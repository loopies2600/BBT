extends State

var time := 0.0

func enter(_msg := {}):
	owner.velocity = Vector2.ZERO
	
	owner.anim.play("Slide")
	owner.sounds[2].play()
	
	Main.plop(owner.global_position + (Vector2(0, -8) * owner.upDirection), [-90 * owner.dir, -60 * owner.dir, -30 * owner.dir, -45 * owner.dir])
	
func physics_update(delta):
	var spdCalc : float = 1.0 - (time / owner.slideDuration)
	
	owner.velocity.x = ((owner.slideStrength / owner.slideDuration) * owner.dir) * spdCalc
	
	time += delta
	
	if time >= owner.slideDuration:
		emit_signal("finished", "idle")
		
	if owner.is_on_wall():
		emit_signal("finished", "idle")
		
	if !owner.closeToCeiling():
			if Input.is_action_just_pressed("jump"):
				emit_signal("finished", "air", {"jumpHeight" : owner.jumpHeight})
	
func exit():
	time = 0.0
