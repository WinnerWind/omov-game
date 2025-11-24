extends Camera2D
class_name LimitingCamera2D

@export var rect:Vector2 = Vector2(1920,1080)
var view_size:Vector2:
	get:
		return Vector2(get_tree().root.size) / zoom
func _ready() -> void:
	get_tree().root.size_changed.connect(_on_size_changed)
	_on_size_changed()

func _on_size_changed():
	var new_size := get_tree().root.size
	var new_size_is_width_longer:bool = ( (int(new_size.x)/float(new_size.y)) > 1)
	if new_size_is_width_longer:
		zoom = Vector2(
			new_size.x/rect.x,
			new_size.x/rect.x
			)
	else:
		zoom = Vector2(
			new_size.y/rect.y,
			new_size.y/rect.y
		)
