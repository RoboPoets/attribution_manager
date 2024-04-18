@tool
extends Control


var _license_classes:Array[Dictionary] = []


func refresh_info(object:Object) -> void:
	if has_theme_icon("Add", "EditorIcons"):
		$AddButton.icon = get_theme_icon("Add", "EditorIcons")
	if has_theme_color("font_color", "Label"):
		$CategoryPanel/HBoxContainer/Icon.modulate = get_theme_color("font_color", "Label")

	for c in ProjectSettings.get_global_class_list():
		if c.base != "LicenseBase":
			continue
		_license_classes.append(c)


func _on_add_button_pressed():
	var info := preload("./license_info.tscn").instantiate()
	$Licenses.add_child(info)
	info.set_licenses(_license_classes)
	info.apply_theme()
