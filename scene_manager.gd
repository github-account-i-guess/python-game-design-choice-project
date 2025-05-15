extends Node3D

func save_bests (data):
	var file = FileAccess.open("user://bests.save", FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
func load_bests():
	if not FileAccess.file_exists("user://bests.save"):
		return {}
	var file = FileAccess.open("user://bests.save", FileAccess.READ)
	var json = JSON.new()
	if json.parse(file.get_line()) == OK:
		return json.data
	else:
		return {}
var bests = load_bests()
var ghostData = {}
var curLevel = ""

func formatTime(time: float):
	var timeInt: int = time
	var out = []
	out.append(floor(timeInt/60))
	out.append("0" if timeInt % 60 < 10 else "")
	out.append(timeInt % 60)
	out.append(str(time-timeInt).split(".")[1])
	return out
class Level:	
	func formatTime(time: float):
		var timeInt: int = time
		var out = []
		out.append(floor(timeInt/60))
		out.append("0" if timeInt % 60 < 10 else "")
		out.append(timeInt % 60)
		out.append(str(time-timeInt).split(".")[1])
		return out
	
	var name: String
	var path: String
	var best: int
	var bestFloat: float

	func _init (name, path, bests):
		self.name = name
		self.path = path
		if not name in bests:
			bests[name] = -1
		self.setBest(bests[name])
	func getText():
		if self.name == "Random Map":
				return self.name
		elif self.best > -1:
			var formattedTime = " - PB: %s:%s%s.%s" % formatTime(self.bestFloat)
			return self.name + formattedTime
		return self.name + " - Not Beaten"
	func setBest(best):
		self.best = best
		self.bestFloat = best
func newLevel(name, path):
	return Level.new(name, path, bests)
var levels = [
	newLevel("Random Map", "random"),
	newLevel("Ramps", "ramps.tscn"),
	newLevel("Square", "square.tscn"),
	newLevel("Circles", "circles.tscn"),
	newLevel("Auto-Map", "auto-map.tscn")
]
func _ready() -> void:
	mainMenu()
func _process(delta: float) -> void:
	if curLevel != "" and Input.is_action_just_pressed("pause"):
		pauseMenu()
func populateButtons(levels) -> void:
	for i in range(len(levels)):
		var button = Button.new()
		button.text = levels[i].getText()
		button.pressed.connect(_on_mapbutton_pressed(i))
		$MainMenu/container/maps.add_child(button)
func innerLambda(id: int): 
	var level = levels[id]
	if level.path == "random":
		innerLambda(randi_range(0, len(levels) - 2))
		return
	var node = load(level.path).instantiate()
	curLevel = level.name
	print(ghostData)
	if curLevel in ghostData:
		print("ghost exists")
		node.activeGhostData = ghostData[curLevel]
		var ghostCar = load("res://ghost.tscn").instantiate()
		node.add_child(ghostCar)
	remove_child(get_child(0))
	add_child(node)#.change_scene_to_file(level.path)
func _on_mapbutton_pressed(id: int):
	return func(): innerLambda(id)
func clear():
	#for i in range(len(get_children())):
		#remove_child(get_child(0))
	for child in get_children():
		remove_child(child)
func lapCompleted(threeLap, lapTimes):
	ghostData[curLevel] = 	get_child(0).get_node("vehicle").ghostData
	clear()
	add_child(preload("res://lap_completed.tscn").instantiate())
	var timesContainer = $LapCompleted/container/timesContainer
	for i in range(len(lapTimes)):
		var t = lapTimes[i]
		var time = Label.new()
		time.text = "Lap %s: %s" % [i + 1, "%s:%s%s.%s" % formatTime(t)]
		timesContainer.add_child(time)
	var totalTimeNode = Label.new()
	totalTimeNode.text = "Total: %s:%s%s.%s" % formatTime(threeLap)
	timesContainer.add_child(totalTimeNode)
	#var bests = load_bests()

	if bests[curLevel] > threeLap:
		bests[curLevel] = threeLap

		save_bests(bests)
	
	curLevel = ""
func mainMenu():
	var node = load("main_menu.tscn").instantiate()
	clear()
	add_child(node)
	populateButtons(levels)
	curLevel = ""
func pauseMenu():
	for node in get_children():
		if node.name == "pause_menu":
			return
	var node = load("pause_menu.tscn").instantiate()
	#clear()
	add_child(node)
	#populateButtons(levels)
func resume():
	remove_child($pause_menu)
