extends Node3D

@export var signal_mappings: Dictionary[String, Callable] = {}

@export var player: Node3D

@export var sensitivity = 0.01
# Maximum vertical angle in degrees
@export var vertical_limit_top = 2
@export var vertical_limit_bottom = -60

# Internal variables
var current_rotation = Vector2.ZERO

func _ready():
	# Capture the mouse to prevent it from leaving the window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		# Get offset of mouse with sensitivity multiplier
		var mouse_offset = event.relative * sensitivity
		
		# Adjust yaw/pitch, with clamping on x-axis rotation
		current_rotation.y -= mouse_offset.x 
		current_rotation.x = clamp(
			current_rotation.x - mouse_offset.y,
			deg_to_rad(vertical_limit_bottom),
			deg_to_rad((vertical_limit_top))
		)

		# Apply the rotation to the pivot
		rotation_degrees = Vector3(rad_to_deg(current_rotation.x), rad_to_deg(current_rotation.y), 0)

func _process(_delta):
	# Move ourselves (the pivot) to the Player position to track the player
	# This could be changed to another position to track other things since
	# it isn't parented by the Player.
	position = player.position
