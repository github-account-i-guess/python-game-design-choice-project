extends OptionButton
class Level:
	var text: String
	var path: String
	func _init (text, path):
		self.text = text
		self.path = path

var levels = [
	Level.new("Audrey Ville Autoracing Place", "audreyville_auto_racing_place.tscn"),
	Level.new("Random Map", "scene.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
