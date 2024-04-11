extends EditorInspectorPlugin


var credits_info:Control = null


func _can_handle(object:Object) -> bool:
	return object is Resource


func _parse_end(object:Object) -> void:
	if not credits_info:
		credits_info = preload("../ui/credits_info.tscn").instantiate()
	credits_info.refresh_info(object)
	add_custom_control(credits_info)
