@tool
extends EditorPlugin


const Settings = preload("./settings.gd")
const manager_path = "res://addons/attribution_manager/editor/scripts/attribution_manager.gd"

var credits_inspector:EditorInspectorPlugin = null


func _enable_plugin():
	add_autoload_singleton("AttributionManager", manager_path)


func _disable_plugin():
	remove_autoload_singleton("AttributionManager")


func _enter_tree() -> void:
	credits_inspector = preload("editor/scripts/credits_inspector.gd").new()
	add_inspector_plugin(credits_inspector)
	Settings.add_project_settings()


func _exit_tree() -> void:
	Settings.remove_project_settings()
	remove_inspector_plugin(credits_inspector)
	credits_inspector = null
