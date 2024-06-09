extends Control
#var simultaneous_scene = preload("res://assets/scenes/Main.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_tree().root.add_child(simultaneous_scene)
	pass

# Function to handle the button press
func _on_play_button_pressed():
	# Remove the previously added simultaneous scene if it exist
	get_tree().change_scene_to_file("res://assets/scenes/Main.tscn")
	#if get_tree().root.has_node("SimultaneousScene"):
		#get_tree().root.get_node("SimultaneousScene").queue_free()
	#get_tree().change_scene("res://assets/scenes/Main.tscn")



func _on_quit_pressed():
	get_tree().quit()
