extends Node

signal file_opened

var godot_web_files_obj
var open_file_callback

func _ready():
	if OS.has_feature("HTML5"):
		godot_web_files_obj = JavaScript.get_interface("GodotWebFiles")
		open_file_callback = JavaScript.create_callback(self, "_on_file_opened")
		godot_web_files_obj.open_file_callback = open_file_callback
	
func open_file(accept = "", text = false, multiple = false):
	if godot_web_files_obj != null:
		godot_web_files_obj.open_file(accept, text, multiple)

func save_file(file, content, mime = "application/octet-stream"):
	if content is String:
		content = content.to_utf8()
	if not content is PoolByteArray:
		assert(false)
	JavaScript.download_buffer(content, file, mime)

func _on_file_opened(data):
	var file = data[0]
	var text = data[1]
	var content = data[2]
	if !text:
		content = _convert_obj_to_byte_array(content)
	emit_signal("file_opened", file, content)

func _convert_obj_to_byte_array(obj):
	var bytes = PoolByteArray()
	bytes.resize(obj.length)
	for i in obj.length:
		bytes[i] = obj[i]
	return bytes
