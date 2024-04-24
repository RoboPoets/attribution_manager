@tool
class_name LicenseCCBY extends LicenseBase


@export var asset_name:String = ""
@export var asset_url:String = ""


func get_asset_name() -> String:
	return asset_name


func get_asset_url() -> String:
	return asset_url


func get_license_name() -> String:
	return "CC BY"


func get_license_url() -> String:
	return "https://creativecommons.org/licenses/by/4.0/"
