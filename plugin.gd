@tool
extends EditorPlugin


var credits_inspector:EditorInspectorPlugin = null


func _enter_tree() -> void:
	credits_inspector = preload("editor/scripts/credits_inspector.gd").new()
	add_inspector_plugin(credits_inspector)


func _exit_tree() -> void:
	remove_inspector_plugin(credits_inspector)
	credits_inspector = null
