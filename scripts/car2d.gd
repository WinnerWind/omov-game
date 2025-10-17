@tool
extends Path2D
class_name CarPath

@export_custom(PROPERTY_HINT_NONE,"suffix:px/s") var speed:float
@export_group("Visuals")
@export var texture:Texture2D:
	set(new_texture):
		texture = new_texture
		if is_node_ready(): set_variables()
@export var collision_shape:RectangleShape2D:
	set(new_shape):
		collision_shape = new_shape
		if is_node_ready(): set_variables()
@export_group("Nodes")
@export var sprite:Sprite2D
@export var collision_object:CollisionShape2D
@export var path_follow:PathFollow2D

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		var distance = curve.get_baked_length()
		var time_taken = distance/speed
		path_follow.progress_ratio += delta / time_taken # Move object in time_taken seconds.
func set_variables():
	if sprite and texture:
		sprite.texture = texture
	if collision_object and collision_shape:
		collision_object.shape = collision_shape
