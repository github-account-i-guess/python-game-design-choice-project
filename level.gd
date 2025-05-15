extends Node3D
@export var numCheckpoints = 0
var checkpoints = []
var threeLap = -1
var activeGhostData = {}
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
	return (a + b)
func save_bests (data):
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
func doBackgroundGameplay():
	var nextCheckpoint = checkpoints[0 if $vehicle.curCheckpoint == numCheckpoints - 1 else $vehicle.curCheckpoint + 1]
	if Time.get_ticks_msec() % 3 == 0:
		var vPos = $vehicle.global_position
		var cPos = nextCheckpoint.global_position
		$vehicle.global_rotation.y = atan2(vPos.y - cPos.y, vPos.x - cPos.x) - PI/2
	else:
		$vehicle.linear_velocity = (nextCheckpoint.global_position - $vehicle.global_position).normalized() * 1000
func _process(delta: float) -> void:
	var time = $vehicle.lapTime + $vehicle.time
	if time in activeGhostData:
		var data = activeGhostData[time]
		print(data)
		$ghost.global_position = data.pos
		$ghost.global_rotation = data.angle
	
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
			activeGhostData = {}
			get_tree().root.get_child(0).lapCompleted(threeLap, lapTimes)
		else:
			doBackgroundGameplay()
	var threeLapText = ($vehicle.lapTime + $vehicle.time) if threeLap == -1 else threeLap
	$ui/leftAlign/threeLap.text = "3 Lap: " + str(round(threeLapText*100)/100)
	var curCheckpoint = $vehicle.curCheckpoint
	for node in get_children():
		if node.is_in_group("checkpoint"):
			node.visible = node.checkpointNum == (curCheckpoint + 1) % numCheckpoints
