extends Control

const FILE_MANAGEMENT_SCRIPT = preload("res://Scripts/FileManagement.gd")

var image
var lastFocusedButton = null

enum States{MAIN, LEVELS, OPTIONS, CREDITS}

var current_state = States.MAIN

var empty_button_normal_image = load("res://Assets/UI/Empty Buttons/Button-Empty.png")
var empty_button_hover_image = load("res://Assets/UI/Empty Buttons/Button-Empty-Disabled.png")
var score_normal_image = load("res://Assets/UI/Score/HighestScore.png")
var score_hover_image = load("res://Assets/UI/Score/HighestScore-Hover.png")
var normal_color = "f5ffe8"
var disabled_color = "8f928e"
var infinite_unblocked = false

@onready var options_difficulty = $OptionsUI/Panel/Difficulty
@onready var options_mode_buttons = $OptionsUI/Panel/ButtonContainer1

# Called when the node enters the scene tree for the first time.
func _ready():
	setLevels()

	if InputHandler.hasController():
		$VBoxContainer/PlayButton.grab_focus()
		lastFocusedButton = $VBoxContainer/PlayButton
	image = $BackgroundImage
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	$Panel.visible = false
	$BackButton.visible = false
	$Panel2.visible = false
	
	options_difficulty.visible = true
	options_mode_buttons.visible = true
	$OptionsUI.showDifficulty = true

	Events.connect("go_to_previous_screen", backFromOptions)
	Events.connect("go_from_credits_to_main_menu", backFromCredits)

func _process(delta):

	match current_state:
		States.MAIN:
			$CreditsButton.visible = true
			$OptionsUI.visible = false
			$OptionsUI.setActive(false)
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() == null:
				if lastFocusedButton.visible == true:
					lastFocusedButton.grab_focus()
				elif $VBoxContainer/PlayButton.visible == true:
					$VBoxContainer/PlayButton.grab_focus()
					lastFocusedButton = $VBoxContainer/PlayButton

		States.LEVELS:
			$OptionsUI.visible = false
			$OptionsUI.setActive(false)
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() == null:
				if $VBoxContainer2/HBoxContainer/Level1Button.visible == true:
					$VBoxContainer2/HBoxContainer/Level1Button.grab_focus()


		States.OPTIONS:
			$OptionsUI.visible = true
			$OptionsUI.setActive(true)
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() == null:
				if $OptionsUI/Panel/ButtonContainer/VideoButton.visible == true:
					$OptionsUI/Panel/ButtonContainer/VideoButton.grab_focus()
			if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
					if get_viewport().gui_get_focus_owner().has_signal("pressed"):
						get_viewport().gui_get_focus_owner().emit_signal("pressed")

		States.CREDITS:
			pass
		
	if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
		if get_viewport().gui_get_focus_owner().get("disabled") != null:
			if get_viewport().gui_get_focus_owner().disabled == false:
				get_viewport().gui_get_focus_owner().emit_signal("pressed")


func _on_play_button_pressed():
	Utils.playUISound(self, -6)
	lastFocusedButton = $VBoxContainer/PlayButton
	$VBoxContainer.visible = false
	$VBoxContainer2.visible = true
	$Panel2.visible = true
	$BackButton.visible = true
	$CreditsButton.visible = false
	#Events.emit_signal("go_to_level_select")

	update_score() 	#call update score to score ui on main menu and finish when having infinite mode

	current_state = States.LEVELS


func _on_options_button_pressed():
	Utils.playUISound(self, -6)
	lastFocusedButton = $VBoxContainer/OptionsButton
	#Events.emit_signal("go_to_options")
	$VBoxContainer.visible = false
	$CreditsButton.visible = false
	current_state = States.OPTIONS
	$OptionsUI.visible = true
	$OptionsUI.resetFocus()

