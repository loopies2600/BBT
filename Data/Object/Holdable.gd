extends Kinematos

export (float, 0, 1) var airDamping = 0.98
export (float, 0, 1) var bounciness = 0.48
export (float, 0, 1) var damping = 0.86
export (float) var gravity = 32
export (float) var weight = 1.5

var colliding := false setget _setColliding

func _ready():
	add_to_group("Holdable")
	
func _setColliding(booly: bool):
	if colliding == booly: return
	
	colliding = booly
	
	if colliding:
		if velocity.y > 400.0:
			var normal = move_and_collide(velocity * get_physics_process_delta_time()).normal
			
			if normal.dot(Vector2.UP) > 0.6:
				spawnFeetDust(global_position + Vector2(0, 16))
		
func _physics_process(delta):
	if !get_child(1).disabled:
		velocity.y += gravity * -upDirection.y
	
	var collision := move_and_collide(velocity * delta)
	self.colliding = true if collision else false
	
	velocity.x *= damping if is_on_floor() else airDamping
	
	if collision:
		var normal := collision.normal
		
		velocity = velocity.bounce(normal)
		velocity *= bounciness
		
func switchCollision(booly := !get_child(1).disabled):
	get_child(1).set_deferred("disabled", booly)
	
func spawnFeetDust(pos := global_position + Vector2(0, 16)):
	var dust = load("res://Data/Particles/FeetDust.tscn")
	
	var xVels := [32, 64, 96, -32, -64, -96]
	
	for i in range(xVels.size()):
		var newDust = dust.instance()
		newDust.velocity.x = xVels[i]
		newDust.global_position = pos
		
		get_tree().get_root().add_child(newDust)

