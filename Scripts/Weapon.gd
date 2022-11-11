extends Node2D

func _process(delta):
	rotation = global_position.direction_to(get_global_mouse_position()).angle()

func _input(event):
	if event.is_action_pressed("Attack") and !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("attack")
