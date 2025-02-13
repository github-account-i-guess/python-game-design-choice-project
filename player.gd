#extends CharacterBody3D
#@export var speed = 100
#@export var fallAcceleration = 150
#var zeroVector = Vector3.ZERO
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#print("ready")
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass 
	#
#func _physics_process(delta: float) -> void:
	#var velocityVector = Vector3.ZERO
	#velocityVector.z = 1 * speed
	#velocity = velocityVector
	#move_and_slide()
extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 140
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

@export var angle = 0

@export var normalAxis = Vector3(0, 1, 0)

var target_velocity = Vector3.ZERO


func _physics_process(delta):
	var direction = Vector3.ZERO
#	
	if Input.is_action_pressed("move_right"):
		#direction.x -= 10
		angle -= 0.1
	if Input.is_action_pressed("move_left"):
		#direction.x += 10
		angle += 0.1
	if Input.is_action_pressed("move_back"):
		direction.z -= 10
	if Input.is_action_pressed("move_forward"):
		direction.z += 10
#
	#if direction != Vector3.ZERO:
		direction = direction.rotated(normalAxis, angle)
		#direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	#target_velocity.x = direction.x * speed
	#target_velocity.z = direction.z * speed
	# Vertical Velocity
	#if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		#target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
