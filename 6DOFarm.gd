extends Node

class_name sixDOFArm

#all lengths are in mm. They are from one degree to another.
var lengths = [108,254,102,102,55,40]

# this default position is pointing forward and straight up
var targetRotations = [0,0,0,0,0,0]



"""
Version that takes euler angles instead of directions
"""
func calculateAnglesFromEulerRotation(targetPos : Vector3, targetRot : Vector3):
	
	var basis = Basis.from_euler(targetRot)
	
	return calculateAngles(targetPos,basis.z,basis.y)
	
	pass

"""
Targetpos is relative to the base of the robot

positive z is forward, positive y is up, positive x is right

"""
func calculateAngles(targetPos : Vector3,forwardBasis : Vector3,upBasis : Vector3):
	
	#convert from meters to mm
	targetPos *= 1000
	
	var segment3length = (lengths[4] + lengths[5])
	var fifthDegreeJointPosition = (targetPos + (forwardBasis * segment3length )) 
	
	targetRotations[0] = atan2(fifthDegreeJointPosition.x,fifthDegreeJointPosition.z)
	
	#this is counting from 1, not 0
	var secondDegreeJointPosition = Vector3(0,lengths[0],0)
	
	#law of cosine with first arm segment as a, the distance from  secondDegreeJointPosition to fifthDegreeJointPosition as b
	# and the length of segment 2 as c
	
	var a = lengths[1]
	var b = secondDegreeJointPosition.distance_to(fifthDegreeJointPosition)
	var c = lengths[2] + lengths[3] 
	
	var xzDegree5distfromdegree2 = Vector2(secondDegreeJointPosition.x,secondDegreeJointPosition.z).distance_to(Vector2(fifthDegreeJointPosition.x,fifthDegreeJointPosition.z))
	var xzDegree5heightfromdegree2 = secondDegreeJointPosition.y - fifthDegreeJointPosition.y
	
	var angleFrom2ndegreeTo5thdegree = atan2(xzDegree5distfromdegree2,(-xzDegree5heightfromdegree2))
	
	targetRotations[1] = angleFrom2ndegreeTo5thdegree - lawOfCosine(a,b,c)
	
	#swap b and c to calculate a different side
	var tempC = c
	c = b 
	b = tempC
	
	targetRotations[2] = -lawOfCosine(a,b,c) + PI
	
	var forwardBasisOfDegreeFour = -Vector3.UP.rotated(Vector3.RIGHT,(targetRotations[1] + targetRotations[2])).rotated(Vector3.UP,targetRotations[0])
	var UpBasisOfDegreeFour = -Vector3.FORWARD.rotated(Vector3.RIGHT,targetRotations[1] + targetRotations[2]).rotated(Vector3.UP,targetRotations[0])
	var RightBasisOfDegreeFour = -Vector3.LEFT.rotated(Vector3.RIGHT,targetRotations[1] + targetRotations[2]).rotated(Vector3.UP,targetRotations[0])
	
	var thirdDegreeJointPosition = secondDegreeJointPosition + (Vector3.UP * lengths[1]) .rotated(Vector3.RIGHT,(targetRotations[1] )).rotated(Vector3.UP,targetRotations[0])
	
	var thirdDegreeJointPositionToTargetPos : Vector3 = targetPos - thirdDegreeJointPosition 
	var targetPosFromThirdJointPerspective = Vector2(thirdDegreeJointPositionToTargetPos.dot(UpBasisOfDegreeFour),thirdDegreeJointPositionToTargetPos.dot(RightBasisOfDegreeFour))
	targetRotations[3] = targetPosFromThirdJointPerspective.angle()
	
	targetRotations[4] =  (forwardBasisOfDegreeFour).angle_to(forwardBasis)
	
	#this one is totally correct
	var rightBasisOfDegreeFive = (-RightBasisOfDegreeFour).rotated(forwardBasisOfDegreeFour,-targetRotations[3])
	var forwardBasisOfDegreeFive = -forwardBasisOfDegreeFour.rotated(rightBasisOfDegreeFive,-targetRotations[4])
	var degree5UpBasis = -forwardBasisOfDegreeFive.cross(rightBasisOfDegreeFive)
	
	var fifthDegreeJointPositionToTargetPos : Vector3 = (targetPos - upBasis * 0.3) - fifthDegreeJointPosition 
	var targetPosFromFifthJointPerspective = Vector2(-fifthDegreeJointPositionToTargetPos.dot(degree5UpBasis),fifthDegreeJointPositionToTargetPos.dot(-rightBasisOfDegreeFive))
	targetRotations[5] =  PI + targetPosFromFifthJointPerspective.angle()
	
	
	#targetRotations[5] = upBasis.angle_to(degree5UpBasis)
	


#returns the angle between a and b. All are side lengths.
func lawOfCosine(a,b,c):
	return acos(
			((a*a + b*b ) - (c*c) )
			/
			(2 * a * b)
		)


