extends Label

@export var is_independent : bool = false

@export_group("Font Settings")
@export var original_font_size : int = 60
@export var min_font_size : int = 36
@export var resize_factor : int = 6

@export_group("Character Settings")
@export var max_characters : int = 8



# Called when the node enters the scene tree for the first time.
func _ready():
	if is_independent:
		label_settings = label_settings.duplicate()
	resize_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	resize_text()


func resize_text():
	if tr(text).length() > max_characters:
		var new_font_size = original_font_size - (tr(text).length() - max_characters) * resize_factor
		if new_font_size < min_font_size:
			new_font_size = min_font_size
		if label_settings.font_size > new_font_size:
			label_settings.font_size = new_font_size