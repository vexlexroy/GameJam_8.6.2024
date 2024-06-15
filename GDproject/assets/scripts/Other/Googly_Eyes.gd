extends Node

@export var iris_L : Node3D;
@export var iris_R : Node3D;

@export var range : float = 0.5;
#@export var speed : float = 1;

var scene_root : Node;
var last_pos : Vector2;
var iris_pos : Vector2;

func _ready():
	scene_root = get_node("..");
	range = pow(range, 2);
	iris_pos = Vector2.ZERO;
	last_pos = Vector2(scene_root.position.x, scene_root.position.y);
	return;


func _process(delta):
	var cur_pos = Vector2(scene_root.position.x, scene_root.position.y);
	var delta_pos = cur_pos - last_pos;
	delta_pos += Vector2(0, delta);	# add gravity
	if (delta_pos != Vector2.ZERO):
		iris_pos -= delta_pos;
		var dis = pow(iris_pos.x, 2) + pow(iris_pos.y, 2);
		if (dis > range):
			iris_pos = iris_pos * (range / dis);
		iris_L.position = Vector3(0, iris_pos.y, iris_pos.x);
		iris_R.position = Vector3(0, iris_pos.y, iris_pos.x);
	last_pos = cur_pos;
	return;
