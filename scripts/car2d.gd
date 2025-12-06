@tool
extends Path2D
class_name CarPath

var speed:float:
	set(new_speed):
		speed = new_speed if new_speed >= 0 else initial_speed
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var initial_speed:float
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var slowdown_speed:float = 100
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var raycast_distance:float = 25:
	set(new):
		raycast_distance = new
		if is_node_ready(): set_variables()
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var horizontal_raycast_distance:float = 25:
	set(new):
		horizontal_raycast_distance = new
		if is_node_ready(): set_variables()
@export_group("Visuals")
@export var texture:Texture2D:
	set(new):
		texture = new
		if is_node_ready(): set_variables()
@export var texture_scale:float:
	set(new):
		texture_scale = new
		if is_node_ready(): set_variables()
var collision_shape:Shape2D
@export_tool_button("Reload All Visuals") var reload_visuals_script:Callable = set_variables
@export_group("Car Modifiers")
@export_range(0,1,0.1) var crash_car_in_pothole_chance:float = 0.0
@export var max_patience:float = 20;
@export var ignore_stop_signs:bool = false
@export_group("Nodes")
@export var sprite:Sprite2D
@export var detector_collision_object:CollisionShape2D
@export var path_follow:PathFollow2D
@export var collision_avoider_object:CollisionShape2D

var is_colliding:bool = false
var is_in_stop_sign:bool = false
var patience:float

const collision_disabled_threshold:float = 0.55
const path_completed_threshold:float = 0.85

signal crashed()
signal crash_pos(pos:Vector2)
signal deadlock()
signal path_complete()

func _ready() -> void:
	speed = initial_speed
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if not is_colliding:
			if not is_in_stop_sign: speed = lerp(speed, initial_speed, delta)
			var distance = curve.get_baked_length()
			patience = 0
			var time_taken = distance/speed
			path_follow.progress_ratio += delta / time_taken # Move object in time_taken seconds.
			if path_follow.progress_ratio >= collision_disabled_threshold: #close enough to the end so disable collision
				detector_collision_object.disabled = true
			if path_follow.progress_ratio >= path_completed_threshold: #Reached the end of path
				path_complete.emit()
				free()
		else:
			patience += delta
			if patience >= max_patience:
				crash_pos.emit(path_follow.position)
				deadlock.emit()
func set_variables():
	if sprite and texture:
		sprite.texture = texture
		sprite.scale = Vector2i.ONE * texture_scale
	if detector_collision_object and collision_shape:
		detector_collision_object.shape = collision_shape
	if sprite and texture and detector_collision_object:
		var shape := RectangleShape2D.new()
		shape.size = texture.get_size() * sprite.scale
		detector_collision_object.shape = shape
	if collision_avoider_object:
		var shape := RectangleShape2D.new()
		shape.size = Vector2(raycast_distance,horizontal_raycast_distance)
		print(shape.size)
		collision_avoider_object.shape = shape
		# Position the object so that the collisions are detected ahead
		# the 1px gap ensures that it doesn't detect itself as a collision (bad!)
		collision_avoider_object.get_parent().position = Vector2(sprite.texture.get_size().x/2 + raycast_distance/2 + 2,0)

func crash() -> void:
	if path_follow.progress_ratio >= collision_disabled_threshold: return
	crashed.emit()
	print(path_follow.progress_ratio)
	crash_pos.emit(path_follow.position)

func entered_slowdown() -> void:
	var is_crash := randf_range(0,1) < crash_car_in_pothole_chance
	speed = slowdown_speed
	if is_crash: crash()

func entered_stop() -> void:
	if ignore_stop_signs:
		pass
	else: #pay heed to stop signs
		speed = 0
		is_in_stop_sign = true

func exited_stop() -> void:
	# 6/12/25
	# HOW DID I LEAVE THIS BUG IN THE GAME FOR A WEEK?!
	is_in_stop_sign = false
func _on_collision_detector_area_entered(area: Area2D) -> void:
	if not area is SlowdownArea: #Ensure we collided with a car
		if not path_follow.progress_ratio <= 0.4: #Stop so called spawn crashes
			var path:CarPath = area.owner
			path.crash()
			crash()


func _on_collision_avoider_area_entered(_area: Area2D) -> void:
	is_colliding = true
	speed = 1
func _on_collision_avoider_area_exited(_area: Area2D) -> void:
	is_colliding = false
