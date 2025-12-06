extends MarginContainer
class_name MainMenu

@export var animation_time:float = 1
@export var tween_trans:Tween.TransitionType

signal start_waves()

func open():
	show()
	var tween:Tween = create_tween()
	position.y = -size.y
	tween.tween_property(self, "position:y",0,animation_time).set_trans(tween_trans)

func close():
	var tween:Tween = create_tween()
	tween.tween_property(self, "position:y", -size.y, animation_time).set_trans(tween_trans)
	await tween.finished
	hide()

func _close_deferred() -> void:
	call_deferred("close")

func play():
	start_waves.emit()
	_close_deferred()
