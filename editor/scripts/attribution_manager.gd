@tool
extends Node


const Settings = preload("../../settings.gd")


func _enter_tree():
	if OS.has_feature("editor"):
		EditorInterface.get_file_system_dock().file_removed.connect(_on_file_removed)
		EditorInterface.get_file_system_dock().folder_removed.connect(_on_folder_removed)


# Handle the removal of all attributions from the credits resource that match
# the uid of the recently deleted file. Files of internal resources are ignored
# here.
func _on_file_removed(file:String) -> void:
	var uid_num := ResourceLoader.get_resource_uid(file)
	if uid_num == ResourceUID.INVALID_ID:
		return

	var uid_str := ResourceUID.id_to_text(uid_num)
	remove_attribution(uid_str)


# Handle the removal of all attributions from the credits resource that match
# the uids of all files in the recently deleted folder.
func _on_folder_removed(folder:String) -> void:
	# We don't get a list of individual files, so we have to
	# clean up the credits resource from start to finish.
	clean_attributions()


# Remove all attributions from the credits resource that match the
# provided resource uid.
func remove_attribution(uid:String) -> void:
	var credits_path := ProjectSettings.get_setting(Settings.key_credits, "")
	var credits:Credits = load(credits_path)
	if not credits:
		return

	var count := credits.attributions.size()
	for i in range(count - 1, -1, -1):
		if credits.attributions[i].resource_id == uid:
			credits.attributions.remove_at(i)

	ResourceSaver.save(credits)


# Iterate over all existing attributions in the credits resource and removes
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


func get_known_licenses():
	var classes:Array[Dictionary] = []
	for c in ProjectSettings.get_global_class_list():
		if c.base == "LicenseBase":
			classes.append(c)
	return classes


func get_attributions(uid:String) -> Array[LicenseBase]:
	var credits_path := ProjectSettings.get_setting(Settings.key_credits, "")
	var credits:Credits = load(credits_path)
	if not credits:
		return []

	var licenses:Array[LicenseBase] = []
	for license in credits.attributions:
		if license.resource_id == uid:
			licenses.append(license)

	return licenses
