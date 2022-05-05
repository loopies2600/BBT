extends "res://Data/Editor/AntiCursor.gd"

onready var accBt := $Accept
onready var cancelBt := $Cancel
onready var csX := $ColorRect/TabContainer/General/SC/Vbc/CS/Vbc/CSX
onready var csY := $ColorRect/TabContainer/General/SC/Vbc/CS/Vbc2/CSY
onready var dm := $ColorRect/TabContainer/General/SC/Vbc/DM
onready var bmpC := $ColorRect/TabContainer/General/SC/Vbc/BMPC
onready var ds := $ColorRect/TabContainer/General/SC/Vbc/DS

func _ready():
	var _unused = cancelBt.connect("pressed", self, "exit")
	_unused = accBt.connect("pressed", self, "_saveAndExit")
	
	csX.text = str(Main.level.cell_size.x)
	csY.text = str(Main.level.cell_size.y)
	dm.pressed = Main.level.darkMode
	bmpC.pressed = Main.level.invertBitmap
	ds.pressed = Main.level.shadows
	
func _saveAndExit():
	var newCellSize : Vector2 = Vector2(float(csX.text), float(csY.text))
	
	for map in [Main.level, Main.level.tmBg, Main.level.tmFg]:
		map.cell_size = newCellSize
	
	Main.level.darkMode = dm.pressed
	Main.olr.visible = dm.pressed
	
	Main.level.invertBitmap = bmpC.pressed
	Main.level.shadows = ds.pressed
	
	Main.level.redrawShadows()
	
	exit()
	
func exit():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
	queue_free()
