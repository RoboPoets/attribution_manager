extends Object


## The project settings key for the default resource that stores the game's
## credits information. Must inherit from [Credits].
const key_credits:String = "plugins/attribution/credits_resource"


static func add_project_settings():
	add_project_setting(key_credits, TYPE_STRING, "", PROPERTY_HINT_FILE, "*.tres,*.res")


static func remove_project_settings():
	remove_project_setting(key_credits)


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
