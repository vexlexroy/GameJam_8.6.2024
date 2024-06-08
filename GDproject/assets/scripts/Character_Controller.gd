extends Node

@export var rot_speed : float
@export var propulsion_speed : float
@export var syphon_factor : float
@export var release_factor : float

var input : int
var amount : float
var syphoning : bool


# Called when the node enters the scene tree for the first time.
func _ready():
	amount = 10;
	return
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	syphoning = Input.is_action_pressed("syphon");
	if syphoning:
		amount += syphon_factor * delta;
		print("syphoning... " + str(amount));
	return
	
func lerp(start, end, delta):
	return start + ((end - start) * delta)
func _integrate_forces(state):
	# ---- Movement
	# -- Rotation
	var rot = 0;
	var grav_mag : int = ProjectSettings.get_setting("physics/2d/default_gravity")
	if Input.is_action_pressed("move_right"): rot = -1;
	elif Input.is_action_pressed("move_left"): rot = 1
	# Apply
	state.angular_velocity.z = lerp(state.angular_velocity.z, rot * (grav_mag * 0.1 * rot_speed * state.step), 0.2)
	# -- Release
	if !syphoning and Input.is_action_pressed("release"):
		if (amount <= 0):
			amount = 0;
			print("empty!");
		else:
			amount -= release_factor * state.step;
			print("releasing... " + str(amount));
			var forward = self.transform.basis.y;
			state.apply_force(forward * grav_mag * propulsion_speed * state.step, Vector3(0, 0, -0.1));
	return
