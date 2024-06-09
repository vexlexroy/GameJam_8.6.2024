extends Node

class_name Storage

var character_node : Node
var UI_node : Node

# Update with new elements from GameMaster
var light_weight_fac : Dictionary = {
	"O" : -0.2, "H" : 0, "C" : 0, "H2O" : 0.3, "He" : -0.6
};

var current_amount : float
func get_current_amount(): return current_amount;

var element_amount = {};

class Portion:
	var element : GameMaster.Elements
	var amount : float
	func _init(e : GameMaster.Elements = -1, a : float = 1): element = e; amount = a;

var element_stack : Array[Portion]


func _ready():
	character_node = get_node("..");
	print(character_node);
	UI_node = get_node("../../UI/Storage_UI");
	for el in GameMaster.Elements.values():
		element_amount[el] = 0.0;
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
			remove_from_storage(last_portion); #current_amount -= last_portion.amount;
			element_stack.pop_back();
			UI_node.Remove_last_item();
			#if (last_portion.element == GameMaster.Elements.He):
			#	helium_delta -= last_portion.amount;
		elif (last_portion.amount > amount):
			portions_released.append(Portion.new(last_portion.element, amount));
			#if (last_portion.element == GameMaster.Elements.He):
			#	helium_delta -= last_portion.amount;
			element_stack[-1].amount -= amount;
			remove_from_storage(Portion.new(element_stack[-1].element, amount)) #current_amount -= amount;
			break;
	if (current_amount < 0): current_amount = 0;
	elif (current_amount > 0): 
		if (len(element_stack) == 0): 
			current_amount = 0; #helium_delta = helium_amount;
		else: UI_node.Update_last_item(element_stack[-1].amount);
	#if (helium_delta != 0):
	#	check_helium_percent(helium_delta);
	check_light_weight_percent();
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
		add_to_storage(Portion.new(element_stack[-1].element, amount)); #current_amount += amount;
		UI_node.Update_last_item(element_stack[-1].amount);
	else:
		var new_portion = Portion.new(element, amount);
		element_stack.append(new_portion);
		UI_node.Add_item(new_portion);
		add_to_storage(new_portion); #current_amount += amount;
	#if (element == GameMaster.Elements.He):
	#	check_helium_percent(amount);
	check_light_weight_percent();
	return amount;

# Overall amount tracking
func add_to_storage(portion : Portion):
	current_amount += portion.amount;
	element_amount[portion.element] += portion.amount;
	return;
func remove_from_storage(portion : Portion):
	current_amount -= portion.amount;
	if (current_amount < 0): current_amount = 0;
	element_amount[portion.element] -= portion.amount;
	if (element_amount[portion.element] < 0):
		element_amount[portion.element] = 0;
	return;


# ----  Element specific  ----
func check_light_weight_percent():
	var total = 1;
	for el in GameMaster.Elements.values():
		total += ((float(element_amount[el]) / float(GameMaster.max_container_size)) * float(light_weight_fac[GameMaster.Elements.keys()[el]]));
	#print("total = " + str(total));
	character_node.light_weight_percent_update(total);
