extends Menu

@export var options_menu: Menu
@export var level_select_menu: Menu


func _ready() -> void:
	get_parent().set_process(false)
	#set_version_info_text()

	enable_menu()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		close_submenu()

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
