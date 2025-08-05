class_name PauseMenu
extends Menu

@export var options_menu: Menu
@export var level_select_menu: Menu

## Path to the main menu scene to load
@export var main_menu_scene: StringName

var current_submenu: Menu

## Last object to hold focus, to be restored after resuming
var last_focus_holder: Control

## Stop menu from showing e.g. on main menu.
var suppress_menu: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	disable_menu()

	options_menu.disable_menu()
	options_menu.menu_closed.connect(_on_options_menu_menu_closed)

	level_select_menu.disable_menu()
	level_select_menu.menu_closed.connect(_on_level_select_menu_menu_closed)
	level_select_menu.level_chosen.connect(_on_level_select_menu_level_chosen)

	if OS.has_feature("web"):
		%QuitButton.hide()

	get_parent().show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if suppress_menu:
		return

	if Input.is_action_just_pressed(back_action):
		if get_tree().paused and visible:
			if current_submenu == null:
				resume()

	if Input.is_action_just_pressed("pause"):
		if get_tree().paused and visible:
			resume()
		else:
			last_focus_holder = get_viewport().gui_get_focus_owner()
			pause()

	process_home_end_keys()


func _on_resume_button_pressed() -> void:
	resume()


func _on_quit_button_pressed() -> void:
	$OptionsMenu.save_preferences()
	get_tree().quit()


func enable_menu() -> void:
	await get_tree().create_timer(0.01).timeout
	show()
	get_tree().paused = true
	_focus_node($VBoxContainer.get_child(int(has_title)))


func disable_menu() -> void:
	await get_tree().create_timer(0.01).timeout
	hide()
	get_tree().paused = false


## Pause game and show pause menu
func pause() -> void:
	enable_menu()


func _on_load_button_pressed() -> void:
	pass  # TODO
	# var game_save: GameSave = GameSave.load()
	# print("game_save= ", game_save)
	# if game_save != null:
	# 	$"/root/Main/TransitionScreen".instant_black()
	# 	resume()
	# 	disable_menu()
	# 	LevelManager.load_level(game_save.map.map, game_save)
	# 	# enable_menu()
	# 	# resume()

	# # TODO: show warning if save is null


func _on_save_button_pressed() -> void:
	pass  # TODO
	# var game_save: GameSave = GameSave.new()
	# game_save.player = PlayerSave.for_player(LevelManager.get_player())
	# game_save.map = MapSave.for_scene(LevelManager.get_current_level())
	# game_save.save()
	# resume()


## Unpause game and hide pause menu
func resume() -> void:
	$OptionsMenu.save_preferences()
	close_submenu(options_menu)
	close_submenu(level_select_menu)
	disable_menu()
	if last_focus_holder:
		last_focus_holder.call_deferred("grab_focus")


func close_submenu(submenu: Menu = null) -> void:
	if submenu == null:
		submenu = current_submenu

	if submenu == null:
		return

	current_submenu = null
	submenu.disable_menu()
	$VBoxContainer.show()
	show()

	if submenu.parent_button != null:
		submenu.parent_button.grab_focus.call_deferred()


func open_options() -> void:
	$OptionsMenu.enable_menu()
	$VBoxContainer.hide()
	current_submenu = options_menu


func _on_options_pressed() -> void:
	open_options()


func _on_options_menu_menu_closed() -> void:
	close_submenu(options_menu)


func open_level_select() -> void:
	$LevelSelectMenu.enable_menu()
	$VBoxContainer.hide()
	current_submenu = level_select_menu


func _on_level_select_button_pressed() -> void:
	print("Level Select")
	open_level_select()


func _on_level_select_menu_menu_closed() -> void:
	close_submenu(level_select_menu)


func _on_level_select_menu_level_chosen(scene_path: String) -> void:
	close_submenu(level_select_menu)
	#LevelManager.load_level(scene_path)
	disable_menu()
	get_tree().change_scene_to_file.call_deferred(scene_path)


func _on_main_menu_button_pressed() -> void:
	#LevelManager.load_level(scene_path)
	disable_menu()
	get_tree().change_scene_to_file.call_deferred(main_menu_scene)
