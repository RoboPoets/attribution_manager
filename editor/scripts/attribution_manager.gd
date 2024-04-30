@tool
extends Node


const Settings = preload("../../settings.gd")


func _enter_tree():
	if Engine.is_editor_hint():
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
	remove_attributions([uid_str])


# Handle the removal of all attributions from the credits resource that match
# the uids of all files in the recently deleted folder.
func _on_folder_removed(folder:String) -> void:
	# We don't get a list of individual files, so we have to
	# clean up the credits resource from start to finish.
	clean_attributions()


# Remove all attributions from the credits resource that match the
# provided resource uids. Attributions to project members are removed,
# but their mention in the Credits section remains.
func remove_attributions(uids:Array[String]) -> void:
	var credits_path := ProjectSettings.get_setting(Settings.key_credits, "")
	var credits:Credits = load(credits_path)
	if not credits:
		return

	var count := credits.attributions.size()
	for i in range(count - 1, -1, -1):
		if credits.attributions[i].resource_id in uids:
			credits.attributions.remove_at(i)

	count = credits.members.size()
	for i in range(count - 1, -1, -1):
		if credits.members[i].resource_id in uids:
			credits.members.remove_at(i)

	ResourceSaver.save(credits)


# Iterate over all existing attributions in the credits resource and removes
# the ones it can't find a related asset for. Project member attributions
# are removed also, but their mention in the Credits section remains.
func clean_attributions() -> void:
	var credits_path := ProjectSettings.get_setting(Settings.key_credits, "")
	var credits:Credits = load(credits_path)
	if not credits:
		return

	var count := credits.attributions.size()
	for i in range(count - 1, -1, -1):
		if not ResourceLoader.exists(credits.attributions[i].resource_id):
			credits.attributions.remove_at(i)

	count = credits.members.size()
	for i in range(count - 1, -1, -1):
		if not ResourceLoader.exists(credits.members[i].resource_id):
			credits.members.remove_at(i)

	ResourceSaver.save(credits)


# Adds all licenses to the list of attributions in the credits resource
# without checking for duplicates or removing any other attribution.
func add_attributions(licenses:Array[LicenseBase]) -> void:
	var credits_path := ProjectSettings.get_setting(Settings.key_credits, "")
	var credits:Credits = load(credits_path)
	if not credits:
		return

	var external:Array[LicenseBase] = licenses.filter(func(l): return not l is LicenseProject)
	var internal:Array[LicenseBase] = licenses.filter(func(l): return l is LicenseProject)

	credits.attributions.append_array(external)
	credits.members.append_array(internal)

	for l:LicenseProject in internal:
		for c in credits.credits:
			if c.role != l.role:
				continue
			if not l.author in c.contributors:
				# The contributors array is read-only (not sure if
				# bug or intended), so we have to do a copy here.
				c.contributors = c.contributors + [l.author]
			break

	ResourceSaver.save(credits)


# Removes any attribution in the credits resource that matches any uid found
# in this list of licenses and replaces them with these new ones.
func replace_attributions(licenses:Array[LicenseBase]) -> void:
	var uids:Array[String] = []
	for l in licenses:
		if not l.resource_id in uids:
			uids.append(l.resource_id)

	remove_attributions(uids)
	add_attributions(licenses)


func get_attributions(uid:String) -> Array[LicenseBase]:
	var credits_path := ProjectSettings.get_setting(Settings.key_credits, "")
	var credits:Credits = load(credits_path)
	if not credits:
		return []

	var licenses:Array[LicenseBase] = []
	for license in credits.attributions:
		if license.resource_id == uid:
			licenses.append(license)
	for license in credits.members:
		if license.resource_id == uid:
			licenses.append(license)

	return licenses


func get_known_licenses() -> Array[Dictionary]:
	var classes:Array[Dictionary] = []
	for c in ProjectSettings.get_global_class_list():
		if c.base == "LicenseBase":
			classes.append(c)
	return classes


func get_known_roles() -> Array[String]:
	var credits_path := ProjectSettings.get_setting(Settings.key_credits, "")
	var credits:Credits = load(credits_path)
	if not credits:
		return []

	var roles:Array[String]
	for c in credits.credits:
		roles.append(c.role)

	return roles
