extends Kinematos
class_name Player

export (float) var accel = 100
export (float, 0, 1) var bounciness = 0.5
export (float, 0, 1) var airDamping = 0.98
export (float, 0, 1) var damping = 0.5
export (float) var jumpHeight = 512
export (Vector2) var tossForce = Vector2(825, 368)
export (int) var objDetectionRadius = 32
export (float) var resetDelay = 1.5
export (int) var slideStrength = 196
export (float) var slideDuration = 0.35

onready var anim := $Graphics/Anim
onready var cam := $Camera
onready var gfx := $Graphics
onready var tools := $Tools
onready var objOffset := $Graphics/HeldObjectOffset
onready var collisionBox := $CollisionBox
onready var fsm := $StateMachine
onready var light := $Light
onready var ceilDetector := $CeilDetector

onready var slideDust := $Graphics/SlideDust

var closeObj
var holding

var god := false

var grounded := false
var canInput := true
var canGetStuff := false
var weight := 1.0

var levelManager

var bottom := 224

func _ready():
	spawnPos = global_position
	
	letsStart()
	
func letsStart():
	cam.set_as_toplevel(false)
	cam.position = Vector2(0, 0)
	
	global_position.x = spawnPos.x
	
	velocity = Vector2.ZERO
	_doDust = false
	
	collisionBox.set_deferred("disabled", true)
	
	doGravity = false
	canInput = false
	
	yield(get_tree(), "idle_frame")
	
	bottom = cam.limit_bottom + 32
	global_position.y = bottom
	
	visible = true
	
	yield(get_tree().create_timer(resetDelay / 2), "timeout")
	
	_hopIn()
	
func _process(delta):
	_bottomKillCheck()
	_checkNHold(delta)
	
	gfx.scale.x = dir
	
func _bottomKillCheck():
	if global_position.y > bottom && !collisionBox.disabled:
		kill({"noAnim" : true})
	
func _checkNHold(delta : float):
	closeObj = tools.findNearObjects()
	
	if is_instance_valid(holding): 
		holding.global_position = lerp(holding.global_position, objOffset.global_position, 16 * delta)
	else:
		holding = null
		weight = 1.0
	
func takeObject():
	if !closeObj: return
	
	holding = closeObj
	weight = holding.weight
	holding.set_collision_mask_bit(3, false)
	holding.doGravity = false
	
func throwObject(force := Vector2()):
	holding.velocity = force
	
	holding.doGravity = true
	holding = null
	
func _dustTrigger():
	pass
	
func kill(msg := {}):
	if god: return
	
	fsm._change_state("dead", msg)
	
func _hopIn():
	doGravity = true
	
	var dist := abs(spawnPos.y - global_position.y - 48)
	var jumpCalc = dist * (gravity / 7)
	
	fsm._change_state("air", {"jumpHeight" : jumpCalc, "antiCancel" : true})
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	canInput = true
	collisionBox.set_deferred("disabled", false)
