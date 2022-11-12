extends Area2D

export var damage := 1.0

var damaged = []

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body : Node):
	if body.get("hitpoints") and !damaged.has(body):
		body.receive_damage(damage, self)
		damaged.append(body)

func activate():
	monitoring = true
	damaged.clear()

func deactivate():
	monitoring = false
