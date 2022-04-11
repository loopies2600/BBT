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
	var _unused = $ExplosionArea.connect("body_entered", self, "_bodyEnter")
	_unused = $ExplosionArea.connect("body_exited", self, "_bodyExit")
	
func _process(_delta):
	if !visible: return
	
	_lookAtPlayer()
	
func _lookAtPlayer():
	var lookAngle := 0.0
	
	lookAngle = (Main.entityLookTowards - global_position).angle()
		
	for p in pupils:
		p.offset = Vector2(3, 0).rotated(lookAngle).round()
		
	for e in eyes:
		e.offset = Vector2(1, 0).rotated(lookAngle).round()

func _bodyEnter(body):
	if exploding: return
	if !visible: return
	
	if body is Kinematos:
		target = body
	else: return
	
	yield(get_tree().create_timer(explosionDelay), "timeout")
	
	anim.play("Explode")
	
func _bodyExit(body):
	if body is Kinematos:
		target = null
	
func explode():
	if !visible: return
	
	exploding = true
	
	get_parent().purgeCircle(area.global_position / 16, ceil(area.shape.radius / 16), -1)
	
	Main.cam.shake(16, 16)
	
	var newExplosion := EXPLOSION.instance()
	
	newExplosion.position = area.global_position
	newExplosion.radius = area.shape.radius
	get_parent().add_child(newExplosion)
	
	visible = false
	col.set_deferred("disabled", true)
	
	if is_instance_valid(target):
		if target is Player:
			var vel := Vector2(512, 0).rotated((global_position - target.global_position).angle())
			vel.y = -256
		
			target.kill({"velocity" : vel, "shakePower" : Vector2(16, 16)})
		elif target is Kinematos:
			target.kill()
	
	yield(get_tree().create_timer(0.25), "timeout")
	_explodeNeighbours()
	
func _explodeNeighbours():
	remove_from_group("Explosives")
	
	var n = Tools.findNearObjects(self, ["Explosives"], area.shape.radius)
	
	if n:
		n.explode()
	
func resetState():
	velocity = Vector2()
	
	add_to_group("Explosives")
	
	target = null
	exploding = false
	
	anim.play("Idle")
	
	visible = true
	col.set_deferred("disabled", false)
