extends Node3D
@export var numCheckpoints = 0
var threeLap = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		if node.is_in_group("checkpoint"):
			numCheckpoints += 1
			#node.visible = node.checkpointNum > curCheckpoint
			if node.checkpointNum == 0:
				$vehicle.firstCheckpoint = node
	$vehicle.numCheckpoints = numCheckpoints

func addLaps(a: int, b: int) -> int: 
	print("A: " + str(a) + ", B: " + str(b))
	return (a + b)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$vehicle.time + 
	$ui/rightAlign/speed.text = "Speed: " + str(round($vehicle.linear_velocity.length()))
	$ui/rightAlign/airTime.text = "Air Time: " + str(round($vehicle.airTime))
	$ui/leftAlign/time.text = "Total Time: " + str(round(($vehicle.lapTime + $vehicle.time)*100)/100)
	$ui/leftAlign/lapTime.text = "Lap Time: " + str(round(($vehicle.lapTime)*100)/100)
	$ui/leftAlign/checkpoint.text = "Checkpoint: " + str(round($vehicle.curCheckpoint) + 1)
	$ui/leftAlign/lap.text = "Laps Completed: " + str(round($vehicle.laps))
	var lapTimes = $vehicle.lapTimes
	if len(lapTimes) > 0:
		$ui/leftAlign/avgLap.text = "Average Lap: " + str(round($vehicle.time/len(lapTimes))+ 1)
	if len(lapTimes) > 2 and threeLap == -1:
		#var addLaps = func(a: int, b: int, i: int) -> int: 
			#print("A: " + str(a) + ", B: " + str(b))
			#return (a + b)
		threeLap = lapTimes.reduce(addLaps, 0)
		get_tree().change_scene_to_file("lap_completed.tscn")
	var threeLapText = ($vehicle.lapTime + $vehicle.time) if threeLap == -1 else threeLap
	$ui/leftAlign/threeLap.text = "3 Lap: " + str(round(threeLapText*100)/100)
	var curCheckpoint = $vehicle.curCheckpoint
	for node in get_children():
		if node.is_in_group("checkpoint"):
			#node.visible = node.checkpointNum > curCheckpoint
			node.visible = node.checkpointNum == (curCheckpoint + 1) % numCheckpoints
