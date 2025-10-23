extends Polygon2D
class_name PotholeSpawner ##The idea of a pothole spawner is kind of funny

@export var max_delay:float
@export var min_delay:float
var delay:
	get:
		return randf_range(min_delay,max_delay)
@export_group("Nodes")
@export var pothole_scene:PackedScene
@export var number_of_potholes_to_spawn:int
var potholes_spawned:int = 0
var timer:Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(queue_spawn_pothole)
	
func spawn_potholes():
	for child in get_children():
		if child is SlowdownArea: child.queue_free() #Clear old potholes
	for i in number_of_potholes_to_spawn:
		var s := pothole_scene.instantiate()
		add_child(s)
		s.position = Triangle.get_random_point_in_polygon(polygon)

func queue_spawn_pothole():
	if not potholes_spawned >= number_of_potholes_to_spawn:
		var s := pothole_scene.instantiate()
		add_child(s)
		s.position = Triangle.get_random_point_in_polygon(polygon)
		timer.start(delay)
		potholes_spawned += 1

class Triangle:
	#https://github.com/godotengine/godot-proposals/issues/13060
	var _p1 : Vector2
	var _p2 : Vector2
	var _p3 : Vector2
	
	func _init(p1: Vector2, p2: Vector2, p3: Vector2) -> void:
		_p1 = p1
		_p2 = p2
		_p3 = p3
	
	func get_triangle_area() -> float:
		return 0.5 * abs((_p1.x*(_p2.y - _p3.y)) + (_p2.x*(_p3.y - _p1.y)) + (_p3.x*(_p1.y - _p2.y)))
	
	func get_random_point():
		var a = randf()
		var b = randf()
		if a > b:
			var c = b
			b = a
			a = c

		return _p1 * a + _p2 * (b - a) + _p3 * (1 - b)
	
	static func get_random_point_in_polygon(polygon: PackedVector2Array) -> Vector2:
		return get_random_point_in_triangulated_polygon(polygon, Geometry2D.triangulate_polygon(polygon))
	
	static func get_random_point_in_triangulated_polygon(polygon: PackedVector2Array, triangle_points : PackedInt32Array) -> Vector2:
		var triangle_weights : PackedFloat32Array = []
		var triangles : Array[Triangle] = []
		
		var index = 0
		var polygon_size = triangle_points.size()
		while index < polygon_size:
			var triangle = Triangle.new(polygon[triangle_points[index]], polygon[triangle_points[index + 1]], polygon[triangle_points[index + 2]])
			triangles.append(triangle)
			triangle_weights.append(triangle.get_triangle_area())
			index += 3
		
		## TODO: We should allow the consumer to specify their own source of randomness, if desired.
		return triangles[RandomNumberGenerator.new().rand_weighted(triangle_weights)].get_random_point()
