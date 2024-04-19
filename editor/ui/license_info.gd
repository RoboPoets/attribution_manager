@tool
extends Control


var _licenses:Array[Dictionary] = []


func _on_attribution_class_selected(index:int) -> void:
	_clear_license_inspector()
	var selection = %ClassListButton.get_item_text(index)
	for l in _licenses:
		if l.class == selection:
			_build_license_inspector(l.path)
			break


func _on_delete_button_pressed() -> void:
	queue_free()


func apply_theme() -> void:
	if has_theme_icon("Remove", "EditorIcons"):
		$DeleteButton.icon = get_theme_icon("Remove", "EditorIcons")


func set_licenses(licenses:Array[Dictionary]) -> void:
	_licenses = licenses
	for l in _licenses:
		%ClassListButton.add_item(l.class)


func get_license() -> LicenseBase:
	var selection = %ClassListButton.get_item_text(%ClassListButton.selected)

	var license:LicenseBase = null
	for l in _licenses:
		if l.class == selection:
			license = load(l.path).new()
			break

	if not license:
		return null

	for c in %Properties.get_children():
		license.set(c.property,c.get_value())
		pass

	return license


func _build_license_inspector(class_path:String) -> void:
	var license:LicenseBase = load(class_path).new()
	var item_scene:PackedScene = preload("./license_item.tscn")
	for prop in license.get_property_list():
		if prop.usage != 4102:
			continue
		if prop.name == "resource_id":
			continue
		var item = item_scene.instantiate()
		item.set_property(prop)
		%Properties.add_child(item)


func _clear_license_inspector() -> void:
	var count := %Properties.get_child_count()
	for i in range(count - 1, -1, -1):
		var node := %Properties.get_child(i)
		%Properties.remove_child(node)
		node.queue_free()
