extends "res://Scripts/Damageable.gd"

enum States {
	IDLE,
	WALK,
	CHASE,
	DAMAGED,
	DEAD,
	WAIT
}

export var speed = 10.0
export var chase_speed = 40.0
export var aggro_range = 300.0
export var received_knockback = 1000.0

var current_state = States.IDLE

var target_pos
var velocity := Vector2(0,0)

onready var player_ref = get_tree().get_nodes_in_group("PLAYER")[0]

func _ready():
	connect("on_death", self, "queue_free")
	connect("on_damaged", self, "_knockback")

func _knockback(origin_ref):
	var origin : Vector2 = origin_ref.global_position
	var dir = origin.direction_to(global_position)
	velocity += dir * received_knockback

func _reached_target_pos_check():
	if global_position.distance_to(target_pos) < 1: # reached destination
		target_pos = null
		current_state = States.WAIT

func _player_in_range() -> bool:
	return global_position.distance_to(player_ref.global_position) < aggro_range

func _process(delta):
	if get_node_or_null("AnimationPlayer"):
		match(current_state):
			States.IDLE:
				$AnimationPlayer.play("Idle")
			States.WAIT:
				$AnimationPlayer.play("Idle")
			States.CHASE:
				$AnimationPlayer.play("Walk")
			States.WALK:
				$AnimationPlayer.play("Walk")

func _physics_process(delta):
	match(current_state):
		States.IDLE:
			if  _player_in_range(): # check if player is in range
				current_state = States.CHASE
			else:
				current_state = States.WALK
		States.WALK:
			if !target_pos:
				target_pos = Vector2(global_position.x + rand_range(-100, 100), global_position.y + rand_range(-100,100))
			var dir = global_position.direction_to(target_pos)
			velocity += dir * speed
			if dir.x > 0: # flip the sprite to the target direction
				$Sprite.scale.x = -1
			else:
				$Sprite.scale.x = 1
			_reached_target_pos_check()
			if _player_in_range():
				current_state = States.CHASE
		States.CHASE:
			if _player_in_range():
				target_pos = player_ref.global_position
			var dir = global_position.direction_to(target_pos)
			if dir.x > 0: # flip the sprite to the target direction
				$Sprite.scale.x = -1
			else:
				$Sprite.scale.x = 1
			velocity += dir * chase_speed
			
			_reached_target_pos_check()
		States.DAMAGED:
			current_state = States.IDLE
		States.DEAD:
			pass
		States.WAIT:
			if randi()%200 == 1:
				current_state = States.IDLE
			if _player_in_range():
				current_state = States.CHASE

		
	move_and_slide(velocity)
	velocity *= .75
