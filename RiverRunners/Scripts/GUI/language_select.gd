extends Node

@export var language_button_template: TextureButton
var languages = {"English" : "en", "Português" : "pt", "Español" : "es", "Українська" : "ua", "Français" : "fr"}

var empty_button_normal_image = load("res://Assets/UI/Empty Buttons/Button-Empty.png")
var empty_button_hover_image = load("res://Assets/UI/Empty Buttons/Button-Empty-Disabled.png")
var normal_color = "f5ffe8"
var disabled_color = "8f928e"

# Called when the node enters the scene tree for the first time.
func _ready():
	if language_button_template:
		instantiate_buttons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func instantiate_buttons():
	var locale = TranslationServer.get_locale()
	if language_button_template.get_child(0) is Label:
		language_button_template.get_child(0).text = languages.keys()[0]
		language_button_template.get_child(0).label_settings = language_button_template.get_child(0).label_settings.duplicate()
		language_button_template.connect("pressed",on_button_click.bind(languages.keys()[0],language_button_template))
		if locale == languages[languages.keys()[0]]:
			language_button_template.texture_normal = empty_button_normal_image
			language_button_template.get_child(0).label_settings.font_color = normal_color
		else:
			language_button_template.texture_normal = empty_button_hover_image
			language_button_template.get_child(0).label_settings.font_color = disabled_color

	for i in range (1,languages.keys().size()):
		var new_button = language_button_template.duplicate()
		if new_button.get_child(0) is Label:
			new_button.get_child(0).text = languages.keys()[i]
			new_button.get_child(0).label_settings = new_button.get_child(0).label_settings.duplicate()
			new_button.connect("pressed",on_button_click.bind(languages.keys()[i],new_button))
			if locale == languages[languages.keys()[i]]:
				new_button.texture_normal = empty_button_normal_image
				new_button.get_child(0).label_settings.font_color = normal_color
			else:
				new_button.texture_normal = empty_button_hover_image
				new_button.get_child(0).label_settings.font_color = disabled_color
		$GridContainer.add_child(new_button)


func on_button_click(text, button:TextureButton):
	if languages[text]:
		TranslationServer.set_locale(languages[text])
	for b in $GridContainer.get_children():
		if b is TextureButton:
			b.texture_normal = empty_button_hover_image
			b.get_child(0).label_settings.font_color = disabled_color
	button.texture_normal = empty_button_normal_image
	button.get_child(0).label_settings.font_color = normal_color

