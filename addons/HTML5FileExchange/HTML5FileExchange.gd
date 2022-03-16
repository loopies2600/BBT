extends Node

signal in_focus

func _ready():
	if OS.get_name() == "HTML5" and OS.has_feature('JavaScript'):
		_define_js()

func _notification(notification:int) -> void:
	if notification == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		emit_signal("in_focus")
		
func _define_js()->void:
	JavaScript.eval("""
	var fileData;
	var fileType;
	var fileName;
	var canceled;
	function upload() {
		canceled = true;
		var input = document.createElement('input'); 
		input.setAttribute("type", "file");
		input.setAttribute("accept", ".tscn");
		input.click();
		input.addEventListener('change', event => {
			if (event.target.files.length > 0){
				canceled = false;}
			var file = event.target.files[0];
			var reader = new FileReader();
			fileType = file.type;
			fileName = file.name;
			reader.readAsArrayBuffer(file);
			reader.onloadend = function (evt) {
				if (evt.target.readyState == FileReader.DONE) {
					fileData = evt.target.result;
				}
			}
		  });
	}
	function download(fileName, byte) {
		var buffer = Uint8Array.from(byte);
		var blob = new Blob([buffer], { type: '.tscn'});
		var link = document.createElement('a');
		link.href = window.URL.createObjectURL(blob);
		link.download = fileName;
		link.click();
	};
	""", true)
	
	
func loadLevel():
	if OS.get_name() != "HTML5" or !OS.has_feature('JavaScript'):
		return
		
	JavaScript.eval("upload();", true)
	
	yield(self, "in_focus")
	
	yield(get_tree().create_timer(0.1), "timeout")
	
	if JavaScript.eval("canceled;", true):
		return
	
	var fileData
	while true:
		fileData = JavaScript.eval("fileData;", true)
		if fileData != null:
			break
			
		yield(get_tree().create_timer(1.0), "timeout")
	
	var fileName = JavaScript.eval("fileName;", true)
	
	var tscn := File.new()
	tscn.open("user://upload.tscn", File.WRITE)
	tscn.store_buffer(fileData)
	
	tscn.close()
	
	Main.reload(ResourceLoader.load("user://upload.tscn"))
	
func downloadLevel(fileName:String = "level.tscn")->void:
	if OS.get_name() != "HTML5" or !OS.has_feature('JavaScript'):
		return
		
	var file := File.new()
	
	var _err = file.open("user://temp.tscn", File.READ)
		
	var levelData = Array(file.get_buffer(file.get_len()))
	file.close()
	
	JavaScript.eval("download('%s', %s);" % [fileName, str(levelData)], true)
