extends Kinematos

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Neo/Objects/FernandezConfig.gd")
const EXPLOSION := preload("res://Data/Particles/Explosion/Explosion.tscn")

export (float) var explosionDelay = 1.0

onready var anim := $Animator
onready var eyes := [$Graphics/LEye, $Graphics/REye]
onready var pupils := [$Graphics/LEye/Pupil, $Graphics/REye/Pupil]
onready var area := $ExplosionArea/Shape
onready var col := $CollisionBox

var target

var drawGizmos := false
var exploding := false

func _ready():
	area.shape = area.shape.duplicate()
	
	var _unused = $ExplosionArea.connect("body_entered", self, "_bodyEnter")
	_unused = $ExplosionArea.connect("body_exited", self, "_bodyExit")
	
	doGravity = false
	
func _process(_delta):
	if !visible: return
	
	_lookAtPlayer()
	
func _physics_process(_delta):
	if Main.editing:
		velocity = Vector2()
		return
	
	if is_on_floor():
		velocity.x *= 0.4
	
func _lookAtPlayer():
	var lookAngle := 0.0
	
	lookAngle = (Main.entityLookTowards - global_position).angle()
		
	for p in pupils:
		p.offset = Vector2(3, 0).rotated(lookAngle).round()
		
	for e in eyes:
		e.offset = Vector2(1, 0).rotated(lookAngle).round()

func _bodyEnter(body):
	if Main.editing: return
	if !visible: return
	
	if body is Player:
		if exploding: return
		
		target = body
		exploding = true
		
		yield(get_tree().create_timer(explosionDelay), "timeout")
		
		anim.play("Explode")
		
func _bodyExit(body):
	if body is Player:
		target = null
	
func explode():
	if !visible: return
	
	get_parent().purgeCircle(area.global_position / 16, ceil(area.shape.radius / 16), -1)
	
	var newExplosion := EXPLOSION.instance()
	
	newExplosion.position = area.global_position
	newExplosion.radius = area.shape.radius
	get_parent().add_child(newExplosion)
	
	visible = false
	col.set_deferred("disabled", true)
	
	_explodeNeighbors()
	
	if target:
		var vel := Vector2(512, 0).rotated((global_position - target.global_position).angle())
		vel.y = -256
		
		target.kill({"velocity" : vel, "shakePower" : Vector2(16, 16)})
	
func _explodeNeighbors():
	var spaceState := get_world_2d().direct_space_state
	var query := Physics2DShapeQueryParameters.new()
	
	query.set_shape(area.shape)
	query.collision_layer = $ExplosionArea.collision_layer
	query.transform = Transform2D(Vector2(1, 0), Vector2(0, 1), self.global_position + Vector2(16, 0))
	
	var result := spaceState.intersect_shape(query)
	
	if result:
		for r in result:
			var tgt = r.collider
			
			if tgt is Kinematos:
				yield(get_tree().create_timer(0.25), "timeout")
				tgt.kill()
				
func kill():
	explode()
	
func resetState():
	doGravity = !Main.editing
	
	velocity = Vector2.ZERO
	global_position = spawnPos
	
	exploding = false
	target = null
	
	anim.play("Idle")
	
	visible = true
	col.set_deferred("disabled", false)
