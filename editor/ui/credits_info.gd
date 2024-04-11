@tool
extends Control


var _license_classes:Array[Dictionary] = []


func _enter_tree()-> void:
	for c in ProjectSettings.get_global_class_list():
		if c.base != "LicenseBase" and c.class != "LicenseBase":
			continue
		_license_classes.append(c)
		%ClassListButton.add_item(c.class)


func refresh_info(object:Object) -> void:
	print("duuuude")


func _on_attribution_class_selected(index:int) -> void:
	var selection = %ClassListButton.get_item_text(index)
	for c in _license_classes:
		if c.class == selection:
			_build_license_inspector(c.path)
			break


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
		$Properties.add_child(hbox)
