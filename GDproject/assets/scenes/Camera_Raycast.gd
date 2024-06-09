extends RayCast3D

@export var target : Node;

var local_on = false;

func _physics_process(delta):
	var hit_target = get_collider() # A CollisionObject3D.
	if ((hit_target == target) != local_on):
		local_on = !local_on;
		target.set_outline(local_on);
	return
