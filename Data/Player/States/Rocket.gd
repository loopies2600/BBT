extends State

const EXPLOSION := preload("res://Data/Particles/Explosion/Explosion.tscn")

var rcVel := Vector2()
var rcRot := 0.0
var spd := 0.0

func enter(_msg := {}):
	spd = p.velocity.x
	
	p.anim.play("Rocket")
	p.velocity = Vector2.ZERO
	p.doGravity = false
	
	p._doDust = true
	rcRot = 0.0
	
	spd = p.velocity.x
	spd += p.rocketSpeed
	p.dir = 1
	
func physics_update(delta):
	spd += p.rocketAccel * delta
	
	var dir : int = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
	rcRot += (p.rocketSteering * dir) * delta
	
	p.rotation = lerp_angle(p.rotation, rcRot, 12 * delta)
	
	p.velocity = Vector2(spd, 0).rotated(p.rotation)
	p.dustOffset = Vector2(-24, 12).rotated(p.rotation)
	
	p.camOffset = lerp(p.camOffset, Vector2(112, 0).rotated(p.rotation), 4 * delta)
	
	if p.get_slide_count():
		_fuckingDestroyEverything()
		
		p.rotation = 0.0
		
		var explosion := EXPLOSION.instance()
		explosion.global_position = p.global_position
		Main.level.add_child(explosion)
		
		p.velocity = Vector2()
		p.kill()
	
func _fuckingDestroyEverything():
	var tiles : Array = Main.level.getTilesInRadius((p.global_position / 16).round(), 4, Main.level.INDESTRUCTIBLE)
	
	for t in tiles:
		Main.level.funnyTileAnim(Main.level, t)
		Main.level.set_cellv(t, -1)
		
	Main.level.redrawShadows()
	
func exit():
	p.dustOffset = Vector2()
	p.camOffset = Vector2()
	
	rcVel = Vector2()
	spd = 0.0
	
	p.doGravity = true
	p.rotation = 0.0
	p._doDust = false
