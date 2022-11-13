extends Area2D

export var damage := 1.0
export var autoclear_time = 0.0 # clears the damaged array after n seconds
var damaged = []

func _ready():
	connect("body_entered", self, "on_body_entered")
	if autoclear_time > 0.0:
		var timer = Timer.new()
		timer.autostart = false
		timer.one_shot = false
		add_child(timer)
		timer.connect("timeout", self, "refresh")
		timer.start(autoclear_time)

func on_body_entered(body : Node):
	if body.get("hitpoints") and !damaged.has(body) and body != self and body != get_parent():
		body.receive_damage(damage, self)
		damaged.append(body)

func refresh():
	damaged.clear()
	monitoring = false
	monitoring = true

func activate():
	monitoring = true
	damaged.clear()

func deactivate():
	monitoring = false
