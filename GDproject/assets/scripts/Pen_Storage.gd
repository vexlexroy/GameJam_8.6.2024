extends Node

class_name Storage

var root : Node
var UI_node : Node

var current_amount : float
func get_current_amount(): return current_amount;

class Portion:
	var element : GameMaster.Elements
	var amount : float
	func _init(e : GameMaster.Elements = -1, a : float = 1): element = e; amount = a;

var element_stack : Array[Portion]


func _ready():
	root = get_node("..");
	UI_node = get_node("../../UI/Storage_UI");
	return;
	
# TEST
"""
var first_frame = true;
func firstFrame():
	if (first_frame):
		for i in [Portion.new(0, 2.5), Portion.new(1, 2.5), Portion.new(2, 2.5)]:
			await get_tree().create_timer(2.0).timeout;
			syphon(i.element, i.amount);
			print("hello" + str(i.element));
		first_frame = false;
	return;
	
func _process(delta):
	firstFrame();
	return;
"""
# /TEST


func syphon(element : GameMaster.Elements, amount : float = 1):
	var ret = add_element(element, amount);
	#print_storage();
	return ret;
func release_next(amount : float = 1) -> Array:
	if (current_amount == 0 or len(element_stack) == 0):
		return [];
	if (current_amount < amount):
		amount = current_amount;
	var portions_released = [];
	while (current_amount > 0 and len(element_stack) > 0):
		var last_portion = element_stack[-1];
		if (last_portion.amount <= amount):
			portions_released.append(last_portion);
			amount -= last_portion.amount;
			current_amount -= last_portion.amount;
			element_stack.pop_back();
			UI_node.Remove_last_item();
		elif (last_portion.amount > amount):
			portions_released.append(Portion.new(last_portion.element, amount));
			UI_node.Update_last_item(element_stack[-1].amount);
			element_stack[-1].amount -= amount;
			current_amount -= amount;
			break;
	if (current_amount < 0): current_amount = 0;
	# TODO: Update UI
	
	# END
	#print_storage();
	return portions_released;

func print_storage():
	var prnts = "cur storage (" + str(current_amount) + "): ";
	for portion in element_stack:
		prnts += "(" + GameMaster.Elements.keys()[portion.element] + " : " + str(portion.amount) + ") ,";
	print(prnts);
	return;

func add_element(element : GameMaster.Elements, amount : float = 1) -> float:
	var max = GameMaster.max_container_size;
	if (current_amount == max): return 0;
	if (amount > max - current_amount):
		amount = max - current_amount;
	if (len(element_stack) > 0 and element_stack[-1].element == element):
		element_stack[-1].amount += amount;
		UI_node.Update_last_item(element_stack[-1].amount);
	else:
		var new_portion = Portion.new(element, amount);
		element_stack.append(new_portion);
		UI_node.Add_item(new_portion);
	current_amount += amount;
	# TODO: Update UI
	return amount;
