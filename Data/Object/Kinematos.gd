extends KinematicBody2D
class_name Kinematos

signal died

export (float) var maxSpd = 116.0
export (float) var dustSpawnRate = 0.025
export (float) var dustMinVel = 500.0

export (float) var jumpHeight = 64.0
export (float) var jumpDuration = 0.25
export (float) var fallDuration = 0.22550
export (float) var weight = 1.5

export (Vector2) var spawnPos

var dir := 1

var doGravity := true
var slideDownSlopes := false

var velocity := Vector2()
var upDirection := Vector2.UP

var camOffset := Vector2()
var _doDust := false
var dustOffset := Vector2()

onready var jumpVel : float = (2.0 * jumpHeight / jumpDuration)
onready var jumpGravity : float = (2.0 * jumpHeight / (jumpDuration * jumpDuration))
onready var fallGravity : float = (2.0 * jumpHeight / (fallDuration * fallDuration))

func resetState():
	upDirection = Vector2.UP
	global_position = spawnPos
	doGravity = !Main.editing
	_doDust = false
	
	velocity = Vector2.ZERO
	visible = true
	set_physics_process(true)
	set_process(true)
	
func _ready():
	spawnPos = global_position
	
	_dustLoop()
	
func recalcJumpValues(h := jumpHeight):
	jumpVel = (2.0 * h / jumpDuration)
	jumpGravity = (2.0 * h / (jumpDuration * jumpDuration))
	fallGravity = (2.0 * h / (fallDuration * fallDuration))
	
func _physics_process(delta):
	if Main.editing: return
	
	scale.y = abs(scale.y) * -upDirection.y
	
	velocity = move_and_slide(velocity, upDirection, !slideDownSlopes)
	
	_applyGravity(delta)
	_dustTrigger()
	_applyVelBoost()
	
func _applyVelBoost():
	if Main.editing: return
	
	var velBoost := Vector2()
	
	for s in get_slide_count():
		var collision = get_slide_collision(s)
		
		if collision.normal != upDirection: continue
		
		if collision.collider.get("velBoost"):
			velBoost = collision.collider.velBoost
		
	velocity += velBoost
	
func _applyGravity(delta : float):
	if doGravity:
		velocity += Vector2((jumpGravity if velocity.y < 0.0 else fallGravity) * delta, 0).rotated(-upDirection.angle())
	
func _dustTrigger():
	if velocity.length() > dustMinVel:
		_doDust = true
	else:
		_doDust = false
	
func _dustLoop():
	if !visible: return
	
	if _doDust:
		var dust = load("res://Data/Particles/FastDust.tscn").instance()
	
		Main.add_child(dust)
		
		dust.global_position = global_position + dustOffset
	
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
		pushable.velocity.x += vel / pushable.weight
	
func kill():
	emit_signal("died")
	
	Main.plop(global_position)
	
	visible = false
	set_physics_process(false)
	set_process(false)
	
