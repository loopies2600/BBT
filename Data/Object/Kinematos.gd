extends KinematicBody2D
class_name Kinematos

signal died

export (float) var maxSpd = 116
export (float) var dustSpawnRate = 0.025
export (float) var dustMinVel = 500.0
export (float) var gravity = 25.0
export (float) var fallMult = 1.25

var dir := 1

var doGravity := true
var slideDownSlopes := false

var velocity := Vector2()
var upDirection := Vector2.UP
var spawnPos := Vector2()

var _doDust := false

func _ready():
	_dustLoop()
	
func _process(delta):
	scale.y = -upDirection.y
	
func _physics_process(delta):
	_getVelocityBoost()
	_applyGravity()
	
	velocity.y = move_and_slide(velocity, upDirection, !slideDownSlopes).y
	
	push(maxSpd * dir)
	_dustTrigger()
	
func _applyGravity():
	if doGravity:
		velocity += Vector2(gravity * (fallMult if sign(velocity.y) == 1 else 1), 0).rotated(-upDirection.angle())
	
func _getVelocityBoost():
	for c in get_slide_count():
		var collision = get_slide_collision(c)
		
		if collision.collider.get("velBoost"):
			velocity += collision.collider.velBoost
		
func _dustTrigger():
	if velocity.length() > dustMinVel:
		_doDust = true
	else:
		_doDust = false
	
func _dustLoop():
	if !visible: return
	
	if _doDust:
		var dust = load("res://Data/Particles/FastDust.tscn").instance()
	
		get_tree().get_root().add_child(dust)
		dust.global_position = global_position
	
	yield(get_tree().create_timer(dustSpawnRate), "timeout")
	_dustLoop()
	
func push(vel : int):
	var pushable
	
	for b in get_slide_count():
		var body = get_slide_collision(b).collider
		var normal = get_slide_collision(b).normal
		
		if body:
			if body.is_in_group("Pushable") && normal != upDirection:
				pushable = body
		
	if pushable:
		pushable.velocity.x += vel
	
func kill():
	emit_signal("died")
	
	Global.plop(global_position)
	queue_free()
