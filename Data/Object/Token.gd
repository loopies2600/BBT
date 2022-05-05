extends Area2D

const TOKANIM := preload("res://Data/Particles/TokenAnim.tscn")

signal taken

onready var spr := $Sprite

var disabled := false

func resetState():
	disabled = false
	
func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _process(_delta):
	visible = !disabled
	
	set_deferred("monitoring", !disabled)
	set_deferred("monitorable", !disabled)
	
	update()
	
func _draw():
	if !Main.level.shadows: return
	
	draw_texture(spr.texture, Vector2(8, 8), Color(0, 0, 0, 0.5))
	
func _bodyEnter(body):
	if body is Player:
		disabled = true
		
		_spawnAnim()
		emit_signal("taken")
	
func _spawnAnim():
	var newAnim = TOKANIM.instance()
	
	newAnim.startPos = get_global_transform_with_canvas().origin
	newAnim.endPos = Main.ot.ti.startPos - Vector2(Main.ot.ti.separation * Main.level.tokensCollected, 0)
	
	Main.ot.add_child(newAnim)
	Main.shine(global_position + Vector2(8, 8), Color.lightskyblue, 8, 196)
