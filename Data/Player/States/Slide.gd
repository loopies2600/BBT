extends State

var time := 0.0

func enter(_msg := {}):
	p.velocity = Vector2.ZERO
	
	p.anim.play("Slide")
	p.sounds[2].play()
	
	Main.plop(p.global_position + (Vector2(0, -8) * p.upDirection), [-90 * p.dir, -60 * p.dir, -30 * p.dir, -45 * p.dir])
	
func physics_update(delta):
	var spdCalc : float = 1.0 - (time / p.slideDuration)
	
	p.velocity.x = ((p.slideStrength / p.slideDuration) * p.dir) * spdCalc
	
	time += delta
	
	if time >= p.slideDuration:
		p.setState(1)
		
	if p.is_on_wall():
		p.setState(0)
		
	if !p.closeToCeiling():
			if Input.is_action_just_pressed("jump"):
				p.setState(3, {"jumpHeight" : p.jumpHeight})
	
func exit():
	time = 0.0
