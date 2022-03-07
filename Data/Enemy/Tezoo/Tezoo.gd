extends Area2D

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Tezoo/TezooConfig.tscn")
const SPIKE := preload("res://Data/Object/SpikyBall.tscn")

export (float) var fireTime = 0.1
export (int) var spikesPerShot = 1

onready var anim := $BodyAnim
onready var timer := $FireTimer

func _ready():
	timer.wait_time = fireTime
	
	var _unused = timer.connect("timeout", self, "_onTimeout")
	
func resetState():
	timer.stop()
	anim.play("Idle")
	
	if !Main.editing:
		timer.start()
	
func _onTimeout():
	anim.stop()
	anim.play("Fire")
	
func fire():
	$Fire.play()
	$Fire.pitch_scale = rand_range(0.75, 0.8)
	
	for _i in range(spikesPerShot):
		var newSpike = SPIKE.instance()
		newSpike.global_position = global_position + Vector2(0, -8).rotated(rotation)
		newSpike.doGravity = true
		
		newSpike.velocity.x = rand_range(-128, 128)
		newSpike.velocity.y = rand_range(-420, -512)
		
		newSpike.velocity = newSpike.velocity.rotated(rotation)
		
		get_parent().add_child(newSpike)
		
		newSpike.anim.play("Idle")
