class_name SubmenuButton
extends Button

## The menu this button is part of.
@export var menu: Menu

## The menu this button opens.
@export var submenu: Menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if submenu != null:
		submenu.disable_menu()
		submenu.menu_closed.connect(_on_menu_closed)


func _on_menu_closed() -> void:
	menu.close_submenu(submenu)


func _on_pressed() -> void:
	menu.open_submenu(submenu)
