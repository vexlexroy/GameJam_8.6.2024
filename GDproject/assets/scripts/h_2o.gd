extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Function to handle collision detection
func _on_body_entered(body):
	print("Collision detected with: ", body.name)

# Optional: handle body exit
func _on_body_exited(body):
	print("Body exited collision with: ", body.name)
