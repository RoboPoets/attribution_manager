@tool
class_name LicenseCCBYSA extends LicenseBase


@export var asset_name:String = ""
@export var asset_url:String = ""


func get_asset_name() -> String:
	return asset_name


func get_asset_url() -> String:
	return asset_url


func get_license_name() -> String:
	return "CC BY-SA"


func get_license_url() -> String:
	return "https://creativecommons.org/licenses/by-sa/4.0/"
