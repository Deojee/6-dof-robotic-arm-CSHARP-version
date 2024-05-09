@tool

extends Node3D

var tip 

const ACCEL = 4
const ROTACCEL = 4
const SPEEDMODIFIER = 0.01
const ROTMODIFIER = 0.03

# Called when the node enters the scene tree for the first time.
func _ready():
	tip = $targetPos
	pass # Replace with function body.

var movementVelocity = Vector3.ZERO
var rotationVelocity = Vector3.ZERO


"""
Here we handle user input and change the position and target velocities
we also hand acceleration


"""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if Engine.is_editor_hint():
		return
	#
	#var speed = $Control/HSlider.value
	#
	##temporary variable for getting velocities
	#var targetVelocity = Vector3.ZERO
	#
	#targetVelocity.y += -Input.get_axis("up","down")
	#targetVelocity.x += Input.get_axis("left","right")
	#targetVelocity.z += Input.get_axis("forward","backward")
	#
	#movementVelocity = lerp(movementVelocity,targetVelocity, ACCEL * delta)
	#
	#position += movementVelocity * speed * SPEEDMODIFIER
	#
	#var targetRotVelocity = Vector3.ZERO
	#
	#targetRotVelocity.y += -Input.get_axis("rotateYClockwise","rotateYCounterClockwise")
	#targetRotVelocity.x += Input.get_axis("rotateXClockwise","rotateXCounterClockwise")
	#targetRotVelocity.z += Input.get_axis("rotateZClockwise","rotateZCounterClockwise")
	#
	#rotationVelocity = lerp(rotationVelocity,targetRotVelocity, ROTACCEL * delta)
	#
	#global_rotate(Vector3.RIGHT,rotationVelocity.x * ROTMODIFIER * speed)
	#global_rotate(Vector3.UP,rotationVelocity.y * ROTMODIFIER * speed)
	#global_rotate(Vector3.FORWARD,rotationVelocity.z * ROTMODIFIER * speed)
	#
	
	
	
	
	global_transform = get_tree().get_first_node_in_group("target").global_transform
	
	pass
