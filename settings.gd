extends Object


## The project settings key for the default resource that stores the game's
## credits information. Must inherit from [Credits].
const key_credits:String = "plugins/attribution/credits_resource"

## The project settings key for the option that enforces attribution. If enabled,
## we expect every attributable asset to have at least one attribution.
##
## Note: Currently, this doesn't do anything directly. It exists to be read by
## editor tools or automated routines that run as part of CI/CD pipelines.
const key_enforce:String = "plugins/attribution/enforce_attribution"


static func add_project_settings():
	add_project_setting(key_credits, TYPE_STRING, "", PROPERTY_HINT_FILE, "*.tres,*.res")
	add_project_setting(key_enforce, TYPE_BOOL, false)


static func remove_project_settings():
	remove_project_setting(key_credits)
	remove_project_setting(key_enforce)


static func add_project_setting(setting: String, type:int, default, hint:int = PROPERTY_HINT_NONE, hint_string:String = ""):
	if not ProjectSettings.has_setting(setting):
		ProjectSettings.set_setting(setting, default)
		ProjectSettings.set_initial_value(setting, default)

	var info:Dictionary = {
		"name": setting,
		"type": type,
		"hint": hint,
		"hint_string": hint_string,
	}

	ProjectSettings.add_property_info(info)


static func remove_project_setting(setting: String):
	ProjectSettings.set_setting(setting, null)
