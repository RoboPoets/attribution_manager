@tool
class_name LicenseBase extends Resource

@export var asset_name:String = ""
@export var asset_url:String = ""
@export var author:String = ""

@export var resource_id:String = ""


## Override this to set the name of the license as it's commonly used by people.
func get_license_name() -> String:
	return ""


## Override this to provide an internet URL to the full license text.
func get_license_url() -> String:
	return ""
