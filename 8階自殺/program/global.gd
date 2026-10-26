extends Node

var fade_layer: CanvasLayer
var fade_rect: ColorRect
var current_tween: Tween


func _ready():
	fade_layer = CanvasLayer.new()
	fade_layer.layer = 100

	fade_rect = ColorRect.new()
	fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade_rect.color = Color.BLACK
	fade_rect.modulate.a = 0.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE  # ← 追加:クリックを邪魔しない
	fade_layer.add_child(fade_rect)

	get_tree().root.add_child.call_deferred(fade_layer)


func fade_in(time := 1.0) -> void:
	if current_tween:
		current_tween.kill()
	fade_rect.modulate.a = 1.0
	current_tween = create_tween()
	current_tween.tween_property(fade_rect, "modulate:a", 0.0, time)
	await current_tween.finished


func fade_out(time := 0.5) -> void:
	if current_tween:
		current_tween.kill()
	current_tween = create_tween()
	current_tween.tween_property(fade_rect, "modulate:a", 1.0, time)
	await current_tween.finished
