extends Area3D

var character_node : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	character_node = get_tree().root.get_node("./Scene/PenCharacter");
	pass
	

# Function to handle collision detection
func _on_body_entered(body):
	print("Collision detected with: ", body.name)
	character_node.fell_in_water();
	

# Optional: handle body exit
func _on_body_exited(body):
	print("Body exited collision with: ", body.name)
	character_node.exited_water();
