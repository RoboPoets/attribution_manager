@tool
extends "./license_item.gd"


func set_property(prop:String) -> void:
	super(prop)
	if prop == "role":
		_set_roles()


func get_value() -> String:
	return $Options.get_item_text($Options.selected)


func set_value(val:String) -> void:
	for i in $Options.item_count:
		if $Options.get_item_text(i) == val:
			$Options.select(i)
			break


func _set_roles() -> void:
	$Options.clear()
	for r in AttributionManager.get_known_roles():
		$Options.add_item(r)
