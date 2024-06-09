extends Node

@export var target  : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x = target.position.x;
	self.position.y = target.position.y;
	return

"""
# Raycast to activate/deactivate outline
func _phsics_process(delta):
	var space_state = get_world_3d().direct_space_state;
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(Vector3(target.position.x, target.position.y, self.position.z), 
													Vector3(target.position.x, target.position.y, target.position.z));
	var result = space_state.intersect_ray(query)
	if result:
		print("Hit at point: ", result.position);
	return;
"""
