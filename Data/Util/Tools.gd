extends Node

var sortWho : Node2D

onready var fileTool := Node.new()

func _ready():
	fileTool.set_script(load("res://addons/HTML5FileExchange/HTML5FileExchange.gd"))
	add_child(fileTool)
	
func getInputDirection(who) -> int:
	if !who.canInput: return 0
	
	return int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
func triggerTimed(variable : String, time := 1.0, endBool := false):
	get_parent().set(variable, !endBool)
	yield(get_tree().create_timer(time), "timeout")
	get_parent().set(variable, endBool)
	
func findNearObjects(who : Node2D, groups := ["Holdable"], radius := 0.0):
	sortWho = who
	
	var closeObjs := []
	
	for g in groups:
		for n in get_tree().get_nodes_in_group(g):
			var distance = n.global_position.distance_to(who.global_position)
			
			if distance < radius:
				closeObjs.append(n)
			
	closeObjs.sort_custom(self, "sortByClosest")
	
	return closeObjs[0] if closeObjs.size() != 0 else null

func sortByClosest(a, b) -> bool:
	if a.global_position.distance_to(sortWho.global_position) < b.global_position.distance_to(sortWho.global_position):
		return true
	else: return false
	
func makeCurve(points := [], offset := Vector2(), dist := 8):
	var c := Curve2D.new()
	
	for p in range(points.size()):
		points[p] += offset
		
	var startDir = points[0].direction_to(points[1])
	c.add_point(points[0], -startDir * dist, startDir * dist)
	
	for i in range(1, points.size() - 1):
		var dir = points[i - 1].direction_to(points[i + 1])
		c.add_point(points[i], -dir * dist, dir * dist)
		
	var endDir = points[-1].direction_to(points[-2])
	c.add_point(points[-1], -endDir * dist, endDir * dist)
	
	return c.get_baked_points()
	
func offscreenCheck(target : Node2D) -> bool:
	var screenPos := target.get_global_transform_with_canvas().origin
		
	if screenPos.x > 418 || screenPos.x < 0:
		return true
	if screenPos.y > 240 || screenPos.y < 0:
		return true
	
	return false

func openFilePicker():
	if OS.get_name() == "HTML5":
		return fileTool.loadLevel()
	elif OS.get_name() == "X11":
		var out := []
		OS.execute("/usr/bin/zenity", ["--file-selection", "--file-filter=Level data (.tscn) | *tscn"], true, out)
		
		if out[0]:
			var path : String = out[0]
			path.erase(out[0].length() - 1, 1)
			
			return ResourceLoader.load(path)
	
