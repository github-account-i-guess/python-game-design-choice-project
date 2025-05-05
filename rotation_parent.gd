extends Node3D
@export var angle = PI/2

func _ready() -> void:
	var parent = self.get_parent()
	var childNodes = get_children()
	for childNode in childNodes:
		for i in range(2*PI/angle - 1):
			var dup = childNode.duplicate()
			add_child(dup)
			if "rotateSelf" in dup:
				dup.rotateSelf(i, angle)
