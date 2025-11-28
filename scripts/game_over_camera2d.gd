extends LimitingCamera2D
class_name GameOverCamera2D

@export var zoom_time:float = 0.2
@export var zoom_scale:float = 0.5
var game_over_triggered:bool = false
func game_over_zoom_in(pos:Vector2):
	var tween:Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "zoom", zoom+Vector2.ONE*zoom_scale,zoom_time)
	tween.tween_property(self, "position", pos,zoom_time)
	game_over_triggered = true

func _on_size_changed():
	super()
	if game_over_triggered: zoom += Vector2.ONE*zoom_scale
