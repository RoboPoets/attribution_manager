@tool
extends Control


var _licenses:Array[Dictionary] = []


func _on_attribution_class_selected(index:int) -> void:
	_clear_license_inspector()
	var selection = %ClassListButton.get_item_text(index)
	for c in _licenses:
		if c.class == selection:
			_build_license_inspector(c.path)
			break


func _on_delete_button_pressed() -> void:
	queue_free()


func apply_theme() -> void:
	$DeleteButton.icon = get_theme_icon("Remove", "EditorIcons")


func set_licenses(licenses:Array[Dictionary]) -> void:
	_licenses = licenses
	for c in _licenses:
		%ClassListButton.add_item(c.class)


func _build_license_inspector(class_path:String) -> void:
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
		%Properties.add_child(hbox)


func _clear_license_inspector() -> void:
	print("huh")
	var count := %Properties.get_child_count()
	for i in range(count - 1, -1, -1):
		var node := %Properties.get_child(i)
		%Properties.remove_child(node)
		node.queue_free()
