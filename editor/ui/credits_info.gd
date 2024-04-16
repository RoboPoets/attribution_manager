@tool
extends Control


@export var license_info:PackedScene = preload("uid://cs5uset63g8ea")

var _license_classes:Array[Dictionary] = []


func refresh_info(object:Object) -> void:
	$AddButton.icon = get_theme_icon("Add", "EditorIcons")
	$CategoryPanel/HBoxContainer/Icon.modulate = get_theme_color("font_color", "Label")

	for c in ProjectSettings.get_global_class_list():
		if c.base != "LicenseBase":
			continue
		_license_classes.append(c)


func _on_add_button_pressed():
	var info := license_info.instantiate()
	info.set_licenses(_license_classes)
	$Licenses.add_child(info)
