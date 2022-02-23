extends KinematicBody2D
class_name Kinematos

signal died

export (float) var maxSpd = 116
export (float) var dustSpawnRate = 0.025
export (float) var dustMinVel = 500.0

export (float) var jumpHeight = 64
export (float) var jumpDuration = 0.25
export (float) var fallDuration = 0.22550

var dir := 1

var doGravity := true
var slideDownSlopes := false

var velocity := Vector2()
var upDirection := Vector2.UP

var _doDust := false

onready var jumpVel : float = (2.0 * jumpHeight / jumpDuration)
onready var jumpGravity : float = (2.0 * jumpHeight / (jumpDuration * jumpDuration))
onready var fallGravity : float = (2.0 * jumpHeight / (fallDuration * fallDuration))

onready var spawnPos := global_position

func resetState():
	visible = true
	set_physics_process(true)
	set_process(true)
	
func _ready():
	_dustLoop()
	
func recalcJumpValues(h := jumpHeight):
	jumpVel = (2.0 * h / jumpDuration)
	jumpGravity = (2.0 * h / (jumpDuration * jumpDuration))
	fallGravity = (2.0 * h / (fallDuration * fallDuration))

func _process(delta):
	scale.y = -upDirection.y
	
func _physics_process(delta):
	_getVelocityBoost()
	_applyGravity(delta)
	
	velocity.y = move_and_slide(velocity, upDirection, !slideDownSlopes).y
	
	push(maxSpd * dir)
	_dustTrigger()
	
func _applyGravity(delta : float):
	if doGravity:
		velocity += Vector2((jumpGravity if velocity.y < 0.0 else fallGravity) * delta, 0).rotated(-upDirection.angle())
	
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
	
		Main.currentScene.add_child(dust)
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
	
	Main.plop(global_position)
	
	visible = false
	set_physics_process(false)
	set_process(false)
	
