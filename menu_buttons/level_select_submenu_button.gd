class_name LevelSelectSubmenuButton
extends SubmenuButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	submenu.level_chosen.connect(_on_level_select_menu_level_chosen)


## Override this method in extneds scripts to customise behaviour.
func load_level(scene_path: String):
	#LevelManager.load_level(scene_path)
	get_tree().change_scene_to_file.call_deferred(scene_path)


func _on_level_select_menu_level_chosen(scene_path: String) -> void:
	menu.close_submenu(submenu)
	await menu.disable_menu()
	load_level(scene_path)
