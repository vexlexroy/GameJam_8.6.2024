extends Node

@export var target  : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x = target.position.x;
	self.position.y = target.position.y;
	pass
