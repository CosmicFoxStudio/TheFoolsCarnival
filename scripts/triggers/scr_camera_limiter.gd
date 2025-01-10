class_name CameraLimiter extends Node2D

enum eLimitX { NONE, LEFT, RIGHT }
enum eLimitY { NONE, TOP, BOTTOM }

const MAX_VALUE = 100000

@export var limitX: eLimitX = eLimitX.NONE
@export var limitY: eLimitY = eLimitY.NONE

@onready var marker: Marker2D = $LimitPosition

func GetLimitTop():
	if limitY != eLimitY.TOP:
		return -MAX_VALUE
	return marker.global_position.y

func GetLimitBottom():
	if limitY != eLimitY.BOTTOM:
		return MAX_VALUE
	return marker.global_position.y

func GetLimitLeft():
	if limitX != eLimitX.LEFT:
		# return -MAX_VALUE
		return 0
	return marker.global_position.x

func GetLimitRight():
	if limitX != eLimitX.RIGHT:
		return MAX_VALUE
	return marker.global_position.x
