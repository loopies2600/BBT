extends Kinematos
class_name Player

export (float) var accel = 100
export (float, 0, 1) var bounciness = 0.5
export (float) var maxSpd = 116
export (float, 0, 1) var airDamping = 0.98
export (float, 0, 1) var damping = 0.5
export (float) var jumpHeight = 512
export (float) var fallMult = 1.25
export (Vector2) var tossForce = Vector2(825, 368)
export (int) var objDetectionRadius = 32
export (float) var resetDelay = 0.5

onready var anim := $Graphics/Anim
onready var cam := $Camera
onready var gfx := $Graphics
onready var tools := $Tools
onready var objOffset := $Graphics/HeldObjectOffset
onready var collisionBox := $CollisionBox
onready var fsm := $StateMachine

var closeObj
var holding

var god := false

var grounded := false
var canInput := true
var canGetStuff := false
var dir := 1
var weight := 1.0

var levelManager

func _ready():
	collisionBox.set_deferred("disabled", true)
	
	doGravity = false
	canInput = false
	
	global_position.y += jumpHeight / 2
	
func _physics_process(delta):
	if doGravity:
		velocity.y += gravity * -upDirection.y * (fallMult if sign(velocity.y) == 1 else 1)
		
	closeObj = tools.findNearObjects()
	
	velocity.y = move_and_slide(velocity, upDirection, true).y
	
	if is_instance_valid(holding): 
		holding.global_position = lerp(holding.global_position, objOffset.global_position, 16 * delta)
	else:
		holding = null
		weight = 1.0
		
	gfx.scale.x = lerp(gfx.scale.x, dir, 16 * delta)
	
	push()
	
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
	
func kill():
	if god: return
	
	if is_instance_valid(holding):
		throwObject()
		
	emit_signal("died")
	
	doGravity = false
	Global.plop(global_position)
	cam.shake(3, 3)
	visible = false
	collisionBox.set_deferred("disabled", true)
	canInput = false
	
	velocity = Vector2()
	
	yield(get_tree().create_timer(resetDelay / 2), "timeout")
	
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(self, "global_position", global_position, spawnPos, resetDelay / 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	
	levelManager.restart()
	
func push(vel := maxSpd * dir):
	var pushable
	
	for b in get_slide_count():
		var body = get_slide_collision(b).collider
		var normal = get_slide_collision(b).normal
		
		if body:
			if body.is_in_group("Pushable") && normal != upDirection:
				pushable = body
		
	if pushable:
		pushable.velocity.x += vel
	
func _tileAnimEnd():
	doGravity = true
	
	var dist := abs(spawnPos.y - global_position.y)
	var jumpCalc = dist * (gravity / 7)
	
	fsm._change_state("air", {"jumpHeight" : jumpCalc, "antiCancel" : true})
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	canInput = true
	collisionBox.set_deferred("disabled", false)
