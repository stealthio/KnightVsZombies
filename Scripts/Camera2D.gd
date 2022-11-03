extends Camera2D

export (NodePath) onready var to_follow = get_node(to_follow) as Node2D # Let's you assign the node to follow via Inspector and converts it to the instance reference
export var camera_speed := 0.1 # defines the lerping weight of the camera movement


func _process(delta):
	global_position = lerp(global_position, to_follow.global_position, camera_speed)
	global_position = global_position.round()
