extends Node3D
@export var numCheckpoints = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$vehicle.numCheckpoints = numCheckpoints
	pass # Replace with function body.

var time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	$ui/infoList/speed.text = "Speed: " + str(round($vehicle.linear_velocity.length()))
	$ui/infoList/time.text = "Time: " + str(round(time))
	$ui/infoList/checkpoint.text = "Checkpoint: " + str(round($vehicle.curCheckpoint) + 1)
	var curCheckpoint = $vehicle.curCheckpoint
	for node in get_children():
		if node.is_in_group("checkpoint"):
			node.visible = node.checkpointNum > curCheckpoint
