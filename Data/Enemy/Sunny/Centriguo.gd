extends Sprite

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Neo/Objects/SunnyConfig.gd")
const SUNNY := preload("res://Data/Enemy/Sunny/Sunny.tscn")

export (int) var amount = 3
export (float) var distance = 64.0
export (int) var speed = -1
export (float) var delayTime = 0.01

onready var delay := $Delay
onready var l := $Light

var drawGizmos := false

var sunnies := []

func resetState():
	_spawnSunnies()
	
	if !Main.editing:
		delay.start(delayTime)
	
func _ready():
	var _unused = delay.connect("timeout", self, "_onDelayEnd")
	
	_spawnSunnies()
	
func _onDelayEnd():
	for s in sunnies:
		s.enabled = true
	
func _process(_delta):
	l.visible = !l.visible
	
func _spawnSunnies():
	delay.wait_time = delayTime
	
	for s in sunnies:
		s.queue_free()
		
	sunnies.clear()
	
	var ang := 0.0
	
	for _i in range(amount):
		var newSunny := SUNNY.instance()
		newSunny.initialAngle = rad2deg(ang)
		newSunny.distance = distance
		newSunny.speed = speed
		
		add_child(newSunny)
		sunnies.append(newSunny)
		
		ang += TAU / amount
