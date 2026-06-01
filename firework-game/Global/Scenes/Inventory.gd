extends Node

var _items: Dictionary = {
	"strontium": 0,
	"barium": 0,
	"copper": 0,
	"glue": 0,
	"oxidizer": 0,
	"dextrin": 0,
	"charcoal": 0,
	"palm wrap": 0,
	"divider": 0,
	"small tube": 0,
	"candle tube": 0,
	"mortar tube": 0,
	"ball wrap": 0,
	"shell": 0,
	"packaging": 0,
	"quick fuse": 0,
	"normal fuse": 0,
	"slow fuse": 0,
}


func add_item(item_id: String, amount: int) -> bool:
	if amount <= 0:
		push_warning("add_item called with non-positive amount: %s" % amount)
		return false
	var current: int = _items.get(item_id, 0)
	_items[item_id] = current + amount
	return true


func remove_item(item_id: String, amount: int) -> bool:
	if amount <= 0:
		push_warning("remove_item called with non-positive amount: %s" % amount)
		return false
	var current: int = _items.get(item_id, 0)
	if current <= 0:
		push_warning("Attempted to remove '%s' but inventory has none." % item_id)
		return false
	_items[item_id] = maxi(current - amount, 0)
	return true


func get_count(item_id: String) -> int:
	return _items.get(item_id, 0)


func has(item_id: String, amount: int) -> bool:
	if amount <= 0:
		return true
	return get_count(item_id) >= amount


func register_dud(dud_id: String) -> void:
	if not _items.has(dud_id):
		_items[dud_id] = 0


func calculate_max_craftable(requirements: Dictionary) -> int:
	var max_possible: int = 999999
	for material: String in requirements.keys():
		var required_amount: int = requirements[material]
		if required_amount <= 0:
			continue
		var current_supply: int = get_count(material)
		var possible_with_mat: int = current_supply / required_amount
		max_possible = mini(max_possible, possible_with_mat)
	return max_possible


func reset() -> void:
	for key: String in _items.keys():
		_items[key] = 0
 