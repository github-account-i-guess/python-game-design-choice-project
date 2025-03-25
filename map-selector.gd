extends OptionButton
class Level:
	var text: String
	var path: String
	func _init (text, path):
		self.text = text
		self.path = path

var levels = [
	Level.new("Random Map", "random"),
	Level.new("Audrey Ville Autoracing Place", "audreyville_auto_racing_place.tscn"),
	Level.new("Goofy Map", "scene.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(levels)):
		add_item(levels[i].text, i) 
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mapbutton_pressed() -> void:
	var level = levels[selected]
	if level.path == "random":
		selected = randi_range(0, len(levels) - 1)
		_on_mapbutton_pressed()
		return
	get_tree().change_scene_to_file(level.path)
	pass # Replace with function body.
