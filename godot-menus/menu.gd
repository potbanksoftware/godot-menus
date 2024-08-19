class_name Menu
extends Control

## Whether there is a title for this menu at the top of the VBoxContainer (e.g. "Options")
@export var has_title: bool = false


func process_home_end_keys() -> void:
	if Input.is_action_just_pressed("ui_end"):
		_focus_node($VBoxContainer.get_child(-1))
	elif Input.is_action_just_pressed("ui_home"):
		_focus_node($VBoxContainer.get_child(int(has_title)))


func _focus_node(node: Control) -> void:
	if node is MenuControl:
		node.focus()
	else:
		node.grab_focus()
