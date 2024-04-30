@tool
extends Control


const LicenseItem = preload("./license_item.tscn")
const LicenseItemOption = preload("./license_item_option.tscn")

var _licenses:Array[Dictionary] = []


func _enter_tree():
	# Don't change any properties or node contents when
	# this scene is opened for editing in the editor.
	if get_viewport() is SubViewport:
		return

	if _licenses.size() == 0:
		_get_licenses()

	if has_theme_icon("Remove", "EditorIcons"):
		$DeleteButton.icon = get_theme_icon("Remove", "EditorIcons")


func _on_license_class_selected(index:int) -> void:
	_clear_license_inspector()
	var selection = %ClassListButton.get_item_text(index)
	for l in _get_licenses():
		if l.class == selection:
			_build_license_inspector(load(l.path).new())
			break


func _on_delete_button_pressed() -> void:
	queue_free()


func get_license() -> LicenseBase:
	var selection = %ClassListButton.get_item_text(%ClassListButton.selected)

	var license:LicenseBase = null
	for l in _get_licenses():
		if l.class == selection:
			license = load(l.path).new()
			break

	if not license:
		return null

	for c in %Properties.get_children():
		license.set(c.get_property(),c.get_value())
		pass

	return license


func set_license(license:LicenseBase) -> void:
	# TODO: this is inconvenient and ugly. Improve it as soon
	# as https://github.com/godotengine/godot/pull/80487 makes
	# it into a stable release.
	var script_path:String = license.get_script().resource_path
	var license_name:String = ""
	for l in _get_licenses():
		if l.path == script_path:
			license_name = l.class
			break

	for i in %ClassListButton.item_count:
		if %ClassListButton.get_item_text(i) == license_name:
			%ClassListButton.select(i)
			break

	_build_license_inspector(license)


func _build_license_inspector(license:LicenseBase) -> void:
	for prop in license.get_property_list():
		if not _should_show_in_inspector(prop):
			continue

		var item:Control
		match prop.name:
			"role": item = LicenseItemOption.instantiate()
			_:      item = LicenseItem.instantiate()

		item.set_property(prop.name)
		item.set_value(license.get(prop.name))
		%Properties.add_child(item)


func _clear_license_inspector() -> void:
	var count := %Properties.get_child_count()
	for i in range(count - 1, -1, -1):
		var node := %Properties.get_child(i)
		node.queue_free()


func _should_show_in_inspector(property:Dictionary) -> bool:
	if property.usage != 4102:
		return false
	if property.name == "resource_id":
		return false
	return true


func _get_licenses() -> Array[Dictionary]:
	if _licenses.size() == 0:
		_licenses = AttributionManager.get_known_licenses()
		for l in _licenses:
			%ClassListButton.add_item(l.class)
	return _licenses
