extends Area2D

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Neo/Objects/BridgeConfig.gd")
const LIMIT := preload("res://Sprites/Object/BridgeLimit.png")
const SEGMENT := preload("res://Data/Object/Motion/BridgeSegment.tscn")

export (float) var weigth := 1.25
export (int) var segAmt := 8 setget _setAmount

onready var detector := $Detector

var curSeg
var bodies := []
var segments := []

func _setAmount(new := 1):
	if segAmt == new: return
	
	segAmt = new
	_setupBridge()
	
func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	_unused = connect("body_exited", self, "_bodyExit")
	
	_setupBridge()
	
func _setupBridge():
	for seg in segments:
		seg.queue_free()
		
	segments.clear()
	
	for i in range(segAmt):
		var newSeg = SEGMENT.instance()
		
		newSeg.position.x += 16 * i
		add_child(newSeg)
		
		segments.append(newSeg)
	
	detector.shape.length = 16 * segAmt
	
func _physics_process(delta):
	update()
	
	var maxDepression
	
	if bodies:
		curSeg = floor((bodies[0].global_position.x - global_position.x) / 16) + 1
	else:
		curSeg = 0
	
# warning-ignore:integer_division
	if curSeg <= segAmt / 2:
		maxDepression = curSeg * 2
	else:
		maxDepression = ((segAmt - curSeg) + 1) * 2
	
	for i in range(segAmt):
		var diff := abs((i + 1) - curSeg)
		var segDist
		var targetY
		
		if i < curSeg:
			segDist = 1 - (diff / curSeg)
		else:
			segDist = 1 - (diff / ((segAmt - curSeg) + 1))
		
		targetY = floor(maxDepression * sin(deg2rad(90 * segDist))) * weigth
		segments[i].position.y = lerp(segments[i].position.y, targetY, 16 * delta)
	
func _draw():
	draw_texture(LIMIT, Vector2(-16, -16))
	draw_set_transform(Vector2(16 + 16 * segAmt, -16), 0.0, Vector2(-1, 1))
	draw_texture(LIMIT, Vector2())
	
func _bodyEnter(body):
	if body is Kinematos:
		bodies.append(body)
	
func _bodyExit(body):
	if bodies:
		bodies.erase(body)
