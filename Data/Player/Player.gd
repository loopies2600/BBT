extends Kinematos
class_name Player

export (float) var accel = 96
export (float, 0, 1) var bounciness = 0.5
export (float) var gravity = 25
export (float) var maxSpd = 116
export (float, 0, 1) var airDamping = 0.98
export (float, 0, 1) var damping = 0.86
export (float) var jumpHeight = 512
export (float) var fallMult = 1.25
export (Vector2) var tossForce = Vector2(825, 368)
export (int) var objDetectionRadius = 32
export (float) var resetDelay = 1.0

onready var anim := $Graphics/Anim
onready var cam := $Camera
onready var gfx := $Graphics
onready var tools := $Tools
onready var objOffset := $Graphics/HeldObjectOffset
onready var collisionBox := $CollisionBox

var closeObj
var holding

var grounded := false
var canInput := true
var canGetStuff := false
var dir := 1
var weight := 1.0

func _physics_process(delta):
	if doGravity:
		velocity.y += gravity * -upDirection.y * (fallMult if sign(velocity.y) == 1 else 1)
		
	closeObj = tools.findNearObjects()
	
	velocity = move_and_slide(velocity, upDirection)
	
	if is_instance_valid(holding): 
		holding.global_position = lerp(holding.global_position, objOffset.global_position, 16 * delta)
	else:
		holding = null
		weight = 1.0
		
	gfx.scale.x = lerp(gfx.scale.x, dir, 16 * delta)
	
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
	if is_instance_valid(holding):
		throwObject()
		
	emit_signal("died")
	
	plop()
	cam.shake(3, 3)
	visible = false
	collisionBox.set_deferred("disabled", true)
	canInput = false
	
	velocity = Vector2()
	
	yield(get_tree().create_timer(resetDelay), "timeout")
	
	get_tree().reload_current_scene()
