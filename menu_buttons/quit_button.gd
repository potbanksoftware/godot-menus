class_name MenuQuitButton
extends Button


func _ready() -> void:
	if OS.has_feature("web"):
		hide()


func _on_pressed() -> void:
	get_tree().quit()
