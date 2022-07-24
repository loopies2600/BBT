extends Control

onready var editor : Node2D = get_tree().get_nodes_in_group("Editor")[0]

onready var r := $Panel/Vbc/Hbc/RChannel/R
onready var g := $Panel/Vbc/Hbc/GChannel/G
onready var b := $Panel/Vbc/Hbc/BChannel/B
onready var hex := $Panel/Vbc/HexColor/Hex

var target : Node2D

func _ready():
	r.text = str(target.modulate.r)
	g.text = str(target.modulate.g)
	b.text = str(target.modulate.b)
	hex.text = target.modulate.to_html(false)
	
	var _unused = r.connect("text_entered", self, "_rChange")
	_unused = g.connect("text_entered", self, "_gChange")
	_unused = b.connect("text_entered", self, "_bChange")
	_unused = hex.connect("text_entered", self, "_hexChange")
	
func _rChange(new := ""):
	r.text = new
	target.modulate.r = float(new)
	editor.cursor.modes[0].basePlaceOptions["modulate:r"] = float(new)

func _gChange(new := ""):
	g.text = new
	target.modulate.g = float(new)
	editor.cursor.modes[0].basePlaceOptions["modulate:g"] = float(new)

func _bChange(new := ""):
	b.text = new
	target.modulate.b = float(new)
	editor.cursor.modes[0].basePlaceOptions["modulate:b"] = float(new)

func _hexChange(new := ""):
	hex.text = new
	target.modulate = new
	
	editor.cursor.modes[0].basePlaceOptions["modulate:r"] = target.modulate.r
	editor.cursor.modes[0].basePlaceOptions["modulate:g"] = target.modulate.g
	editor.cursor.modes[0].basePlaceOptions["modulate:b"] = target.modulate.b

func _process(_delta):
	rect_position = target.get_global_transform_with_canvas().origin + (Vector2(16, 16) * target.get_global_transform_with_canvas().get_scale())
