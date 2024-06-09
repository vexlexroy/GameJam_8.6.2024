extends Node

class_name Storage

var root : Node
var character_node : Node
var UI_node : Node

var current_amount : float
func get_current_amount(): return current_amount;

var helium_amount : float;

class Portion:
	var element : GameMaster.Elements
	var amount : float
	func _init(e : GameMaster.Elements = -1, a : float = 1): element = e; amount = a;

var element_stack : Array[Portion]


func _ready():
	root = get_node("..");
	character_node = get_node("../PenCharacter");
	UI_node = get_node("../../UI/Storage_UI");
	return;


func release_next(amount : float = 1) -> Array:
	if (current_amount == 0 or len(element_stack) == 0):
		return [];
	if (current_amount < amount):
		amount = current_amount;
	var portions_released = [];
	var helium_delta = 0;
	while (current_amount > 0 and len(element_stack) > 0):
		var last_portion = element_stack[-1];
		if (last_portion.amount <= amount):
			portions_released.append(last_portion);
			amount -= last_portion.amount;
			current_amount -= last_portion.amount;
			element_stack.pop_back();
			UI_node.Remove_last_item();
			if (last_portion.element == GameMaster.Elements.He):
				helium_delta -= last_portion.amount;
		elif (last_portion.amount > amount):
			portions_released.append(Portion.new(last_portion.element, amount));
			if (last_portion.element == GameMaster.Elements.He):
				helium_delta -= last_portion.amount;
			element_stack[-1].amount -= amount;
			current_amount -= amount;
			break;
	if (current_amount < 0): current_amount = 0;
	elif (current_amount > 0): 
		if (len(element_stack) == 0): 
			current_amount = 0; helium_delta = helium_amount;
		else: UI_node.Update_last_item(element_stack[-1].amount);
	if (helium_delta != 0):
		check_helium_percent(helium_delta);
	return portions_released;

func print_storage():
	var prnts = "cur storage (" + str(current_amount) + "): ";
	for portion in element_stack:
		prnts += "(" + GameMaster.Elements.keys()[portion.element] + " : " + str(portion.amount) + ") ,";
	print(prnts);
	return;

func syphon(element : GameMaster.Elements, amount : float = 1) -> float:
	var max = GameMaster.max_container_size;
	if (current_amount == max): return 0;
	if (amount > max - current_amount):
		amount = max - current_amount;
	if (len(element_stack) > 0 and element_stack[-1].element == element):
		element_stack[-1].amount += amount;
		current_amount += amount;
		UI_node.Update_last_item(element_stack[-1].amount);
	else:
		var new_portion = Portion.new(element, amount);
		element_stack.append(new_portion);
		UI_node.Add_item(new_portion);
		current_amount += amount;
	if (element == GameMaster.Elements.He):
		check_helium_percent(amount);
	return amount;

# ----  Element specific  ----
func check_helium_percent(new_delta : float):
	if (new_delta != 0):
		helium_amount += new_delta;
		character_node.helium_percent_update(helium_amount / GameMaster.max_container_size);
