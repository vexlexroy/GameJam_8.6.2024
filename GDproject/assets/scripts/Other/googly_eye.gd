extends Node

@export var range : float = 0.5;
#@export var speed : float = 1;

var scene_root : Node;

func _ready():
	scene_root = get_node("../../..");
	range = pow(range, 2);
	return;


func _process(delta):
	var local_direction = scene_root.transform.basis.y;
	#var angle = rad_to_deg(local_direction.angle_to(global_down));
	self.position = range * Vector3(0, -local_direction[1], -local_direction[0]);
	#var dis = pow(self.position.x, 2) + pow(self.position.y, 2);
	#if (dis > range):
	#	self.position += (dis - range) * Vector3(0, local_direction[1], local_direction[0]);
	return;