func _on_credits_button_pressed():
	Utils.playUISound(self, -6)
	lastFocusedButton = $CreditsButton
	$BackgroundImage.visible = false
	$VBoxContainer.visible = false
	$CreditsButton.visible = false
	current_state = States.CREDITS
	$Credits.visible = true
	Events.emit_signal("go_from_main_menu_to_credits")
	#lastFocusedButton = get_viewport().gui_get_focus_owner()
	#Events.emit_signal("go_to_credits")

func backFromCredits():
	$VBoxContainer/PlayButton.grab_focus()
	$VBoxContainer2.visible = false
	$Panel2.visible = false
	$BackButton.visible = false
	$BackgroundImage.visible = true
	$VBoxContainer.visible = true
	$CreditsButton.visible = true
	current_state = States.MAIN
	$Credits.visible = false

func _on_exit_button_pressed():
	Utils.playUISound(self, -6)
	$Panel.visible = true
	if InputHandler.hasController():
		$Panel/HBoxContainer/NoButton.grab_focus()

func _on_yes_button_pressed():
	get_tree().quit()


func _on_no_button_pressed():
	Utils.playUISound(self, -6)
	$Panel.visible = false

func backFromOptions():
	setLevels()
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	current_state = States.MAIN


func _on_back_button_pressed():
	Utils.playUISound(self, -6)
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	$BackButton.visible = false
	$Panel2.visible = false
	current_state = States.MAIN

func _on_level_1_button_pressed():
	Utils.playUISound(self, -6)
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", 0)


func _on_level_2_button_pressed():
	Utils.playUISound(self, -6)
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", 1)


func _on_level_3_button_pressed():
	Utils.playUISound(self, -6)
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", 2)


func _on_level_4_button_pressed():
	Utils.playUISound(self, -6)
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", 3)


func _on_level_5_button_pressed():
	Utils.playUISound(self, -6)
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", 4)

func _on_level_6_button_pressed():
	Utils.playUISound(self, -6)
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", 5)

func _on_infinite_button_pressed():
	Utils.playUISound(self, -6)
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", 6)

func update_score():
	if infinite_unblocked:
		if FILE_MANAGEMENT_SCRIPT.loadHighestScore() == null:
			$Panel2/Label2.text = str(0)
		else:
			var labeled_score = $Panel2/Label2.text
			if labeled_score.to_int() < FILE_MANAGEMENT_SCRIPT.loadHighestScore() or labeled_score.to_int() == 0:
				$Panel2/Label2.text = str(FILE_MANAGEMENT_SCRIPT.loadHighestScore())
				$Panel2/Label2.position.x -= $Panel2/Label2.size.x/2
				$Panel2/Label2.position.y -= $Panel2/Label2.size.y/2

