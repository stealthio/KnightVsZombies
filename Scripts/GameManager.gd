extends Node2D

var wave = 0

var enemy_types = [preload("res://Prefabs/Enemies/Enemy.tscn")]
onready var spawn_points = $SpawnPoints.get_children()

func _ready():
	pass # Replace with function body.
