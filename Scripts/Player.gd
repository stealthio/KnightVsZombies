extends "res://Scripts/Damageable.gd"

enum States {
	IDLE,
	WALK,
	DODGING,
	DEAD
}

export var speed := 200.0
export var dodge_speed := 400.0

var input_velocity := Vector2(0.0, 0.0) # Describes the motion from keyboard inputs that is applied every physics tick
var velocity := Vector2(0.0, 0.0) # Describes the total motion
var dodging := false
var dodge_vector := Vector2(0,0)

var current_state = States.IDLE

func _init():
	add_to_group("PLAYER")

func _ready():
	pass

func _get_movement_input_vector():
	input_velocity = Vector2(0.0, 0.0)
	if Input.is_action_pressed("Up"):
		input_velocity += Vector2(0.0, -1.0)
	if Input.is_action_pressed("Down"):
		input_velocity += Vector2(0.0, 1.0)
	if Input.is_action_pressed("Left"):
		input_velocity += Vector2(-1.0, 0.0)
	if Input.is_action_pressed("Right"):
		input_velocity += Vector2(1.0, 0.0)
	return input_velocity

func _process(delta):
	match(current_state):
		States.IDLE:
			$AnimationPlayer.play("Idle")
		States.WALK:
			$AnimationPlayer.play("Walk")
		States.DODGING:
			$AnimationPlayer.play("Walk")
			

func _physics_process(delta):
	var input_vector = _get_movement_input_vector()
	match(current_state):
		States.IDLE:
			if _get_movement_input_vector().length() > 0.0:
				current_state = States.WALK
			if Input.is_action_just_pressed("Dodge") and $DodgeCooldown.is_stopped():
				$Dodge.start()
				dodge_vector = _get_movement_input_vector()
				current_state = States.DODGING
		States.WALK:
			if input_vector.length() <= 0.0:
				current_state = States.IDLE
			if Input.is_action_just_pressed("Dodge") and $DodgeCooldown.is_stopped():
				$Dodge.start()
				dodge_vector = input_vector
				current_state = States.DODGING
			velocity += input_vector.normalized() * speed
		States.DODGING:
			velocity += dodge_vector.normalized() * dodge_speed
	
	if input_vector.x > 0: # flip the sprite to the target direction
		$Sprite.scale.x = -1
	elif input_vector.x < 0:
		$Sprite.scale.x = 1
	
	move_and_slide(velocity)
	
	velocity *= 0.5 # Smooth decelleration
	
	if velocity.length() < 1.0: # Snap velocity to 0.0 if the motion is too subtle to notice
		velocity = Vector2(0.0, 0.0)
	
	global_position = global_position.round()


func _on_Dodge_timeout():
	$DodgeCooldown.start()
	current_state = States.IDLE
