extends EditorInspectorPlugin


const Settings = preload("../../settings.gd")

var inspector_theme:Theme = null


func _init():
	EditorInterface.get_editor_settings().settings_changed.connect(_on_editor_settings_changed)
	EditorInterface.get_file_system_dock().file_removed.connect(_on_file_removed)
	EditorInterface.get_file_system_dock().folder_removed.connect(_on_folder_removed)


func _can_handle(object:Object) -> bool:
	if not object is Resource:
		return false

	var res := object as Resource
	var ext := res.resource_path.get_extension()
	if ext in ["tres", "res"]:
		return false

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


# Remove all attributions from the credits resource that match the uid of
# the recently deleted file. Files of internal resources are ignored here.
func _on_file_removed(file:String) -> void:
	var uid_num := ResourceLoader.get_resource_uid(file)
	if uid_num == ResourceUID.INVALID_ID:
		return

	var credits_path := ProjectSettings.get_setting(Settings.key_credits, "")
	var credits:Credits = load(credits_path)
	if not credits:
		return

	var uid_str := ResourceUID.id_to_text(uid_num)
	var count := credits.attributions.size()
	for i in range(count - 1, -1, -1):
		if credits.attributions[i].resource_id == uid_str:
			credits.attributions.remove_at(i)

	ResourceSaver.save(credits)


# Remove all attributions from the credits resource that match the uids of
# all files in the recently deleted folder.
func _on_folder_removed(folder:String) -> void:
	# We don't get a list of individual files, so we have to
	# clean up the credits resource from start to finish.
	clean_attributions()


# Iterates over all existing attributions in the credits resource and removes
# the ones it can't find a related asset for.
func clean_attributions() -> void:
	var credits_path := ProjectSettings.get_setting(Settings.key_credits, "")
	var credits:Credits = load(credits_path)
	if not credits:
		return

	var count := credits.attributions.size()
	for i in range(count - 1, -1, -1):
		if not ResourceLoader.exists(credits.attributions[i].resource_id):
			credits.attributions.remove_at(i)

	ResourceSaver.save(credits)


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
