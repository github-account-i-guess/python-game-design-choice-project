extends VehicleBody3D
@export var added_engine_force = 3000

@export var angle = 0
const xAxis = Vector3(1, 0, 0)
const yAxis = Vector3(0, 1, 0)
const zAxis = Vector3(0, 0, 1)
var numCheckpoints = 0
var check_point = Vector3.ZERO
var slow = false
var groundBodiesCollided = 0
var jumpSpeed = 11#20
var firstCheckpoint = null;

var boost = 0
var prevSpeed = 0
var frontWheels: Array[VehicleWheel3D]
var wheels: Array[VehicleWheel3D]
var backWheels: Array[VehicleWheel3D]
var fastFall = 0
var slowTime = 0
var airTime = 0
var airDashAvailable = false
var airBoost = 0
var curCheckpoint = -1
var laps = 0
var lapTimes = []
var time = 0
var lapTime = 0
#var target_velocity = Vector3.ZERO
func _ready():
	backWheels = [$BackLeftWheel, $BackRightWheel]
	frontWheels = [$FrontLeftWheel, $FrontRightWheel]
	wheels = backWheels.duplicate()
	wheels.append_array(frontWheels)
	for wheel in wheels:
		wheel.wheel_roll_influence = 0
		wheel.wheel_friction_slip = 8

func _physics_process(delta):
	var velocity = linear_velocity
	velocity.y = 0
	var speed = velocity.length()
	#var direction = Vector3.ZERO
	var steeringCap = PI/3

	var drifting = Input.is_action_pressed("drift")
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	if Input.is_action_pressed("move_forward"):
		engine_force = added_engine_force
	else:
		##brake = 0.2
		engine_force *= 9/10
		#accelTime -= 1
	if right and angle > -steeringCap:
		#direction.x -= 10
		angle -= 0.05
	if left and angle < steeringCap:
		#direction.x += 10	
		angle += 0.05
	if not (left or right):
		angle -= 0.01 * sign(angle) * (1 + speed/30)

	if Input.is_action_pressed("move_back"):
		engine_force = -added_engine_force 
		#linear_velocity *= 0.9999
	#if Input.is_action_just_pressed("drift"):
			#linear_velocity += Vector3(0, 30, 0)
	if drifting and airTime < 60:
		if (left or right) and boost < 60:
			boost += 1

		for wheel in backWheels:
			wheel.wheel_friction_slip = 1
		#for wheel in frontWheels:
			#wheel.wheel_friction_slip = 10
		if right:
			$BackLeftWheel.wheel_roll_influence = 5
		if left:
			$BackRightWheel.wheel_roll_influence = 5
		$BodyMesh.mesh.material.albedo_color = Color(0, 0, 1, 0.5)
	else:
		for wheel in wheels:
			wheel.wheel_friction_slip = 10.5
		$BodyMesh.mesh.material.albedo_color = Color(0, 1, 0, 0.5)
		for wheel in backWheels:
			wheel.wheel_roll_influence = 0
	if Input.is_action_just_released('drift') and not Input.is_action_pressed("move_back") and (groundBodiesCollided > 0 or airDashAvailable):
		var direction = zAxis.rotated(yAxis, steering + global_rotation.y).rotated(xAxis, rotation.x).rotated(zAxis, rotation.z)
		var increasedDirection = direction.normalized() * 10 * (boost/3)
		linear_velocity += increasedDirection
		angular_velocity = angular_velocity.normalized() * min(angular_velocity.length(), 1/2)
		boost = 0
	if Input.is_action_pressed("jump") and groundBodiesCollided > 0:
		#linear_velocity.y = jumpSpeed
		linear_velocity += Vector3(0, jumpSpeed, 0).rotated(xAxis, rotation.x).rotated(zAxis, rotation.z)
	if Input.is_action_just_pressed("reset"):
		die()
	if Input.is_action_just_pressed("full_reset"):
		curCheckpoint = -1
		laps = 0
		lapTimes = []
		time = 0
		lapTime = 0
		boost = 0
		save_check_point(firstCheckpoint)
		die()
	#engine_force = speedMap(accelTime)

	$Camera.setFov(sqrt(speed) + 90)

	steering = angle

	#if linear_velocity.y >= 0:
	if slow and linear_velocity.length() > 75:
		if slowTime > 3:
			linear_velocity -= linear_velocity.normalized() * 34
		slowTime += 1
	else:
		slowTime = 0
	if fastFall > 0:
		print("fastFalling")
		#if linear_velocity.y > 0:
			#fastFall = 0
		gravity_scale = 20
		global_rotation.x = 0
		global_rotation.z = 0
		$BodyMesh.mesh.material.albedo_color = Color(1, 0, 0, 0.5)
		fastFall -= 1
	else:
		gravity_scale = 3
	if groundBodiesCollided == 0:
		if airTime == 0:
			airDashAvailable = true
		airTime += 1
	elif airTime:
		airTime = 0
	lapTime += delta
func die():
	global_position = check_point.global_position
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	global_rotation = check_point.global_rotation
	if curCheckpoint == 0 and laps == 0:
		lapTime = 0
func _on_body_entered(body: Node):
	#print("body: " + str(body))
	if (body.is_in_group("slow")):
		slow = true
	if (body.is_in_group("fast_fall")):
		fastFall = 120
	if (body.is_in_group("ground")):
		groundBodiesCollided += 1
	
func _on_body_exited(body: Node) -> void:
	#print("body: " + str(body))
	if (body.is_in_group("slow")):
		slow = false
	if (body.is_in_group("ground")):
		groundBodiesCollided -= 1
	 # Replace with function body.

func _on_vehicle_area_entered(area: Area3D) -> void:
	#print("area: " + str(area))
	if area.is_in_group("boost"):
		#print("boosted")
		linear_velocity += 200 * zAxis.rotated(xAxis, area.global_rotation.x).rotated(yAxis, area.global_rotation.y)
	if area.is_in_group("checkpoint"):
		var num = area.checkpointNum
		if num == curCheckpoint + 1:
			curCheckpoint = num
			save_check_point(area)
		if curCheckpoint == numCheckpoints - 1 and num == 0:
			curCheckpoint = num
			laps += 1
			time += lapTime
			lapTimes.append(lapTime)
			lapTime = 0
			save_check_point(area)
	if area.is_in_group("deathzone"):
		die()
	# Replace with function body.


func save_check_point(checkpoint):
	check_point = checkpoint
