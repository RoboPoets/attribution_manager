@tool
extends Control


var _property:String = ""


func get_property() -> String:
	return _property


func set_property(prop:String) -> void:
	_property = prop
	$Label.text = prop.capitalize()


func get_value() -> String:
	return $LineEdit.text


func set_value(val:String) -> void:
	$LineEdit.text = val
