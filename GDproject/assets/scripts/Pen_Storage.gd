extends Node

class_name Storage

var root : Node

@export var max_amount : float
var current_amount : float

class Portion:
	var element : GameMaster.Elements
	var amount : float
	func _init(e : int = -1, a : float = 1): element = e; amount = a;
var element_stack : Array[Portion]


func _ready():
	root = get_node("..");
	#for el in GameMaster.Elements: element_dict[el] = 0;
	return;


func syphon(element : GameMaster.Elements, amount : float = 1):
	var ret = add_element(element, amount);
	print_storage();
	return ret;
func release_next(amount : float = 1) -> Array:
	if (current_amount == 0 or len(element_stack) == 0):
		return [];
	if (current_amount < amount):
		amount = current_amount;
	var portions_released = [];
	var loop_amount = amount;
	while (loop_amount and len(element_stack) > 0):
		var last_portion = element_stack[-1];
		if (last_portion.amount <= loop_amount):
			portions_released.append(last_portion);
			loop_amount -= last_portion.amount;
			element_stack.remove_at(len(element_stack) - 1);
		elif (last_portion.amount > loop_amount):
			portions_released.append(Portion.new(last_portion.element, loop_amount));
			element_stack[-1].amount -= loop_amount;
			loop_amount = 0;
			break;
	current_amount -= (amount - loop_amount);
	# TODO: Update UI
	print_storage();
	return portions_released;

func print_storage():
	var prnts = "cur storage (" + str(current_amount) + "): ";
	for portion in element_stack:
		prnts += "(" + GameMaster.Elements.keys()[portion.element] + " : " + str(portion.amount) + ") ,";
	print(prnts);
	return;

func add_element(element : GameMaster.Elements, amount : float = 1) -> float:
	if (current_amount == max_amount): return 0;
	if (amount > max_amount - current_amount):
		amount = max_amount - current_amount;
	if (len(element_stack) > 0 and element_stack[-1].element == element):
		element_stack[-1].amount += amount;
	else:
		element_stack.append(Portion.new(element, amount));
	current_amount += amount;
	# TODO: Update UI
	return amount;
