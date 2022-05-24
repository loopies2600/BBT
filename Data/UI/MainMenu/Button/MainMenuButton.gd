extends Node2D

const MESH := preload("res://Data/UI/MainMenu/Button/MainMenuButtonMesh.tscn")

export (String) var labText = "MAIN MENU BUTTON"
export (int) var initialAngle = 0
export (bool) var selected = false
export (Texture) var frontFaceTex

onready var center := global_position
onready var sprite := $MeshRenderer
onready var label := $Label

var distance := 96.0
var orbitDimension := Vector2(1, 0.15)
var angle := 0.0
var tgtAngle := 0.0

var mesh
var vp : Viewport

func _ready():
	angle = deg2rad(initialAngle)
	tgtAngle = deg2rad(initialAngle)
	
	# set up new Viewport by code!!
	vp = Viewport.new()
	vp.size = Vector2(96, 96)
	vp.transparent_bg = true
	vp.render_target_v_flip = true
	vp.own_world = true
	
	mesh = MESH.instance()
	
	vp.add_child(mesh)
	add_child(vp)
	
	mesh.owner = self
	mesh.frontFace.texture = frontFaceTex
	
	label.text = labText
	
func _process(delta):
	sprite.texture = vp.get_texture()
	
# warning-ignore:narrowing_conversion
	z_index = max(0, global_position.y)
	
	global_position = center + (Vector2(1, 0).rotated(angle).normalized() * distance) * orbitDimension
	
	var tgtScale := Vector2.ONE if selected else Vector2(0.65, 0.65)
	var tgtModulate := Color.white if selected else Color(0.5, 0.5, 0.75, 1.0)
	
	angle = lerp(angle, tgtAngle, 2 * delta)
	scale = lerp(scale, tgtScale, 4 * delta)
	modulate = lerp(modulate, tgtModulate, 3 * delta)
