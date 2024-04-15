@tool
class_name LicenseCustom extends LicenseBase


@export var license_name:String = ""
@export var license_url:String = ""


func get_license_name() -> String:
	return license_name


func get_license_url() -> String:
	return license_url
