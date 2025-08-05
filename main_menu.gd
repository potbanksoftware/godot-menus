extends Menu

enum SubMenu { NONE, LEVEL_SELECT, OPTIONS }

var submenu: SubMenu = SubMenu.NONE


func _ready() -> void:
	get_parent().set_process(false)
	#set_version_info_text()
	%OptionsMenu.disable_menu()
	%LevelSelectMenu.disable_menu()

	enable_menu()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		match submenu:
			SubMenu.LEVEL_SELECT:
				close_level_select()
			SubMenu.OPTIONS:
				close_options()

	process_home_end_keys()


func set_version_info_text() -> void:
	var engine_version: Dictionary = Engine.get_version_info()

	var project_version: String
	if not OS.has_feature("editor"):
		project_version = ProjectSettings.get_setting("application/config/version")
	else:
		@warning_ignore("untyped_declaration")
		var git_version_provider = load("res://addons/AutoExportVersion/VersionProvider.gd").new()
		project_version = (
			"Commit %s (%s)"
			% [git_version_provider.get_git_commit_hash(), git_version_provider.get_git_branch_name()]
		)
	%VersionInfo.text = (
		"%s\nGodot %s %s" % [project_version, engine_version["string"], engine_version["hash"].left(7)]
	)


func _on_quit_button_pressed() -> void:
	%OptionsMenu.save_preferences()
	get_tree().quit()


func enable_menu() -> void:
	# InputMap.action_add_event("ui_accept", controller_a_event)
	await get_tree().create_timer(0.01).timeout
	show()
	%LevelSelectButton.grab_focus.call_deferred()


func disable_menu() -> void:
	# InputMap.action_erase_event("ui_accept", controller_a_event)
	await get_tree().create_timer(0.01).timeout
	hide()


func _on_load_button_pressed() -> void:
	pass  # TODO


#	var game_save: GameSave = GameSave.load()
#	print("game_save= ", game_save)
#	if game_save != null:
#		disable_menu()
#		$"/root/Main/PauseCanvas/PauseMenu".suppress_menu = false
#		$"/root/HUD".show()
#		LevelManager.load_level(game_save.map.map, game_save)
#
#	# TODO: show warning if save is null


func open_options() -> void:
	%OptionsMenu.enable_menu()
	%MainMenu.hide()
	submenu = SubMenu.OPTIONS


func close_options() -> void:
	%OptionsMenu.disable_menu()
	%MainMenu.show()
	%OptionsButton.grab_focus.call_deferred()
	submenu = SubMenu.NONE


func _on_options_button_pressed() -> void:
	print("Options")
	open_options()


func _on_options_menu_preferences_finished() -> void:
	close_options()


func open_level_select() -> void:
	%LevelSelectMenu.enable_menu()
	%MainMenu.hide()
	submenu = SubMenu.LEVEL_SELECT


func close_level_select() -> void:
	%LevelSelectMenu.disable_menu()
	%MainMenu.show()
	%LevelSelectButton.grab_focus.call_deferred()
	submenu = SubMenu.NONE


func _on_level_select_button_pressed() -> void:
	print("Level Select")
	open_level_select()


func _on_level_select_menu_level_select_abort() -> void:
	close_level_select()


func _on_level_select_menu_level_select_chosen(scene_path: String) -> void:
	close_level_select()
	#LevelManager.load_level(scene_path)
	disable_menu()
