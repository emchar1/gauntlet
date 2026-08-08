extends Node


# PROPERTIES


# FUNCTIONS

func map_2d_to_3d(vector2: Vector2) -> Vector3:
	return Vector3(vector2.x, 0.0, vector2.y)


func map_3d_to_2d(vector3: Vector3) -> Vector2:
	return Vector2(vector3.x, vector3.z)
