@tool
extends Control


var property:String = ""


func set_property(prop:Dictionary) -> void:
	property = prop.name
	$Label.text = prop.name.capitalize()


func get_value() -> String:
	return $LineEdit.text
