extends "res://Scripts/Damageable.gd"

export var speed := 200.0
export var dodge_speed := 400.0

var input_velocity := Vector2(0.0, 0.0) # Describes the motion from keyboard inputs that is applied every physics tick
var velocity := Vector2(0.0, 0.0) # Describes the total motion
var dodging := false
var dodge_vector := Vector2(0,0)

func _ready():
	pass

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
	if Input.is_action_just_pressed("Dodge") and !dodging and $DodgeCooldown.is_stopped():
		dodging = true
		dodge_vector = input_velocity
		$Dodge.start()

	# Velocity application
	if dodging:
		velocity += dodge_vector.normalized() * dodge_speed
	else:
		velocity += input_velocity.normalized() * speed
	
	move_and_slide(velocity)
	
	velocity *= 0.5 # Smooth decelleration
	
	if velocity.length() < 1.0: # Snap velocity to 0.0 if the motion is too subtle to notice
		velocity = Vector2(0.0, 0.0)
	
	global_position = global_position.round()


func _on_Dodge_timeout():
	$DodgeCooldown.start()
	dodging = false
