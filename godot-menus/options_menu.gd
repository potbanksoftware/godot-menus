extends Menu

signal preferences_finished

var debug_menu_style_strings: Array[String] = ["Off", "FPS", "Verbose"]
var last_debug_menu_style: int = 0

var debug_menu: Node
var user_prefs: UserPreferences

@onready var debug_menu_button: Button = $VBoxContainer/DebugMenuButton

@onready var master_slider: VolumeSlider = %MasterVolumeSlider
@onready var music_slider: VolumeSlider = %MusicVolumeSlider
@onready var sfx_slider: VolumeSlider = %SFXVolumeSlider
@onready var vsync_checkbox: CheckBoxButton = %VSyncCheckBox
@onready var fullscreen_checkbox: CheckBoxButton = %FullscreenCheckBox
@onready var touch_controls_checkbox: CheckBoxButton = %TouchControlsCheckBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_option_states()
	debug_menu = Utils.get_debug_menu()
	if debug_menu == null:
		debug_menu_button.queue_free()
	else:
		debug_menu.style = user_prefs.debug_menu_style
		debug_menu_button.text = "Debug Menu: %s" % [debug_menu_style_strings[debug_menu.style]]
		last_debug_menu_style = debug_menu.style
	sfx_slider.value_changed.connect(_on_sfx_volume_slider_value_changed)

	if get_parent() == get_tree().root:
		# Launched as main scene (F6)
		enable_menu()


func set_option_states() -> void:
	user_prefs = UserPreferences.load_or_create()
	if master_slider:
		master_slider.value = user_prefs.master_audio_level
	if sfx_slider:
		sfx_slider.value = user_prefs.sfx_audio_level
	if music_slider:
		music_slider.value = user_prefs.music_audio_level
	if vsync_checkbox:
		vsync_checkbox.button_pressed = user_prefs.vsync_enabled
		enable_vsync(user_prefs.vsync_enabled)
	#if fullscreen_checkbox:
	#	fullscreen_checkbox.button_pressed = user_prefs.fullscreen
	#	enable_fullscreen(user_prefs.fullscreen)
	if touch_controls_checkbox:
		touch_controls_checkbox.button_pressed = user_prefs.touch_controls_enabled
		Input.joy_connection_changed.emit(0, true)
	last_debug_menu_style = user_prefs.debug_menu_style


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not visible:
		return

	if debug_menu != null:
		if debug_menu.style != last_debug_menu_style:
			last_debug_menu_style = debug_menu.style
			$VBoxContainer/DebugMenuButton.text = (
				"Debug Menu: %s" % [debug_menu_style_strings[debug_menu.style]]
			)

	if Input.is_action_just_pressed("menu_close"):
		preferences_finished.emit()

	process_home_end_keys()


func _on_debug_menu_button_pressed() -> void:
	if debug_menu != null:
		debug_menu.style += 1

	# var cycle_debug_menu_event = InputEventAction.new()
	# cycle_debug_menu_event.action = "cycle_debug_menu"
	# cycle_debug_menu_event.pressed = true
	# Input.parse_input_event(cycle_debug_menu_event)


func save_preferences() -> void:
	if user_prefs:
		if master_slider:
			user_prefs.master_audio_level = master_slider.value
		if sfx_slider:
			user_prefs.sfx_audio_level = sfx_slider.value
		if music_slider:
			user_prefs.music_audio_level = music_slider.value
		if debug_menu:
			user_prefs.debug_menu_style = debug_menu.style
		if vsync_checkbox:
			user_prefs.vsync_enabled = vsync_checkbox.button_pressed
		#if fullscreen_checkbox:
		#	user_prefs.fullscreen = fullscreen_checkbox.button_pressed
		if touch_controls_checkbox:
			user_prefs.touch_controls_enabled = touch_controls_checkbox.button_pressed

		user_prefs.save()


func _on_sfx_volume_slider_focus_entered() -> void:
	$SFXAmbient.play()


func _on_sfx_volume_slider_focus_exited() -> void:
	$SFXAmbient.stop()


func _on_sfx_volume_slider_value_changed() -> void:
	$SFXAction.play()


func _on_back_button_pressed() -> void:
	save_preferences()
	preferences_finished.emit()


func enable_menu() -> void:
	set_option_states()
	show()
	set_process(true)
	$VBoxContainer/MasterVolumeSlider.focus()


func disable_menu() -> void:
	hide()
	set_process(false)


func _on_v_sync_check_box_toggled(toggled_on: bool) -> void:
	enable_vsync(toggled_on)


func enable_vsync(enable: bool = true) -> void:
	if enable:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_touch_controls_check_box_toggled(toggled_on: bool) -> void:
	user_prefs.touch_controls_enabled = toggled_on
	Input.joy_connection_changed.emit(0, true)


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	pass
	#enable_fullscreen(toggled_on)

#func enable_fullscreen(enable: bool = false) -> void:
#	 if enable:
#	 	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
#	 else:
#	 	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
#	 	# DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)   # Breaks window
