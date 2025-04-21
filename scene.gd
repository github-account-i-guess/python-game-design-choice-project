extends Node3D
@export var numCheckpoints = 0
var checkpoints = []
var threeLap = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		if node.is_in_group("checkpoint"):
			numCheckpoints += 1
			checkpoints.append(node)
			#node.visible = node.checkpointNum > curCheckpoint
			if node.checkpointNum == 0:
				$vehicle.firstCheckpoint = node
	checkpoints.sort_custom(func(a, b): return a.checkpointNum < b.checkpointNum)
	$vehicle.numCheckpoints = numCheckpoints

func addLaps(a: float, b: float) -> float: 
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
	if len(lapTimes) > 0:
		if threeLap == -1:
			threeLap = lapTimes.reduce(addLaps, 0)
			
			get_tree().root.get_child(0).add_child(preload("res://lap_completed.tscn").instantiate())
			var timesContainer = $LapCompleted/container/timesContainer
			for i in range(len(lapTimes)):
				var t = lapTimes[i]
				var time = Label.new()
				time.text = "Lap " + str(i + 1) + ": " + str(t)
				timesContainer.add_child(time)
			var totalTimeNode = Label.new()
			totalTimeNode.text = "Total: " + str(threeLap)
			timesContainer.add_child(totalTimeNode)
		else:
			var nextCheckpoint = checkpoints[0 if $vehicle.curCheckpoint == numCheckpoints - 1 else $vehicle.curCheckpoint + 1]
			print(nextCheckpoint)
			print(nextCheckpoint.checkpointNum)
			$vehicle.linear_velocity = (nextCheckpoint.global_position - $vehicle.global_position).normalized() * 1000
			
			$vehicle.basis = $vehicle.basis.looking_at(nextCheckpoint.global_position)
	var threeLapText = ($vehicle.lapTime + $vehicle.time) if threeLap == -1 else threeLap
	$ui/leftAlign/threeLap.text = "3 Lap: " + str(round(threeLapText*100)/100)
	var curCheckpoint = $vehicle.curCheckpoint
	for node in get_children():
		if node.is_in_group("checkpoint"):
			#node.visible = node.checkpointNum > curCheckpoint
			node.visible = node.checkpointNum == (curCheckpoint + 1) % numCheckpoints
