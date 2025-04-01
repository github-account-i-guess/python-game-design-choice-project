extends Node3D
@export var numCheckpoints = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		if node.is_in_group("checkpoint"):
			numCheckpoints += 1
			#node.visible = node.checkpointNum > curCheckpoint
			if node.checkpointNum == 0:
				$vehicle.firstCheckpoint = node
	$vehicle.numCheckpoints = numCheckpoints


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$vehicle.time + 
	$ui/rightAlign/speed.text = "Speed: " + str(round($vehicle.linear_velocity.length()))
	$ui/leftAlign/time.text = "Total Time: " + str(round(($vehicle.lapTime + $vehicle.time)*100)/100)
	$ui/leftAlign/lapTime.text = "Lap Time: " + str(round(($vehicle.lapTime)*100)/100)
	$ui/leftAlign/checkpoint.text = "Checkpoint: " + str(round($vehicle.curCheckpoint) + 1)
	$ui/leftAlign/lap.text = "Lap: " + str(round($vehicle.laps) + 1)
	var lapTimes = $vehicle.lapTimes
	if len(lapTimes) > 0:
		$ui/leftAlign/avgLap.text = "Average Lap: " + str(round($vehicle.time/len(lapTimes)) + 1)
		if len(lapTimes) > 3:
			$ui/leftAlign/threeLap.text = "Lap: " + str(round(lapTimes.reduce(func(a,b,i): return a + b if i < 3 else 0, 0)/lapTimes) + 1)
	var curCheckpoint = $vehicle.curCheckpoint
	for node in get_children():
		if node.is_in_group("checkpoint"):
			#node.visible = node.checkpointNum > curCheckpoint
			node.visible = node.checkpointNum == (curCheckpoint + 1) % numCheckpoints
