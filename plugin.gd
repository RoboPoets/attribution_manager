@tool
extends EditorPlugin


const Settings = preload("./settings.gd")
const manager_path = "res://addons/attribution_manager/editor/scripts/attribution_manager.gd"

var credits_inspector:EditorInspectorPlugin = null
var exporter:EditorExportPlugin = null


func _enable_plugin():
	add_autoload_singleton("AttributionManager", manager_path)


func _disable_plugin():
	remove_autoload_singleton("AttributionManager")


func _enter_tree() -> void:
	credits_inspector = preload("editor/scripts/credits_inspector.gd").new()
	add_inspector_plugin(credits_inspector)
	exporter = preload("editor/scripts/export_plugin.gd").new()
	add_export_plugin(exporter)
	Settings.add_project_settings()

	EditorInterface.get_file_system_dock().file_removed.connect(_on_file_removed)
	EditorInterface.get_file_system_dock().folder_removed.connect(_on_folder_removed)


func _exit_tree() -> void:
	Settings.remove_project_settings()
	remove_export_plugin(exporter)
	exporter = null
	remove_inspector_plugin(credits_inspector)
	credits_inspector = null


# Handle the removal of all attributions from the credits resource that match
# the uid of the recently deleted file. Files of internal resources are ignored
# here.
func _on_file_removed(file:String) -> void:
	var uid_num := ResourceLoader.get_resource_uid(file)
	if uid_num == ResourceUID.INVALID_ID:
		return

	var uid_str := ResourceUID.id_to_text(uid_num)
	AttributionManager.remove_attributions([uid_str])


# Handle the removal of all attributions from the credits resource that match
# the uids of all files in the recently deleted folder.
func _on_folder_removed(folder:String) -> void:
	# We don't get a list of individual files, so we have to
	# clean up the credits resource from start to finish.
	AttributionManager.clean_attributions()
