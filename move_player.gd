extends CharacterBody3D

@export var camera_pivot: Node3D
@export var debugger_ball: Node3D

@export var movement_speed = 1.4
@export var run_multiplier = 3
@export var look_to_scale = 5

func _physics_process(delta):
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	var new_vel = Vector3.ZERO
	var old_y = velocity.y
	var mult = movement_speed
	
	var z_vel = Input.get_axis("ui_down", "ui_up")
	var x_vel = Input.get_axis("ui_right", "ui_left")
	
	# Add running multiplier!
	if (Input.is_action_pressed("ui_move_mod")):
		mult *= run_multiplier
	
	# Add Vectors that are based on the z and x rotations of the node.
	# This offsets the existing position from local space and looking vectors, 
	# similar to `position.x + x_vel` but more efficient among multiple axis.
	# We also multiply these by the input values by axis (keyboard is -1 to 1).
	# This will also inherently work with analogue controls as well.
	new_vel += transform.basis.z * z_vel * mult
	new_vel += transform.basis.x * x_vel * mult
	
	# If we don't restore to previous falling height, 
	# it'll always calc the velocity from 0
	# We need to take previous gravity instaneous velocity into effect,
	# so re-continue the velocity in y-axis from existing inertia.
	new_vel.y = old_y
	# And apply *new* gravity offset. Delta is needed here since gravity is
	# exponential per second.
	new_vel.y -= gravity * delta
	
	# Set and move
	velocity = new_vel
	move_and_slide()

func _process(_delta):
	if (camera_pivot):
		# Get the way the camera is looking on the basis matrix
		# Camera looks in -z
		var look_vec = -camera_pivot.basis.z
		# Ignore y-axis during normalizing calcs
		look_vec.y = 0
		# Normalize the vector so the `magnitudwwwwwe` is 1. This lets us keep
		# a consistent distance from the center origin later
		look_vec = look_vec.normalized()
		# Scale looking vector
		look_vec *= look_to_scale

		# Get the new target, which is based on our current position 
		# and the looking vector offset
		var target = position - Vector3(look_vec.x, 0, look_vec.z) 

		# Keep the original Y position of the bug as placed in scene
		debugger_ball.global_position = target
		
		look_at(target, Vector3.UP, true)
