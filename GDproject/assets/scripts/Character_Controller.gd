extends Node

@export var rot_speed : float
@export var propulsion_speed : float
@export var syphon_factor : float
@export var release_factor : float
@export var hop_factor : float

var input : int
var syphoning : bool
var cap_in : bool;

var storage_node;

var contact_cnt : int

# Called when the node enters the scene tree for the first time.
func _ready():
	self.contact_monitor = true;
	self.max_contacts_reported  = 4;
	contact_cnt = 0;
	cap_in = false;
	storage_node = get_node("./Storage");
	return

# TEST
var cnt = 0;
var timer = 0;
# TEST
func _process(delta):
	syphoning = Input.is_action_pressed("syphon");
	if syphoning and timer <= 0:
		# TEST
		var _syphoned_amount = storage_node.syphon(cnt % 2, 2.0);
		cnt += 1;
		timer = 2;
		# TEST
		#var amount = syphon_factor * delta;
		#var el = 0; # TODO: Get element depending on environment
		#var _syphoned_amount = storage_node.syphon(el, amount);
	# TEST
	if (timer > 0):
		timer -= delta;
	# TEST
	return;
# TEST

func lerp(start, end, delta):
	return start + ((end - start) * delta);
	
func _integrate_forces(state):
	# ---- Movement
	# -- Rotation
	var rot = 0;
	var grav_mag : int = ProjectSettings.get_setting("physics/2d/default_gravity");
	var forward = self.transform.basis.y;
	if Input.is_action_pressed("move_right"): rot = -1;
	elif Input.is_action_pressed("move_left"): rot = 1;
	# Apply
	state.angular_velocity.z = lerp(state.angular_velocity.z, rot * (grav_mag * 0.1 * rot_speed * state.step), 0.2);
	
	# -- Cap
	if Input.is_action_just_released("cap_toggle"):
		var anim_node = get_node("./AnimationPlayer");
		print(anim_node.is_playing());
		if (not anim_node.is_playing()):
			if (cap_in and contact_cnt > 0):
				print("hop!");
				state.apply_force(forward * (grav_mag * 100) * hop_factor * state.step, Vector3(0, 0, -0.1));
			anim_node.play("Pen/pen_click_out" if cap_in else "Pen/pen_click_in");
			cap_in = !cap_in;
	
	# -- Release/Propulsion
	if !syphoning and Input.is_action_pressed("release"):
		var release_arr = storage_node.release_next(release_factor * state.step);
		if (len(release_arr) == 0): pass; #print("empty!");
		else:
			#var prnts = "releasing: ";
			#for portion in release_arr:
			#	prnts += "(" +  GameMaster.Elements.keys()[portion.element] + " : " + str(portion.amount) + ") ,";
			#print(prnts);
			forward = self.transform.basis.y;
			state.apply_force(forward * grav_mag * propulsion_speed * state.step, Vector3(0, 0, -0.1));
	return
	

# ------  Signals  ------
func _on_cap_area_body_entered(_body):
	contact_cnt += 1;
	return;
func _on_cap_area_body_exited(_body):
	contact_cnt -= 1;
	return;
