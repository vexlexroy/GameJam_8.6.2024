extends Node

@export var speed : float
var input : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func lerp(start, end, delta):
	return start + ((end - start) * delta)
func _integrate_forces(state):
	# get input
	var rot = 0;
	if Input.is_action_pressed("move_right"): rot = -1;
	elif Input.is_action_pressed("move_left"): rot = 1
	# apply rotation
	state.angular_velocity.z = lerp(state.angular_velocity.z, rot * (speed * state.step), 0.2)
	return
