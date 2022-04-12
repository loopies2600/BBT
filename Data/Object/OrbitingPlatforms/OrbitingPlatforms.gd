extends Sprite

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Neo/Objects/OrbitingPlatformsConfig.gd")
const PLATFORM := preload("res://Data/Object/OrbitingPlatforms/Platform.tscn")

export (int) var amount = 3
export (float) var distance = 64.0
export (int) var speed = -1
export (float) var delayTime = 0.01

onready var delay := $Delay

var platforms := []

func resetState():
	_spawnPlatforms()
	
	if !Main.editing:
		delay.start(delayTime)
	
func _ready():
	var _unused = delay.connect("timeout", self, "_onDelayEnd")
	
	_spawnPlatforms()
	
func _onDelayEnd():
	for p in platforms:
		p.enabled = true
	
func _spawnPlatforms():
	delay.wait_time = delayTime
	
	for p in platforms:
		p.queue_free()
		
	platforms.clear()
	
	var ang := 0.0
	
	for _i in range(amount):
		var newPlat := PLATFORM.instance()
		newPlat.initialAngle = rad2deg(ang)
		newPlat.distance = distance
		newPlat.speed = speed
		
		add_child(newPlat)
		platforms.append(newPlat)
		
		ang += TAU / amount
