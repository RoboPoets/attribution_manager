extends EditorInspectorPlugin


var inspector_theme:Theme = null


func _init():
	EditorInterface.get_editor_settings().settings_changed.connect(_on_editor_settings_changed)


func _can_handle(object:Object) -> bool:
	if not object is Resource:
		return false

	var res := object as Resource
	var uid := ResourceLoader.get_resource_uid(res.resource_path)
	return uid != -1


func _parse_end(object:Object) -> void:
	if not inspector_theme:
		_setup_inspector_theme()

	# It seems that the inspector automatically frees the credits info node
	# when selecting a new object, so we don't bother checking its validity
	# or storing a reference and instead just create a new one everytime.
	var credits_info := preload("../ui/credits_info.tscn").instantiate()
	credits_info.theme = inspector_theme
	credits_info.refresh_info(object)
	add_custom_control(credits_info)


# Reset the inspector theme when editor settings are changed. If the theme
# was changed the changes are picked up on the next time an object is selected.
func _on_editor_settings_changed() -> void:
	inspector_theme = null


# Doing this work here, once, has the benefit of not blocking the UI for
# a noticeable time as it was in a previous implementation.
func _setup_inspector_theme() -> void:
	var t := EditorInterface.get_editor_theme()
	inspector_theme = Theme.new()
	inspector_theme.merge_with(t)

	var cat_style := t.get_stylebox("bg", "EditorInspectorCategory")
	cat_style.set_content_margin_all(0)
	inspector_theme.set_type_variation("CategoryHead", "PanelContainer")
	inspector_theme.set_stylebox("panel", "CategoryHead", cat_style)
