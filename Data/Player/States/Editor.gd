extends State

func enter(_msg := {}):
	Main.ot.dmr.marks.clear()
	
	randomize()
	
	p.collisionBox.set_deferred("disabled", true)
	
	Main.cam.target = null
	
	p.velocity = Vector2.ZERO
	p.doGravity = false
	p.global_position = p.spawnPos
	
	# random dance
	var danceChance := 10
	
	if randi() % danceChance == 0:
		p.anim.play("Dance")
	else:
		p.anim.play("Wait")
	
func physics_update(_delta):
	p.velocity *= p.damping
	
	p.dir = 1
	
	if !Main.editing:
		p.setState(0)
	
func exit():
	p.collisionBox.set_deferred("disabled", false)
	
	p.doGravity = true
	p.spawnPos = p.global_position
