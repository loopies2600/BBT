extends Area2D

const TOKANIM := preload("res://Data/Particles/TokenAnim.tscn")

signal taken

onready var anim := $AnimatedSprite

var disabled := false

func resetState():
	disabled = false
	
	anim.frame = 0
	anim.play()
	
func _ready():
	anim.frame = 0
	anim.play()
	
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _process(_delta):
	visible = !disabled
	
	set_deferred("monitoring", !disabled)
	set_deferred("monitorable", !disabled)
	
func _bodyEnter(body):
	if body is Player:
		disabled = true
		
		_spawnAnim()
		emit_signal("taken")
	
func _spawnAnim():
	var newAnim = TOKANIM.instance()
	
	newAnim.frame = anim.frame
	newAnim.startPos = get_global_transform_with_canvas().origin
	newAnim.endPos = Main.ot.ti.startPos - Vector2(Main.ot.ti.separation * Main.level.tokensCollected, 0)
	
	Main.ot.add_child(newAnim)
	Main.shine(global_position + Vector2(8, 8), Color.lightskyblue, 8, 196)
	
	newAnim.playing = true
