extends Node2D

const WIDGET := preload("res://Data/Object/Decoration/PureColor/ModulateWidget.tscn")

onready var editor : Node2D = get_tree().get_nodes_in_group("Editor")[0]

var clrWidget

func resetState():
	_widgetCheck()
	
func _ready():
	add_to_group("PureColors")
	
	update()
	
	var _unused = editor.cursor.connect("object_placed", self, "_widgetCheck")
	
func _draw():
	draw_rect(Rect2(0, 0, 16, 16), Color.white)

func clickEvent():
	_widgetCheck()
	
	clrWidget = WIDGET.instance()
	
	clrWidget.rect_position = get_global_transform_with_canvas().origin + Vector2(16, 16)
	clrWidget.target = self
	
	editor.guiLayer.add_child(clrWidget)
	
func _exit_tree():
	_widgetCheck()
	
func _widgetCheck(_pos := Vector2()):
	for n in get_tree().get_nodes_in_group("PureColors"):
		if n.clrWidget:
			n.clrWidget.queue_free()
			n.clrWidget = null
