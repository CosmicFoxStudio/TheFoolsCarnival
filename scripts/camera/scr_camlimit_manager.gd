class_name CameraLimitManager extends Node2D

const MAX_LIMIT = 100000

@onready var camera : Camera = get_parent()

var limitTransitionSpeed = 3

# Camera Bounds
var cameraBoundsXMin
var cameraBoundsXMax
var cameraBoundsYMin
var cameraBoundsYMax

# Limit Target Attributes
var limitLeftTarget: float = -MAX_LIMIT
var limitRightTarget: float = MAX_LIMIT
var limitTopTarget: float = -MAX_LIMIT
var LimitBottomTarget: float = MAX_LIMIT

func _ready() -> void:
	var cameraBounds = get_viewport_rect()
	cameraBoundsXMin = cameraBounds.position.x
	cameraBoundsYMin = cameraBounds.position.y
	cameraBoundsXMax = cameraBounds.end.x
	cameraBoundsYMax = cameraBounds.end.y

# Limit camera bounds dynamically every frame
func _physics_process(_delta: float) -> void:
	camera.limit_left = CalculateLimit(camera.limit_left, limitLeftTarget, true)
	camera.limit_right = CalculateLimit(camera.limit_right, limitRightTarget, true)
	camera.limit_top = CalculateLimit(camera.limit_top, limitTopTarget, false)
	camera.limit_bottom = CalculateLimit(camera.limit_bottom, LimitBottomTarget, false)

func CalculateLimit(__currentLimit, __targetLimit, __isX):
	# Already reached the limit
	if __currentLimit == __targetLimit:
		return __currentLimit
	
	var clampedLimit = ClampLimit(__currentLimit, __isX)
	return MoveLimitToward(clampedLimit, __targetLimit)

func ClampLimit(__limit, __isX): 
	var player = Global.level.player
	var playerPos = player.global_position.x if __isX else player.global_position.y
	var isLimitAfterPlayer = sign(__limit - playerPos)
	var clampValue
	
	if __isX: 
		clampValue = cameraBoundsXMax if isLimitAfterPlayer else cameraBoundsXMin
	else:
		clampValue = cameraBoundsYMax if isLimitAfterPlayer else cameraBoundsYMin
		
	return minf(clampValue, __limit) if isLimitAfterPlayer else maxf(clampValue, __limit)

func MoveLimitToward(__current, __target):
	# Move directly to target
	if abs(__current) >= MAX_LIMIT or abs(__target) >= MAX_LIMIT:
		return __target
	if __current != __target:
		return move_toward(__current, __target, limitTransitionSpeed)
	
	return __target

func SetLimiter(__limiter: CameraLimiter, __instant = false):
	limitLeftTarget = __limiter.GetLimitLeft()
	limitRightTarget = __limiter.GetLimitRight()
	limitTopTarget = __limiter.GetLimitTop() + camera.offset.y
	LimitBottomTarget = __limiter.GetLimitBottom() - camera.offset.y
	
	if __instant:
		camera.limit_left = limitLeftTarget
		camera.limit_top = limitTopTarget
		camera.limit_right = limitRightTarget
		camera.limit_bottom = LimitBottomTarget
