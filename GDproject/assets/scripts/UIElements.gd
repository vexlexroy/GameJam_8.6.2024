extends Control

var storage_node : Node;
var stack_node : Node;

var array : Array[Node];
var templateNode : Node;

var Element_Colors = [
	Color(150, 245, 245),	# 0 -> O; Oxygen
	Color(250, 250, 250),	# 1 -> H; Hydrogen
	Color(196, 196, 196)	# 2 -> C; Carbon
];

func _ready():
	storage_node = get_node("../../PenCharacter/Storage");
	stack_node = get_node("./StackOfElements");
	templateNode = get_node("./StackOfElements/_Template");
	templateNode.visible = false;
	array = [];
	return;


func Set_element_UI(elements):
	for portion in elements:
		var new_sprite_node = templateNode.duplicate();
		new_sprite_node.offset = Vector2(0, 0);
		array.append(new_sprite_node);
		new_sprite_node.texture = load("res://assets/Icons/Color_" + GameMaster.Elements.keys()[portion.element] + ".png");
		var percent_amount = portion.amount / GameMaster.max_container_size;
		new_sprite_node.scale.y = (float(150)/float(256)) * percent_amount;
		var percent_filled = float(storage_node.get_current_amount()) / float(GameMaster.max_container_size);
		new_sprite_node.position.y = float(150) * percent_filled;
		print(str(percent_filled) + " * " + str(150) + " = " + str(new_sprite_node.position.y));
		new_sprite_node.visible = true;
		stack_node.add_child(new_sprite_node);
		print(new_sprite_node.name + ":");
	return
	
func Add_item(portion : Storage.Portion):
	var new_sprite_node = templateNode.duplicate();
	new_sprite_node.offset = Vector2(0, 0);
	new_sprite_node.texture = load("res://assets/Icons/Color_" + GameMaster.Elements.keys()[portion.element] + ".png");
	var percent_amount = portion.amount / GameMaster.max_container_size;
	new_sprite_node.scale.y = (float(150)/float(256)) * percent_amount;
	var percent_filled = float(storage_node.get_current_amount() - portion.amount) / float(GameMaster.max_container_size);
	new_sprite_node.position.y = float(150) * percent_filled;
	new_sprite_node.visible = true;
	array.push_back(new_sprite_node);
	print("array (" + str(len(array)) + "):");
	print(array);
	stack_node.add_child(new_sprite_node);
	return
func Remove_last_item():
	array[-1].queue_free();
	array.pop_back();
	return
func Update_last_item(newAmount : float):
	print("update_last_item(" + str(newAmount) + "): ");
	var target = array[-1];
	var percent_amount = newAmount / GameMaster.max_container_size;
	target.scale.y = (float(150)/float(256)) * percent_amount;
	var percent_filled = float(storage_node.get_current_amount() - newAmount) / float(GameMaster.max_container_size);
	target.position.y = (float(150) * percent_filled);
	return
