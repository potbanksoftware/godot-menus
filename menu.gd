class_name Menu
extends Control

signal menu_closed

## Whether there is a title for this menu at the top of the VBoxContainer (e.g. "Options")
@export var has_title: bool = false

## The button to open this menu in the parent
@export var parent_button: Button

## The name of the input action to close the menu (and menus in general)
@export var back_action: StringName = "menu_close"

func process_home_end_keys() -> void:
	if Input.is_action_just_pressed("ui_end"):
		_focus_node($VBoxContainer.get_child(-1))
	elif Input.is_action_just_pressed("ui_home"):
		_focus_node($VBoxContainer.get_child(int(has_title)))


func _focus_node(node: Control) -> void:
	if node is PanelControl:
		node.focus()
	else:
		node.grab_focus()


func enable_menu() -> void:
	await get_tree().create_timer(0.01).timeout
	show()
	set_process(true)
	_focus_node($VBoxContainer.get_child(int(has_title)))

func disable_menu() -> void:
	await get_tree().create_timer(0.01).timeout
	hide()
	set_process(false)
