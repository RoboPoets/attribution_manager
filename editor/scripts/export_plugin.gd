extends EditorExportPlugin


const Settings = preload("../../settings.gd")


func _export_begin(features, is_debug, path, flags) -> void:
	var enforce_attribution:bool = ProjectSettings.get_setting(Settings.key_enforce, false)
	if not enforce_attribution:
		return

	var paths := get_resource_paths("res://")
	for p in paths:
		var uid_num := ResourceLoader.get_resource_uid(p)
		var uid_str := ResourceUID.id_to_text(uid_num)
		if AttributionManager.get_attributions(uid_str).size() == 0:
			printerr("Missing attribution for asset " + p)


func get_resource_paths(root: String) -> Array[String]:
	var paths: Array[String] = []

	var dir := DirAccess.open(root)
	dir.list_dir_begin()
	var file := dir.get_next()

	while file != "":
		var path := root.path_join(file)
		if should_ignore_path(path):
			file = dir.get_next()
			continue

		if dir.current_is_dir():
			paths.append_array(get_resource_paths(path))
		elif is_attributable_resource(path):
			paths.append(path)
		file = dir.get_next()

	dir.list_dir_end()
	return paths


# TODO: this should use a list of whitelist/blacklist
# directories set in the project settings.
func should_ignore_path(path:String) -> bool:
	if path.begins_with("res://.godot"):
		return true
	if path.begins_with("res://export"):
		return true
	if path.begins_with("res://addons"):
		return true
	return false


# TODO: There is some overlap with the inspector plugin's
# _can_handle method. Keep an eye on that.
func is_attributable_resource(path:String) -> bool:
	var ext := path.get_extension()
	if ext in ["tscn", "scn", "tres", "res"]:
		return false

	var uid := ResourceLoader.get_resource_uid(path)
	return uid != ResourceUID.INVALID_ID
