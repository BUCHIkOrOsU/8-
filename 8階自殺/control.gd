extends Control

signal finished

# 項目はすべて任意です
#   image : 未指定=そのまま / ""=消す / パス=切り替え
#   se    : 鳴らす効果音のパス
const PAGES = [
	{"name": "少女", "text": "ここでいいのかな？"},
	{
		"name": "少女",
		"text": "！",
		"image": "res://image/icon.svg",
		"se": "res://image/携帯電話のバイブレーション1.mp3",
	},
	{
		"name": "少女",
		"text": "・・・・・・・",
		"image": "res://image/5-2.png",
	},
	{
		"name":"少女",
		"text":"行かなきゃ",
	},
]

@export var chars_per_second := 30.0
@export var type_se_interval := 2  

var index := -1
var typing := false
var last_shown := 0
var tween: Tween
var picture_tween: Tween

@onready var picture: TextureRect = $smart
@onready var name_label: Label = $panel/VBoxContainer/name
@onready var text_label: RichTextLabel = $panel/VBoxContainer/text
@onready var next_icon: Label = $next
@onready var se_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var bgm_player: AudioStreamPlayer = get_node_or_null("BGMPlayer")


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	picture.modulate.a = 0.0
	next_icon.hide()
	if bgm_player and bgm_player.stream:
		bgm_player.play()
	_next_page()


func _input(event):
	var clicked = event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT

	if event.is_action_pressed("ui_accept") or clicked:
		get_viewport().set_input_as_handled()
		if typing:
			_finish_typing()
		else:
			_next_page()
	elif event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_end_opening()


func _next_page():
	index += 1
	if index >= PAGES.size():
		_end_opening()
		return

	var page: Dictionary = PAGES[index]
	next_icon.hide()
	name_label.text = page.get("name", "")
	name_label.visible = name_label.text != ""

	_update_picture(page)
	_play_se(page)
	_start_typing(page["text"])


# ---------- 画像 ----------
func _update_picture(page: Dictionary):
	if not page.has("image"):
		return  

	if picture_tween:
		picture_tween.kill()
	picture_tween = create_tween()

	var path: String = page["image"]
	if path == "":
		picture_tween.tween_property(picture, "modulate:a", 0.0, 0.3)
	else:
		picture_tween.tween_property(picture, "modulate:a", 0.0, 0.15)
		picture_tween.tween_callback(func(): picture.texture = load(path))
		picture_tween.tween_property(picture, "modulate:a", 1.0, 0.4)


# ---------- 効果音 ----------
func _play_se(page: Dictionary):
	var path: String = page.get("se", "")
	if path == "":
		return
	se_player.stream = load(path)
	se_player.play()


# ---------- 文字送り ----------
func _start_typing(text: String):
	text_label.text = text
	text_label.visible_ratio = 0.0
	typing = true
	last_shown = 0

	var total = text_label.get_total_character_count()
	var duration = max(total / chars_per_second, 0.01)

	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_method(_on_typing_progress, 0.0, 1.0, duration)
	tween.finished.connect(_on_typing_finished)


func _on_typing_progress(ratio: float):
	text_label.visible_ratio = ratio

	# 表示文字数は ratio から自分で計算する(visible_characters に頼らない)
	var shown = int(ratio * text_label.get_total_character_count())
	if shown != last_shown:
		last_shown = shown


func _finish_typing():
	if tween:
		tween.kill()
	text_label.visible_ratio = 1.0
	_on_typing_finished()


func _on_typing_finished():
	typing = false
	next_icon.show()


# ---------- 終了 ----------
func _end_opening():
	set_process_input(false)
	if tween:
		tween.kill()

	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.4)
	if bgm_player:
		t.parallel().tween_property(bgm_player, "volume_db", -40.0, 0.4)
	await t.finished

	finished.emit()
	get_parent().queue_free()
