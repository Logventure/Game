extends Control

@onready var progress_bar = $Panel/TextureRect
var progress_bar_image = Image.load_from_file("res://Assets/UI/Progress Bar/ProgressBarContainer.png")
var progress_bar_texture = ImageTexture.create_from_image(progress_bar_image)

var progress_bar_image_1 = Image.load_from_file("res://Assets/UI/Progress Bar/ProgressBarContainer-1.png")
var progress_bar_texture_1 = ImageTexture.create_from_image(progress_bar_image_1)

var progress_bar_image_2 = Image.load_from_file("res://Assets/UI/Progress Bar/ProgressBarContainer-2.png")
var progress_bar_texture_2 = ImageTexture.create_from_image(progress_bar_image_2)

var progress_bar_image_3 = Image.load_from_file("res://Assets/UI/Progress Bar/ProgressBarContainer-3.png")
var progress_bar_texture_3 = ImageTexture.create_from_image(progress_bar_image_3)

var progress_bar_image_4 = Image.load_from_file("res://Assets/UI/Progress Bar/ProgressBarContainer-4.png")
var progress_bar_texture_4 = ImageTexture.create_from_image(progress_bar_image_4)

var progress_bar_image_5 = Image.load_from_file("res://Assets/UI/Progress Bar/ProgressBarContainer-5.png")
var progress_bar_texture_5 = ImageTexture.create_from_image(progress_bar_image_5)

var progress_bar_image_6 = Image.load_from_file("res://Assets/UI/Progress Bar/ProgressBarContainer-6.png")
var progress_bar_texture_6 = ImageTexture.create_from_image(progress_bar_image_6)

var progress_bar_image_7 = Image.load_from_file("res://Assets/UI/Progress Bar/ProgressBarContainer-7.png")
var progress_bar_texture_7 = ImageTexture.create_from_image(progress_bar_image_7)

var progress_bar_image_8 = Image.load_from_file("res://Assets/UI/Progress Bar/ProgressBarContainer-8.png")
var progress_bar_texture_8 = ImageTexture.create_from_image(progress_bar_image_8)

var progress_bar_image_9 = Image.load_from_file("res://Assets/UI/Progress Bar/ProgressBarContainer-9.png")
var progress_bar_texture_9 = ImageTexture.create_from_image(progress_bar_image_9)

var progress_bar_image_10 = Image.load_from_file("res://Assets/UI/Progress Bar/ProgressBarContainer-10.png")
var progress_bar_texture_10 = ImageTexture.create_from_image(progress_bar_image_10)

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar.texture = progress_bar_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateProgressBar(progress):
	if progress > 1 and progress < 10:
		progress_bar.texture = progress_bar_texture_1
	elif progress > 10 and progress < 20:
		progress_bar.texture = progress_bar_texture_2
	elif progress > 20 and progress < 30:
		progress_bar.texture = progress_bar_texture_3
	elif progress > 30 and progress < 40:
		progress_bar.texture = progress_bar_texture_4
	elif progress > 40 and progress < 50:
		progress_bar.texture = progress_bar_texture_5
	elif progress > 50 and progress < 60:
		progress_bar.texture = progress_bar_texture_6
	elif progress > 60 and progress < 70:
		progress_bar.texture = progress_bar_texture_7
	elif progress > 70 and progress < 80:
		progress_bar.texture = progress_bar_texture_8
	elif progress > 80 and progress < 90:
		progress_bar.texture = progress_bar_texture_9
	elif progress >= 99:
		progress_bar.texture = progress_bar_texture_10
