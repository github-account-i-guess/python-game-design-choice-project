extends CharecterBody3D
@export var speed = 100
@export var fallAcceleration = 75
var zeroVector = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 
	
func _physics_process(delta: float) -> void:
	var velocityVector = Vector3.ZERO
	velocityVector.x = 1
	velocity = velocityVector
	move_and_slide()
