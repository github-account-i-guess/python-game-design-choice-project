extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = self.get_parent()
	for i in range(3):
		var dup = $ramp.duplicate()
		add_child(dup)
		dup.rotateSelf(i)
		#parent.add_child(dup)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
