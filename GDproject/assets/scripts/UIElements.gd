extends Control

var ui

# Called when the node enters the scene tree for the first time.
func _ready():
	ui = get_node("./StackOfElements")
	Update_element_UI([1,2,3])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	



func Update_element_UI(elements):
	for i in elements:
		var original_image=null
		var icon = Button.new()
		icon.disabled=true
		if i == 1:
			original_image = load("res://assets/Icons/ElementO2.png")
		elif i == 2:
			original_image = load("res://assets/Icons/ElementH2O.png")
		elif i == 3:
			original_image = load("res://assets/Icons/ElementHe.png")
		var desired_size = Vector2(60, 60)  # Set your desired size here
		#var resized_image = original_image.resize(desired_size.x, desired_size.y)
		icon.icon=original_image
		ui.add_child(icon)	
	return
	
func Colect_item():
	pass
	
func Remove_itme():
	pass
	
