extends EditorInspectorPlugin


func _can_handle(object:Object) -> bool:
	return object is Resource


func _parse_end(object:Object) -> void:
	# In past versions, we stored a reference to this in order to reuse the
	# node, but it seems that the inspector automatically frees it
	# when selecting a new object, so the reference would never persist
	# anyway.
	var credits_info:Control = preload("../ui/credits_info.tscn").instantiate()
	credits_info.refresh_info(object)
	add_custom_control(credits_info)
