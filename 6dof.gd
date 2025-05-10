extends CharacterBody3D

@export var move_acceleration: float = 20.0
@export var move_deceleration: float = 10.0
@export var max_speed: float = 15.0
@export var boost_multiplier: float = 2.0
@export var mouse_sensitivity: float = 0.003
@export var roll_speed: float = 2.0

var pitch: float = 0.0
var yaw: float = 0.0
var roll: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		pitch -= event.relative.y * mouse_sensitivity
		yaw -= event.relative.x * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	handle_input(delta)

func handle_input(delta):
	# --- Roll input
	var roll_input := 0.0
	if Input.is_action_pressed("roll_left"):
		roll_input += 1.0
	if Input.is_action_pressed("roll_right"):
		roll_input -= 1.0
	roll += roll_input * roll_speed * delta

	# --- Compute rotation basis with accumulated yaw/pitch/roll
	var basis = Basis(Vector3.UP, yaw) * Basis(Vector3.RIGHT, pitch) * Basis(Vector3.BACK, roll)
	global_transform.basis = basis.orthonormalized()

	# --- Movement input using axes
	var forward := Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	var strafe := Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	var vertical := Input.get_action_strength("ui_accept") - Input.get_action_strength("hover_down")

	var input_vector: Vector3 = (basis.z * forward) + (basis.x * strafe) + (basis.y * vertical)

	if input_vector != Vector3.ZERO:
		input_vector = input_vector.normalized()
		var target_speed = max_speed
		if Input.is_action_pressed("ui_move_mod"):
			target_speed *= boost_multiplier
		velocity = velocity.move_toward(input_vector * target_speed, move_acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, move_deceleration * delta)

	move_and_slide()
