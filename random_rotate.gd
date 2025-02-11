class_name RandomRotator
extends Node3D

var rotate_axis := Vector3.FORWARD
const MAIN_RATE = TAU*0.8
const DRIFT_RATE = TAU

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func randDir() -> Vector3:
	var dir := Vector3.ONE
	while dir.length_squared() > 1:
		dir = Vector3(randf(), randf(), randf())*2-Vector3.ONE
	return dir.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(rotate_axis, delta*MAIN_RATE)
	#quaternion = Quaternion(rotate_axis, delta*MAIN_RATE) * quaternion
	rotate_axis = rotate_axis.rotated(randDir(), delta*DRIFT_RATE)