func setLevels():
	var savedLevels = FILE_MANAGEMENT_SCRIPT.loadLevels()
	if savedLevels == null:
		savedLevels = 0
	#print("saved levels: ", savedLevels)
	match savedLevels:
		0:
			$VBoxContainer2/HBoxContainer/Level1Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level1Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level1Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level1Button/Level1.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer/Level2Button.disabled = true
			$VBoxContainer2/HBoxContainer/Level2Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer/Level2Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer/Level2Button/Play3.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer2/Level3Button.disabled = true
			$VBoxContainer2/HBoxContainer2/Level3Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer2/Level3Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer2/Level3Button/Play4.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer2/Level4Button.disabled = true
			$VBoxContainer2/HBoxContainer2/Level4Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer2/Level4Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer2/Level4Button/Play5.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer3/Level5Button.disabled = true
			$VBoxContainer2/HBoxContainer3/Level5Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer3/Level5Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer3/Level5Button/Play6.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer3/Level6Button.disabled = true
			$VBoxContainer2/HBoxContainer3/Level6Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer3/Level6Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer3/Level6Button/Play7.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer4/InfiniteButton.disabled = true
			$VBoxContainer2/HBoxContainer4/InfiniteButton.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer4/InfiniteButton.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer4/InfiniteButton/Play8.label_settings.font_color = disabled_color
			$Panel2/TextureRect.texture = score_hover_image
			$Panel2/Label2.label_settings.font_color = disabled_color
			$Panel2/HighestScore.label_settings.font_color = disabled_color
			
		1:
			$VBoxContainer2/HBoxContainer/Level1Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level1Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level1Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level1Button/Level1.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer/Level2Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level2Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level2Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level2Button/Play3.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer2/Level3Button.disabled = true
			$VBoxContainer2/HBoxContainer2/Level3Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer2/Level3Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer2/Level3Button/Play4.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer2/Level4Button.disabled = true
			$VBoxContainer2/HBoxContainer2/Level4Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer2/Level4Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer2/Level4Button/Play5.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer3/Level5Button.disabled = true
			$VBoxContainer2/HBoxContainer3/Level5Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer3/Level5Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer3/Level5Button/Play6.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer3/Level6Button.disabled = true
			$VBoxContainer2/HBoxContainer3/Level6Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer3/Level6Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer3/Level6Button/Play7.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer4/InfiniteButton.disabled = true
			$VBoxContainer2/HBoxContainer4/InfiniteButton.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer4/InfiniteButton.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer4/InfiniteButton/Play8.label_settings.font_color = disabled_color
			$Panel2/TextureRect.texture = score_hover_image
			$Panel2/Label2.label_settings.font_color = disabled_color
			$Panel2/HighestScore.label_settings.font_color = disabled_color

		2:
			$VBoxContainer2/HBoxContainer/Level1Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level1Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level1Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level1Button/Level1.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer/Level2Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level2Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level2Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level2Button/Play3.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer2/Level3Button.disabled = false
			$VBoxContainer2/HBoxContainer2/Level3Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer2/Level3Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer2/Level3Button/Play4.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer2/Level4Button.disabled = true
			$VBoxContainer2/HBoxContainer2/Level4Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer2/Level4Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer2/Level4Button/Play5.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer3/Level5Button.disabled = true
			$VBoxContainer2/HBoxContainer3/Level5Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer3/Level5Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer3/Level5Button/Play6.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer3/Level6Button.disabled = true
			$VBoxContainer2/HBoxContainer3/Level6Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer3/Level6Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer3/Level6Button/Play7.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer4/InfiniteButton.disabled = true
			$VBoxContainer2/HBoxContainer4/InfiniteButton.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer4/InfiniteButton.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer4/InfiniteButton/Play8.label_settings.font_color = disabled_color
			$Panel2/TextureRect.texture = score_hover_image
			$Panel2/Label2.label_settings.font_color = disabled_color
			$Panel2/HighestScore.label_settings.font_color = disabled_color

		3:
			$VBoxContainer2/HBoxContainer/Level1Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level1Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level1Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level1Button/Level1.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer/Level2Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level2Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level2Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level2Button/Play3.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer2/Level3Button.disabled = false
			$VBoxContainer2/HBoxContainer2/Level3Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer2/Level3Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer2/Level3Button/Play4.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer2/Level4Button.disabled = false
			$VBoxContainer2/HBoxContainer2/Level4Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer2/Level4Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer2/Level4Button/Play5.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer3/Level5Button.disabled = true
			$VBoxContainer2/HBoxContainer3/Level5Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer3/Level5Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer3/Level5Button/Play6.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer3/Level6Button.disabled = true
			$VBoxContainer2/HBoxContainer3/Level6Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer3/Level6Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer3/Level6Button/Play7.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer4/InfiniteButton.disabled = true
			$VBoxContainer2/HBoxContainer4/InfiniteButton.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer4/InfiniteButton.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer4/InfiniteButton/Play8.label_settings.font_color = disabled_color
			$Panel2/TextureRect.texture = score_hover_image
			$Panel2/Label2.label_settings.font_color = disabled_color
			$Panel2/HighestScore.label_settings.font_color = disabled_color

		4:
			$VBoxContainer2/HBoxContainer/Level1Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level1Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level1Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level1Button/Level1.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer/Level2Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level2Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level2Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level2Button/Play3.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer2/Level3Button.disabled = false
			$VBoxContainer2/HBoxContainer2/Level3Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer2/Level3Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer2/Level3Button/Play4.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer2/Level4Button.disabled = false
			$VBoxContainer2/HBoxContainer2/Level4Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer2/Level4Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer2/Level4Button/Play5.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer3/Level5Button.disabled = false
			$VBoxContainer2/HBoxContainer3/Level5Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer3/Level5Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer3/Level5Button/Play6.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer3/Level6Button.disabled = true
			$VBoxContainer2/HBoxContainer3/Level6Button.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer3/Level6Button.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer3/Level6Button/Play7.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer4/InfiniteButton.disabled = true
			$VBoxContainer2/HBoxContainer4/InfiniteButton.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer4/InfiniteButton.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer4/InfiniteButton/Play8.label_settings.font_color = disabled_color
			$Panel2/TextureRect.texture = score_hover_image
			$Panel2/Label2.label_settings.font_color = disabled_color
			$Panel2/HighestScore.label_settings.font_color = disabled_color

		5:
			$VBoxContainer2/HBoxContainer/Level1Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level1Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level1Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level1Button/Level1.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer/Level2Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level2Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level2Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level2Button/Play3.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer2/Level3Button.disabled = false
			$VBoxContainer2/HBoxContainer2/Level3Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer2/Level3Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer2/Level3Button/Play4.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer2/Level4Button.disabled = false
			$VBoxContainer2/HBoxContainer2/Level4Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer2/Level4Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer2/Level4Button/Play5.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer3/Level5Button.disabled = false
			$VBoxContainer2/HBoxContainer3/Level5Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer3/Level5Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer3/Level5Button/Play6.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer3/Level6Button.disabled = false
			$VBoxContainer2/HBoxContainer3/Level6Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer3/Level6Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer3/Level6Button/Play7.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer4/InfiniteButton.disabled = true
			$VBoxContainer2/HBoxContainer4/InfiniteButton.mouse_filter = MOUSE_FILTER_IGNORE
			$VBoxContainer2/HBoxContainer4/InfiniteButton.texture_normal = empty_button_hover_image
			$VBoxContainer2/HBoxContainer4/InfiniteButton/Play8.label_settings.font_color = disabled_color
			$Panel2/TextureRect.texture = score_hover_image
			$Panel2/Label2.label_settings.font_color = disabled_color
			$Panel2/HighestScore.label_settings.font_color = disabled_color

		6:
			infinite_unblocked = true
			$VBoxContainer2/HBoxContainer/Level1Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level1Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level1Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level1Button/Level1.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer/Level2Button.disabled = false
			$VBoxContainer2/HBoxContainer/Level2Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer/Level2Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer/Level2Button/Play3.label_settings.font_color = disabled_color

			$VBoxContainer2/HBoxContainer2/Level3Button.disabled = false
			$VBoxContainer2/HBoxContainer2/Level3Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer2/Level3Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer2/Level3Button/Play4.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer2/Level4Button.disabled = false
			$VBoxContainer2/HBoxContainer2/Level4Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer2/Level4Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer2/Level4Button/Play5.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer3/Level5Button.disabled = false
			$VBoxContainer2/HBoxContainer3/Level5Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer3/Level5Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer3/Level5Button/Play6.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer3/Level6Button.disabled = false
			$VBoxContainer2/HBoxContainer3/Level6Button.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer3/Level6Button.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer3/Level6Button/Play7.label_settings.font_color = normal_color

			$VBoxContainer2/HBoxContainer4/InfiniteButton.disabled = false
			$VBoxContainer2/HBoxContainer4/InfiniteButton.mouse_filter = MOUSE_FILTER_STOP
			$VBoxContainer2/HBoxContainer4/InfiniteButton.texture_normal = empty_button_normal_image
			$VBoxContainer2/HBoxContainer4/InfiniteButton/Play8.label_settings.font_color = normal_color
			$Panel2/TextureRect.texture = score_normal_image
			$Panel2/Label2.label_settings.font_color = normal_color
			$Panel2/HighestScore.label_settings.font_color = normal_color

	if savedLevels >= 6:
		infinite_unblocked = true
		$VBoxContainer2/HBoxContainer/Level1Button.disabled = false
		$VBoxContainer2/HBoxContainer/Level1Button.mouse_filter = MOUSE_FILTER_STOP
		$VBoxContainer2/HBoxContainer/Level1Button.texture_normal = empty_button_normal_image
		$VBoxContainer2/HBoxContainer/Level1Button/Level1.label_settings.font_color = normal_color

		$VBoxContainer2/HBoxContainer/Level2Button.disabled = false
		$VBoxContainer2/HBoxContainer/Level2Button.mouse_filter = MOUSE_FILTER_STOP
		$VBoxContainer2/HBoxContainer/Level2Button.texture_normal = empty_button_normal_image
		$VBoxContainer2/HBoxContainer/Level2Button/Play3.label_settings.font_color = normal_color

		$VBoxContainer2/HBoxContainer2/Level3Button.disabled = false
		$VBoxContainer2/HBoxContainer2/Level3Button.mouse_filter = MOUSE_FILTER_STOP
		$VBoxContainer2/HBoxContainer2/Level3Button.texture_normal = empty_button_normal_image
		$VBoxContainer2/HBoxContainer2/Level3Button/Play4.label_settings.font_color = normal_color

		$VBoxContainer2/HBoxContainer2/Level4Button.disabled = false
		$VBoxContainer2/HBoxContainer2/Level4Button.mouse_filter = MOUSE_FILTER_STOP
		$VBoxContainer2/HBoxContainer2/Level4Button.texture_normal = empty_button_normal_image
		$VBoxContainer2/HBoxContainer2/Level4Button/Play5.label_settings.font_color = normal_color

		$VBoxContainer2/HBoxContainer3/Level5Button.disabled = false
		$VBoxContainer2/HBoxContainer3/Level5Button.mouse_filter = MOUSE_FILTER_STOP
		$VBoxContainer2/HBoxContainer3/Level5Button.texture_normal = empty_button_normal_image
		$VBoxContainer2/HBoxContainer3/Level5Button/Play6.label_settings.font_color = normal_color

		$VBoxContainer2/HBoxContainer3/Level6Button.disabled = false
		$VBoxContainer2/HBoxContainer3/Level6Button.mouse_filter = MOUSE_FILTER_STOP
		$VBoxContainer2/HBoxContainer3/Level6Button.texture_normal = empty_button_normal_image
		$VBoxContainer2/HBoxContainer3/Level6Button/Play7.label_settings.font_color = normal_color

		$VBoxContainer2/HBoxContainer4/InfiniteButton.disabled = false
		$VBoxContainer2/HBoxContainer4/InfiniteButton.mouse_filter = MOUSE_FILTER_STOP
		$VBoxContainer2/HBoxContainer4/InfiniteButton.texture_normal = empty_button_normal_image
		$VBoxContainer2/HBoxContainer4/InfiniteButton/Play8.label_settings.font_color = normal_color
		$Panel2/TextureRect.texture = score_normal_image
		$Panel2/Label2.label_settings.font_color = normal_color
		$Panel2/HighestScore.label_settings.font_color = normal_color

	if FILE_MANAGEMENT_SCRIPT.loadDifficulty() > 2:
		$Panel2/TextureRect.texture = score_hover_image
		$Panel2/Label2.label_settings.font_color = Color.GRAY
