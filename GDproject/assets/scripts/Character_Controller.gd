extends Node

class_name Character

@export var rot_speed : float
@export var syphon_factor : float
@export var release_factor : float
@export var hop_factor : float

# ---- Elements propulsion factors ----
@export var propulsion_fac_air : float
@export var propulsion_fac_water : float
@export var propulsion_fac_helium : float

var input : int
var syphoning : bool
var cap_in : bool;

var storage_node;
var pen_outline_node : Node;
var cap_outline_node : Node;

var contact_cnt : int

var in_water : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.contact_monitor = true;
	self.max_contacts_reported  = 4;
	contact_cnt = 0;
	cap_in = false;
	storage_node = get_node("./Storage");
	pen_outline_node = get_node("./PenOutline");
	cap_outline_node = get_node("./PenOutline/CapOutline");
	set_outline(false);
	return

# TEST
var cnt = 0;
var timer = 0;
# TEST
func _process(delta):
	syphoning = Input.is_action_pressed("syphon");
	if syphoning:
		var amount = syphon_factor * delta;
		var el = 3 if in_water else 0; # TODO: Get element depending on environment
		var _syphoned_amount = storage_node.syphon(el, amount);
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
			var prop_fac = average_prop_factor(release_arr);
			state.apply_force(forward * grav_mag * prop_fac * state.step, Vector3(0, 0, -0.1));
	return

func average_prop_factor(portions : Array):
	var res = 0.0;
	var sum = 0.0;
	for portion in portions:
		match (portion.element):
			GameMaster.Elements.O:
				res += float(propulsion_fac_air) * float(portion.amount); sum += portion.amount;
			GameMaster.Elements.H2O:
				res += float(propulsion_fac_water) * float(portion.amount); sum += portion.amount;
			GameMaster.Elements.He:
				res += float(propulsion_fac_helium) * float(portion.amount); sum += portion.amount;
	return float(res) / float(sum);


func set_outline(value : bool):
	pen_outline_node.visible = !value;
	cap_outline_node.visible = !value;
	return;

# ------  Element effects  ------
# Water
func fell_in_water(): in_water = true;
func exited_water(): in_water = false;
# Helium
func helium_percent_update(helium_percent : float):
	self.gravity_scale = 1 - (helium_percent * 0.5); return;


# ------  Signals  ------
func _on_cap_area_body_entered(_body):
	contact_cnt += 1;
	return;
func _on_cap_area_body_exited(_body):
	contact_cnt -= 1;
	return;
