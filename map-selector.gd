extends VBoxContainer
func save_bests(data):
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
class Level:	
	var name: String
	var path: String
	var best: int
	var bestFloat: float

	func _init (name, path, bests):
		self.name = name
		self.path = path
		if not name in bests:
			bests[name] = -1
		self.best = bests[name]		
		self.bestFloat = bests[name]
	func getText():
		print(best)
		var formattedTime = " - PB: %s:%s%s.%s" % [floor(self.best/60), "0" if self.best % 60 < 10 else "", self.best % 60, round((self.bestFloat-self.best)*1000)] 
		return self.name + (formattedTime if self.best > -1 else " - Not Beaten")
func newLevel(name, path):
	return Level.new(name, path, bests)
var levels = [
	newLevel("Random Map", "random"),
	newLevel("Audrey Ville Autoracing Place", "audreyville_auto_racing_place.tscn"),
	newLevel("Square Map", "square.tscn"),
	newLevel("Craig Cyclinder", "craig_mall_but_not_a_mall.tscn"),
	newLevel("Auto-Map", "auto-map.tscn")
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(levels)):
		var button = Button.new()
		button.text = levels[i].getText()
		button.pressed.connect(_on_mapbutton_pressed(i))
		$maps.add_child(button)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func innerLambda(id: int): 
	var level = levels[id]
	if level.path == "random":
		innerLambda(randi_range(0, len(levels) - 2))
		return
	var node = load(level.path).instantiate()
	node.name = level.name
	var root = get_tree().root
	root.remove_child(root.get_child(0))
	root.add_child(node)#.change_scene_to_file(level.path)
func _on_mapbutton_pressed(id: int):
	return func(): innerLambda(id)
