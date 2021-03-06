extends Control

const VARBOX := preload("res://Data/Editor/Item/Object/Neo/VariableBox.tscn")
const TAB := preload("res://Data/Editor/Item/Object/Neo/Tab.tscn")
const SWITCH := preload("res://Data/Editor/Item/Object/Neo/Switch.tscn")

onready var cont := $Panel/Container
onready var targetTile := (target.global_position / Main.cellSize).floor()

var target : Node2D
var tabs := []
var rows := []

func _ready():
	if target.get("drawGizmos") != null:
		target.drawGizmos = true
	
	_tabSetup()
	_modulateTabSetup()
	
func _tabSetup():
	_addTab("Main")
	
	_addRow("Position")
	_addVariableBox(0, "global_position:x", "X", "none", 16)
	_addVariableBox(0, "global_position:y", "Y", "none", 16)
	_addVariableBox(0, "z_index", "Depth")
	
	_addRow("Affine")
	_addVariableBox(1, "scale:x", "X")
	_addVariableBox(1, "scale:y", "Y")
	_addVariableBox(1, "rotation_degrees", "Angle", "_editorRotate")
	
func _modulateTabSetup():
	_addTab("Modulate")
	_addRow("")
	
	_addVariableBox(1, "modulate:r", "Red")
	_addVariableBox(1, "modulate:g", "Green")
	_addVariableBox(1, "modulate:b", "Blue")
	
	_addRow("")
	_addVariableBox(2, "modulate", "Hex              ")
	
func _addTab(tName := "Tab"):
	var newTab = TAB.instance()
	
	newTab.name = tName
	
	cont.add_child(newTab)
	tabs.append(newTab.get_node("VBox"))
	
func _addRow(rName := "Row"):
	if rName:
		var newLabel := Label.new()
		newLabel.add_stylebox_override("normal", StyleBoxEmpty.new())
	
		newLabel.text = rName
		tabs[tabs.size() - 1].add_child(newLabel)
	
	var newRow := HBoxContainer.new()
	
	tabs[tabs.size() - 1].add_child(newRow)
	rows.append(newRow)
	
func _addVariableBox(type : int, tgVar : String, varName : String, altTarget := "none", mult := 1):
	var newVarBox = VARBOX.instance()
	var tg = target
	
	newVarBox.type = type
	newVarBox.mult = mult
	
	if target.get(altTarget) && altTarget != "none":
		tg = target.get(altTarget)
	
	newVarBox.target = tg
	newVarBox.tgVar = tgVar
	
	rows[rows.size() - 1].add_child(newVarBox)
	
	newVarBox.varName.text = varName
	
	newVarBox.owner = self
	
func _addSwitch(tgVar : String, varName : String, on := true):
	var newSwitch = SWITCH.instance()
	
	newSwitch.target = target
	newSwitch.tgVar = tgVar
	newSwitch.pressed = on
	
	rows[rows.size() - 1].add_child(newSwitch)
	
	newSwitch.text = varName
	
	newSwitch.owner = self
	
func updateConfigurator():
	targetTile = (target.global_position / Main.cellSize).floor()
	
	if target.get("spawnPos"):
		target.set("spawnPos", target.global_position)
		
	if target.get("_editorRotate"):
		target.set("___tempRot", target._editorRotate.rotation)
		
	for l in get_tree().get_nodes_in_group("LabelRefresh"):
		l.refresh()
	
func close():
	get_parent().get_parent().cursor.configurator = null
	get_parent().get_parent().cursor.canPlace = true
	
	if target.get("drawGizmos") != null:
		target.drawGizmos = false
		
	queue_free()
