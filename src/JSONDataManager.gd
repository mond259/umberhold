extends Node
class_name JSONDataManager

# Loads and caches JSON resources from `res://` paths.
# Designed as an Autoload singleton so any system can request data without
# creating hard dependencies between scenes.

var _cache: Dictionary = {}
var _cache_enabled: bool = true

func clear_cache() -> void:
	_cache.clear()

func load_json(res_path: String, use_cache: bool = true) -> Variant:
	if use_cache and _cache_enabled and _cache.has(res_path):
		return _cache[res_path]

	var file := FileAccess.open(res_path, FileAccess.READ)
	if file == null:
		push_error("JSONDataManager: Failed to open JSON file: %s" % res_path)
		return null

	var text := file.get_as_text()
	var json := JSON.new()
	var err := json.parse(text)
	if err != OK:
		push_error(
			"JSONDataManager: Failed to parse JSON file: %s (error %s)" % [res_path, err]
		)
		return null

	var data = json.data

	if use_cache and _cache_enabled:
		_cache[res_path] = data

	return data

func load_json_dictionary(res_path: String, use_cache: bool = true) -> Dictionary:
	var data = load_json(res_path, use_cache)
	if data is Dictionary:
		return data as Dictionary
	push_error("JSONDataManager: JSON at %s is not a Dictionary." % res_path)
	return {}
