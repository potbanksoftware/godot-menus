class_name UserPreferences
extends Resource

@export_range(0, 1, 0.05) var master_audio_level: float = 1.0
@export_range(0, 1, 0.05) var sfx_audio_level: float = 1.0
@export_range(0, 1, 0.05) var music_audio_level: float = 1.0
@export var debug_menu_style: int = 0
@export var vsync_enabled: bool = true
@export var fullscreen: bool = false
@export var touch_controls_enabled: bool = false


func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")


static func _create_default_prefs() -> UserPreferences:
	var res := UserPreferences.new()

	var master_bus_index: int = AudioServer.get_bus_index("Master")
	res.master_audio_level = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))

	var sfx_bus_index: int = AudioServer.get_bus_index("SFX")
	res.sfx_audio_level = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))

	var music_bus_index: int = AudioServer.get_bus_index("Music")
	res.music_audio_level = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))

	match DisplayServer.window_get_vsync_mode():
		DisplayServer.VSYNC_ENABLED:
			res.vsync_enabled = true
		DisplayServer.VSYNC_DISABLED:
			res.vsync_enabled = false
		_:
			print_debug(DisplayServer.window_get_vsync_mode())

	# match DisplayServer.window_get_mode():
	# 	DisplayServer.WINDOW_MODE_FULLSCREEN:
	# 		res.fullscreen = true
	# 	DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
	# 		res.fullscreen = true
	# 	DisplayServer.WINDOW_MODE_WINDOWED:
	# 		res.fullscreen = false
	# 	DisplayServer.WINDOW_MODE_MAXIMIZED:
	# 		res.fullscreen = false
	# 	_:
	# 		print_debug(DisplayServer.window_get_vsync_mode())

	var debug_menu: Node = Utils.get_debug_menu()
	if debug_menu != null:
		res.debug_menu_style = debug_menu.style

	return res


static func load_or_create() -> UserPreferences:
	# TODO: Use ResourceLoader?
	var res: UserPreferences
	if ResourceLoader.exists("user://user_prefs.tres"):
		res = load("user://user_prefs.tres") as UserPreferences
	else:
		res = _create_default_prefs()
	if not res:
		res = _create_default_prefs()

	return res
