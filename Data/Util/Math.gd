extends Object
class_name Math

static func quadBezier(p0: Vector2, p1: Vector2, p2: Vector2, time: float) -> Vector2:
	# para interpolar movimientos usando el algoritmo del bezier cuadrado
	var q0 = p0.linear_interpolate(p1, time)
	var q1 = p1.linear_interpolate(p2, time)
	
	var r = q0.linear_interpolate(q1, time)
	return r
	
static func cubicBezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, time: float) -> Vector2:
	# para interpolar movimientos usando el algoritmo del bezier cubico
	var q0 = p0.linear_interpolate(p1, time)
	var q1 = p1.linear_interpolate(p2, time)
	var q2 = p2.linear_interpolate(p3, time)
	
	var r0 = q0.linear_interpolate(q1, time)
	var r1 = q1.linear_interpolate(q2, time)
	
	var r = r0.linear_interpolate(r1, time)
	return r
	
static func isEven(value : int) -> bool:
	return value % 2 == 0
	
static func dec2bin(decimalValue : int) -> int:
	var binaryString = "" 
	var temp 
	var count = 31
	while(count >= 0):
		temp = decimalValue >> count 
		if(temp & 1):
			binaryString = binaryString + "1"
		else:
			binaryString = binaryString + "0"
		count -= 1
		
	return int(binaryString)
	
static func bin2dec(binaryValue : int) -> int:
	var decimalValue = 0
	var count = 0
	var temp
	while(binaryValue != 0):
		temp = binaryValue % 10
		binaryValue /= 10
		decimalValue += temp * pow(2, count)
		count += 1
	return decimalValue
	
static func isBitEnabled(mask, index):
	return mask & (1 << index) != 0
	
static func setBit(mask, index, enabled := true):
	if enabled:
		return mask | (1 << index)
	else:
		return mask & ~(1 << index)
	
static func remapToRange(value : float, iStart : float, iStop : float, oStart : float, oStop : float) -> float:
	return oStart + (oStop - oStart) * ((value - iStart) / (iStop - iStart))
	
static func toVec2(value) -> Vector2:
	return Vector2(value, value)
	
static func toVec3(value) -> Vector3:
	return Vector3(value, value, value)

static func calculateAngleIndex(radians, anglePerDirection = TAU / 8):
	var angleStep = stepify(radians, anglePerDirection)
	angleStep = fposmod(angleStep, TAU)
	
	return int(angleStep / anglePerDirection)

static func angleToAngle(from : int, to : int):
	return ((((from - to) % 360) + 540) % 360) - 180
