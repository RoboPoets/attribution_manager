@tool
class_name LicenseCustom extends LicenseBase


@export var asset_name:String = ""
@export var asset_url:String = ""
@export var license_name:String = ""
@export var license_url:String = ""


func get_asset_name() -> String:
	return asset_name


func get_asset_url() -> String:
	return asset_url


func get_license_name() -> String:
	return license_name


func get_license_url() -> String:
	return license_url
