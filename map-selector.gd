extends VBoxContainer
class Level:
	var text: String
	var path: String
	func _init (text, path):
		self.text = text
		self.path = path

var levels = [
	Level.new("Random Map", "random"),
	Level.new("Audrey Ville Autoracing Place", "audreyville_auto_racing_place.tscn"),
	Level.new("Square Map", "square.tscn"),
	Level.new("Craig Cyclinder", "craig_mall_but_not_a_mall.tscn"),
	Level.new("Auto-Map", "auto-map.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(levels)):
		var button = Button.new()
		button.text = levels[i].text
		button.pressed.connect(_on_mapbutton_pressed(i))
		add_child(button)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func innerLambda(id: int): 
	var level = levels[id]
	if level.path == "random":
		innerLambda(randi_range(0, len(levels) - 2))
		return
	get_tree().change_scene_to_file(level.path)
func _on_mapbutton_pressed(id: int):
	return func(): innerLambda(id) 
