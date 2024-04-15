@tool
extends Control


var _license_classes:Array[Dictionary] = []


# We use this to guard against cases where the scene for this UI element is
# open and we're using its functionality on resources at the same time. This
# would cause changes to the options button to persist, which is not at all
# what we'd want.
func _notification(what:int) -> void:
	match what:
		NOTIFICATION_EDITOR_PRE_SAVE:
			%ClassListButton.clear()


func refresh_info(object:Object) -> void:
	%ClassListButton.add_item("None")
	%ClassListButton.selected = 0

	for c in ProjectSettings.get_global_class_list():
		if c.base != "LicenseBase" and c.class != "LicenseBase":
			continue
		_license_classes.append(c)
		%ClassListButton.add_item(c.class)


func _on_attribution_class_selected(index:int) -> void:
	var selection = %ClassListButton.get_item_text(index)
	for c in _license_classes:
		if c.class == selection:
			_build_license_inspector(c.path)
			break


func _build_license_inspector(class_path:String) -> void:
	_clear_license_inspector()

	var license:LicenseBase = load(class_path).new()
	for prop in license.get_property_list():
		if prop.usage != 4102:
			continue
		var label := Label.new()
		label.text = prop.name.capitalize()
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var edit := TextEdit.new()
		edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var hbox := HBoxContainer.new()
		hbox.add_child(label)
		hbox.add_child(edit)
		$Properties.add_child(hbox)


func _clear_license_inspector() -> void:
	var count := $Properties.get_child_count()
	for i in range(count - 1, -1, -1):
		var node := $Properties.get_child(i)
		$Properties.remove_child(node)
		node.queue_free()
