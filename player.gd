extends Node3D

var lookXY := Vector2.ZERO
const SENSITIVITY := 0.005
const MOVE_SPEED := 4.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		lookXY += event.screen_relative * SENSITIVITY
		lookXY.y = clampf(lookXY.y, -PI/2, PI/2)
		lookXY.x = fmod(lookXY.x, TAU)
		quaternion = Quaternion(Vector3.DOWN, lookXY.x) * Quaternion(Vector3.LEFT, lookXY.y)
	elif event.is_action_released("quit"):
		get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move := Vector3.ZERO
	if Input.is_action_pressed("move_fwd"):
		move += Vector3.FORWARD
	if Input.is_action_pressed("move_bkwd"):
		move += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		move += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		move += Vector3.RIGHT
	if Input.is_action_pressed("move_up"):
		move += Vector3.UP
	if Input.is_action_pressed("move_down"):
		move += Vector3.DOWN
	position += move.normalized().rotated(Vector3.DOWN, lookXY.x) * delta * MOVE_SPEED
