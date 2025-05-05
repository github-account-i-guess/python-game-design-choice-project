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
		print(best)
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
	print("nL Bests: " + str(bests))
	return Level.new(name, path, bests)
var levels = [
	newLevel("Random Map", "random"),
	newLevel("Audrey Ville Autoracing Place", "audreyville_auto_racing_place.tscn"),
	newLevel("Square Map", "square.tscn"),
	newLevel("Craig Cyclinder", "craig_mall_but_not_a_mall.tscn"),
	newLevel("Auto-Map", "auto-map.tscn")
]
func _ready() -> void:
	mainMenu()
func populateButtons(levels) -> void:
	print("pB Bests: " + str(bests))
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
	remove_child(get_child(0))
	add_child(node)#.change_scene_to_file(level.path)
func _on_mapbutton_pressed(id: int):
	return func(): innerLambda(id)
func clear():
	for i in range(len(get_children())):
		remove_child(get_child(i))
func lapCompleted(threeLap, lapTimes):
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
		levels.filter(func(el): return el.name == curLevel)[0].setBest(threeLap)
		save_bests(bests)
	
	curLevel = ""
func mainMenu():
	var node = load("main_menu.tscn").instantiate()
	clear()
	add_child(node)
	populateButtons(levels)
