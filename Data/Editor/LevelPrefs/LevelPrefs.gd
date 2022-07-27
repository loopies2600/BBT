extends "res://Data/Editor/AntiCursor.gd"

onready var accBt := $Accept
onready var cancelBt := $Cancel
onready var csX := $ColorRect/TabContainer/General/SC/Vbc/Hbc/Vbc/CS/Vbc/CSX
onready var csY := $ColorRect/TabContainer/General/SC/Vbc/Hbc/Vbc/CS/Vbc2/CSY
onready var dm := $ColorRect/TabContainer/Visuals/SC/Vbc/DM
onready var bmpC := $ColorRect/TabContainer/Visuals/SC/Vbc/BMPC
onready var ds := $ColorRect/TabContainer/Visuals/SC/Vbc/DS
onready var lvlN := $ColorRect/TabContainer/General/SC/Vbc/CS2/Vbc/LvNm
onready var lvlD := $ColorRect/TabContainer/General/SC/Vbc/LvDs
onready var lvlA := $ColorRect/TabContainer/General/SC/Vbc/CS2/Vbc2/LvA
onready var bsX := $ColorRect/TabContainer/General/SC/Vbc/Hbc/Vbc2/BS/Vbc/BSX
onready var bsY := $ColorRect/TabContainer/General/SC/Vbc/Hbc/Vbc2/BS/Vbc2/BSY

func _ready():
	$ColorRect/TabContainer.current_tab = 1
	
	var _unused = cancelBt.connect("pressed", self, "exit")
	_unused = accBt.connect("pressed", self, "_saveAndExit")
	
	csX.text = str(Main.cellSize.x)
	csY.text = str(Main.cellSize.y)
	bsX.text = str(Main.level.boundaries.x)
	bsY.text = str(Main.level.boundaries.y)
	
	dm.pressed = Main.level.darkMode
	bmpC.pressed = Main.level.invertBitmap
	ds.pressed = Main.level.shadows
	
	lvlN.text = Main.level.lName
	lvlD.text = Main.level.lDesc
	lvlA.text = Main.level.lAuthor
	
func _saveAndExit():
	var newCellSize : Vector2 = Vector2(float(csX.text), float(csY.text))
	
	for map in [Main.level, Main.level.tmBg, Main.level.tmFg]:
		Main.cellSize = newCellSize
	
	Main.level.boundaries = Vector2(int(bsX.text), int(bsY.text))
	Main.level.darkMode = dm.pressed
	Main.olr.visible = dm.pressed
	
	Main.level.invertBitmap = bmpC.pressed
	Main.level.shadows = ds.pressed
	
	Main.level.lName = lvlN.text
	Main.level.lDesc = lvlD.text
	Main.level.lAuthor = lvlA.text
	
	Main.level.redrawShadows()
	
	exit()
	
func exit():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
	queue_free()
