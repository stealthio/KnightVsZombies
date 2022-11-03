extends KinematicBody2D

export var speed := 200.0

var input_velocity := Vector2(0.0, 0.0) # Describes the motion from keyboard inputs that is applied every physics tick
var velocity := Vector2(0.0, 0.0) # Describes the total motion

func _physics_process(delta):
	# Handle player input
	input_velocity = Vector2(0.0, 0.0)
	if Input.is_action_pressed("Up"):
		input_velocity += Vector2(0.0, -1.0)
	if Input.is_action_pressed("Down"):
		input_velocity += Vector2(0.0, 1.0)
	if Input.is_action_pressed("Left"):
		input_velocity += Vector2(-1.0, 0.0)
	if Input.is_action_pressed("Right"):
		input_velocity += Vector2(1.0, 0.0)
	
	# Velocity application
	velocity += input_velocity.normalized() * speed
	
	move_and_slide(velocity)
	
	velocity *= 0.5 # Smooth decelleration
	
	if velocity.length() < 1.0: # Snap velocity to 0.0 if the motion is too subtle to notice
		velocity = Vector2(0.0, 0.0)
	
	global_position = global_position.round()
