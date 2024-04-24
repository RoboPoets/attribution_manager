@tool
extends Control


const LicenseInfo = preload("./license_info.tscn")

var _object:Resource = null


func _enter_tree():
	# Don't change any properties or node contents when
	# this scene is opened for editing in the editor.
	if get_viewport() is SubViewport:
		return

	if has_theme_icon("Save", "EditorIcons"):
		%SaveButton.icon = get_theme_icon("Save", "EditorIcons")
	if has_theme_icon("Add", "EditorIcons"):
		%AddButton.icon = get_theme_icon("Add", "EditorIcons")
	if has_theme_color("font_color", "Label"):
		$CategoryPanel/HBoxContainer/Icon.modulate = get_theme_color("font_color", "Label")


func _on_add_button_pressed() -> void:
	var info := LicenseInfo.instantiate()
	$Licenses.add_child(info)


func _on_save_button_pressed() -> void:
	if not _object:
		return

	var uid_num := ResourceLoader.get_resource_uid(_object.resource_path)
	var uid_str := ResourceUID.id_to_text(uid_num)

	var licenses:Array[LicenseBase]
	for c in $Licenses.get_children():
		var license:LicenseBase = c.get_license()
		if not license:
			continue
		license.resource_id = uid_str
		licenses.append(license)

	AttributionManager.replace_attributions(licenses)


func set_object(object:Object) -> void:
	_object = object as Resource
	if not _object:
		return

	var uid_num := ResourceLoader.get_resource_uid(_object.resource_path)
	var uid_str := ResourceUID.id_to_text(uid_num)
	var licenses := AttributionManager.get_attributions(uid_str)
	for license in licenses:
		if license.resource_id != uid_str:
			continue

		var info := LicenseInfo.instantiate()
		$Licenses.add_child(info)
		info.set_license(license)
