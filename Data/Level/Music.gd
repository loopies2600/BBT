extends AudioStreamPlayer

onready var req = HTTPRequest.new()

func _ready():
	add_child(req)
	var _unused = req.connect("request_completed", self, "_reqEnd")
	
	retrieveSong()
	
func retrieveSong():
	var url : String = "https://www.newgrounds.com/audio/download/%s" % get_parent().audioID
	print("Downloading audio from: %s" % url)
	
	req.download_file = "user://lvlAudio.mp3"
	req.request(url, ["Access-Control-Allow-Origin: *"], false)
	
	get_tree().paused = true
	
func _reqEnd(result, rc, head, body):
	get_tree().paused = false
	
	if result == 0:
		var strm = load(req.download_file)
		
		if OS.get_name() != "HTML5":
			strm = AudioStreamMP3.new()
			
			var file := File.new()
			file.open(req.download_file, File.READ)
			var buffer : PoolByteArray = file.get_buffer(file.get_len())
			strm.data = buffer
			strm.loop = true
			file.close()
		
		stream = strm
