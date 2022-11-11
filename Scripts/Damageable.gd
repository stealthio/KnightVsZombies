extends KinematicBody2D

export var hitpoints := 1.0 setget set_hitpoints

var dead := false

signal on_damaged
signal on_death

func set_hitpoints(value):
	hitpoints = max(0.0, value)
	if hitpoints <= 0.0:
		emit_signal("on_death")
		dead = true

func receive_damage(amount):
	set_hitpoints(hitpoints - amount)
