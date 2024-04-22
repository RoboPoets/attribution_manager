@tool
extends Control


const Settings = preload("../../settings.gd")
const LicenseInfo = preload("./license_info.tscn")

var _license_classes:Array[Dictionary] = []
var _object:Resource = null


func _on_add_button_pressed() -> void:
	var info := LicenseInfo.instantiate()
	$Licenses.add_child(info)
	info.set_licenses(_license_classes)
	info.apply_theme()


func _on_save_button_pressed() -> void:
	if not _object:
		return

	var credits_path := ProjectSettings.get_setting(Settings.key_credits, "")
	var credits:Credits = load(credits_path)
	if not credits:
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

	var count := credits.attributions.size()
	for i in range(count - 1, -1, -1):
		if credits.attributions[i].resource_id == uid_str:
			credits.attributions.remove_at(i)

	credits.attributions.append_array(licenses)
	ResourceSaver.save(credits)


func refresh_info(object:Object) -> void:
	for c in ProjectSettings.get_global_class_list():
		if c.base != "LicenseBase":
			continue
		_license_classes.append(c)

	_object = object as Resource
	apply_theme()
	load_info()


func apply_theme() -> void:
	if has_theme_icon("Save", "EditorIcons"):
		%SaveButton.icon = get_theme_icon("Save", "EditorIcons")
	if has_theme_icon("Add", "EditorIcons"):
		%AddButton.icon = get_theme_icon("Add", "EditorIcons")
	if has_theme_color("font_color", "Label"):
		$CategoryPanel/HBoxContainer/Icon.modulate = get_theme_color("font_color", "Label")


func load_info() -> void:
	if not _object:
		return

	var credits_path := ProjectSettings.get_setting(Settings.key_credits, "")
	var credits:Credits = load(credits_path)
	if not credits:
		return

	var uid_num := ResourceLoader.get_resource_uid(_object.resource_path)
	var uid_str := ResourceUID.id_to_text(uid_num)
	for license in credits.attributions:
		if license.resource_id != uid_str:
			continue

		var info := LicenseInfo.instantiate()
		$Licenses.add_child(info)
		info.set_licenses(_license_classes)
		info.set_license(license)
		info.apply_theme()
